from __future__ import annotations

import os
from dataclasses import dataclass

import yaml


@dataclass
class SkillMetadata:
    """Metadata representing a skill loaded from SKILL.md."""

    name: str
    description: str
    location: str
    license: str | None = None
    metadata: dict[str, str] | None = None
    allowed_tools: list[str] | None = None  # Tool whitelist for this skill
    content: str | None = None  # Full SKILL.md content (for activation injection)


class SkillLoader:
    """Loads skills metadata from SKILL.md files following AgentSkills standards."""

    def __init__(self, skills_dir: str = "app/skills"):
        self.skills_dir = skills_dir

    def load_skills(self, max_depth: int = 2) -> list[SkillMetadata]:
        """Load skills from skills directory, supporting nested directories.

        This allows for community skills in subdirectories like:
        - app/skills/finance-analyst/SKILL.md  (local skill)
        - app/skills/community/frontend-design/SKILL.md  (community skill)

        Args:
            max_depth: Maximum depth to search for SKILL.md files (default: 2)
        """
        skills = []
        if not os.path.exists(self.skills_dir):
            return []

        def scan_directory(directory: str, depth: int = 0) -> None:
            if depth > max_depth:
                return

            try:
                for item in os.listdir(directory):
                    item_path = os.path.join(directory, item)

                    if os.path.isdir(item_path):
                        skill_md = os.path.join(item_path, "SKILL.md")

                        if os.path.exists(skill_md):
                            # Found a skill directory
                            metadata = self._parse_skill_md(skill_md)
                            if metadata:
                                skills.append(metadata)
                        else:
                            # Recurse into subdirectory (e.g., 'community/')
                            scan_directory(item_path, depth + 1)
            except PermissionError:
                pass  # Skip directories we can't read

        scan_directory(self.skills_dir)
        return sorted(skills, key=lambda x: x.name)

    def _parse_skill_md(self, file_path: str) -> SkillMetadata | None:
        try:
            with open(file_path, encoding="utf-8") as f:
                content = f.read()

            # Simple YAML frontmatter extraction
            if content.startswith("---"):
                parts = content.split("---", 2)
                if len(parts) >= 3:
                    frontmatter_str = parts[1]
                    markdown_content = parts[2].strip()  # Extract Markdown body
                    data = yaml.safe_load(frontmatter_str)

                    # Use relative path for better LLM understanding and command construction
                    rel_path = os.path.relpath(file_path)

                    # Parse allowed-tools (AgentSkills.io specification)
                    # Format: space-delimited string of tool names
                    # Example: "Bash(git:*) Bash(jq:*) Read"
                    # Reference: https://agentskills.io/specification#allowed-tools-field
                    allowed_tools_raw = data.get("allowed-tools")
                    allowed_tools = None

                    if allowed_tools_raw and isinstance(allowed_tools_raw, str):
                        # Official format: space-delimited string
                        allowed_tools = allowed_tools_raw.split()

                    return SkillMetadata(
                        name=data.get("name", "unknown"),
                        description=data.get("description", ""),
                        location=rel_path,
                        license=data.get("license"),
                        metadata=data.get("metadata"),
                        allowed_tools=allowed_tools,
                        content=markdown_content,
                    )
            return None
        except Exception:
            # Silently fail for malformed skills to avoid crashing
            return None

    def get_catalog_xml(self) -> str:
        """Generates XML skill entries for system prompt injection.

        Returns skill entries without the outer <available_skills> wrapper,
        as the wrapper is defined in the system prompt template itself.

        This follows the AgentSkills.io specification:
        https://agentskills.io/integrate-skills#injecting-into-context
        """
        skills = self.load_skills()
        if not skills:
            return "    <!-- No skills available -->"

        xml_parts = []
        for skill in skills:
            xml_parts.append("    <skill>")
            xml_parts.append(f"      <name>{skill.name}</name>")
            xml_parts.append(f"      <description>{skill.description}</description>")
            xml_parts.append(f"      <location>{skill.location}</location>")
            # Optional: inject extra metadata if needed for routing
            if skill.metadata:
                for k, v in skill.metadata.items():
                    xml_parts.append(f"      <{k}>{v}</{k}>")
            xml_parts.append("    </skill>")

        return "\n".join(xml_parts)

    def get_skill(self, skill_name: str) -> SkillMetadata | None:
        """Get a skill by name."""
        skills = self.load_skills()
        for skill in skills:
            if skill.name == skill_name:
                return skill
        return None

    def activate_skill_prompt(self, skill_name: str) -> str | None:
        """Generate skill activation prompt fragment.

        Used for dynamic injection into conversation context,
        switching the AI to the specified skill mode.

        Returns:
            Full skill content (Markdown) wrapped in XML tags.
        """
        skill = self.get_skill(skill_name)
        if not skill or not skill.content:
            return None

        # Construct activation prompt
        activation_prompt = f"""<activated_skill name="{skill.name}">
{skill.content}
</activated_skill>

You have activated the **{skill.name}** skill. Follow the instructions above strictly.
"""
        return activation_prompt

    def get_allowed_tools(self, skill_name: str) -> list[str] | None:
        """Get the tool whitelist for a skill.

        Returns the allowed-tools list declared in SKILL.md.

        Returns:
            List of tool names, or None (no restrictions).
        """
        skill = self.get_skill(skill_name)
        if not skill or not skill.allowed_tools:
            return None

        # Return tool names directly (no mapping needed)
        return skill.allowed_tools
