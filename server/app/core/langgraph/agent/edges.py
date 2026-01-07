"""Edge/Routing logic definition

LangGraph conditional edge routing functions, determining the flow of execution.
Reference: https://docs.langchain.com/oss/python/langgraph/graph-api#conditional-edges

Routing is now declarative based on tool metadata's `continuation` property,
with minimal override rules for special modes like `direct_execute`.
"""

from typing import Literal, cast

from langchain_core.messages import AIMessage
from langgraph.graph import END

from app.core.langgraph.agent.state import AgentState
from app.core.langgraph.tools.tool_metadata import Continuation
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
        return cast(Literal["tools", "__end__"], END)

    last_message = messages[-1]

    # Check for tool calls
    if isinstance(last_message, AIMessage) and getattr(last_message, "tool_calls", None):
        tool_names = [tc.get("name", "") for tc in last_message.tool_calls]
        logger.debug("route_after_agent_to_tools", tool_names=tool_names)
        return "tools"

    return cast(Literal["tools", "__end__"], END)


# ============================================================================
# Direct Execute Mode Overrides
# ============================================================================
# When ui_mode=direct_execute, these rules override the tool's declared continuation.
# This centralizes special-case logic instead of scattering it in conditionals.

DIRECT_EXECUTE_OVERRIDES: dict[Continuation, Literal["agent", "__end__"]] = {
    # WRITE tools: need agent to provide summary/confirmation after direct execution
    Continuation.END: "agent",
    # WAIT_USER tools: UI handles the rest, terminate graph
    Continuation.WAIT_USER: cast(Literal["agent", "__end__"], END),
    # AGENT tools: continue as normal
    Continuation.AGENT: "agent",
}


def route_after_tools(state: AgentState) -> Literal["agent", "__end__"]:
    """Tool post-routing based on declarative continuation policy.

    Routing is determined by the tool's `continuation` metadata:
    - AGENT: Return to agent for further processing
    - END: Terminate execution
    - WAIT_USER: Terminate and wait for user UI interaction

    In `direct_execute` mode, DIRECT_EXECUTE_OVERRIDES may modify the behavior.

    Args:
        state: Agent state

    Returns:
        "agent" or END
    """
    from langchain_core.messages import ToolMessage

    from app.core.langgraph.tools.tool_metadata import Continuation, get_tool_metadata

    messages = state.get("messages", [])

    if not messages:
        return cast(Literal["agent", "__end__"], END)

    last_message = messages[-1]

    if not isinstance(last_message, ToolMessage):
        return cast(Literal["agent", "__end__"], END)

    tool_name = getattr(last_message, "name", "")
    tool_meta = get_tool_metadata(tool_name)

    if not tool_meta:
        # Unknown tool: default to continue
        logger.debug("route_after_tools_unknown", tool_name=tool_name)
        return "agent"

    continuation = tool_meta.continuation
    ui_mode = state.get("ui_mode", "idle")

    # Apply direct_execute overrides if applicable
    if ui_mode == "direct_execute":
        override = DIRECT_EXECUTE_OVERRIDES.get(continuation)
        if override is not None:
            logger.info(
                "route_after_tools_direct_execute_override",
                tool_name=tool_name,
                original_continuation=continuation.value,
                override=override if override != END else "END",
            )
            return override

    # Normal mode: use declared continuation
    if continuation == Continuation.AGENT:
        logger.debug(
            "route_after_tools_to_agent",
            tool_name=tool_name,
            continuation=continuation.value,
        )
        return "agent"

    elif continuation == Continuation.END:
        logger.info(
            "route_after_tools_end",
            tool_name=tool_name,
            continuation=continuation.value,
        )
        return cast(Literal["agent", "__end__"], END)

    elif continuation == Continuation.WAIT_USER:
        logger.info(
            "route_after_tools_wait_user",
            tool_name=tool_name,
            continuation=continuation.value,
        )
        return cast(Literal["agent", "__end__"], END)

    # Fallback: should not reach here
    logger.warning(
        "route_after_tools_fallback",
        tool_name=tool_name,
        continuation=continuation.value,
    )
    return cast(Literal["agent", "__end__"], END)
