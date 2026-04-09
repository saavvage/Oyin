from app.models import ChatRequest, ChatResponse, UserContext
from app.services.llm_service import llm_service
from app.services.rag_service import rag_service
from app.services.router import query_router
from app.services.translation_service import translation_service
import logging

logger = logging.getLogger(__name__)


class ChatService:
    def __init__(self):
        self.llm = llm_service
        self.rag = rag_service
        self.router = query_router
        self.translator = translation_service
    
    def process_chat(self, request: ChatRequest) -> ChatResponse:
        original_message = request.message
        detected_lang = self.translator.detect_language(original_message)
        
        logger.info(f"User {request.user_id}: Language={detected_lang}, RAG={self.router.should_use_rag(original_message)}, Query: {original_message[:50]}...")
        
        # Translate to English if needed
        if detected_lang != 'en':
            request.message = self.translator.translate_to_english(original_message, detected_lang)
            logger.info(f"Translated query to English: {request.message[:50]}...")
        
        use_rag = self.router.should_use_rag(request.message)
        
        if use_rag:
            response = self._handle_rag_query(request)
        else:
            response = self._handle_direct_query(request)
        
        # Translate response back to original language
        if detected_lang != 'en':
            response.response = self.translator.translate_from_english(response.response, detected_lang)
            logger.info(f"Translated response back to {detected_lang}")
        
        return response
    
    def _handle_rag_query(self, request: ChatRequest) -> ChatResponse:
        retrieved_docs, sources = self.rag.retrieve_relevant_documents(request.message)
        
        context = "\n\n".join([f"[Document {i+1}]\n{doc}" for i, doc in enumerate(retrieved_docs)])
        
        prompt = self._build_prompt(
            request.message,
            request.user_context,
            rag_context=context
        )
        
        response_text = self.llm.generate_response(prompt)
        
        return ChatResponse(
            response=response_text,
            sources=sources,
            used_rag=True
        )
    
    def _handle_direct_query(self, request: ChatRequest) -> ChatResponse:
        prompt = self._build_prompt(
            request.message,
            request.user_context,
            rag_context=None
        )
        
        response_text = self.llm.generate_response(prompt)
        
        return ChatResponse(
            response=response_text,
            sources=None,
            used_rag=False
        )
    
    def _build_prompt(self, query: str, user_context: UserContext = None, rag_context: str = None) -> str:
        # Query is already in English from translation service
        base_prompt = "You are a helpful sports AI assistant. Answer clearly and concisely.\n\n"
        
        if user_context:
            if user_context.preferred_sports:
                base_prompt += f"User's sports: {', '.join(user_context.preferred_sports)}\n"
            if user_context.injuries:
                base_prompt += f"User's injuries: {', '.join(user_context.injuries)}\n"
            base_prompt += "\n"
        
        if rag_context:
            base_prompt += f"Reference:\n{rag_context[:800]}\n\n"
        
        base_prompt += f"Question: {query}\nAnswer:"
        
        return base_prompt


chat_service = ChatService()






