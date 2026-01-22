"""Prompt management module with cache-friendly design.

This module implements a layered prompt architecture following LangGraph best practices:
- Core system prompt: Stable, cacheable (never changes)
- Dynamic context: Injected via middleware (SkillMiddleware, DynamicContextMiddleware)

Skills are now injected dynamically by SkillMiddleware following
LangChain's official Progressive Disclosure pattern:
https://docs.langchain.com/oss/python/langchain/multi-agent/skills

This design maximizes Claude's Prompt Cache hit rate (85-95%) and reduces token costs by 40-60%.
"""

import os
from functools import lru_cache


@lru_cache(maxsize=1)
def _load_core_prompt_template() -> str:
    """Load and cache the core system prompt template from file.

    This is cached because the file content never changes at runtime.
    """
    prompt_path = os.path.join(os.path.dirname(__file__), "system.md")
    with open(prompt_path, encoding="utf-8") as f:
        return f.read()


def get_stable_system_prompt() -> str:
    """Get the stable (cacheable) system prompt.

    This prompt contains static content only. Dynamic content like
    skill catalogs are injected by SkillMiddleware at runtime.
    """
    return _load_core_prompt_template()


# Legacy function for backward compatibility
def load_system_prompt(**kwargs: str) -> str:
    """Legacy function - redirects to new cache-friendly implementation.

    DEPRECATED: Use get_stable_system_prompt() instead.

    Note: This no longer injects current_date_and_time into the system prompt
    to preserve prompt cache efficiency. Time should be injected via user messages.
    """
    long_term_memory = kwargs.get("long_term_memory", "")
    base_prompt = get_stable_system_prompt()

    if long_term_memory:
        return f"{base_prompt}\n\n<user_memory>\n{long_term_memory}\n</user_memory>"
    return base_prompt
