# Sports AI Assistant

A production-ready FastAPI service that provides AI-powered sports advice with RAG (Retrieval-Augmented Generation) for health and safety queries.

## Features

- **Hybrid AI**: Intelligently routes between RAG (health/safety) and direct LLM (technique/general)
- **Local Model Support**: Uses your Gemma 2 GGUF model (no API costs!)
- **ChromaDB**: Vector database for semantic search over sports documents
- **User Context Aware**: Personalizes responses based on injuries, sports, and skill level
- **Production Ready**: Rate limiting, logging, error handling

## Quick Start

### 1. Install Dependencies

```bash
pip install -r requirements.txt
pip install -r requirements-local.txt  # For local Gemma 2 support
```

### 2. Configuration

Create `.env` file:
```bash
GEMINI_API_KEY=your_key_here  # Optional if using local model
USE_LOCAL_MODEL=true
MODEL_FALLBACK_ENABLED=true
CHROMA_PERSIST_DIRECTORY=./chroma_db
```

### 3. Load Documents (One Time)

```bash
python load_documents.py
```

### 4. Start Server

```bash
uvicorn app.main:app --reload
```

Server runs at: http://localhost:8000

## API Endpoints

### POST /chat
Main AI assistant endpoint.

**Request:**
```json
{
  "user_id": "user_123",
  "message": "How do I prevent tennis elbow?",
  "user_context": {
    "preferred_sports": ["tennis"],
    "skill_levels": {"tennis": "intermediate"},
    "injuries": []
  }
}
```

**Response:**
```json
{
  "response": "To prevent tennis elbow...",
  "sources": ["Internal"],
  "used_rag": true
}
```

### GET /health
Health check endpoint.

### Interactive API Docs
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Project Structure

```
Oyin_ML/
├── app/
│   ├── main.py                  # FastAPI app
│   ├── config.py                # Configuration
│   ├── models.py                # Data models
│   ├── services/
│   │   ├── chat_service.py      # Chat logic
│   │   ├── rag_service.py       # Vector DB
│   │   ├── llm_service.py       # Gemini/Gemma
│   │   ├── local_llm_service.py # Local GGUF support
│   │   └── router.py            # Query routing
│   └── utils/
│       └── document_loader.py   # Document processing
├── models/
│   └── sports-health-gemma2.gguf  # Your local model
├── rag_files/                   # Health documents
├── requirements.txt
├── requirements-local.txt
└── README.md
```

## Testing Your Model

```bash
python test_gguf_model.py
```

## Usage Examples

### Query for Technique (Direct LLM)
```bash
curl -X POST http://localhost:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","message":"What is the best tennis grip?"}'
```

### Query for Health/Safety (RAG)
```bash
curl -X POST http://localhost:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","message":"How do I prevent injuries?"}'
```

## How It Works

1. **Query Router**: Automatically classifies queries
   - Health/Safety keywords → Uses RAG with ChromaDB
   - Technique/Rules → Uses direct LLM

2. **Local Model**: Your Gemma 2 GGUF model
   - 1.6GB quantized model
   - No API costs
   - Fast on CPU

3. **RAG System**: For health queries
   - Loads documents from `rag_files/`
   - Generates embeddings with sentence-transformers
   - Semantic search for relevant content

## Configuration Options

In `.env`:

```bash
# Use local model only
USE_LOCAL_MODEL=true

# Use Gemini with fallback to local
USE_LOCAL_MODEL=false
MODEL_FALLBACK_ENABLED=true
GEMINI_API_KEY=your_key

# Model settings
LOCAL_MODEL_PATH=./models/gemma
CHROMA_PERSIST_DIRECTORY=./chroma_db
```

## Performance

With your Gemma 2 GGUF model:
- Load time: ~3 seconds
- Response time: 4-8 seconds per query
- Memory: ~3GB RAM
- Quality: Good for sports advice

## Documents Included

The `rag_files/` directory contains:
- `badminton_safety.md`
- `tennis_safety.md`
- `common_injuries.md`
- `warm_up_guidelines.md`
- `first_aid_basics.md`
- `general_safety.md`

## Model Location

Place your GGUF model in the `models/` directory:
```bash
mv sports-health-gemma2.gguf models/
```

The service will automatically find GGUF files in:
1. `models/` directory (recommended)
2. Project root (fallback)

## Troubleshooting

**Model not loading:**
- Ensure `sports-health-gemma2.gguf` is in `models/` directory
- Check llama-cpp-python is installed

**Slow responses:**
- Normal for CPU inference
- Reduce `n_ctx` in local_llm_service.py for faster loading
- Consider GPU acceleration with `n_gpu_layers`

**Empty responses:**
- Model prompt formatting issue
- Check logs in terminal output

## Production Deployment

For production:
1. Deploy to cloud (AWS/GCP/Azure)
2. Add authentication middleware
3. Use managed vector DB (Pinecone/Weaviate)
4. Set up monitoring
5. Configure CORS for your domain

## License

MIT License
