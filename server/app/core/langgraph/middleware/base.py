"""Base middleware classes for LangChain agent middleware system.

This module defines the base middleware interface and the agent wrapper
that applies middleware to agent invocations.

Based on LangChain 1.0 middleware best practices:
- Supports both node-style (before/after) and wrap-style hooks
- Configurable error handling strategies
- Optional hook implementations (no abstract methods)
"""

from abc import ABC, abstractmethod
from collections.abc import AsyncGenerator, Callable
from typing import Any, cast

from langchain_core.messages import BaseMessage, SystemMessage
from langgraph.types import Command

from app.core.logging import logger


class BaseMiddleware(ABC):
    """Base class for agent middleware following LangChain 1.0 best practices.

    Middleware can intercept and modify agent execution at multiple points:
    - before_invoke/after_invoke: Node-style hooks for pre/post processing
    - wrap_model_call: Wrap-style hook for full control over execution
    - before_stream/after_stream: Streaming-specific hooks

    All hooks are optional - implement only what you need.
    """

    @property
    @abstractmethod
    def name(self) -> str:
        """Name of the middleware (abstract)."""
        pass

    async def before_invoke(
        self,
        messages: list[BaseMessage],
        config: dict[str, Any],
    ) -> tuple[list[BaseMessage], dict[str, Any]]:
        """Called before agent invocation (optional).

        Args:
            messages: List of messages to send to agent
            config: Configuration dict for agent invocation

        Returns:
            Modified (messages, config) tuple
        """
        return messages, config

    async def after_invoke(
        self,
        result: dict[str, Any],
        config: dict[str, Any],
    ) -> dict[str, Any]:
        """Called after agent invocation (optional).

        Args:
            result: Result dict from agent invocation
            config: Configuration dict used for invocation

        Returns:
            Modified result dict
        """
        return result

    async def wrap_model_call(
        self,
        request: dict,
        handler: Callable,
    ) -> Any:
        """Wrap the entire model call for full control (optional).

        This wrap-style hook allows middleware to:
        - Retry on failures
        - Cache results
        - Switch models dynamically
        - Add circuit breakers

        Args:
            request: Request dict containing messages, config, etc.
            handler: Function to call the actual model

        Returns:
            Result from handler or modified result
        """
        return await handler(request)

    async def before_stream(
        self,
        messages: list[BaseMessage],
        config: dict[str, Any],
    ) -> tuple[list[BaseMessage], dict[str, Any]]:
        """Called before agent streaming (optional).

        Default implementation delegates to before_invoke.

        Args:
            messages: List of messages to send to agent
            config: Configuration dict for agent invocation

        Returns:
            Modified (messages, config) tuple
        """
        return await self.before_invoke(messages, config)

    async def after_stream(
        self,
        config: dict[str, Any],
    ) -> None:
        """Called after agent streaming completes (optional).

        Args:
            config: Configuration dict used for invocation
        """
        return  # B027: Non-abstract empty method in ABC

    def should_continue_on_error(self) -> bool:
        """Determine if execution should continue when this middleware fails.

        Returns:
            True to continue with original values on error, False to raise
        """
        return True


class MiddlewareAgent:
    """Agent wrapper that applies middleware stack following LangChain 1.0 patterns.

    This wrapper intercepts agent invocations and applies a stack of
    middleware before and after execution. It maintains compatibility
    with the standard LangChain agent interface.

    Execution order (per LangChain 1.0 spec):
    - before_* hooks: first to last
    - after_* hooks: last to first (reversed)
    """

    def __init__(
        self,
        agent: Any,
        middlewares: list[BaseMiddleware],
        continue_on_error: bool = True,
    ) -> None:
        """Initialize middleware agent.

        Args:
            agent: The underlying LangChain agent
            middlewares: List of middleware to apply (in order)
            continue_on_error: Global flag for error handling strategy
        """
        self.agent = agent
        self.middlewares = middlewares
        self.continue_on_error = continue_on_error
        logger.info(
            "middleware_agent_initialized",
            middleware_count=len(middlewares),
            middleware_types=[m.name for m in middlewares],
        )

    async def ainvoke(
        self,
        input_data: dict,
        config: dict | None = None,
    ) -> dict:
        """Invoke agent with middleware processing.

        Follows LangChain 1.0 execution order:
        - before_invoke: first to last
        - after_invoke: last to first (reversed)

        Args:
            input_data: Input dict with "messages" key
            config: Configuration dict for agent invocation

        Returns:
            Result dict from agent invocation
        """
        if config is None:
            config = {}

        messages = input_data.get("messages", [])

        # Apply before_invoke middleware (forward order)
        for middleware in self.middlewares:
            try:
                messages, config = await middleware.before_invoke(messages, config)
                logger.debug(
                    "middleware_before_invoke_applied",
                    middleware=middleware.name,
                )
            except Exception as e:
                should_continue = (
                    self.continue_on_error
                    if self.continue_on_error is not None
                    else middleware.should_continue_on_error()
                )
                logger.error(
                    "middleware_before_invoke_failed",
                    middleware=middleware.name,
                    error=str(e),
                    continue_on_error=should_continue,
                )
                if not should_continue:
                    raise

        # Prepare agent input (preserve original input data)
        agent_input = input_data.copy()
        agent_input["messages"] = messages

        # Invoke actual agent
        result = await self.agent.ainvoke(
            agent_input,
            config=config,
        )

        # Apply after_invoke middleware (reverse order)
        for middleware in reversed(self.middlewares):
            try:
                result = await middleware.after_invoke(result, config)
                logger.debug(
                    "middleware_after_invoke_applied",
                    middleware=middleware.name,
                )
            except Exception as e:
                should_continue = (
                    self.continue_on_error
                    if self.continue_on_error is not None
                    else middleware.should_continue_on_error()
                )
                logger.error(
                    "middleware_after_invoke_failed",
                    middleware=middleware.name,
                    error=str(e),
                    continue_on_error=should_continue,
                )
                if not should_continue:
                    raise

        return cast(dict, result)

    async def astream(
        self,
        input_data: dict,
        config: dict | None = None,
        stream_mode: str = "values",
    ) -> AsyncGenerator[Any]:
        """Stream agent execution with middleware processing.

        Follows LangChain 1.0 execution order:
        - before_stream: first to last
        - after_stream: last to first (reversed)

        Args:
            input_data: Input dict with "messages" key
            config: Configuration dict for agent invocation
            stream_mode: Streaming mode for agent

        Yields:
            Stream events from agent
        """
        if config is None:
            config = {}

        # Pattern B HITL: If input is a Command object (resume), bypass middleware
        # and pass directly to agent - middleware is for processing messages, not resume
        if isinstance(input_data, Command):
            logger.debug(
                "middleware_bypass_for_command",
                command_type=type(input_data).__name__,
            )
            async for chunk in self.agent.astream(
                input_data,
                config=config,
                stream_mode=stream_mode,
            ):
                yield chunk
            return

        messages = input_data.get("messages", [])

        # Apply before_stream middleware (forward order)
        for middleware in self.middlewares:
            try:
                messages, config = await middleware.before_stream(messages, config)
                logger.debug(
                    "middleware_before_stream_applied",
                    middleware=middleware.name,
                )
            except Exception as e:
                should_continue = (
                    self.continue_on_error
                    if self.continue_on_error is not None
                    else middleware.should_continue_on_error()
                )
                logger.error(
                    "middleware_before_stream_failed",
                    middleware=middleware.name,
                    error=str(e),
                    continue_on_error=should_continue,
                )
                if not should_continue:
                    raise

        # Prepare agent input (preserve original input data)
        agent_input = input_data.copy()
        agent_input["messages"] = messages

        logger.info(
            "middleware_agent_astream_input",
            input_keys=list(agent_input.keys()),
            ui_mode=agent_input.get("ui_mode"),
        )

        # Stream from actual agent
        async for event in self.agent.astream(
            agent_input,
            config=config,
            stream_mode=stream_mode,
        ):
            yield event

        # Apply after_stream middleware (reverse order)
        for middleware in reversed(self.middlewares):
            try:
                await middleware.after_stream(config)
                logger.debug(
                    "middleware_after_stream_applied",
                    middleware=middleware.name,
                )
            except Exception as e:
                should_continue = (
                    self.continue_on_error
                    if self.continue_on_error is not None
                    else middleware.should_continue_on_error()
                )
                logger.error(
                    "middleware_after_stream_failed",
                    middleware=middleware.name,
                    error=str(e),
                    continue_on_error=should_continue,
                )
                if not should_continue:
                    raise

    async def aget_state(self, config: dict) -> Any:
        """Get agent state (delegates to underlying agent).

        Args:
            config: Configuration dict with thread_id

        Returns:
            Agent state
        """
        return await self.agent.aget_state(config)

    async def aupdate_state(self, config: dict, values: dict, as_node: str | None = None) -> Any:
        """Update agent state (delegates to underlying agent).

        Args:
            config: Configuration dict with thread_id
            values: Values to update hiding inside the state
            as_node: Optional node name to update as

        Returns:
            Updated configuration
        """
        return await self.agent.aupdate_state(config, values, as_node)


def inject_system_message(
    messages: list[BaseMessage],
    system_content: str,
) -> list[BaseMessage]:
    """Inject or update system message in message list.

    If a system message already exists, prepend the new content.
    Otherwise, insert a new system message at the beginning.

    Args:
        messages: List of messages
        system_content: Content to inject into system message

    Returns:
        Modified message list with system message
    """
    if not system_content:
        return messages

    # Check if first message is a system message
    if messages and isinstance(messages[0], SystemMessage):
        # Prepend to existing system message
        existing_content = messages[0].content
        messages[0] = SystemMessage(content=f"{system_content}\n\n{existing_content}")
        return messages
    else:
        # Insert new system message at beginning
        return [SystemMessage(content=system_content)] + messages
