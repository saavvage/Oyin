from app.config import get_settings
import logging

logger = logging.getLogger(__name__)


class LLMService:
    """
    LLM inference with two-tier fallback:
      1. Local GGUF model (primary — fast, no network)
      2. Vast.ai remote server (fallback — your model on rented GPU)
    """

    def __init__(self):
        self.settings = get_settings()
        self.local_service = None
        self.vastai_service = None

        self._initialize_local()
        self._initialize_vastai()

    def _initialize_local(self):
        try:
            from app.services.local_llm_service import get_local_llm_service
            self.local_service = get_local_llm_service(self.settings.local_model_path)
            if self.local_service.is_available:
                logger.info("Local GGUF model available (primary)")
            else:
                logger.info("Local GGUF model not found — will use Vast.ai")
        except Exception as e:
            logger.warning(f"Could not initialize local model: {e}")

    def _initialize_vastai(self):
        try:
            from app.services.vastai_service import get_vastai_service
            self.vastai_service = get_vastai_service()
            if self.vastai_service.is_available:
                logger.info("Vast.ai server available (fallback)")
            elif self.settings.vastai_api_url:
                logger.warning("Vast.ai URL configured but server not reachable")
            else:
                logger.info("No Vast.ai URL configured")
        except Exception as e:
            logger.warning(f"Could not initialize Vast.ai service: {e}")

    @property
    def _local_available(self) -> bool:
        return self.local_service is not None and self.local_service.is_available

    @property
    def _vastai_available(self) -> bool:
        return self.vastai_service is not None and self.vastai_service.is_available

    def generate_response(self, prompt: str) -> str:
        # 1) Try local GGUF
        if self._local_available:
            try:
                response = self.local_service.generate_response(prompt)
                if response:
                    return response
            except Exception as e:
                logger.error(f"Local model error: {e}")

        # 2) Try Vast.ai
        if self._vastai_available:
            try:
                response = self.vastai_service.generate_response(prompt)
                if response:
                    return response
            except Exception as e:
                logger.error(f"Vast.ai error: {e}")
        elif self.vastai_service and self.settings.vastai_api_url:
            # Re-check in case server came back online
            self.vastai_service.invalidate_cache()
            if self.vastai_service.is_available:
                try:
                    response = self.vastai_service.generate_response(prompt)
                    if response:
                        return response
                except Exception as e:
                    logger.error(f"Vast.ai retry error: {e}")

        return (
            "I'm sorry, the AI service is currently unavailable. "
            "Please try again later."
        )

    def generate_embeddings(self, texts: list[str]) -> list[list[float]]:
        """Generate embeddings using sentence-transformers (runs locally)."""
        try:
            from sentence_transformers import SentenceTransformer
            model = SentenceTransformer('all-MiniLM-L6-v2')
            embeddings = model.encode(texts)
            return embeddings.tolist()
        except ImportError:
            logger.error("sentence-transformers not installed. Run: pip install sentence-transformers")
            raise
        except Exception as e:
            logger.error(f"Embedding generation error: {e}")
            raise

    def generate_query_embedding(self, query: str) -> list[float]:
        return self.generate_embeddings([query])[0]


llm_service = LLMService()
