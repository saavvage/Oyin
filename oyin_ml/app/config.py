from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    gemini_api_key: str = ""
    chroma_persist_directory: str = "./chroma_db"
    environment: str = "development"
    max_retrieved_docs: int = 5
    chunk_size: int = 500
    chunk_overlap: int = 50
    
    use_local_model: bool = False
    local_model_path: str = "./models"
    model_fallback_enabled: bool = True
    
    class Config:
        env_file = ".env"
        case_sensitive = False


@lru_cache()
def get_settings():
    return Settings()

