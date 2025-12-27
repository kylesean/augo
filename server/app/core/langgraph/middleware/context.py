"""Dynamic context middleware for injecting runtime context into agent prompts.

This middleware injects dynamic information like current time and user ID
into the system prompt before agent invocation.
"""

from datetime import datetime

from langchain_core.messages import BaseMessage

from app.core.langgraph.middleware.base import BaseMiddleware, inject_system_message
from app.core.logging import logger


class DynamicContextMiddleware(BaseMiddleware):
    """Middleware for injecting dynamic context into system prompt.

    This middleware adds runtime information such as:
    - Current timestamp
    - User ID (if available)

    The context is injected as a system message to keep the base
    system prompt stable for better caching.

    Follows LangChain 1.0 middleware best practices.
    """

    name = "DynamicContextMiddleware"

    async def before_invoke(
        self,
        messages: list[BaseMessage],
        config: dict,
    ) -> tuple[list[BaseMessage], dict]:
        """Inject dynamic context before agent invocation.

        Args:
            messages: List of messages to send to agent
            config: Configuration dict for agent invocation

        Returns:
            Modified (messages, config) tuple with context injected
        """
        from zoneinfo import ZoneInfo

        context_parts = []
        user_uuid = config.get("configurable", {}).get("user_uuid")

        # Get user timezone from config or default to Asia/Shanghai
        user_timezone = config.get("configurable", {}).get("user_timezone", "Asia/Shanghai")

        # Get current time in user's timezone (ISO 8601 format)
        current_time = datetime.now(ZoneInfo(user_timezone))
        time_str = current_time.isoformat()  # e.g., "2024-12-04T14:30:00+08:00"

        context_parts.append(f"当前时间: {time_str}")

        # Add user ID if available
        if user_uuid:
            context_parts.append(f"用户ID: {user_uuid}")

        # Build context string
        if context_parts:
            context_str = "\n".join(context_parts)
            context_message = f"# 动态上下文\n{context_str}"

            # Inject into system message
            messages = inject_system_message(messages, context_message)

            logger.debug(
                "dynamic_context_injected",
                has_user_uuid=bool(user_uuid),
                timestamp=time_str,
            )

        return messages, config
