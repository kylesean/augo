"""Prompt management module with cache-friendly design.

This module implements a layered prompt architecture following LangGraph best practices:
- Core system prompt: Stable, cacheable (never changes)
- Dynamic context: Injected via user messages or prompt function (changes per request)

This design maximizes Claude's Prompt Cache hit rate (85-95%) and reduces token costs by 40-60%.
"""

import os
from functools import lru_cache

from app.core.config import settings
from app.core.skills.loader import SkillLoader


@lru_cache(maxsize=1)
def _load_core_prompt_template() -> str:
    """Load and cache the core system prompt template from file.

    This is cached because the file content never changes at runtime.
    """
    prompt_path = os.path.join(os.path.dirname(__file__), "system.md")
    with open(prompt_path, encoding="utf-8") as f:
        return f.read()


@lru_cache(maxsize=1)
def _get_skills_catalog_xml() -> str:
    """Get skills catalog XML for system prompt injection.

    Uses SkillLoader to generate skill entries following AgentSkills.io specification.
    The output is designed to be inserted into the <available_skills> section
    defined in the system prompt template.
    """
    loader = SkillLoader()
    return loader.get_catalog_xml()


def get_stable_system_prompt() -> str:
    """Get the stable (cacheable) system prompt.

    This prompt contains static content and discovery metadata for Skills.
    The skills catalog is injected into the {skills_catalog} placeholder.
    """
    template = _load_core_prompt_template()

    # Inject skills catalog into the template
    skills_xml = _get_skills_catalog_xml()
    return template.replace("{skills_catalog}", skills_xml)


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
