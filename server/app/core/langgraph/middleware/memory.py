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

    MODIFIED: Now passive for retrieval. Primary memory retrieval is handled 
    internally by the 'search_personal_context' tool to support i18n and 
    reduce noise.
    
    This middleware remains for lifecycle management and potential future
    mandatory global context injection.
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
