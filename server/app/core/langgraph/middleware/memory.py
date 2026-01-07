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

from app.core.langgraph.middleware.base import BaseMiddleware
from app.core.logging import logger
from app.services.memory import MemoryService, get_memory_service


class LongTermMemoryMiddleware(BaseMiddleware):
    """Middleware for long-term memory operations.

    STATUS: PASSIVE (no-op)

    This middleware is currently disabled. Memory operations are now handled by:

    WRITE PATH:
        chatbot.py -> agent._update_long_term_memory() -> MemoryService.add_conversation_memory()

    READ PATH:
        Agent tool 'search_personal_context' -> MemoryService.search_memories()

    BENEFITS OF CURRENT DESIGN:
        - Agent can call memory tool on-demand instead of every conversation
        - Supports i18n and finer-grained control
        - Reduces unnecessary memory queries and latency

    This middleware framework is preserved for potential future use cases:
        - Global context injection (e.g., user profile summary)
        - Mandatory memory retrieval for specific scenarios
    """

    name = "LongTermMemoryMiddleware"

    def __init__(
        self,
        memory: Optional[object] = None,  # Deprecated, kept for compatibility
        max_memories: int = 5,
        min_relevance_score: float = 0.0,
        categories: Optional[list[str]] = None,
    ):
        """Initialize the middleware."""
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

        MODIFIED: Now passive. Primary memory retrieval is handled by 'search_personal_context' tool.
        """
        # We skip automatic injection here to give full control to the Agent via tools.
        return messages, config
