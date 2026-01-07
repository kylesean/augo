"""RenderPolicy - 渲染策略模式实现

职责：
- 决定 GenUI 事件的渲染时机（立即/缓冲/静默）
- 替代 StreamProcessor 中分散的 if-else 逻辑
- 支持通过组合扩展策略

设计模式：
- 策略模式 (Strategy Pattern)
- 组合模式 (Composite Pattern)
"""

from abc import ABC, abstractmethod
from enum import Enum
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from app.schemas.genui import GenUIEvent


class RenderDecision(str, Enum):
    """渲染决策枚举"""

    EMIT = "emit"  # 立即发送给客户端
    BUFFER = "buffer"  # 缓冲到流结束后再发送
    SUPPRESS = "suppress"  # 完全静默不发送


class RenderPolicy(ABC):
    """渲染策略抽象基类

    子类实现 decide() 方法来定义特定的渲染策略
    """

    @abstractmethod
    def decide(self, event: "GenUIEvent", node_name: str) -> RenderDecision:
        """决定事件的渲染方式

        Args:
            event: GenUI 事件
            node_name: 产生该事件的 LangGraph 节点名称

        Returns:
            RenderDecision 枚举值
        """
        ...


class AlwaysEmitPolicy(RenderPolicy):
    """始终立即发送策略（默认行为）"""

    def decide(self, event: "GenUIEvent", node_name: str) -> RenderDecision:
        """Determines that the event should always be emitted immediately."""
        return RenderDecision.EMIT


class ToolsNodeBufferPolicy(RenderPolicy):
    """Tools 节点 a2ui_message 缓冲策略

    设计意图：
    - tools 节点产生的 UI 组件应该在 AI 文本分析完成后再展示
    - 这样用户会先看到文本洞察，再看到数据可视化卡片
    - 称为"附件置底原则"
    """

    def decide(self, event: "GenUIEvent", node_name: str) -> RenderDecision:
        """Buffers a2ui_message events from the tools node, emitted at the end."""
        if node_name == "tools" and event.type == "a2ui_message":
            return RenderDecision.BUFFER
        return RenderDecision.EMIT


class CompositeRenderPolicy(RenderPolicy):
    """组合渲染策略

    按优先级顺序执行多个策略，返回第一个非 EMIT 的决策。
    如果所有策略都返回 EMIT，则最终返回 EMIT。
    """

    def __init__(self, policies: list[RenderPolicy] | None = None):
        self._policies = policies or []

    def add_policy(self, policy: RenderPolicy) -> "CompositeRenderPolicy":
        """添加策略（链式调用）"""
        self._policies.append(policy)
        return self

    def decide(self, event: "GenUIEvent", node_name: str) -> RenderDecision:
        """Evaluates composite policies and returns the first prioritized decision."""
        for policy in self._policies:
            decision = policy.decide(event, node_name)
            if decision != RenderDecision.EMIT:
                return decision
        return RenderDecision.EMIT


class DefaultRenderPolicy(CompositeRenderPolicy):
    """默认渲染策略

    简洁设计：
    - a2ui_message 缓冲到流结束再发送
    - 文本流完成后，GenUI 组件直接出现在消息末尾
    - 无骨架屏预占位（避免复杂的时序问题）
    """

    def __init__(self) -> None:
        super().__init__([])
