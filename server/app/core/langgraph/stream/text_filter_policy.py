"""TextFilterPolicy - 文本过滤策略模式实现

职责：
- 决定是否静默 AI 文本输出
- 基于节点类型和工具元数据控制文本静默

设计模式：
- 策略模式 (Strategy Pattern)
- 组合模式 (Composite Pattern)
"""

from abc import ABC, abstractmethod
from typing import Any


class TextFilterPolicy(ABC):
    """文本过滤策略抽象基类

    子类实现 should_suppress() 方法来定义特定的静默策略
    """

    @abstractmethod
    def should_suppress(self, node_name: str, metadata: dict[str, Any]) -> bool:
        """决定是否静默文本输出

        Args:
            node_name: LangGraph 节点名称
            metadata: 消息元数据

        Returns:
            True 表示应该静默（不输出文本）
        """
        ...


class NeverSuppressPolicy(TextFilterPolicy):
    """从不静默策略（默认行为）"""

    def should_suppress(self, node_name: str, metadata: dict[str, Any]) -> bool:
        """Determines that text output should never be suppressed."""
        return False


class DirectExecuteSilentPolicy(TextFilterPolicy):
    """direct_execute 节点静默策略

    设计意图：
    - direct_execute 是 GenUI 原子模式的直接执行节点
    - 用户已在 UI 上完成交互，AI 不需要再输出文本解释
    - 让 UI 组件自己"说话"
    """

    def should_suppress(self, node_name: str, metadata: dict[str, Any]) -> bool:
        """Suppresses output if the originating node is 'direct_execute'."""
        return node_name == "direct_execute"


class SilentToolPolicy(TextFilterPolicy):
    """静默工具策略

    设计意图：
    - 某些工具（如 bash、read_file）的执行不需要 AI 文本输出
    - 工具的执行结果已经足够表达意图

    注意：此策略需要配合 ToolMetadata.silent_mode 使用
    """

    # 静默工具集合（从 genui.py 迁移）
    _SILENT_TOOLS = {"bash", "ls", "read_file", "write_file", "write_todos", "execute"}

    def __init__(self, additional_tools: set[str] | None = None):
        self._silent_tools = self._SILENT_TOOLS.copy()
        if additional_tools:
            self._silent_tools.update(additional_tools)

    def should_suppress(self, node_name: str, metadata: dict[str, Any]) -> bool:
        """Suppresses output if the tool executed is marked as silent."""
        # 检查当前执行的工具是否在静默列表中
        current_tool = metadata.get("current_tool_name")
        return current_tool in self._silent_tools if current_tool else False


class CompositeTextFilterPolicy(TextFilterPolicy):
    """组合文本过滤策略

    按顺序执行多个策略，只要有一个返回 True 就静默
    """

    def __init__(self, policies: list[TextFilterPolicy] | None = None):
        self._policies = policies or []

    def add_policy(self, policy: TextFilterPolicy) -> "CompositeTextFilterPolicy":
        """添加策略（链式调用）"""
        self._policies.append(policy)
        return self

    def should_suppress(self, node_name: str, metadata: dict[str, Any]) -> bool:
        """Suppresses output if any sub-policy determines it should be suppressed."""
        return any(p.should_suppress(node_name, metadata) for p in self._policies)


class DefaultTextFilterPolicy(CompositeTextFilterPolicy):
    """默认文本过滤策略

    组合了以下策略：
    1. DirectExecuteSilentPolicy - direct_execute 节点静默

    注意：SilentToolPolicy 暂不启用，因为需要更复杂的元数据传递
    后续可以通过 ToolMetadata.silent_mode 统一管理
    """

    def __init__(self):
        super().__init__(
            [
                DirectExecuteSilentPolicy(),
            ]
        )
