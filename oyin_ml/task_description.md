# Task: Build FastAPI RAG Service for Sports AI Assistant

## Overview
Build a FastAPI microservice that serves as the AI backend for a sports matchmaking app (like Tinder for sports). The service handles chat interactions with users, using a hybrid approach: RAG for health/safety queries, direct LLM for general sport tips.

## Tech Stack
- **Framework**: FastAPI
- **LLM**: Google Gemini API
- **Vector DB**: ChromaDB
- **Embeddings**: Use Gemini's embedding model or sentence-transformers

## Architecture

```
NestJS Backend → FastAPI Service → Gemini API
                      ↓
                  ChromaDB (for health/safety RAG)
```

## Core Endpoints

### POST /chat
Main chat endpoint for the AI assistant.

**Request:**
```json
{
  "user_id": "string",
  "message": "string",
  "user_context": {
    "preferred_sports": ["tennis", "badminton"],
    "skill_levels": {"tennis": "intermediate", "badminton": "beginner"},
    "injuries": ["recovering from knee injury"],
    "matches_played": 12,
    "recent_matches": [
      {"sport": "tennis", "date": "2024-01-15", "opponent": "user_456"}
    ]
  }
}
```

**Response:**
```json
{
  "response": "string",
  "sources": ["source1.md", "source2.md"],  // only if RAG was used
  "used_rag": true
}
```

### POST /embed-documents
Endpoint to add/update documents in ChromaDB (for admin use).

**Request:**
```json
{
  "documents": [
    {
      "content": "string",
      "metadata": {
        "source": "WHO",
        "sport": "general",
        "topic": "injury_prevention"
      }
    }
  ]
}
```

### GET /health
Health check endpoint.

## Hybrid Logic

Implement a classifier/router that decides whether to use RAG:

**Use RAG when the query contains:**
- Injury-related keywords: injury, pain, hurt, strain, sprain, recovery, rehabilitation
- Safety keywords: safe, dangerous, risk, precaution, warm-up, cool-down, hydration
- Medical keywords: doctor, medical, health, symptom, condition
- First aid keywords: emergency, first aid, what to do if

**Use direct Gemini (no RAG) for:**
- Technique questions: grip, stance, swing, serve, footwork
- Rules questions: scoring, regulations, court dimensions
- Equipment questions: racket, shoes, ball, gear recommendations
- General conversation: greetings, match coordination tips, sport discovery

## RAG Implementation

### Document Processing
1. Load markdown files from `/documents` folder
2. Split into chunks (~500 tokens each)
3. Extract metadata from frontmatter or filename
4. Generate embeddings
5. Store in ChromaDB with metadata

### Retrieval
1. When RAG is triggered, embed the user query
2. Retrieve top 3-5 relevant chunks
3. Include retrieved context in the Gemini prompt
4. Return sources in response

### ChromaDB Collection Schema
```python
collection = chroma_client.create_collection(
    name="sports_health_safety",
    metadata={"hnsw:space": "cosine"}
)

# Document metadata
{
    "source": "WHO | ACSM | ITF | ...",
    "sport": "general | tennis | badminton | ...",
    "topic": "injury_prevention | warm_up | hydration | first_aid | rules"
}
```

## System Prompt Template

```
You are a friendly AI assistant in a sports matchmaking app. Users come to you for advice about sports, finding players to match with, and staying healthy while playing.

User Profile:
- Preferred sports: {preferred_sports}
- Skill levels: {skill_levels}
- Known injuries/conditions: {injuries}
- Matches played: {matches_played}

{if rag_context}
Use the following verified health and safety information to answer:
---
{retrieved_documents}
---
Base your health/safety advice on this information. If the information doesn't fully answer the question, say so.
{endif}

Guidelines:
- Be conversational and encouraging, not preachy
- Remember their injuries and be mindful in suggestions
- For health/safety topics, stick to the provided sources
- For technique/rules, use your general knowledge
- Suggest trying new sports based on their interests
- Keep responses concise unless they ask for detail
```

## Project Structure

```
sports-ai-service/
├── app/
│   ├── main.py              # FastAPI app, endpoints
│   ├── config.py            # Settings, API keys
│   ├── models.py            # Pydantic models
│   ├── services/
│   │   ├── chat_service.py  # Main chat logic
│   │   ├── rag_service.py   # RAG logic, ChromaDB
│   │   ├── llm_service.py   # Gemini API wrapper
│   │   └── router.py        # RAG vs direct classifier
│   └── utils/
│       └── document_loader.py
├── documents/               # Markdown files for RAG
│   ├── general_safety.md
│   ├── warm_up_guidelines.md
│   ├── tennis_injuries.md
│   └── ...
├── tests/
├── requirements.txt
├── .env.example
└── README.md
```

## Requirements.txt

```
fastapi>=0.104.0
uvicorn>=0.24.0
chromadb>=0.4.0
google-generativeai>=0.3.0
python-dotenv>=1.0.0
pydantic>=2.0.0
sentence-transformers>=2.2.0  # alternative embeddings
```

## Environment Variables

```
GEMINI_API_KEY=your_key_here
CHROMA_PERSIST_DIRECTORY=./chroma_db
ENVIRONMENT=development
```

## Additional Notes

1. **Startup**: On startup, load all documents from `/documents` folder into ChromaDB if not already loaded
2. **Caching**: Consider caching frequent queries
3. **Logging**: Log all requests with user_id, query type (RAG/direct), and response time
4. **Error handling**: Graceful fallback if Gemini API fails
5. **Rate limiting**: Implement basic rate limiting per user_id

## Testing Checklist

- [ ] Health endpoint returns 200
- [ ] Chat endpoint handles missing user_context gracefully
- [ ] RAG triggers correctly for safety queries
- [ ] RAG does NOT trigger for technique queries
- [ ] Sources are returned when RAG is used
- [ ] User injuries are referenced appropriately in responses
- [ ] Documents are loaded into ChromaDB on startup