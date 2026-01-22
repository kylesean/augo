"""Middleware system for LangChain agents.

This module provides a middleware pattern for LangChain agents, allowing
custom logic to be executed before and after agent invocations.

Implements LangChain v1 Skills pattern:
- SkillMiddleware: Progressive disclosure of skills via load_skill tool

Reference: https://docs.langchain.com/oss/python/langchain/multi-agent/skills
"""

from app.core.langgraph.middleware.attachment import AttachmentMiddleware
from app.core.langgraph.middleware.base import BaseMiddleware, MiddlewareAgent
from app.core.langgraph.middleware.context import DynamicContextMiddleware
from app.core.langgraph.middleware.memory import LongTermMemoryMiddleware
from app.core.langgraph.middleware.skill import SkillMiddleware

__all__ = [
    "BaseMiddleware",
    "MiddlewareAgent",
    "DynamicContextMiddleware",
    "LongTermMemoryMiddleware",
    "AttachmentMiddleware",
    "SkillMiddleware",
]
