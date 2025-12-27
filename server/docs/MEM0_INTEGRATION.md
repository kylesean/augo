# Mem0 Integration Optimization

## Overview

This document summarizes the Mem0 long-term memory integration optimization for the Augo project.

## Changes Made

### 1. Created Centralized MemoryService (`app/services/memory/memory_service.py`)

A singleton service that provides:
- **CRUD Operations**: `add_conversation_memory`, `get_user_memories`, `get_memory_by_id`, `update_memory`, `delete_memory`, `delete_all_user_memories`
- **Search**: `search_memories` with configurable limit and category filtering
- **Formatting**: `format_memories_for_prompt` for prompt injection
- **Analytics**: `get_memory_stats` for user memory statistics

### 2. Created Memory Management API (`app/api/v1/memory.py`)

New REST endpoints for users to manage their memories:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/memory` | GET | List all user memories |
| `/api/v1/memory/search?q=` | GET | Search memories by query |
| `/api/v1/memory/stats` | GET | Get memory statistics |
| `/api/v1/memory/{id}` | GET | Get specific memory |
| `/api/v1/memory/{id}` | DELETE | Delete specific memory |
| `/api/v1/memory` | DELETE | Delete all user memories |

### 3. Enhanced LongTermMemoryMiddleware (`app/core/langgraph/middleware/memory.py`)

Improvements:
- Uses MemoryService instead of direct AsyncMemory initialization
- Configurable parameters:
  - `max_memories`: Maximum memories to inject (default: 5)
  - `min_relevance_score`: Minimum score threshold (default: 0.0)
  - `categories`: Optional category filtering
- Better multimodal content handling
- Enhanced error handling and logging

### 4. Updated SimpleLangChainAgent (`app/core/langgraph/simple_agent.py`)

Changes:
- Replaced direct `AsyncMemory` usage with `MemoryService`
- Enhanced `_update_long_term_memory()` method with:
  - Session context (session_id)
  - Category tagging
  - Additional metadata support
- Middleware initialization now passes configuration parameters

### 5. Added Memory Update in Chat Stream (`app/api/v1/chatbot.py`)

- After conversation stream completes, user messages are now saved to long-term memory
- Memory update runs asynchronously to not block response
- Graceful error handling ensures response delivery even if memory update fails

### 6. Updated Bootstrap Script (`scripts/bootstrap.py`)

- Uses MemoryService for Mem0 initialization

### 7. Enhanced Configuration (`.env.example`)

- Added comprehensive documentation for Mem0 configuration
- Added `LONG_TERM_MEMORY_COLLECTION_NAME` setting

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Memory Layer                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐     ┌─────────────────────┐                  │
│  │  Memory API  │────▶│   MemoryService     │                  │
│  │  /api/v1/    │     │   (Singleton)       │                  │
│  │   memory     │     │                     │                  │
│  └──────────────┘     │  ┌───────────────┐  │                  │
│                       │  │ AsyncMemory   │  │   ┌──────────┐   │
│  ┌──────────────┐     │  │ (Mem0)        │──┼──▶│ pgvector │   │
│  │ LongTermMem. │────▶│  └───────────────┘  │   └──────────┘   │
│  │ Middleware   │     │                     │                  │
│  └──────────────┘     │  - add()            │                  │
│                       │  - search()         │                  │
│  ┌──────────────┐     │  - get_all()        │                  │
│  │ Chatbot API  │────▶│  - delete()         │                  │
│  │ (stream end) │     │  - format()         │                  │
│  └──────────────┘     └─────────────────────┘                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Memory Flow

### Write Path (Conversation → Memory)
1. User sends message via `/chatbot/chat/stream`
2. Agent processes and generates response
3. After stream completes, `_update_long_term_memory()` is called
4. MemoryService passes messages to Mem0
5. Mem0 extracts key facts using LLM
6. Facts are stored in pgvector with metadata

### Read Path (Memory → Prompt)
1. User sends new message
2. `LongTermMemoryMiddleware.before_invoke()` is triggered
3. MemoryService searches for relevant memories
4. Memories are formatted and injected into system prompt
5. Agent generates response with memory context

## Best Practices Implemented

1. **Singleton Pattern**: MemoryService uses singleton to ensure consistent memory instance
2. **Rich Metadata**: Each memory includes category, session_id, timestamp
3. **Graceful Degradation**: Errors don't break the main flow
4. **Configurable Retrieval**: Relevance threshold and limit are configurable
5. **User Isolation**: Memories are strictly scoped by user_id

## Configuration

### Basic Configuration

```env
# Long Term Memory (Mem0)
LONG_TERM_MEMORY_MODEL=gpt-4o-mini
LONG_TERM_MEMORY_EMBEDDER_PROVIDER=openai
LONG_TERM_MEMORY_EMBEDDER_MODEL=text-embedding-3-small
LONG_TERM_MEMORY_EMBEDDER_DIMS=1024
LONG_TERM_MEMORY_COLLECTION_NAME=longterm_memory
```

### Supported Embedder Providers

#### 1. OpenAI (Default)

```env
LONG_TERM_MEMORY_EMBEDDER_PROVIDER=openai
LONG_TERM_MEMORY_EMBEDDER_MODEL=text-embedding-3-small
LONG_TERM_MEMORY_EMBEDDER_DIMS=1536
# Uses OPENAI_API_KEY by default, or specify:
LONG_TERM_MEMORY_EMBEDDER_API_KEY=sk-xxx
```

#### 2. OpenAI-Compatible APIs (SiliconFlow, DeepSeek, etc.)

```env
LONG_TERM_MEMORY_EMBEDDER_PROVIDER=openai
LONG_TERM_MEMORY_EMBEDDER_MODEL=BAAI/bge-m3
LONG_TERM_MEMORY_EMBEDDER_DIMS=1024
LONG_TERM_MEMORY_EMBEDDER_API_KEY=sk-xxx
LONG_TERM_MEMORY_EMBEDDER_BASE_URL=https://api.siliconflow.cn/v1
```

#### 3. Ollama (Local)

```env
LONG_TERM_MEMORY_EMBEDDER_PROVIDER=ollama
LONG_TERM_MEMORY_EMBEDDER_MODEL=nomic-embed-text
LONG_TERM_MEMORY_EMBEDDER_DIMS=768
LONG_TERM_MEMORY_OLLAMA_BASE_URL=http://localhost:11434
```

Popular Ollama embedding models:
- `nomic-embed-text` (768 dims) - Fast and efficient
- `mxbai-embed-large` (1024 dims) - High quality
- `bge-m3` (1024 dims) - Multilingual

#### 4. HuggingFace

```env
LONG_TERM_MEMORY_EMBEDDER_PROVIDER=huggingface
LONG_TERM_MEMORY_EMBEDDER_MODEL=BAAI/bge-small-en-v1.5
LONG_TERM_MEMORY_EMBEDDER_DIMS=384
LONG_TERM_MEMORY_EMBEDDER_API_KEY=hf_xxx  # Optional
```

### Embedding Dimensions Reference

| Provider | Model | Dimensions |
|----------|-------|------------|
| OpenAI | text-embedding-3-small | 1536 |
| OpenAI | text-embedding-3-large | 3072 |
| OpenAI | text-embedding-ada-002 | 1536 |
| Ollama | nomic-embed-text | 768 |
| Ollama | mxbai-embed-large | 1024 |
| Ollama | bge-m3 | 1024 |
| SiliconFlow | BAAI/bge-m3 | 1024 |
| HuggingFace | BAAI/bge-small-en-v1.5 | 384 |

## Next Steps (Optional)

1. **Memory Cleanup Job**: Add scheduled task to clean old/irrelevant memories
2. **Memory Categories UI**: Allow users to browse memories by category
3. **Memory Export**: API endpoint to export all user memories
4. **Analytics Dashboard**: Visualize memory stats per user
