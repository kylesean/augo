"""Tool metadata and utilities for UI paradigm handling.

This module defines metadata for each tool including:
- Tool type (readonly, write, genui)
- Silent mode (controls text output suppression)
- Cancellability
- User-facing display names
"""

from enum import Enum
from typing import Any, Dict

from app.schemas.genui import SilentMode


class ToolType(str, Enum):
    """Tool type classification for cancellation handling."""

    READONLY = "readonly"  # Query operations - fully cancellable
    WRITE = "write"  # Write operations - may not be cancellable after execution starts
    GENUI = "genui"  # GenUI tools - waiting for user input via UI


class ToolMetadata:
    """Metadata about a tool for UI and cancellation handling.

    Attributes:
        name: 工具名称
        display_name: 显示名称（用于 UI）
        tool_type: 工具类型（READONLY/WRITE/GENUI）
        silent_mode: 静默模式（NONE/TEXT_ONLY/FULL）
        cancellable: 是否可取消
        warning_on_cancel: 取消操作的警告消息
    """

    def __init__(
        self,
        name: str,
        display_name: str,
        tool_type: ToolType,
        silent_mode: SilentMode = SilentMode.NONE,
        cancellable: bool = True,
        warning_on_cancel: str | None = None,
    ):
        self.name = name
        self.display_name = display_name
        self.tool_type = tool_type
        self.silent_mode = silent_mode
        self.cancellable = cancellable
        self.warning_on_cancel = warning_on_cancel

    def to_dict(self) -> Dict[str, Any]:
        """Convert the tool metadata to a serializable dictionary."""
        return {
            "name": self.name,
            "display_name": self.display_name,
            "tool_type": self.tool_type.value,
            "silent_mode": self.silent_mode.value,
            "cancellable": self.cancellable,
            "warning_on_cancel": self.warning_on_cancel,
        }

    @property
    def is_text_silent(self) -> bool:
        """检查工具是否应该静默文本输出"""
        return self.silent_mode in (SilentMode.TEXT_ONLY, SilentMode.FULL)

    @property
    def is_fully_silent(self) -> bool:
        """检查工具是否完全静默"""
        return self.silent_mode == SilentMode.FULL


# Tool metadata registry
TOOL_METADATA: Dict[str, ToolMetadata] = {
    # ============================================================
    # 只读工具 - 可完全取消
    # ============================================================
    "search_transactions": ToolMetadata(
        name="search_transactions",
        display_name="搜索交易记录",
        tool_type=ToolType.READONLY,
        silent_mode=SilentMode.NONE,
        cancellable=True,
    ),
    "list_financial_accounts": ToolMetadata(
        name="list_financial_accounts",
        display_name="获取账户列表",
        tool_type=ToolType.READONLY,
        silent_mode=SilentMode.NONE,
        cancellable=True,
    ),
    "query_budget_status": ToolMetadata(
        name="query_budget_status",
        display_name="查询预算状态",
        tool_type=ToolType.READONLY,
        silent_mode=SilentMode.NONE,
        cancellable=True,
    ),
    # ============================================================
    # 写入工具 - 执行后不可取消
    # ============================================================
    "record_transactions": ToolMetadata(
        name="record_transactions",
        display_name="记录交易",
        tool_type=ToolType.WRITE,
        silent_mode=SilentMode.NONE,  # 正常输出，让用户确认
        cancellable=False,
        warning_on_cancel="操作可能已执行，请检查账户余额",
    ),
    "execute_transfer": ToolMetadata(
        name="execute_transfer",
        display_name="执行转账",
        tool_type=ToolType.WRITE,
        silent_mode=SilentMode.TEXT_ONLY,  # 静默文本，让 UI 说话
        cancellable=False,
        warning_on_cancel="转账可能已执行，请检查账户余额",
    ),
    "create_budget": ToolMetadata(
        name="create_budget",
        display_name="创建预算",
        tool_type=ToolType.WRITE,
        silent_mode=SilentMode.NONE,
        cancellable=False,
        warning_on_cancel="预算可能已创建，请刷新查看",
    ),
    "associate_transactions_to_space": ToolMetadata(
        name="associate_transactions_to_space",
        display_name="关联共享空间",
        tool_type=ToolType.WRITE,
        silent_mode=SilentMode.TEXT_ONLY,  # 静默文本，让 UI 展示结果
        cancellable=False,
        warning_on_cancel="关联操作可能已执行",
    ),
    # ============================================================
    # GenUI 交互工具
    # ============================================================
    "write_todos": ToolMetadata(
        name="write_todos",
        display_name="规划任务步骤",
        tool_type=ToolType.GENUI,
        silent_mode=SilentMode.NONE,
        cancellable=True,
    ),
    # ============================================================
    # 文件系统/技能执行工具 - 完全静默
    # ============================================================
    "execute": ToolMetadata(
        name="execute",
        display_name="执行技能脚本",
        tool_type=ToolType.GENUI,
        silent_mode=SilentMode.FULL,  # 完全静默
        cancellable=True,
    ),
    "bash": ToolMetadata(
        name="bash",
        display_name="执行命令",
        tool_type=ToolType.READONLY,
        silent_mode=SilentMode.FULL,
        cancellable=True,
    ),
    "read_file": ToolMetadata(
        name="read_file",
        display_name="读取文件",
        tool_type=ToolType.READONLY,
        silent_mode=SilentMode.FULL,
        cancellable=True,
    ),
    "write_file": ToolMetadata(
        name="write_file",
        display_name="写入文件",
        tool_type=ToolType.WRITE,
        silent_mode=SilentMode.FULL,
        cancellable=True,
    ),
    "ls": ToolMetadata(
        name="ls",
        display_name="列出目录",
        tool_type=ToolType.READONLY,
        silent_mode=SilentMode.FULL,
        cancellable=True,
    ),
}


def get_tool_metadata(tool_name: str) -> ToolMetadata | None:
    """Get metadata for a tool by name."""
    return TOOL_METADATA.get(tool_name)


def is_tool_cancellable(tool_name: str) -> bool:
    """Check if a tool can be safely cancelled."""
    metadata = get_tool_metadata(tool_name)
    if metadata is None:
        return True  # Default to cancellable for unknown tools
    return metadata.cancellable


def get_cancel_warning(tool_name: str) -> str | None:
    """Get the cancel warning message for a tool, if any."""
    metadata = get_tool_metadata(tool_name)
    if metadata is None:
        return None
    return metadata.warning_on_cancel


def is_text_silent(tool_name: str) -> bool:
    """Check if a tool should suppress text output.

    Used by TextFilterPolicy.SilentToolPolicy.
    """
    metadata = get_tool_metadata(tool_name)
    if metadata is None:
        return False
    return metadata.is_text_silent
