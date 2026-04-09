import sys
import os
import time
from dotenv import load_dotenv

load_dotenv()

sys.path.insert(0, os.path.dirname(__file__))

from app.services.rag_service import rag_service
from app.utils.document_loader import document_loader

def main():
    print("=" * 70)
    print(" DOCUMENT LOADER - Load documents into ChromaDB")
    print("=" * 70)
    print("\nThis script loads documents from rag_files/ into the vector database.")
    print("WARNING: This will make embedding API calls to Gemini.")
    print("On free tier, you have limits on embedding calls per minute/day.")
    print("\nIf you get rate limit errors, wait a few minutes and try again.")
    print("=" * 70)
    
    response = input("\nDo you want to proceed? (yes/no): ")
    if response.lower() not in ['yes', 'y']:
        print("Cancelled.")
        return
    
    print("\nLoading documents...")
    documents = document_loader.load_documents()
    
    if not documents:
        print("No documents found in rag_files/")
        return
    
    print(f"Found {len(documents)} document chunks")
    print("=" * 70)
    
    reset = input("\nReset existing collection? (yes/no): ")
    if reset.lower() in ['yes', 'y']:
        print("Resetting collection...")
        rag_service.reset_collection()
    
    print("\nGenerating embeddings and storing in ChromaDB...")
    print("This may take a minute depending on the number of documents...")
    
    batch_size = 5
    for i in range(0, len(documents), batch_size):
        batch = documents[i:i+batch_size]
        try:
            rag_service.add_documents(batch)
            print(f"Processed {min(i+batch_size, len(documents))}/{len(documents)} chunks")
            if i + batch_size < len(documents):
                time.sleep(2)
        except Exception as e:
            print(f"Error processing batch: {e}")
            print("You may have hit rate limits. Wait a few minutes and run this script again.")
            print("Already processed documents won't be duplicated.")
            sys.exit(1)
    
    print("\n" + "=" * 70)
    print("SUCCESS! All documents loaded into ChromaDB")
    print(f"Total chunks: {rag_service.collection.count()}")
    print("=" * 70)
    print("\nYou can now start the FastAPI server:")
    print("  uvicorn app.main:app --reload")

if __name__ == "__main__":
    main()






