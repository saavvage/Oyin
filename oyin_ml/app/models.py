from pydantic import BaseModel, Field
from typing import List, Dict, Optional


class RecentMatch(BaseModel):
    sport: str
    date: str
    opponent: str


class UserContext(BaseModel):
    preferred_sports: Optional[List[str]] = []
    skill_levels: Optional[Dict[str, str]] = {}
    injuries: Optional[List[str]] = []
    matches_played: Optional[int] = 0
    recent_matches: Optional[List[RecentMatch]] = []


class ChatRequest(BaseModel):
    user_id: str
    message: str
    user_context: Optional[UserContext] = None


class ChatResponse(BaseModel):
    response: str
    sources: Optional[List[str]] = None
    used_rag: bool


class DocumentMetadata(BaseModel):
    source: str
    sport: str
    topic: str


class Document(BaseModel):
    content: str
    metadata: DocumentMetadata


class EmbedDocumentsRequest(BaseModel):
    documents: List[Document]


class EmbedDocumentsResponse(BaseModel):
    status: str
    documents_added: int


class HealthResponse(BaseModel):
    status: str
    version: str = "1.0.0"






