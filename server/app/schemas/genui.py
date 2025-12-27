"""GenUI Event and Component Schemas

This module defines the data structures for Generative UI events and components,
supporting both real-time streaming and historical message restoration using Pydantic.

Schema Version: 2.0 (Refactored)
"""

from enum import Enum
from typing import Any, Dict, Optional

from pydantic import BaseModel, ConfigDict
from pydantic.alias_generators import to_camel

# ============================================================================
# 事件类型枚举
# ============================================================================


class GenUIEventType(str, Enum):
    """GenUI 事件类型枚举

    消除魔法字符串，提供类型安全的事件类型引用。
    """

    # 会话生命周期
    SESSION_INIT = "session_init"
    DONE = "done"
    ERROR = "error"

    # 文本流
    TEXT_DELTA = "text_delta"
    REASONING_DELTA = "reasoning_delta"

    # 工具调用
    TOOL_CALL_START = "tool_call_start"
    TOOL_CALL_END = "tool_call_end"

    # UI 组件
    A2UI_MESSAGE = "a2ui_message"

    # 元数据
    TITLE_UPDATE = "title_update"


class SilentMode(str, Enum):
    """静默模式枚举"""

    NONE = "none"  # 正常模式：文本和 UI 都输出
    TEXT_ONLY = "text_only"  # 只静默文本，UI 正常
    FULL = "full"  # 完全静默


class UIComponentMode(str, Enum):
    """UI 组件渲染模式"""

    LIVE = "live"
    HISTORICAL = "historical"


# ============================================================================
# 核心数据模型
# ============================================================================


class UIComponentData(BaseModel):
    """Complete UI component data for rendering."""

    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    surface_id: str
    component_type: str
    data: Dict[str, Any]
    mode: UIComponentMode = UIComponentMode.LIVE
    user_selection: Optional[Dict[str, Any]] = None
    created_at: Optional[str] = None
    tool_call_id: Optional[str] = None
    tool_name: Optional[str] = None


class GenUIEvent(BaseModel):
    """GenUI streaming event.

    Attributes:
        type: 事件类型（推荐使用 GenUIEventType 枚举）
        content: 文本内容（用于 text_delta 等）
        data: 结构化数据（用于 tool_call_start, a2ui_message 等）
        surface_id: Surface ID
        title: 标题（用于 title_update）
        metadata: 额外元数据
    """

    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    type: str
    content: Optional[str] = None
    data: Optional[Dict[str, Any]] = None
    surface_id: Optional[str] = None
    title: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    insight_slot_id: Optional[str] = None

    def to_sse(self) -> str:
        """Convert to SSE format."""
        payload_json = self.model_dump_json(by_alias=True, exclude_none=True)
        return f"data: {payload_json}\n\n"


class HistoricalUIComponent(BaseModel):
    """UI component from historical message."""

    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    surface_id: str
    component_type: str
    data: Dict[str, Any]
    mode: str = "historical"
    user_selection: Optional[Dict[str, Any]] = None
