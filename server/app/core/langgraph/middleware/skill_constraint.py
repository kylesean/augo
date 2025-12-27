"""技能约束中间件

实现技能的"硬约束"：
1. 当 Agent 激活某个技能时，应用 allowed-tools 白名单
2. 技能激活时动态注入 skill_exclusive_tools
3. 技能的"发现"和"激活"由 LLM 自主决定（通过 read_file 读取 SKILL.md）

注意：这个 Middleware 不做意图检测！意图检测是 LLM 的工作。
我们只负责在技能激活后应用约束。
"""

from typing import Any, Dict, List, Optional, Set

from app.core.langgraph.middleware.base import BaseMiddleware
from app.core.logging import logger
from app.core.skills.loader import SkillLoader


class SkillConstraintMiddleware(BaseMiddleware):
    """技能约束中间件

    当 LLM 自主决定激活某个技能时（通过 state.active_skill 标记），
    本 Middleware 负责：
    1. 应用 allowed-tools 白名单约束
    2. 提供工具过滤能力

    技能的发现和激活由 LLM 自己完成，通过：
    - 查看 system prompt 中的 <available_skills> 列表
    - 调用 read_file 读取 SKILL.md 获取完整指导
    """

    def __init__(self, tools: Optional[List] = None):
        """初始化技能约束中间件

        Args:
            tools: 完整工具列表引用（用于动态过滤）
        """
        self._skill_loader = SkillLoader()
        self._active_skill: Optional[str] = None
        self._allowed_tools: Optional[Set[str]] = None
        self._all_tools: Optional[List] = tools  # 完整工具列表

    def set_tools(self, tools: List):
        """设置完整工具列表（延迟初始化用）"""
        self._all_tools = tools

    @property
    def name(self) -> str:
        """Identifier for the skill constraint middleware."""
        return "skill_constraint"

    async def before_invoke(
        self,
        messages: List[Any],  # BaseMessage
        config: Dict[str, Any],
    ) -> tuple[List[Any], Dict[str, Any]]:
        """在调用前检测技能激活状态并应用约束

        技能激活可以通过以下方式触发：
        1. configurable 中设置 active_skill

        注意：我们不做意图检测，让 LLM 自己决定何时激活技能。
        """
        # 从 configurable 获取激活的技能
        if "configurable" not in config:
            config["configurable"] = {}

        configurable = config["configurable"]
        active_skill = configurable.get("active_skill")

        if active_skill and active_skill != self._active_skill:
            # 技能切换，更新约束
            self._active_skill = active_skill
            allowed_tools = self._skill_loader.get_allowed_tools(active_skill)

            if allowed_tools:
                self._allowed_tools = set(allowed_tools)

                # 将过滤后的工具注入 config，供 agent_node 使用
                if self._all_tools:
                    # 1. 基于白名单过滤基础工具
                    filtered = [t for t in self._all_tools if t.name in self._allowed_tools]

                    # 2. 注入技能专属工具（如 statistics_tools）
                    from app.core.langgraph.tools import skill_exclusive_tools

                    if active_skill in skill_exclusive_tools:
                        exclusive = skill_exclusive_tools[active_skill]
                        # 只注入白名单中的专属工具
                        for tool in exclusive:
                            if tool.name in self._allowed_tools:
                                filtered.append(tool)
                        logger.info(
                            "skill_exclusive_tools_injected",
                            skill=active_skill,
                            injected_tools=[t.name for t in exclusive if t.name in self._allowed_tools],
                        )

                    config["configurable"]["filtered_tools"] = filtered
                    logger.info(
                        "skill_constraint_activated",
                        skill=active_skill,
                        allowed_tools=allowed_tools,
                        filtered_count=len(filtered),
                    )
                else:
                    logger.info(
                        "skill_constraint_activated",
                        skill=active_skill,
                        allowed_tools=allowed_tools,
                    )
            else:
                # 技能没有定义白名单，不限制
                self._allowed_tools = None
                # 清除过滤
                if "filtered_tools" in config["configurable"]:
                    del config["configurable"]["filtered_tools"]
                logger.debug(
                    "skill_constraint_no_whitelist",
                    skill=active_skill,
                )
        elif not active_skill and self._active_skill:
            # 技能停用
            logger.info("skill_deactivated", skill=self._active_skill)
            self._active_skill = None
            self._allowed_tools = None
            if "filtered_tools" in config["configurable"]:
                del config["configurable"]["filtered_tools"]

        return messages, config

    def filter_tool_calls(
        self,
        tool_calls: List[Dict[str, Any]],
    ) -> tuple[List[Dict[str, Any]], List[Dict[str, Any]]]:
        """过滤工具调用

        Args:
            tool_calls: 工具调用列表

        Returns:
            (allowed_calls, blocked_calls) 元组
        """
        if not self._allowed_tools:
            return tool_calls, []

        allowed = []
        blocked = []

        for tc in tool_calls:
            tool_name = tc.get("name", "")
            if tool_name in self._allowed_tools:
                allowed.append(tc)
            else:
                blocked.append(tc)
                logger.warning(
                    "skill_constraint_blocked_tool",
                    skill=self._active_skill,
                    blocked_tool=tool_name,
                    allowed_tools=list(self._allowed_tools),
                )

        return allowed, blocked

    def is_tool_allowed(self, tool_name: str) -> bool:
        """检查工具是否被允许"""
        if not self._allowed_tools:
            return True
        return tool_name in self._allowed_tools

    def get_filtered_tools(self, all_tools: List) -> List:
        """获取过滤后的工具列表"""
        if not self._allowed_tools:
            return all_tools

        filtered = [t for t in all_tools if t.name in self._allowed_tools]

        logger.debug(
            "skill_constraint_filtered_tools",
            skill=self._active_skill,
            original_count=len(all_tools),
            filtered_count=len(filtered),
        )

        return filtered

    def get_active_skill(self) -> Optional[str]:
        """获取当前激活的技能"""
        return self._active_skill

    async def after_invoke(
        self,
        output: Dict[str, Any],
        config: Dict[str, Any],
    ) -> Dict[str, Any]:
        """在调用后检测技能激活

        检测以下调用自动激活对应的 skill：
        1. read_file 对 SKILL.md 的调用
        2. bash 调用 app/skills/*/scripts/*.py

        这是 AgentSkills.io 规范的"渐进式披露"实现。
        """
        import re

        messages = output.get("messages", [])

        for msg in messages:
            # 检查是否有工具调用
            if hasattr(msg, "tool_calls"):
                for tc in msg.tool_calls:
                    tool_name = tc.get("name", "")
                    args = tc.get("args", {})

                    skill_name = None
                    trigger = None

                    # 检测 read_file 调用 SKILL.md
                    if tool_name == "read_file":
                        path = args.get("path", "")
                        match = re.search(r"app/skills/([^/]+)/SKILL\.md", path)
                        if match:
                            skill_name = match.group(1)
                            trigger = "read_file_SKILL.md"

                    # 检测 bash/execute 调用 skills 脚本
                    elif tool_name in ["bash", "execute"]:
                        command = args.get("command", "")
                        match = re.search(r"app/skills/([^/]+)/scripts/", command)
                        if match:
                            skill_name = match.group(1)
                            trigger = f"{tool_name}_skill_script"

                    # 激活检测到的技能
                    if skill_name and skill_name != self._active_skill:
                        self._active_skill = skill_name
                        allowed_tools = self._skill_loader.get_allowed_tools(skill_name)

                        if allowed_tools:
                            self._allowed_tools = set(allowed_tools)
                            logger.info(
                                "skill_auto_activated",
                                skill=skill_name,
                                allowed_tools=list(self._allowed_tools),
                                trigger=trigger,
                            )
                        else:
                            logger.debug(
                                "skill_activated_no_whitelist",
                                skill=skill_name,
                            )

        return output
