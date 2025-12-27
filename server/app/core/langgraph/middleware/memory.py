"""Long-term memory middleware for injecting user memories into agent prompts.

This middleware fetches relevant memories from Mem0 and injects them
into the system prompt before agent invocation.

Enhanced Features:
- Configurable memory limits and relevance thresholds
- Category-based memory filtering
- Rich logging for debugging
- Graceful degradation on errors
"""

from typing import Optional

from langchain_core.messages import BaseMessage, HumanMessage

from app.core.langgraph.middleware.base import BaseMiddleware, inject_system_message
from app.core.logging import logger
from app.services.memory import MemoryService, get_memory_service


class LongTermMemoryMiddleware(BaseMiddleware):
    """Middleware for injecting long-term memory into system prompt.

    This middleware:
    1. Extracts user_uuid from config
    2. Fetches relevant memories from Mem0 using MemoryService
    3. Injects formatted memories into system prompt

    Configuration:
        max_memories: Maximum number of memories to inject (default: 5)
        min_relevance_score: Minimum score threshold (default: 0.0)
        categories: Optional list of categories to filter by

    Follows LangChain 1.0 middleware best practices.
    """

    name = "LongTermMemoryMiddleware"

    def __init__(
        self,
        memory: Optional[object] = None,  # Deprecated, kept for compatibility
        max_memories: int = 5,
        min_relevance_score: float = 0.0,
        categories: Optional[list[str]] = None,
    ):
        """Initialize the middleware.

        Args:
            memory: Deprecated parameter, ignored (uses MemoryService instead)
            max_memories: Maximum number of memories to inject
            min_relevance_score: Minimum relevance score for memory inclusion
            categories: Optional list of categories to filter memories
        """
        self.max_memories = max_memories
        self.min_relevance_score = min_relevance_score
        self.categories = categories
        self._memory_service: Optional[MemoryService] = None

    async def _get_memory_service(self) -> MemoryService:
        """Get or initialize the memory service."""
        if self._memory_service is None:
            self._memory_service = await get_memory_service()
        return self._memory_service

    async def before_invoke(
        self,
        messages: list[BaseMessage],
        config: dict,
    ) -> tuple[list[BaseMessage], dict]:
        """Inject long-term memory before agent invocation.

        Args:
            messages: List of messages to send to agent
            config: Configuration dict for agent invocation

        Returns:
            Modified (messages, config) tuple with memories injected
        """
        # Extract user_uuid from config
        user_uuid = config.get("configurable", {}).get("user_uuid")

        if not user_uuid:
            logger.debug("memory_middleware_skipped_no_user_uuid")
            return messages, config

        # Extract query from last user message
        query = self._extract_query(messages)

        if not query:
            logger.debug("memory_middleware_skipped_no_query")
            return messages, config

        # Fetch relevant memories using MemoryService
        memory_content = await self._get_relevant_memory(user_uuid, query)

        if memory_content:
            # Inject memories into system message
            memory_section = f"# 用户相关记忆\n以下是关于该用户的历史记忆，请在回答时参考这些信息：\n{memory_content}"
            messages = inject_system_message(messages, memory_section)

            logger.info(
                "long_term_memory_injected",
                user_uuid=user_uuid,
                memory_count=memory_content.count("\n* ") + 1,
            )
        else:
            logger.debug(
                "memory_middleware_no_memories_found",
                user_uuid=user_uuid,
            )

        return messages, config

    def _extract_query(self, messages: list[BaseMessage]) -> str:
        """Extract query from last user message.

        Args:
            messages: List of messages

        Returns:
            Content of last user message, or empty string
        """
        for msg in reversed(messages):
            if isinstance(msg, HumanMessage):
                content = msg.content
                # Handle multimodal content (list of dicts)
                if isinstance(content, list):
                    for item in content:
                        if isinstance(item, dict) and item.get("type") == "text":
                            return item.get("text", "")
                    return ""
                return content if isinstance(content, str) else ""
        return ""

    async def _get_relevant_memory(
        self,
        user_uuid: str,
        query: str,
    ) -> str:
        """Retrieve and format relevant memories.

        Args:
            user_uuid: User ID to fetch memories for
            query: Query to search memories

        Returns:
            Formatted memory string, or empty string on error
        """
        try:
            service = await self._get_memory_service()

            # Search for relevant memories
            memories = await service.search_memories(
                user_uuid=user_uuid,
                query=query,
                limit=self.max_memories,
                categories=self.categories,
            )

            if not memories:
                return ""

            # Filter by relevance score if threshold is set
            if self.min_relevance_score > 0:
                memories = [m for m in memories if m.get("score", 0) >= self.min_relevance_score]

            # Format memories for prompt injection
            return service.format_memories_for_prompt(
                memories,
                max_memories=self.max_memories,
            )

        except Exception as e:
            logger.error(
                "failed_to_get_relevant_memory",
                error=str(e),
                user_uuid=user_uuid,
            )
            # Return empty string to continue without memories
            return ""
