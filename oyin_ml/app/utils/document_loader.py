import os
from pathlib import Path
import re
import logging

logger = logging.getLogger(__name__)


class DocumentLoader:
    def __init__(self, documents_path: str = "./rag_files"):
        self.documents_path = documents_path
    
    def load_documents(self) -> list[dict]:
        documents = []
        doc_path = Path(self.documents_path)
        
        if not doc_path.exists():
            logger.warning(f"Documents path {self.documents_path} does not exist")
            return documents
        
        for file_path in doc_path.glob("*.md"):
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                metadata = self._extract_metadata(file_path.name, content)
                chunks = self._chunk_text(content)
                
                for i, chunk in enumerate(chunks):
                    documents.append({
                        "content": chunk,
                        "metadata": metadata,
                        "id": f"{file_path.stem}_chunk_{i}",
                        "source_file": file_path.name
                    })
                
                logger.info(f"Loaded {len(chunks)} chunks from {file_path.name}")
            except Exception as e:
                logger.error(f"Error loading {file_path}: {e}")
        
        return documents
    
    def _extract_metadata(self, filename: str, content: str) -> dict:
        sport = "general"
        topic = "general"
        source = "Internal"
        
        if "tennis" in filename.lower():
            sport = "tennis"
        elif "badminton" in filename.lower():
            sport = "badminton"
        
        if "safety" in filename.lower():
            topic = "injury_prevention"
        elif "warm" in filename.lower() or "warmup" in filename.lower():
            topic = "warm_up"
        elif "injury" in filename.lower() or "injuries" in filename.lower():
            topic = "common_injuries"
        elif "first_aid" in filename.lower() or "first aid" in filename.lower():
            topic = "first_aid"
        
        return {
            "source": source,
            "sport": sport,
            "topic": topic
        }
    
    def _chunk_text(self, text: str, chunk_size: int = 500, overlap: int = 50) -> list[str]:
        words = text.split()
        chunks = []
        
        for i in range(0, len(words), chunk_size - overlap):
            chunk = ' '.join(words[i:i + chunk_size])
            if chunk.strip():
                chunks.append(chunk.strip())
        
        return chunks if chunks else [text]


document_loader = DocumentLoader()






