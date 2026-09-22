# n8n RAG Knowledge Assistant

End-to-end Retrieval-Augmented Generation (RAG) assistant built with n8n, Groq, Ollama, Supabase pgvector, and Google Drive.

## System Architecture

![RAG Knowledge Assistant Architecture](docs/architecture.png)

The system separates document ingestion from question answering. Documents are processed and embedded into Supabase pgvector, while the AI Agent retrieves relevant context before generating grounded responses.

## Workflows

### Workflow 1 — RAG Knowledge Ingestion

The ingestion workflow prepares documents for semantic search.

**Pipeline:**

Google Drive → PDF Download → Data Loader → Text Splitting → Ollama Embeddings → Supabase pgvector

**Configuration:**
- Chunk size: 800 characters
- Chunk overlap: 120 characters
- Embedding model: `nomic-embed-text`
- Embedding dimensions: 768
- Vector table: `rag_documents`

### Workflow 2 — RAG Agent Final

The agent workflow handles user questions and retrieves relevant document context before generating an answer.

**Pipeline:**

Chat Trigger → AI Agent → Supabase Vector Store → Retrieved Context → Groq LLM → Answer

**LLM:** `openai/gpt-oss-20b`

**Vector retrieval:** `match_documents`

## Key Features

- 📄 PDF knowledge-base ingestion
- 🔎 Semantic vector search using Supabase pgvector
- 🧠 Ollama `nomic-embed-text` embeddings
- 🤖 AI Agent with tool-based retrieval
- ⚡ Groq `openai/gpt-oss-20b` for response generation
- 🔐 Document-grounded responses
- 🛑 Prevents unsupported answers when information is not found
- 🔄 Separate ingestion and query workflows
- 🧩 Modular n8n architecture

## Technology Stack

| Technology | Purpose |
|---|---|
| n8n | Workflow automation and AI Agent orchestration |
| Google Drive | Knowledge-base document storage |
| Ollama | Local embedding generation |
| nomic-embed-text | 768-dimensional embeddings |
| Supabase | PostgreSQL + pgvector vector storage |
| Groq | LLM inference |
| GPT-OSS-20B | Response generation |
| PostgreSQL | Vector database backend |

## Testing & Validation

The RAG assistant was tested with both positive and negative knowledge-base queries.

| Query | Result |
|---|---|
| What is the project name? | ✅ Atlas Support Assistant |
| What is the project code? | ✅ ATLAS-47 |
| What is the embedding model? | ✅ nomic-embed-text |
| What is the CEO's name? | ✅ Information not found in the uploaded document |

The negative test verifies that the assistant does not provide an unsupported answer when the requested information is absent from the knowledge base.

## Challenges Faced

### 1. Embedding Model and Vector Dimension Compatibility

Initially, different embedding providers produced incompatible vector dimensions for the Supabase pgvector table. The system was standardized on Ollama `nomic-embed-text`, which produces 768-dimensional embeddings, and the `rag_documents` table was configured accordingly.

### 2. Retrieval Accuracy for Short Queries

Short questions such as "What is the project code?" did not always return the most relevant chunk when only one document was retrieved. The retrieval configuration was tuned to return multiple relevant candidates, allowing the AI Agent to use the correct context before generating the final response.

## Limitations

- The current knowledge base depends on the documents that have been ingested into Supabase.
- Updating source documents requires running the ingestion workflow again.
- Retrieval quality can vary for very short or ambiguous queries.
- The current implementation is primarily designed for document-based question answering rather than general-purpose web research.
- Ollama embeddings require the Ollama service to be available when generating or querying embeddings.
- The current project has been validated with a controlled knowledge base and would require additional testing with larger and more diverse document collections for production use.

## What's Next

- Add support for multiple document types such as DOCX, TXT, and additional PDF sources.
- Implement automatic document update and re-indexing when files change.
- Add conversation memory for multi-turn questions.
- Add source citations so users can see which document chunks support each answer.
- Add authentication and user-specific knowledge bases.
- Add monitoring for retrieval quality, latency, token usage, and LLM costs.
- Deploy the complete system as a production-ready application.
- Add evaluation datasets and automated RAG quality testing.

## Project Structure

```text
n8n-rag-knowledge-assistant/
├── workflows/
│   ├── rag-knowledge-ingestion.json
│   └── rag-agent-final.json
├── database/
│   └── match_documents.sql
├── docs/
│   └── architecture.png
├── README.md
├── LICENSE
└── .gitignore
```
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
---

## 6. Setup

Then:

```markdown
## Setup

1. Import the two workflow JSON files into n8n.
2. Configure your own Google Drive, Supabase, Ollama, and Groq credentials.
3. Select your knowledge-base PDF in the ingestion workflow.
4. Create the `rag_documents` vector table.
5. Configure the `match_documents` Supabase RPC using the SQL file in `database/`.
6. Run the ingestion workflow to index the documents.
7. Run the RAG Agent workflow and start asking questions.
```

## Security

Workflow exports are sanitized to remove n8n credential references and instance-specific identifiers. Never commit API keys, passwords, `.env` files, or credential exports.
