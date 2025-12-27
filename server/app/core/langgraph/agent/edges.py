"""Edge/Routing logic definition

LangGraph conditional edge routing functions, determining the flow of execution.
Reference: https://docs.langchain.com/oss/python/langgraph/graph-api#conditional-edges
"""

from typing import Literal

from langchain_core.messages import AIMessage
from langgraph.graph import END

from app.core.langgraph.agent.state import AgentState
from app.core.logging import logger


def route_entry(state: AgentState) -> Literal["direct_execute", "agent"]:
    """Entry routing: Skip LLM and directly execute tool when ui_mode=direct_execute and tool_name is specified."""
    ui_mode = state.get("ui_mode", "idle")
    tool_name = state.get("tool_name")

    logger.info("route_entry_check", ui_mode=ui_mode, tool_name=tool_name)

    if ui_mode == "direct_execute" and tool_name:
        return "direct_execute"

    return "agent"


def route_after_agent(state: AgentState) -> Literal["tools", "__end__"]:
    """Agent post-routing: Determine whether to call tools or end

    Standard ReAct pattern: If LLM returns tool calls, route to tools node;
    otherwise end execution.

    Args:
        state: Agent state

    Returns:
        "tools" or END
    """
    messages = state.get("messages", [])

    if not messages:
        return END

    last_message = messages[-1]

    # Check for tool calls
    if isinstance(last_message, AIMessage) and getattr(last_message, "tool_calls", None):
        tool_names = [tc.get("name", "") for tc in last_message.tool_calls]
        logger.debug("route_after_agent_to_tools", tool_names=tool_names)
        return "tools"

    return END


def route_after_tools(state: AgentState) -> Literal["agent", "__end__"]:
    """Tool post-routing: Write operation/GenUI directly ends, read operation returns Agent

    Based on dynamic：
    - WRITE type → directly ends after successful execution
    - GENUI type → directly ends after successful execution, waiting for user interaction
    - READONLY type → returns Agent to continue conversation

    Args:
        state: Agent state

    Returns:
        "agent" or END
    """
    from langchain_core.messages import ToolMessage

    from app.core.langgraph.tools.tool_metadata import ToolType, get_tool_metadata

    messages = state.get("messages", [])

    if not messages:
        return END

    # Check the last executed tool
    last_message = messages[-1]

    if isinstance(last_message, ToolMessage):
        tool_name = getattr(last_message, "name", "")
        tool_meta = get_tool_metadata(tool_name)

        if tool_meta:
            # Check if we are in GenUI atomic direct execute mode
            ui_mode = state.get("ui_mode", "idle")

            # WRITE type:
            # - If normal: ends (Agent will summarize)
            # - If direct_execute: must go to AGENT to provide final summary/confirmation
            if tool_meta.tool_type == ToolType.WRITE:
                if ui_mode == "direct_execute":
                    logger.info("route_after_tools_to_agent_for_summary", tool_name=tool_name, ui_mode=ui_mode)
                    return "agent"

                logger.info(
                    "route_after_tools_end",
                    tool_name=tool_name,
                    tool_type=tool_meta.tool_type.value,
                    reason="write_operation_complete",
                )
                return END

            # GENUI type:
            # - If direct_execute: ends (UI will handle interaction/wizard)
            # - If normal agent flow: return to AGENT for synthesis (e.g. Skill analysis)
            if tool_meta.tool_type == ToolType.GENUI:
                if ui_mode == "direct_execute":
                    logger.info("route_after_tools_end_direct_genui", tool_name=tool_name)
                    return END

                logger.info("route_after_tools_continue_for_synthesis", tool_name=tool_name)
                return "agent"

            # Data query tools (like search_transactions):
            # - End to let UI display results, avoid redundant text.
            if tool_name == "search_transactions":
                logger.info("route_after_tools_end_data_query", tool_name=tool_name)
                return END

        # READONLY type or unknown tool: returns Agent to continue conversation
        logger.debug(
            "route_after_tools_to_agent",
            tool_name=tool_name,
            tool_type=tool_meta.tool_type.value if tool_meta else "unknown",
            reason="read_operation_continue",
        )
        return "agent"

    # DEFAULT：END
    return END
