from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    chroma_persist_directory: str = "./chroma_db"
    environment: str = "development"
    max_retrieved_docs: int = 5
    chunk_size: int = 500
    chunk_overlap: int = 50

    # Local GGUF model (primary)
    local_model_path: str = "./models"

    # Vast.ai remote inference (fallback when local is unavailable)
    vastai_api_url: str = ""          # e.g. http://<vast-ip>:8080
    vastai_api_key: str = ""          # optional, depends on your server setup
    vastai_model_name: str = "default"  # model name for OpenAI-compatible API
    vastai_timeout: int = 60          # seconds

    class Config:
        env_file = ".env"
        case_sensitive = False


@lru_cache()
def get_settings():
    return Settings()
