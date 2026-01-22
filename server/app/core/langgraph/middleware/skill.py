"""Skill Middleware following LangChain official Skills pattern.

This middleware implements progressive skill disclosure as per LangChain docs:
https://docs.langchain.com/oss/python/langchain/multi-agent/skills

Key responsibilities:
1. Inject skill catalog (name + description) into system prompt
2. Register the load_skill tool for on-demand skill loading
3. Apply tool constraints when a skill is active
"""

from __future__ import annotations

from typing import Any

from langchain_core.messages import BaseMessage, SystemMessage

from app.core.langgraph.middleware.base import BaseMiddleware
from app.core.logging import logger
from app.core.skills.loader import SkillLoader


class SkillMiddleware(BaseMiddleware):
    """Middleware that implements LangChain's official Skills pattern.

    This middleware:
    1. Injects skill descriptions into the system prompt (progressive disclosure)
    2. Applies tool constraints when a skill is loaded
    3. Tracks skill state through before_invoke/after_invoke hooks

    The actual skill loading is done by the load_skill tool, which updates
    the agent state with skills_loaded and active_skill fields.
    """

    def __init__(self) -> None:
        """Initialize skill middleware with skill catalog."""
        self._skill_loader = SkillLoader()
        self._skills_prompt: str | None = None
        self._allowed_tools_cache: dict[str, set[str]] = {}

        # Pre-build skills prompt and cache allowed tools
        self._build_skills_catalog()

    def _build_skills_catalog(self) -> None:
        """Build the skills catalog for system prompt injection."""
        skills = self._skill_loader.load_skills()

        if not skills:
            self._skills_prompt = None
            return

        # Build skill list for system prompt
        skills_list = []
        for skill in skills:
            skills_list.append(f"- **{skill.name}**: {skill.description}")

            # Cache allowed tools for each skill
            if skill.allowed_tools:
                self._allowed_tools_cache[skill.name] = set(skill.allowed_tools)

        self._skills_prompt = "\n".join(skills_list)

        logger.info(
            "skill_middleware_initialized",
            skill_count=len(skills),
            skills_with_constraints=len(self._allowed_tools_cache),
        )

    @property
    def name(self) -> str:
        """Middleware identifier."""
        return "skill"

    async def before_invoke(
        self,
        messages: list[BaseMessage],
        config: dict[str, Any],
    ) -> tuple[list[BaseMessage], dict[str, Any]]:
        """Inject skill catalog into system prompt.

        This implements "progressive disclosure" - only skill names and
        descriptions are shown upfront. Full content is loaded on-demand
        via the load_skill tool.
        """
        if not self._skills_prompt:
            return messages, config

        # Build skills addendum for system prompt
        skills_addendum = f"""

## Available Skills

{self._skills_prompt}

Use the `load_skill` tool when you need detailed instructions for a specific task."""

        # Find and update system message, or insert new one
        updated_messages = list(messages)
        system_found = False

        for i, msg in enumerate(updated_messages):
            if isinstance(msg, SystemMessage):
                # Append skills section to existing system message
                existing_content = msg.content
                if isinstance(existing_content, str):
                    updated_messages[i] = SystemMessage(content=existing_content + skills_addendum)
                system_found = True
                break

        if not system_found and updated_messages:
            # No system message found, this shouldn't happen with proper setup
            logger.warning("skill_middleware_no_system_message")

        return updated_messages, config

    async def after_invoke(
        self,
        result: dict[str, Any],
        config: dict[str, Any],
    ) -> dict[str, Any]:
        """Check for skill activation and log state.

        The actual skill loading and state updates are handled by the
        load_skill tool via Command. This hook is for logging and
        potential post-processing.
        """
        # Log if a skill was activated in this invocation
        if "active_skill" in result and result.get("active_skill"):
            active_skill = result["active_skill"]
            skills_loaded = result.get("skills_loaded", [])

            logger.info(
                "skill_activated_in_invocation",
                active_skill=active_skill,
                skills_loaded=skills_loaded,
            )

        return result

    def get_allowed_tools(self, skill_name: str) -> set[str] | None:
        """Get allowed tools for a skill.

        Args:
            skill_name: Name of the skill

        Returns:
            Set of allowed tool names, or None if no constraints
        """
        return self._allowed_tools_cache.get(skill_name)

    def filter_tools_for_skill(
        self,
        skill_name: str,
        all_tools: list[Any],
    ) -> list[Any]:
        """Filter tools based on skill's allowed-tools constraint.

        Args:
            skill_name: Active skill name
            all_tools: All available tools

        Returns:
            Filtered tool list, or all tools if no constraints
        """
        allowed = self.get_allowed_tools(skill_name)
        if not allowed:
            return all_tools

        filtered = [t for t in all_tools if t.name in allowed]

        logger.debug(
            "skill_tools_filtered",
            skill=skill_name,
            original_count=len(all_tools),
            filtered_count=len(filtered),
            allowed=list(allowed),
        )

        return filtered
