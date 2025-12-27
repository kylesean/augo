"""Execute Transfer Tool

This tool executes a transfer between two accounts.
- Requires source_account_id and target_account_id (typically provided by GenUI).
- Usually triggered by interaction with the TransferPathBuilder UI.
"""

import uuid
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

from langchain_core.runnables import RunnableConfig
from langchain_core.tools import tool
from pydantic import BaseModel, Field

from app.core.database import db_manager
from app.core.logging import logger
from app.services.transaction_service import TransactionService


class ExecuteTransferInput(BaseModel):
    """Input for execute_transfer tool."""

    source_account_id: str = Field(..., description="ID of the source account (provided by UI)")
    target_account_id: str = Field(..., description="ID of the target account (provided by UI)")
    amount: float = Field(..., gt=0, description="Transfer amount")
    memo: str = Field(default="", description="Optional transfer memo/note")
    transaction_at: Optional[str] = Field(
        default=None, description="Transaction time in ISO 8601 format (defaults to current time)"
    )
    surface_id: Optional[str] = Field(default=None, description="GenUI surface ID for in-place updates")


def _get_user_uuid(config: RunnableConfig) -> Optional[uuid.UUID]:
    """从配置中提取用户 UUID，返回 UUID 对象"""
    val = config.get("configurable", {}).get("user_uuid")
    if val is None:
        return None
    return uuid.UUID(val) if isinstance(val, str) else val


def _parse_time(time_str: Optional[str]) -> datetime:
    """解析时间字符串，失败则返回当前时间"""
    if not time_str:
        return datetime.now(timezone.utc)
    try:
        return datetime.fromisoformat(time_str.replace("Z", "+00:00"))
    except (ValueError, AttributeError):
        return datetime.now(timezone.utc)


@tool("execute_transfer", args_schema=ExecuteTransferInput)
async def execute_transfer(
    source_account_id: str,
    target_account_id: str,
    amount: float,
    memo: str = "",
    transaction_at: Optional[str] = None,
    surface_id: Optional[str] = None,
    *,
    config: RunnableConfig,
) -> Dict[str, Any]:
    """Execute a transfer between two accounts.

    IMPORTANT: This tool requires specific account IDs, which should be provided by the
    TransferPathBuilder UI. When user asks to transfer money, use the transfer-expert
    skill to display the interactive UI for account selection.
    """
    user_uuid = _get_user_uuid(config)
    if not user_uuid:
        return {"success": False, "message": "用户未认证"}

    # 验证账户 ID
    if source_account_id == target_account_id:
        return {"success": False, "message": "转出和转入账户不能相同"}

    tx_time = _parse_time(transaction_at)

    # 构建 tags（转账通常用 memo 作为描述）
    tags = ["转账"]
    if memo:
        tags.append(memo)

    async with db_manager.session_factory() as session:
        service = TransactionService(session)

        try:
            result = await service.create_transaction(
                user_uuid=user_uuid,  # 已是 UUID 对象
                amount=amount,
                transaction_type="transfer",
                transaction_at=tx_time,
                category_key="GENERAL_TRANSFER",
                raw_input=memo or "转账",
                source_account_id=uuid.UUID(source_account_id),
                target_account_id=uuid.UUID(target_account_id),
                tags=tags,
            )

            if isinstance(result, dict) and result.get("success"):
                result["componentType"] = "TransferReceipt"
            return result

        except Exception as e:
            logger.error("execute_transfer_failed", error=str(e), exc_info=True)
            return {"success": False, "message": f"转账失败: {str(e)}"}


# Export
transfer_tools = [execute_transfer]
