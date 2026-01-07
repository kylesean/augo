"""Node 函数定义

LangGraph 节点函数，每个节点专注于单一职责。
"""
from __future__ import annotations

from collections.abc import Callable
from typing import Any, cast

from langchain_core.language_models import BaseChatModel
from langchain_core.messages import AIMessage, BaseMessage, SystemMessage
from langchain_core.runnables import RunnableConfig
from langchain_core.tools import BaseTool

from app.core.langgraph.agent.state import AgentState
from app.core.logging import logger


def create_agent_node(
    llm: BaseChatModel,
    tools: list[BaseTool],
    system_prompt: str,
) -> Callable[[AgentState, RunnableConfig], Any]:
    """创建 Agent 节点

    Agent 节点调用 LLM 生成响应，支持动态工具过滤。
    """

    async def agent_node(state: AgentState, config: RunnableConfig) -> dict[str, list[BaseMessage]]:
        messages = state["messages"]

        # 支持 SkillConstraintMiddleware 动态过滤工具
        filtered_tools = config.get("configurable", {}).get("filtered_tools")
        current_tools = cast(
            list[BaseTool], filtered_tools or state.get("filtered_tools") or tools
        )

        bound_llm = llm.bind_tools(current_tools)
        prompt_messages = [SystemMessage(content=system_prompt)] + messages
        response = await bound_llm.ainvoke(prompt_messages, config)

        logger.debug(
            "agent_node_response",
            has_tool_calls=bool(getattr(response, "tool_calls", None)),
            content_length=len(response.content) if response.content else 0,
            tools_count=len(current_tools),
        )

        return {"messages": [response]}

    return agent_node


# === 内部工具注册表 ===
# GenUI 直接执行的工具，不暴露给 LLM
# 新增工具只需在此添加
def _get_internal_tools() -> dict[str, BaseTool]:
    """延迟加载内部工具，避免循环导入"""
    from app.core.langgraph.tools.space_association_tools import associate_transactions_to_space
    from app.core.langgraph.tools.transfer_tools import execute_transfer

    return {
        "execute_transfer": execute_transfer,
        "associate_transactions_to_space": associate_transactions_to_space,
    }


def create_direct_execute_node(
    tools: list[BaseTool],  # 保留参数以兼容图构建接口
) -> Callable[[AgentState, RunnableConfig], Any]:
    """创建直接执行节点

    用于 GenUI 场景：用户在 UI 上操作完成后，跳过 LLM 直接执行工具。

    协议:
        - state.tool_name: 要执行的工具名（需在 INTERNAL_TOOLS 注册）
        - state.tool_params: 工具参数
    """
    INTERNAL_TOOLS = _get_internal_tools()

    async def direct_execute_node(state: AgentState, config: RunnableConfig) -> dict[str, Any]:
        tool_name = state.get("tool_name")
        tool_params = state.get("tool_params")

        if not tool_name or not tool_params:
            logger.warning("direct_execute_missing_params", tool_name=tool_name, has_params=bool(tool_params))
            return {
                "messages": [AIMessage(content="错误：未指定要执行的操作。")],
                "ui_mode": "idle",
            }

        tool = INTERNAL_TOOLS.get(tool_name)
        if not tool:
            logger.error("direct_execute_tool_not_found", tool_name=tool_name, available=list(INTERNAL_TOOLS.keys()))
            return {
                "messages": [AIMessage(content=f"系统错误：工具 {tool_name} 未注册。")],
                "ui_mode": "idle",
            }

        logger.debug(
            "direct_execute_invoking",
            tool_name=tool_name,
            params_keys=list(tool_params.keys()),
        )

        try:
            result = await tool.ainvoke(tool_params, config=config)

            logger.info("direct_execute_success", tool_name=tool_name)

            return {
                "messages": [AIMessage(content="")],  # 静默，让 UI 组件展示结果
                "ui_mode": "idle",
                "tool_name": None,
                "tool_params": None,
                "direct_execute_result": {
                    "tool_name": tool_name,
                    "success": True,
                    "data": result if isinstance(result, dict) else {"result": result},
                    "surface_id": tool_params.get("surface_id"),
                },
            }
        except Exception as e:
            logger.error("direct_execute_error", tool_name=tool_name, error=str(e))
            return {
                "messages": [AIMessage(content=f"⚠️ 操作执行失败：{str(e)}")],
                "ui_mode": "idle",
                "tool_name": None,
                "tool_params": None,
                "direct_execute_result": None,
            }

    return direct_execute_node
