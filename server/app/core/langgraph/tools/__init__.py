"""工具模块 - LangGraph Agent 工具集

架构设计：
- LLM 可见工具：record_transactions, search_transactions, 预算, 文件系统
- 内部工具：execute_transfer（仅 GenUI 回调使用，不暴露给 LLM）

设计原则：
- 工具语义清晰，LLM 无需额外提示即可正确选择
- 统一入口：record_transactions 支持混合类型批量记录
- 转账通过 transfer-expert 技能触发，由 UI 收集账户信息
- 财务分析、共享空间等通过 Skills + 脚本实现，节省 token 消耗
"""

from contextvars import ContextVar
from typing import Dict, List

from langchain_core.tools.base import BaseTool

from app.core.logging import logger

from .budget_tools import budget_tools
from .duckduckgo_search import duckduckgo_search_tool
from .filesystem_tools import filesystem_tools
from .memory_tools import memory_tools

# 统一的交易工具（记录 + 查询）
from .transaction_tools import transaction_tools as record_tools
from .transfer_tools import execute_transfer, transfer_tools  # execute_transfer 单独导出供内部使用

# 用于在请求生命周期内存储用户身份和语言
from .context import current_session_language, current_user_id


# 1. LLM 可见的业务工具
# - record_transactions: 记录交易（支持混合类型批量）
# - search_transactions: 查询交易
# 注意：execute_transfer 不在此列表中，LLM 看不到它
transaction_semantic_tools: List[BaseTool] = record_tools

# 业务工具
business_tools: List[BaseTool] = transaction_semantic_tools + budget_tools

# 2. 通用工具
utility_tools: List[BaseTool] = [
    duckduckgo_search_tool,
]

# 3. DeepAgents 文件系统工具（用于 Skills 执行）
# 包含 read_file, ls, execute

# 4. 最终暴露给 LLM 的工具集（日常对话）
tools: List[BaseTool] = utility_tools + business_tools + filesystem_tools + memory_tools

# 5. 技能专属工具（已迁移到脚本模式，不再需要）
# - finance-analyst: 通过 analyze_finance.py, forecast_finance.py 脚本
# - shared-space: 通过 list_spaces.py, query_space_summary.py 脚本
skill_exclusive_tools: Dict[str, List[BaseTool]] = {}

# 6. 内部工具（不暴露给 LLM，仅供 GenUI 回调等内部使用）
# execute_transfer 已通过上面的 import 导出，供需要时调用

logger.info(
    "tools_loaded",
    llm_visible=len(tools),
    skill_exclusive=sum(len(v) for v in skill_exclusive_tools.values()),
    internal=1,  # execute_transfer
    total=len(tools) + sum(len(v) for v in skill_exclusive_tools.values()) + 1,
)
