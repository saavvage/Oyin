from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from app.models import (
    ChatRequest, ChatResponse, EmbedDocumentsRequest,
    EmbedDocumentsResponse, HealthResponse
)
from app.services.chat_service import chat_service
from app.services.rag_service import rag_service
import logging
import time
from collections import defaultdict

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="Sports AI Assistant",
    description="RAG-powered AI assistant for sports matchmaking app",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

rate_limit_store = defaultdict(list)
RATE_LIMIT_WINDOW = 60
RATE_LIMIT_MAX_REQUESTS = 30


@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    duration = time.time() - start_time
    
    logger.info(f"{request.method} {request.url.path} - {response.status_code} - {duration:.2f}s")
    
    return response


def check_rate_limit(user_id: str) -> bool:
    now = time.time()
    user_requests = rate_limit_store[user_id]
    
    user_requests = [req_time for req_time in user_requests if now - req_time < RATE_LIMIT_WINDOW]
    rate_limit_store[user_id] = user_requests
    
    if len(user_requests) >= RATE_LIMIT_MAX_REQUESTS:
        return False
    
    user_requests.append(now)
    return True


@app.get("/health")
async def health_check():
    from app.services.llm_service import llm_service
    backend = "none"
    if llm_service._local_available:
        backend = "local_gguf"
    elif llm_service._vastai_available:
        backend = "vastai"
    return {
        "status": "healthy",
        "version": "1.0.0",
        "inference_backend": backend,
    }


@app.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    try:
        if not check_rate_limit(request.user_id):
            raise HTTPException(status_code=429, detail="Rate limit exceeded. Please try again later.")
        
        response = chat_service.process_chat(request)
        return response
    
    except Exception as e:
        logger.error(f"Error processing chat request: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.post("/embed-documents", response_model=EmbedDocumentsResponse)
async def embed_documents(request: EmbedDocumentsRequest):
    try:
        documents = []
        for i, doc in enumerate(request.documents):
            documents.append({
                "content": doc.content,
                "metadata": doc.metadata.dict(),
                "id": f"custom_doc_{i}_{int(time.time())}"
            })
        
        rag_service.add_documents(documents)
        
        return EmbedDocumentsResponse(
            status="success",
            documents_added=len(documents)
        )
    
    except Exception as e:
        logger.error(f"Error embedding documents: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.post("/reset-collection")
async def reset_collection():
    try:
        rag_service.reset_collection()
        return {"status": "success", "message": "Collection reset and reloaded"}
    except Exception as e:
        logger.error(f"Error resetting collection: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)






