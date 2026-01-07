from __future__ import annotations

import os
from dataclasses import dataclass

import yaml


@dataclass
class SkillMetadata:
    """Metadata representing a skill loaded from a script."""

    name: str
    description: str
    location: str
    license: str | None = None
    metadata: dict[str, str] | None = None
    allowed_tools: list[str] | None = None  # 技能可使用的工具白名单
    content: str | None = None  # 完整的 SKILL.md 内容（用于激活时注入）


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
                    markdown_content = parts[2].strip()  # 提取 Markdown 正文
                    data = yaml.safe_load(frontmatter_str)

                    # 使用相对路径，更利于 LLM 理解和构造命令
                    rel_path = os.path.relpath(file_path)

                    # 解析 allowed-tools（支持两种格式）
                    # 1. 新格式（官方规范）: "Bash Read Write" 或 "Bash(git:*) Read"
                    # 2. 旧格式: ["bash", "read_file", ...]
                    allowed_tools_raw = data.get("allowed-tools")
                    allowed_tools = None

                    if allowed_tools_raw:
                        if isinstance(allowed_tools_raw, str):
                            # 新格式：空格分隔的字符串
                            allowed_tools = allowed_tools_raw.split()
                        elif isinstance(allowed_tools_raw, list):
                            # 旧格式：列表
                            allowed_tools = allowed_tools_raw

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
        """Generates XML catalog for system prompt injection.

        This follows the official AgentSkills.io specification:
        https://agentskills.io/integrate-skills#injecting-into-context
        """
        skills = self.load_skills()
        if not skills:
            return ""

        xml_parts = ["<available_skills>"]
        for skill in skills:
            xml_parts.append("  <skill>")
            xml_parts.append(f"    <name>{skill.name}</name>")
            xml_parts.append(f"    <description>{skill.description}</description>")
            xml_parts.append(f"    <location>{skill.location}</location>")
            # Optional: inject extra metadata if needed for routing
            if skill.metadata:
                for k, v in skill.metadata.items():
                    xml_parts.append(f"    <{k}>{v}</{k}>")
            xml_parts.append("  </skill>")
        xml_parts.append("</available_skills>")

        return "\n".join(xml_parts)

    def get_skill(self, skill_name: str) -> SkillMetadata | None:
        """获取指定名称的技能。"""
        skills = self.load_skills()
        for skill in skills:
            if skill.name == skill_name:
                return skill
        return None

    def activate_skill_prompt(self, skill_name: str) -> str | None:
        """生成技能激活的系统提示词片段。

        用于动态注入到对话上下文中，让 AI 切换到该技能模式。

        Returns:
            技能的完整内容（Markdown），包裹在 XML 标签中
        """
        skill = self.get_skill(skill_name)
        if not skill or not skill.content:
            return None

        # 构造激活提示词
        activation_prompt = f"""<activated_skill name="{skill.name}">
{skill.content}
</activated_skill>

你现在已激活 **{skill.name}** 技能。请严格按照上述技能说明执行任务。
"""
        return activation_prompt

    def get_allowed_tools(self, skill_name: str) -> list[str] | None:
        """获取技能的工具白名单。

        直接返回 SKILL.md 中 allowed-tools 声明的工具名列表。

        Returns:
            工具名称列表，或 None（表示不限制）
        """
        skill = self.get_skill(skill_name)
        if not skill or not skill.allowed_tools:
            return None

        # 直接返回工具名列表（不再做映射）
        return skill.allowed_tools
