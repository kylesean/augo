"""Agent State 定义

使用 LangGraph TypedDict + Annotated 模式定义 Agent 状态。
参考: https://docs.langchain.com/oss/python/langgraph/graph-api#state
"""

from __future__ import annotations

from typing import Annotated, Any, Literal, TypedDict

from langchain_core.messages import BaseMessage
from langgraph.graph.message import add_messages


def _merge_skills(left: list[str] | None, right: list[str] | None) -> list[str]:
    """Reducer for skills_loaded: merge and deduplicate skill names."""
    left_set = set(left or [])
    right_set = set(right or [])
    return list(left_set | right_set)


class AgentState(TypedDict):
    """LangGraph Agent State

    Attributes:
        messages: 消息历史，使用 add_messages reducer 智能累积和去重
        ui_mode: UI 驱动的路由模式
        tool_name: GenUI 直接执行的工具名
        tool_params: GenUI 直接执行的工具参数
        direct_execute_result: 直接执行节点的结果（供流处理层生成 UI）
        skills_loaded: 已加载的技能列表（用于工具约束）
        active_skill: 当前激活的技能名称
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

    # Loaded skills list (using reducer to merge)
    skills_loaded: Annotated[list[str], _merge_skills]

    # Currently active skill (last loaded)
    active_skill: str | None


def create_initial_state() -> AgentState:
    """创建初始状态"""
    return {
        "messages": [],
        "ui_mode": "idle",
        "tool_name": None,
        "tool_params": None,
        "direct_execute_result": None,
        "skills_loaded": [],
        "active_skill": None,
    }
