"""Middleware system for LangChain agents.

This module provides a middleware pattern for LangChain agents, allowing
custom logic to be executed before and after agent invocations.

Note: LangChain v1 does not have a built-in middleware API. This implementation
provides a wrapper-based middleware pattern that maintains compatibility with
the standard create_agent API while enabling dynamic context injection and
memory management.
"""

from app.core.langgraph.middleware.attachment import AttachmentMiddleware
from app.core.langgraph.middleware.base import BaseMiddleware, MiddlewareAgent
from app.core.langgraph.middleware.context import DynamicContextMiddleware
from app.core.langgraph.middleware.memory import LongTermMemoryMiddleware
from app.core.langgraph.middleware.skill_constraint import SkillConstraintMiddleware

__all__ = [
    "BaseMiddleware",
    "MiddlewareAgent",
    "DynamicContextMiddleware",
    "LongTermMemoryMiddleware",
    "AttachmentMiddleware",
    "SkillConstraintMiddleware",
]
