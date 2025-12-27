"""Agent模块 - LangGraph 底层 API 实现

此模块包含使用 LangGraph StateGraph 底层 API 构建的 Agent 实现。
将原 simple_agent.py 的职责分解为：
- state.py: State 定义
- nodes.py: 节点函数
- edges.py: 路由逻辑
- graph.py: 图构建
"""

from app.core.langgraph.agent.graph import build_agent_graph
from app.core.langgraph.agent.state import AgentState

__all__ = [
    "AgentState",
    "build_agent_graph",
]
