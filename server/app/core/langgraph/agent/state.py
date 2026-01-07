"""Agent State 定义

使用 LangGraph TypedDict + Annotated 模式定义 Agent 状态。
参考: https://docs.langchain.com/oss/python/langgraph/graph-api#state
"""

from __future__ import annotations

from typing import Annotated, Any, Literal, TypedDict

from langchain_core.messages import BaseMessage
from langgraph.graph.message import add_messages


class AgentState(TypedDict):
    """LangGraph Agent State

    Attributes:
        messages: 消息历史，使用 add_messages reducer 智能累积和去重
        ui_mode: UI 驱动的路由模式
        tool_name: GenUI 直接执行的工具名
        tool_params: GenUI 直接执行的工具参数
        direct_execute_result: 直接执行节点的结果（供流处理层生成 UI）
    """

    # 消息历史 (add_messages reducer 自动处理流式 chunks 累积和 ID 去重)
    messages: Annotated[list[BaseMessage], add_messages]

    # UI 模式 (用于入口路由)
    ui_mode: Literal[
        "idle",  # 默认，走 agent 节点
        "direct_execute",  # 跳过 LLM，直接执行 tool_name 指定的工具
    ]

    # GenUI 直接执行参数
    tool_name: str | None
    tool_params: dict[str, Any] | None

    # 直接执行结果 (供流处理层渲染 UI)
    direct_execute_result: dict[str, Any] | None


def create_initial_state() -> AgentState:
    """创建初始状态"""
    return {
        "messages": [],
        "ui_mode": "idle",
        "tool_name": None,
        "tool_params": None,
        "direct_execute_result": None,
    }
