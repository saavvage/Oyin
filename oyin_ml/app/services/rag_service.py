import chromadb
from chromadb.config import Settings as ChromaSettings
from app.config import get_settings
from app.services.llm_service import llm_service
from app.utils.document_loader import document_loader
import logging

logger = logging.getLogger(__name__)


class RAGService:
    def __init__(self):
        self.settings = get_settings()
        self.client = chromadb.PersistentClient(
            path=self.settings.chroma_persist_directory,
            settings=ChromaSettings(anonymized_telemetry=False)
        )
        self.collection_name = "sports_health_safety"
        self.collection = None
        self._initialize_collection()
    
    def _initialize_collection(self):
        try:
            self.collection = self.client.get_collection(self.collection_name)
            count = self.collection.count()
            logger.info(f"Loaded existing collection: {self.collection_name} with {count} documents")
            if count == 0:
                logger.info("Collection is empty, will load documents on first request to avoid rate limits")
        except:
            self.collection = self.client.create_collection(
                name=self.collection_name,
                metadata={"hnsw:space": "cosine"}
            )
            logger.info(f"Created new collection: {self.collection_name}")
            logger.info("Documents will be loaded lazily to avoid rate limits")
    
    def _load_initial_documents(self):
        logger.info("Loading initial documents into ChromaDB...")
        documents = document_loader.load_documents()
        
        if not documents:
            logger.warning("No documents found to load")
            return
        
        self.add_documents(documents)
        logger.info(f"Loaded {len(documents)} document chunks into ChromaDB")
    
    def add_documents(self, documents: list[dict]):
        if not documents:
            return
        
        contents = [doc["content"] for doc in documents]
        metadatas = [doc["metadata"] for doc in documents]
        ids = [doc["id"] for doc in documents]
        
        try:
            embeddings = llm_service.generate_embeddings(contents)
            
            self.collection.add(
                embeddings=embeddings,
                documents=contents,
                metadatas=metadatas,
                ids=ids
            )
            logger.info(f"Successfully added {len(documents)} documents to collection")
        except Exception as e:
            logger.error(f"Error adding documents: {e}")
            raise
    
    def retrieve_relevant_documents(self, query: str, n_results: int = None) -> tuple[list[str], list[str]]:
        if self.collection.count() == 0:
            logger.info("Collection is empty, loading documents now...")
            try:
                self._load_initial_documents()
            except Exception as e:
                logger.error(f"Failed to load documents: {e}")
                return [], []
        
        if n_results is None:
            n_results = self.settings.max_retrieved_docs
        
        try:
            query_embedding = llm_service.generate_query_embedding(query)
            
            results = self.collection.query(
                query_embeddings=[query_embedding],
                n_results=min(n_results, self.collection.count())
            )
            
            documents = results['documents'][0] if results['documents'] else []
            metadatas = results['metadatas'][0] if results['metadatas'] else []
            
            sources = list(set([meta.get('source', 'Unknown') for meta in metadatas]))
            
            return documents, sources
        except Exception as e:
            logger.error(f"Error retrieving documents: {e}")
            return [], []
    
    def reset_collection(self):
        try:
            self.client.delete_collection(self.collection_name)
            logger.info(f"Deleted collection: {self.collection_name}")
        except:
            pass
        self._initialize_collection()


rag_service = RAGService()

