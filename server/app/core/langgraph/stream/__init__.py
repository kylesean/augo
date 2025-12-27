"""Stream 处理模块

将流处理逻辑从 Agent 类中分离，提供可复用的流处理组件。

核心组件：
- StreamProcessor: 流处理编排者
- EventGenerator: 事件生成器
- ComponentDetector: 组件类型检测器
- RenderPolicy: 渲染策略
- TextFilterPolicy: 文本过滤策略
"""

from app.core.langgraph.stream.component_detector import ComponentDetector
from app.core.langgraph.stream.event_generator import EventGenerator
from app.core.langgraph.stream.processor import StreamProcessor
from app.core.langgraph.stream.render_policy import (
    CompositeRenderPolicy,
    DefaultRenderPolicy,
    RenderDecision,
    RenderPolicy,
)
from app.core.langgraph.stream.text_filter_policy import (
    CompositeTextFilterPolicy,
    DefaultTextFilterPolicy,
    TextFilterPolicy,
)

__all__ = [
    # 核心处理器
    "StreamProcessor",
    "EventGenerator",
    # 组件检测
    "ComponentDetector",
    # 渲染策略
    "RenderPolicy",
    "RenderDecision",
    "DefaultRenderPolicy",
    "CompositeRenderPolicy",
    # 文本过滤策略
    "TextFilterPolicy",
    "DefaultTextFilterPolicy",
    "CompositeTextFilterPolicy",
]
