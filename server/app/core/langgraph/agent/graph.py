"""Graph 构建模块

使用 LangGraph 底层 StateGraph API 构建 Agent 图。

图结构:     START ──► route_entry ──┬──► agent ──► route_after_agent ──┬──► tools ──► agent
                            │                                    │
                            └──► direct_execute ──► END          └──► END

参考: docs/ROUTE_AFTER_GAENT.md
"""

from typing import List, Optional

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
from app.core.skills.loader import SkillLoader


def build_agent_graph(
    llm: BaseChatModel,
    tools: List[BaseTool],
    system_prompt: str,
    checkpointer: Optional[BaseCheckpointSaver] = None,
    name: str = "AugoAgent",
) -> CompiledStateGraph:
    """构建 Agent 图

    使用 LangGraph StateGraph API 构建完整的 Agent 图，包含：
    - agent 节点：调用 LLM
    - tools 节点：执行工具（使用 ToolNode）
    - direct_execute 节点：GenUI 直接执行场景

    Args:
        llm: 已绑定工具的 LLM 实例
        tools: 可用工具列表
        system_prompt: 系统提示词
        checkpointer: 可选的 checkpoint 保存器（用于短期记忆）
        name: 图名称

    Returns:
        编译后的 StateGraph
    """
    # 动态加载 Skills 并注入 Prompt
    loader = SkillLoader()
    skills_xml = loader.get_catalog_xml()
    formatted_prompt = system_prompt.replace("{skills_catalog}", skills_xml)

    # 创建 StateGraph
    workflow = StateGraph(AgentState)

    # 添加节点
    workflow.add_node("agent", create_agent_node(llm, tools, formatted_prompt))
    workflow.add_node("tools", ToolNode(tools))
    workflow.add_node("direct_execute", create_direct_execute_node(tools))

    # 添加边
    # 1. 入口条件边：检查是否需要直接执行
    workflow.add_conditional_edges(START, route_entry)

    # 2. Agent -> After Agent（直接检查工具调用）
    workflow.add_conditional_edges("agent", route_after_agent)

    # 3. 工具执行后条件边：写操作直接结束，读操作返回 Agent
    workflow.add_conditional_edges("tools", route_after_tools)

    # 5. 直接执行后结束
    workflow.add_edge("direct_execute", END)

    # 编译图
    compiled_graph = workflow.compile(
        checkpointer=checkpointer,
        name=name,
    )

    logger.info(
        "agent_graph_built",
        node_count=4,  # agent, filter_response, tools, direct_execute
        has_checkpointer=checkpointer is not None,
        name=name,
    )

    return compiled_graph
