"""Tool metadata and utilities for UI paradigm handling.

This module defines metadata for each tool using three orthogonal dimensions:
- SideEffect: Mutation characteristics (PURE/READ/WRITE)
- Continuation: Post-execution routing policy (AGENT/END/WAIT_USER)
- OutputPolicy: Text/UI output filtering (NORMAL/SILENT_TEXT/SILENT_ALL)

This design provides clear separation of concerns and enables declarative routing logic.
"""

from enum import Enum
from typing import Any, Dict

# ============================================================================
# Orthogonal Dimension Enums
# ============================================================================


class SideEffect(str, Enum):
    """Side effect classification - determines cancellability and safety.

    Use this to classify whether a tool modifies external state.

    Decision guide:
    - PURE: No side effects (e.g., UI rendering, data transformation)
    - READ: Read-only operations (e.g., database queries, file reads)
    - WRITE: Mutating operations (e.g., database writes, transfers)
    """

    PURE = "pure"  # No side effects
    READ = "read"  # Read-only operations
    WRITE = "write"  # Mutating operations


class Continuation(str, Enum):
    """Post-execution routing policy - determines control flow.

    Use this to declare where the graph should go AFTER the tool executes.

    Decision guide:
    - AGENT: Return to agent for further processing/reasoning
    - END: Terminate the current execution loop
    - WAIT_USER: Pause and wait for user interaction via UI
    """

    AGENT = "agent"  # Return to agent for further processing
    END = "end"  # Terminate execution
    WAIT_USER = "wait_user"  # Wait for user UI interaction


class OutputPolicy(str, Enum):
    """Output filtering policy - determines text/UI display behavior.

    Use this to control what gets shown to the user during streaming.

    Decision guide:
    - NORMAL: Show all output (text + UI)
    - SILENT_TEXT: Suppress text, show UI only
    - SILENT_ALL: Suppress all output (internal tools)
    """

    NORMAL = "normal"  # Normal output (text + UI)
    SILENT_TEXT = "silent_text"  # Suppress text, show UI
    SILENT_ALL = "silent_all"  # Completely silent


# ============================================================================
# Tool Metadata
# ============================================================================


class ToolMetadata:
    """Metadata about a tool for routing and UI handling.

    Attributes:
        name: Tool identifier
        display_name: User-facing display name
        side_effect: Mutation characteristics
        continuation: Post-execution routing policy
        output_policy: Text/UI output filtering
        cancellable: Whether the tool can be safely cancelled
        warning_on_cancel: Warning message when cancelling
    """

    def __init__(
        self,
        name: str,
        display_name: str,
        side_effect: SideEffect,
        continuation: Continuation,
        output_policy: OutputPolicy = OutputPolicy.NORMAL,
        cancellable: bool = True,
        warning_on_cancel: str | None = None,
    ):
        self.name = name
        self.display_name = display_name
        self.side_effect = side_effect
        self.continuation = continuation
        self.output_policy = output_policy
        self.cancellable = cancellable
        self.warning_on_cancel = warning_on_cancel

    def to_dict(self) -> Dict[str, Any]:
        """Convert the tool metadata to a serializable dictionary."""
        return {
            "name": self.name,
            "display_name": self.display_name,
            "side_effect": self.side_effect.value,
            "continuation": self.continuation.value,
            "output_policy": self.output_policy.value,
            "cancellable": self.cancellable,
            "warning_on_cancel": self.warning_on_cancel,
        }

    @property
    def is_text_silent(self) -> bool:
        """Check if tool should suppress text output."""
        return self.output_policy in (OutputPolicy.SILENT_TEXT, OutputPolicy.SILENT_ALL)

    @property
    def is_fully_silent(self) -> bool:
        """Check if tool should be completely silent."""
        return self.output_policy == OutputPolicy.SILENT_ALL


# ============================================================================
# Tool Metadata Registry
# ============================================================================

TOOL_METADATA: Dict[str, ToolMetadata] = {
    # ------------------------------------------------------------------
    # Read-only query tools - return to agent for further processing
    # ------------------------------------------------------------------
    "search_transactions": ToolMetadata(
        name="search_transactions",
        display_name="搜索交易记录",
        side_effect=SideEffect.READ,
        continuation=Continuation.AGENT,
        output_policy=OutputPolicy.NORMAL,
        cancellable=True,
    ),
    "list_financial_accounts": ToolMetadata(
        name="list_financial_accounts",
        display_name="获取账户列表",
        side_effect=SideEffect.READ,
        continuation=Continuation.AGENT,
        output_policy=OutputPolicy.NORMAL,
        cancellable=True,
    ),
    "query_budget_status": ToolMetadata(
        name="query_budget_status",
        display_name="查询预算状态",
        side_effect=SideEffect.READ,
        continuation=Continuation.AGENT,
        output_policy=OutputPolicy.NORMAL,
        cancellable=True,
    ),
    # ------------------------------------------------------------------
    # Write tools - terminate after execution
    # ------------------------------------------------------------------
    "record_transactions": ToolMetadata(
        name="record_transactions",
        display_name="记录交易",
        side_effect=SideEffect.WRITE,
        continuation=Continuation.END,
        output_policy=OutputPolicy.NORMAL,
        cancellable=False,
        warning_on_cancel="操作可能已执行，请检查账户余额",
    ),
    "execute_transfer": ToolMetadata(
        name="execute_transfer",
        display_name="执行转账",
        side_effect=SideEffect.WRITE,
        continuation=Continuation.END,
        output_policy=OutputPolicy.SILENT_TEXT,
        cancellable=False,
        warning_on_cancel="转账可能已执行，请检查账户余额",
    ),
    "create_budget": ToolMetadata(
        name="create_budget",
        display_name="创建预算",
        side_effect=SideEffect.WRITE,
        continuation=Continuation.END,
        output_policy=OutputPolicy.NORMAL,
        cancellable=False,
        warning_on_cancel="预算可能已创建，请刷新查看",
    ),
    "associate_transactions_to_space": ToolMetadata(
        name="associate_transactions_to_space",
        display_name="关联共享空间",
        side_effect=SideEffect.WRITE,
        continuation=Continuation.END,
        output_policy=OutputPolicy.SILENT_TEXT,
        cancellable=False,
        warning_on_cancel="关联操作可能已执行",
    ),
    # ------------------------------------------------------------------
    # Interactive UI tools - wait for user interaction
    # ------------------------------------------------------------------
    "write_todos": ToolMetadata(
        name="write_todos",
        display_name="规划任务步骤",
        side_effect=SideEffect.PURE,
        continuation=Continuation.WAIT_USER,
        output_policy=OutputPolicy.NORMAL,
        cancellable=True,
    ),
    # ------------------------------------------------------------------
    # Background/skill tools - silent execution, return to agent
    # ------------------------------------------------------------------
    "execute": ToolMetadata(
        name="execute",
        display_name="执行技能脚本",
        side_effect=SideEffect.READ,
        continuation=Continuation.AGENT,
        output_policy=OutputPolicy.SILENT_ALL,
        cancellable=True,
    ),
    "bash": ToolMetadata(
        name="bash",
        display_name="执行命令",
        side_effect=SideEffect.READ,
        continuation=Continuation.AGENT,
        output_policy=OutputPolicy.SILENT_ALL,
        cancellable=True,
    ),
    "read_file": ToolMetadata(
        name="read_file",
        display_name="读取文件",
        side_effect=SideEffect.READ,
        continuation=Continuation.AGENT,
        output_policy=OutputPolicy.SILENT_ALL,
        cancellable=True,
    ),
    "write_file": ToolMetadata(
        name="write_file",
        display_name="写入文件",
        side_effect=SideEffect.WRITE,
        continuation=Continuation.END,
        output_policy=OutputPolicy.SILENT_ALL,
        cancellable=True,
    ),
    "ls": ToolMetadata(
        name="ls",
        display_name="列出目录",
        side_effect=SideEffect.READ,
        continuation=Continuation.AGENT,
        output_policy=OutputPolicy.SILENT_ALL,
        cancellable=True,
    ),
}


# ============================================================================
# Utility Functions
# ============================================================================


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
    """Check if a tool should suppress text output."""
    metadata = get_tool_metadata(tool_name)
    if metadata is None:
        return False
    return metadata.is_text_silent
