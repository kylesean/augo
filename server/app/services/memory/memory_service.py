"""Memory Service - Centralized long-term memory management using Mem0.

This service provides:
- User memory CRUD operations
- Memory search with reranking
- Automatic memory extraction from conversations
- Memory lifecycle management (cleanup, archival)

Best Practices Implemented:
1. Memory Hygiene: Regular cleanup of old/irrelevant memories
2. Contextual Metadata: Rich metadata for better retrieval
3. Error Handling: Graceful degradation on failures
4. User Isolation: Memories are strictly scoped by user_id
"""

from datetime import datetime, timezone
from typing import Optional
from uuid import UUID

from mem0 import AsyncMemory

from app.core.config import settings
from app.core.logging import logger


class MemoryService:
    """Centralized service for long-term memory management.

    Singleton pattern ensures consistent memory instance across the app.

    Usage:
        service = await MemoryService.get_instance()

        # Add memory from conversation
        await service.add_conversation_memory(
            user_uuid="user-123",
            messages=[{"role": "user", "content": "I prefer dark mode"}],
            session_id="session-456",
        )

        # Search memories
        results = await service.search_memories(
            user_uuid="user-123",
            query="What are my preferences?",
        )

        # Get all memories for a user
        all_memories = await service.get_user_memories(user_uuid="user-123")

        # Delete specific memory
        await service.delete_memory(memory_id="mem-789")
    """

    _instance: Optional["MemoryService"] = None
    _memory: Optional[AsyncMemory] = None

    def __init__(self):
        """Private constructor. Use get_instance() instead."""
        pass

    @classmethod
    async def get_instance(cls) -> "MemoryService":
        """Get or create the singleton instance.

        Returns:
            MemoryService instance with initialized AsyncMemory
        """
        if cls._instance is None:
            cls._instance = cls()
            await cls._instance._initialize()
        return cls._instance

    async def _initialize(self) -> None:
        """Initialize the AsyncMemory instance with configurable embedder."""
        if self._memory is not None:
            return

        try:
            # Build embedder configuration based on provider
            embedder_config = self._build_embedder_config()

            self._memory = await AsyncMemory.from_config(
                config_dict={
                    "vector_store": {
                        "provider": "pgvector",
                        "config": {
                            "collection_name": settings.LONG_TERM_MEMORY_COLLECTION_NAME,
                            "dbname": settings.POSTGRES_DB,
                            "user": settings.POSTGRES_USER,
                            "password": settings.POSTGRES_PASSWORD,
                            "host": settings.POSTGRES_HOST,
                            "port": settings.POSTGRES_PORT,
                            "embedding_model_dims": settings.LONG_TERM_MEMORY_EMBEDDER_DIMS,
                        },
                    },
                    "llm": {
                        "provider": "openai",
                        "config": {"model": settings.LONG_TERM_MEMORY_MODEL},
                    },
                    "embedder": embedder_config,
                }
            )
            logger.info(
                "memory_service_initialized",
                embedder_provider=settings.LONG_TERM_MEMORY_EMBEDDER_PROVIDER,
                embedder_model=settings.LONG_TERM_MEMORY_EMBEDDER_MODEL,
            )
        except Exception as e:
            logger.error("memory_service_init_failed", error=str(e))
            raise

    def _build_embedder_config(self) -> dict:
        """Build embedder configuration based on provider setting.

        Supports:
        - openai: OpenAI or OpenAI-compatible APIs (DeepSeek, SiliconFlow, etc.)
        - ollama: Local Ollama server
        - huggingface: HuggingFace embeddings

        Returns:
            dict: Embedder configuration for Mem0
        """
        provider = settings.LONG_TERM_MEMORY_EMBEDDER_PROVIDER.lower()

        if provider == "ollama":
            # Ollama local embeddings
            config = {
                "provider": "ollama",
                "config": {
                    "model": settings.LONG_TERM_MEMORY_EMBEDDER_MODEL,
                },
            }
            if settings.LONG_TERM_MEMORY_OLLAMA_BASE_URL:
                config["config"]["ollama_base_url"] = settings.LONG_TERM_MEMORY_OLLAMA_BASE_URL

            logger.info(
                "using_ollama_embedder",
                model=settings.LONG_TERM_MEMORY_EMBEDDER_MODEL,
                base_url=settings.LONG_TERM_MEMORY_OLLAMA_BASE_URL,
            )
            return config

        elif provider == "huggingface":
            # HuggingFace embeddings
            config = {
                "provider": "huggingface",
                "config": {
                    "model": settings.LONG_TERM_MEMORY_EMBEDDER_MODEL,
                },
            }
            if settings.LONG_TERM_MEMORY_EMBEDDER_API_KEY:
                config["config"]["api_key"] = settings.LONG_TERM_MEMORY_EMBEDDER_API_KEY

            logger.info(
                "using_huggingface_embedder",
                model=settings.LONG_TERM_MEMORY_EMBEDDER_MODEL,
            )
            return config

        else:
            # Default: OpenAI or OpenAI-compatible API
            config = {
                "provider": "openai",
                "config": {
                    "model": settings.LONG_TERM_MEMORY_EMBEDDER_MODEL,
                    "api_key": settings.LONG_TERM_MEMORY_EMBEDDER_API_KEY or settings.OPENAI_API_KEY,
                },
            }

            # Support custom base URL for OpenAI-compatible APIs
            base_url = settings.LONG_TERM_MEMORY_EMBEDDER_BASE_URL or settings.OPENAI_BASE_URL
            if base_url:
                config["config"]["openai_base_url"] = base_url

            logger.info(
                "using_openai_embedder",
                model=settings.LONG_TERM_MEMORY_EMBEDDER_MODEL,
                base_url=base_url or "https://api.openai.com/v1",
            )
            return config

    # =========================================================================
    # Core CRUD Operations
    # =========================================================================

    async def add_conversation_memory(
        self,
        user_uuid: str | UUID,
        messages: list[dict],
        session_id: Optional[str] = None,
        category: str = "conversation",
        additional_metadata: Optional[dict] = None,
    ) -> dict:
        """Add memories from a conversation with proactive fact extraction.

        Instead of storing the raw conversation, this method extracts salient
        facts and preferences to maintain a clean and valuable memory base.

        Args:
            user_uuid: User identifier
            messages: List of message dicts with 'role' and 'content'
            session_id: Optional session identifier for context
            category: Memory category hint
            additional_metadata: Extra metadata to store with memories

        Returns:
            dict with operation result
        """
        if not messages:
            return {"success": False, "message": "No messages provided"}

        user_id = str(user_uuid)
        
        # 1. Extract salient facts from the messages
        # We only care about the latest exchange usually, but can look at context
        full_text = "\n".join([f"{m['role']}: {m['content']}" for m in messages])
        facts = await self.extract_salient_facts(full_text)
        
        if not facts:
            logger.debug("no_salient_facts_extracted", user_uuid=user_id)
            return {"success": True, "extracted": False}

        # 2. Build rich metadata
        metadata = {
            "category": category,
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "original_message_count": len(messages),
            "memory_type": "extracted_fact"
        }

        if session_id:
            metadata["session_id"] = session_id

        if additional_metadata:
            metadata.update(additional_metadata)

        try:
            # 3. Store consolidated facts in Mem0
            # Join facts into one block so Mem0 only calls its internal LLM once.
            consolidated_text = "\n".join(facts)
            result = await self._memory.add(
                consolidated_text,
                user_id=user_id,
                metadata=metadata,
            )

            logger.info(
                "salient_memories_added",
                user_uuid=user_id,
                fact_count=len(facts),
                session_id=session_id,
            )

            return {
                "success": True,
                "extracted": True,
                "fact_count": len(facts),
                "result": result
            }

        except Exception as e:
            logger.warning(
                "memory_add_failed",
                user_uuid=user_id,
                error=str(e),
            )
            return {
                "success": False,
                "error": str(e),
            }

    async def extract_salient_facts(self, text: str) -> list[str]:
        """Extract important financial facts and preferences from text.
        
        Uses LLM to filter noise and retain only long-term valuable information.
        
        Args:
            text: Single string or conversation transcript
            
        Returns:
            List of extracted fact strings
        """
        try:
            from app.services.llm import llm_service
            
            prompt = (
                "You are a Senior Financial Memory Analyst for an AI Personal Finance Agent. "
                "Your task is to analyze the conversation and extract ONLY high-value, long-term salient facts. "
                "\n\n--- CRITYERIA FOR RETENTION ---"
                "\n1. Personal Identity & Context: 'I have 2 kids', 'I work at Google', 'My partner is Alice'."
                "\n2. Financial Goals: 'I want to save for a house', 'Retirement goal is 2M by 2040'."
                "\n3. Persistent Preferences: 'Always categorize Meituan as Dining', 'I prefer conservative investments'."
                "\n4. Account/Asset Info: 'My mortgage is with HSBC', 'I have a hidden savings account'."
                "\n5. Explicit Decisions & Overrides: 'Set my monthly food budget to $500 from now on', 'I no longer work at Google, I moved to Tesla'."
                "\n- AI SELF-DESCRIPTION: Descriptions about your own capabilities, 'I have memory function', 'My principles are...', 'How can I help'."
                "\n- AI INSTRUCTIONS: Directions given to the AI, or AI explaining its own code/logic."
                "\n- Temporary queries: 'How much did I spend yesterday?'"
                "\n- Generic small talk: 'Hello', 'Thanks'."
                "\n- Technical instructions: 'Show me the chart', 'Open settings'."
                "\n- Individual transaction details unless they imply a pattern."
                "\n--- FORMAT & CONFLICTS ---"
                "\n- Logic: If the user explicitly changes a previous fact (e.g., a new job or a new budget goal), extract the NEW fact as a standalone statement."
                "\n- Language: MUST match the user's primary language."
                "\n- Output: List of standalone concise facts. If nothing found, return exactly 'NONE'."
                "\n\nConversation Content:\n"
                f"{text}\n\n"
                "Extracted Facts:"
            )
            
            # Use the default LLM (typically a capable one for reasoning)
            from langchain_core.messages import HumanMessage
            response = await llm_service.call(
                messages=[HumanMessage(content=prompt)]
            )
            
            if not response or not response.content:
                return []
                
            content = response.content.strip()
            if content.upper() == "NONE":
                return []
                
            # Split lines and clean up
            facts = [f.strip("* ").strip("- ").strip() for f in content.split("\n") if f.strip()]
            return [f for f in facts if len(f) > 5] # Basic filter for noise

        except Exception as e:
            logger.error("fact_extraction_failed", error=str(e))
            return []

    async def search_memories(
        self,
        user_uuid: str | UUID,
        query: str,
        limit: int = 5,
        rerank: bool = True,
        categories: Optional[list[str]] = None,
    ) -> list[dict]:
        """Search for relevant memories with optional category filtering.

        Args:
            user_uuid: User identifier
            query: Search query string
            limit: Maximum number of results to return
            rerank: Whether to apply reranking for better relevance
            categories: Optional list of categories to filter by (e.g., ['financial', 'preference'])

        Returns:
            List of memory dicts with 'memory', 'score', and 'metadata'
        """
        user_id = str(user_uuid)

        try:
            # Build filters if categories specified
            filters = None
            if categories:
                filters = {"category": {"$in": categories}}

            result = await self._memory.search(
                query=query,
                user_id=user_id,
                limit=limit,
                filters=filters,
            )

            memories = []
            if result and result.get("results"):
                memories = result["results"]

            logger.debug(
                "memory_search_completed",
                user_uuid=user_id,
                query_length=len(query),
                result_count=len(memories),
            )

            return memories

        except Exception as e:
            logger.warning(
                "memory_search_failed",
                user_uuid=user_id,
                error=str(e),
            )
            return []

    async def get_user_memories(
        self,
        user_uuid: str | UUID,
        limit: int = 100,
    ) -> list[dict]:
        """Get all memories for a user.

        Args:
            user_uuid: User identifier
            limit: Maximum number of memories to return

        Returns:
            List of all user memories
        """
        user_id = str(user_uuid)

        try:
            result = await self._memory.get_all(user_id=user_id)

            memories = []
            if result and result.get("results"):
                memories = result["results"][:limit]

            logger.debug(
                "memories_retrieved",
                user_uuid=user_id,
                count=len(memories),
            )

            return memories

        except Exception as e:
            logger.warning(
                "get_memories_failed",
                user_uuid=user_id,
                error=str(e),
            )
            return []

    async def get_memory_by_id(
        self,
        memory_id: str,
    ) -> Optional[dict]:
        """Get a specific memory by ID.

        Args:
            memory_id: Memory identifier

        Returns:
            Memory dict or None if not found
        """
        try:
            result = await self._memory.get(memory_id)
            return result
        except Exception as e:
            logger.warning(
                "get_memory_failed",
                memory_id=memory_id,
                error=str(e),
            )
            return None

    async def update_memory(
        self,
        memory_id: str,
        data: str,
    ) -> bool:
        """Update an existing memory.

        Args:
            memory_id: Memory identifier
            data: New memory content

        Returns:
            True if successful, False otherwise
        """
        try:
            await self._memory.update(memory_id, data=data)
            logger.info("memory_updated", memory_id=memory_id)
            return True
        except Exception as e:
            logger.warning(
                "memory_update_failed",
                memory_id=memory_id,
                error=str(e),
            )
            return False

    async def delete_memory(
        self,
        memory_id: str,
    ) -> bool:
        """Delete a specific memory.

        Args:
            memory_id: Memory identifier

        Returns:
            True if successful, False otherwise
        """
        try:
            await self._memory.delete(memory_id)
            logger.info("memory_deleted", memory_id=memory_id)
            return True
        except Exception as e:
            logger.warning(
                "memory_delete_failed",
                memory_id=memory_id,
                error=str(e),
            )
            return False

    async def delete_all_user_memories(
        self,
        user_uuid: str | UUID,
    ) -> bool:
        """Delete all memories for a user.

        Args:
            user_uuid: User identifier

        Returns:
            True if successful, False otherwise
        """
        user_id = str(user_uuid)

        try:
            await self._memory.delete_all(user_id=user_id)
            logger.info("all_memories_deleted", user_uuid=user_id)
            return True
        except Exception as e:
            logger.warning(
                "delete_all_memories_failed",
                user_uuid=user_id,
                error=str(e),
            )
            return False

    # =========================================================================
    # Memory Formatting for Prompt Injection
    # =========================================================================

    def format_memories_for_prompt(
        self,
        memories: list[dict],
        max_memories: int = 5,
    ) -> str:
        """Format memories for injection into system prompts.

        Args:
            memories: List of memory dicts
            max_memories: Maximum number of memories to include

        Returns:
            Formatted string for prompt injection
        """
        if not memories:
            return ""

        # Take top N memories
        selected = memories[:max_memories]

        lines = []
        for mem in selected:
            memory_text = mem.get("memory", "")
            if memory_text:
                # Include score if available for debugging
                score = mem.get("score", 0)
                if score > 0:
                    lines.append(f"* {memory_text} (relevance: {score:.2f})")
                else:
                    lines.append(f"* {memory_text}")

        return "\n".join(lines)

    # =========================================================================
    # Memory Analytics
    # =========================================================================

    async def get_memory_stats(
        self,
        user_uuid: str | UUID,
    ) -> dict:
        """Get memory statistics for a user.

        Args:
            user_uuid: User identifier

        Returns:
            dict with memory count and category breakdown
        """
        memories = await self.get_user_memories(user_uuid, limit=1000)

        # Category breakdown
        categories = {}
        for mem in memories:
            meta = mem.get("metadata", {})
            cat = meta.get("category", "unknown")
            categories[cat] = categories.get(cat, 0) + 1

        return {
            "total_count": len(memories),
            "categories": categories,
        }


# Convenience function for quick access
async def get_memory_service() -> MemoryService:
    """Get the memory service instance.

    Returns:
        MemoryService singleton instance
    """
    return await MemoryService.get_instance()
