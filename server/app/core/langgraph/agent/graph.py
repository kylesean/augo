"""Graph construction module.

Uses LangGraph StateGraph API to build the Agent graph.

Graph structure:
    START --> route_entry --+--> agent --> route_after_agent --+--> tools --> agent
                            |                                  |
                            +--> direct_execute --> END        +--> END

Reference: docs/ROUTE_AFTER_AGENT.md
"""

from __future__ import annotations

from typing import Any, cast

from langchain_core.language_models import BaseChatModel
from langchain_core.tools import BaseTool
from langgraph.checkpoint.base import BaseCheckpointSaver
from langgraph.graph import END, START, StateGraph
from langgraph.graph.state import CompiledStateGraph
from langgraph.prebuilt import ToolNode

from app.core.langgraph.agent.edges import route_after_agent, route_after_tools, route_entry
from app.core.langgraph.agent.nodes import create_agent_node, create_direct_execute_node
from app.core.langgraph.agent.state import AgentState
from app.core.logging import logger


def build_agent_graph(
    llm: BaseChatModel,
    tools: list[BaseTool],
    system_prompt: str,
    checkpointer: BaseCheckpointSaver | None = None,
    name: str = "AugoAgent",
) -> CompiledStateGraph:
    """Build the Agent graph.

    Uses LangGraph StateGraph API to construct the complete Agent graph, including:
    - agent node: Invokes the LLM
    - tools node: Executes tools (using ToolNode)
    - direct_execute node: GenUI direct execution scenario

    Args:
        llm: LLM instance with tools already bound
        tools: List of available tools
        system_prompt: System prompt (should already contain skills catalog)
        checkpointer: Optional checkpoint saver (for short-term memory)
        name: Graph name

    Returns:
        Compiled StateGraph
    """
    # Create StateGraph
    workflow = StateGraph(AgentState)

    # Add nodes
    workflow.add_node("agent", cast(Any, create_agent_node(llm, tools, system_prompt)))
    workflow.add_node("tools", ToolNode(tools))
    workflow.add_node("direct_execute", cast(Any, create_direct_execute_node(tools)))

    # Add edges
    # 1. Entry conditional edge: Check if direct execution is needed
    workflow.add_conditional_edges(START, route_entry)

    # 2. Agent -> After Agent (check tool calls directly)
    workflow.add_conditional_edges("agent", route_after_agent)

    # 3. Post-tool conditional edge: Write ops end, read ops return to Agent
    workflow.add_conditional_edges("tools", route_after_tools)

    # 4. Direct execute ends immediately
    workflow.add_edge("direct_execute", END)

    # Compile graph
    compiled_graph = workflow.compile(
        checkpointer=checkpointer,
        name=name,
    )

    logger.info(
        "agent_graph_built",
        node_count=4,
        has_checkpointer=checkpointer is not None,
        name=name,
    )

    return compiled_graph
