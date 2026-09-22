# n8n RAG Knowledge Assistant

End-to-end Retrieval-Augmented Generation (RAG) assistant built with n8n, Groq, Ollama, Supabase pgvector, and Google Drive.

## Workflows

- **RAG Knowledge Ingestion** — indexes PDF knowledge into Supabase.
- **RAG Agent Final** — retrieves relevant knowledge and answers user questions.

## Stack

- n8n
- Groq `openai/gpt-oss-20b`
- Ollama `nomic-embed-text`
- Supabase PostgreSQL / pgvector
- Google Drive

## Configuration

- Chunk size: 800
- Chunk overlap: 120
- Embedding dimensions: 768
- Vector table: `rag_documents`
- Retrieval RPC: `match_documents`
- Retrieval limit: 4

## Verified tests

- Project name → `Atlas Support Assistant`
- Project code → `ATLAS-47`
- Embedding model → `nomic-embed-text`
- Unknown CEO question → information not found in the uploaded document

## Structure

```text
n8n-rag-knowledge-assistant/
├── workflows/
│   ├── rag-knowledge-ingestion.json
│   └── rag-agent-final.json
├── database/
│   └── match_documents.sql
├── README.md
└── .gitignore
```

## Security

Workflow exports are sanitized to remove n8n credential references and instance-specific identifiers. Never commit API keys, passwords, `.env` files, or credential exports.
