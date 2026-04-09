import google.generativeai as genai
from app.config import get_settings
import logging

logger = logging.getLogger(__name__)


class LLMService:
    def __init__(self):
        self.settings = get_settings()
        self.use_local = self.settings.use_local_model
        self.fallback_enabled = self.settings.model_fallback_enabled
        self.local_service = None
        self.model = None
        self.embedding_model = None
        
        if not self.use_local and self.settings.gemini_api_key:
            try:
                genai.configure(api_key=self.settings.gemini_api_key)
                self.model = genai.GenerativeModel('models/gemini-2.0-flash')
                self.embedding_model = 'models/embedding-001'
                logger.info("Using Gemini API for LLM")
            except Exception as e:
                logger.warning(f"Failed to initialize Gemini: {e}")
                if self.fallback_enabled:
                    self._initialize_local_fallback()
        else:
            self._initialize_local_fallback()
        
    def _initialize_local_fallback(self):
        """Initialize local Gemma model as fallback"""
        try:
            from app.services.local_llm_service import get_local_llm_service
            self.local_service = get_local_llm_service(self.settings.local_model_path)
            if self.local_service.is_available:
                logger.info("Local Gemma model available as fallback")
                self.use_local = True
            else:
                logger.info("Local model not available. Download Gemma to models/gemma/ for offline usage")
        except Exception as e:
            logger.warning(f"Could not initialize local fallback: {e}")
    
    def generate_response(self, prompt: str) -> str:
        if self.use_local and self.local_service and self.local_service.is_available:
            try:
                response = self.local_service.generate_response(prompt)
                if response:
                    return response
            except Exception as e:
                logger.error(f"Error with local model: {e}")
        
        if self.model is not None:
            try:
                response = self.model.generate_content(prompt)
                return response.text
            except Exception as e:
                logger.error(f"Error generating response with Gemini: {e}")
                
                if self.fallback_enabled and not self.use_local:
                    logger.info("Attempting fallback to local model...")
                    if self.local_service is None:
                        self._initialize_local_fallback()
                    
                    if self.local_service and self.local_service.is_available:
                        try:
                            response = self.local_service.generate_response(prompt)
                            if response:
                                logger.info("Successfully used local fallback")
                                return response
                        except Exception as local_e:
                            logger.error(f"Local fallback also failed: {local_e}")
        
        return "I apologize, but I'm having trouble processing your request right now. Please try again in a moment."
    
    def generate_embeddings(self, texts: list[str]) -> list[list[float]]:
        if self.use_local and self.local_service and self.local_service.is_available:
            try:
                embeddings = self.local_service.generate_embeddings(texts)
                if embeddings:
                    return embeddings
            except Exception as e:
                logger.error(f"Error with local embeddings: {e}")
        
        try:
            embeddings = []
            for text in texts:
                result = genai.embed_content(
                    model=self.embedding_model,
                    content=text,
                    task_type="retrieval_document"
                )
                embeddings.append(result['embedding'])
            return embeddings
        except Exception as e:
            logger.error(f"Error generating embeddings with Gemini: {e}")
            
            if self.fallback_enabled and not self.use_local:
                logger.info("Attempting embedding fallback to local model...")
                if self.local_service is None:
                    self._initialize_local_fallback()
                
                if self.local_service:
                    try:
                        embeddings = self.local_service.generate_embeddings(texts)
                        if embeddings:
                            logger.info("Successfully used local embeddings")
                            return embeddings
                    except Exception as local_e:
                        logger.error(f"Local embedding fallback failed: {local_e}")
            
            raise
    
    def generate_query_embedding(self, query: str) -> list[float]:
        if self.use_local and self.local_service and self.local_service.is_available:
            try:
                embeddings = self.local_service.generate_embeddings([query])
                if embeddings:
                    return embeddings[0]
            except Exception as e:
                logger.error(f"Error with local query embedding: {e}")
        
        try:
            result = genai.embed_content(
                model=self.embedding_model,
                content=query,
                task_type="retrieval_query"
            )
            return result['embedding']
        except Exception as e:
            logger.error(f"Error generating query embedding with Gemini: {e}")
            
            if self.fallback_enabled and not self.use_local:
                logger.info("Attempting query embedding fallback...")
                if self.local_service is None:
                    self._initialize_local_fallback()
                
                if self.local_service:
                    try:
                        embeddings = self.local_service.generate_embeddings([query])
                        if embeddings:
                            logger.info("Successfully used local query embedding")
                            return embeddings[0]
                    except Exception as local_e:
                        logger.error(f"Local query embedding fallback failed: {local_e}")
            
            raise


llm_service = LLMService()

