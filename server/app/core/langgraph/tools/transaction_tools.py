"""Transaction Tools - Transaction records and inquiry tools

Provide two core tools:
- record_transactions: Record transactions (support mixed type batch recording)
- search_transactions: Query transactions (support multi-condition search)

Design Principles:
- Single entry point, reduce LLM selection burden
- Type parameterization, rather than multi-tool separation
- Return GenUI component data
"""

import uuid
from datetime import datetime, timedelta, timezone
from decimal import Decimal
from typing import Any, Dict, List, Literal, Optional

from langchain_core.runnables import RunnableConfig
from langchain_core.tools import tool
from pydantic import BaseModel, Field, field_validator

from app.core.constants.transaction_constants import EXPENSE_CATEGORIES, INCOME_CATEGORIES, TransactionCategory
from app.core.database import db_manager
from app.core.logging import logger
from app.services.transaction_service import TransactionService

# ============================================================================
# Helper Functions
# ============================================================================


def _get_user_uuid(config: RunnableConfig) -> Optional[uuid.UUID]:
    """Extract user UUID from configuration"""
    val = config.get("configurable", {}).get("user_uuid")
    if val is None:
        return None
    return uuid.UUID(val) if isinstance(val, str) else val


def _get_user_uuid_str(config: RunnableConfig) -> Optional[str]:
    """Extract user UUID string from configuration"""
    val = config.get("configurable", {}).get("user_uuid")
    if val is None:
        return None
    return str(val) if isinstance(val, uuid.UUID) else val


def _get_thread_id(config: RunnableConfig) -> Optional[str]:
    """Extract thread_id (session_id) from configuration for message anchor"""
    return config.get("configurable", {}).get("thread_id")


def _parse_time(time_str: Optional[str]) -> datetime:
    """Parse time string, return current time if failed"""
    if not time_str:
        return datetime.now(timezone.utc)
    try:
        return datetime.fromisoformat(time_str.replace("Z", "+00:00"))
    except (ValueError, AttributeError):
        return datetime.now(timezone.utc)


def _get_default_category(tx_type: str) -> str:
    """Fallback default category if LLM fails to provide one"""
    if tx_type == "income":
        return TransactionCategory.SALARY_WAGE.value
    return TransactionCategory.OTHERS.value


# ============================================================================
# Record Transactions Tool
# ============================================================================


class TransactionItem(BaseModel):
    """Transaction item"""

    type: Literal["expense", "income"] = Field(
        ..., description="Transaction type: expense (outflow) or income (inflow)"
    )
    amount: float = Field(..., gt=0, description="Amount")
    currency: Optional[str] = Field(
        default=None,
        description=(
            "Currency code (ISO 4217). IMPORTANT: Leave as null/empty unless the user "
            "EXPLICITLY mentions a DIFFERENT currency. Examples of explicit mentions: "
            "'5 US dollars', '10 euros', '1000 yen'. "
            "Do NOT infer currency from ambiguous expressions like '元', '块', '¥', or bare numbers - "
            "these should use the user's default currency (leave null). "
            "Only fill this when the user clearly wants a specific currency different from their usual one."
        ),
    )
    tags: List[str] = Field(
        ..., min_length=1, description="Tags (describe transaction content), e.g. ['fruit', 'supermarket']"
    )
    category_key: TransactionCategory = Field(
        ..., description="Key of the category. Choose the most appropriate one based on context."
    )
    raw_input: Optional[str] = Field(default=None, description="Corresponding original input fragment")


class RecordTransactionsInput(BaseModel):
    """Record transactions input schema"""

    transactions: List[TransactionItem] = Field(
        ..., min_length=1, description="Transaction list, each containing type/amount/tags"
    )
    transaction_at: Optional[str] = Field(
        default=None, description="Transaction time (ISO 8601), default current time"
    )
    source_account_id: Optional[str] = Field(default=None, description="Payment account ID for expense (optional)")
    target_account_id: Optional[str] = Field(default=None, description="Receipt account ID for income (optional)")


@tool("record_transactions", args_schema=RecordTransactionsInput)
async def record_transactions(
    transactions: List[dict],
    transaction_at: Optional[str] = None,
    source_account_id: Optional[str] = None,
    target_account_id: Optional[str] = None,
    *,
    config: RunnableConfig,
) -> Dict[str, Any]:
    """Record financial transactions. Supports multiple items of mixed types (expense/income).

    INTENT DETECTION:
    - Pure numbers (e.g., "20", "3") → Treat as "record expense of that amount"
    - Number + description (e.g., "30 buy coffee", "lunch 50") → Record transaction with tags

    GUIDANCE ON TYPE:
    - expense: Any transaction where the user's total net worth decreases (Outflow).
    - income: Any transaction where the user's total net worth increases (Inflow).

    DISAMBIGUATION:
    - "Red Packets" (红包): If the user is GIVING/SENDING, it is an expense. If the user is RECEIVING/GETTING, it is an income.
    - "Lending/Repayment": Lending money to others is an expense; receiving repayment is an income.

    The model should infer the direction of flow based on the semantic intent of the input language.
    """
    user_uuid = _get_user_uuid(config)
    if not user_uuid:
        return {"success": False, "message": "User not authenticated"}

    tx_time = _parse_time(transaction_at)

    if not transactions:
        return {"success": False, "message": "Please provide at least one transaction"}

    async with db_manager.session_factory() as session:
        service = TransactionService(session)

        try:
            expense_items = []
            income_items = []

            for tx in transactions:
                if hasattr(tx, "model_dump"):
                    tx_dict = tx.model_dump()
                elif hasattr(tx, "dict"):
                    tx_dict = tx.dict()
                elif isinstance(tx, dict):
                    tx_dict = tx
                else:
                    tx_dict = dict(tx)

                tx_type = tx_dict.get("type", "expense")
                amount = tx_dict.get("amount")
                tags = tx_dict.get("tags", [])
                category = tx_dict.get("category_key") or _get_default_category(tx_type)
                raw_input = tx_dict.get("raw_input")
                currency = tx_dict.get("currency")  # None uses user default

                item = {
                    "amount": amount,
                    "tags": tags,
                    "category_key": category,
                    "raw_input": raw_input,
                    "transaction_type": tx_type,
                    "currency": currency,
                }

                if tx_type == "income":
                    income_items.append(item)
                else:
                    expense_items.append(item)

            all_items = expense_items + income_items

            result = await service.create_batch_transactions(
                user_uuid=user_uuid,
                data={
                    "transactions": all_items,
                    "source_account_id": source_account_id,
                    "target_account_id": target_account_id,
                    "transaction_at": tx_time.isoformat(),
                },
                source_thread_id=_get_thread_id(config),
            )

            if isinstance(result, dict) and result.get("success"):
                expense_count = len(expense_items)
                income_count = len(income_items)
                expense_total = sum(item["amount"] for item in expense_items)
                income_total = sum(item["amount"] for item in income_items)

                result["componentType"] = "TransactionGroupReceipt"
                result["summary"] = {
                    "expense_count": expense_count,
                    "income_count": income_count,
                    "expense_total": expense_total,
                    "income_total": income_total,
                    "net": income_total - expense_total,
                }

                logger.info(
                    "record_transactions_success",
                    expense_count=expense_count,
                    income_count=income_count,
                    total_count=len(all_items),
                )

            return result

        except Exception as e:
            logger.error("record_transactions_failed", error=str(e), exc_info=True)
            return {"success": False, "message": f"记录失败: {str(e)}"}


# ============================================================================
# Search Transactions Tool
# ============================================================================


class SearchTransactionInput(BaseModel):
    """Search transaction input schema"""

    keyword: Optional[str] = Field(None, description="Keyword, match description/merchant/tags")
    min_amount: Optional[float] = Field(None, description="Minimum amount")
    max_amount: Optional[float] = Field(None, description="Maximum amount")
    transaction_types: Optional[List[str]] = Field(None, description="Type: EXPENSE/INCOME/TRANSFER")

    @field_validator("transaction_types", mode="before")
    @classmethod
    def parse_transaction_types(cls, v: Any) -> Any:
        """Convert JSON string to list"""
        if v is None:
            return None
        if isinstance(v, list):
            return v
        if isinstance(v, str):
            import json

            try:
                parsed = json.loads(v)
                if isinstance(parsed, list):
                    return parsed
            except (json.JSONDecodeError, TypeError):
                pass
            if "," in v:
                return [t.strip().upper() for t in v.split(",")]
            v_clean = v.strip().replace('\\"', "").replace('"', "").replace("[", "").replace("]", "")
            if v_clean:
                return [v_clean.upper()]
        return v

    start_date: Optional[str] = Field(None, description="Start date (ISO 8601)")
    end_date: Optional[str] = Field(None, description="End date (ISO 8601)")
    page: int = Field(1, description="Page number")
    per_page: int = Field(10, description="Number of items per page")


@tool("search_transactions", args_schema=SearchTransactionInput)
async def search_transactions(
    keyword: Optional[str] = None,
    min_amount: Optional[float] = None,
    max_amount: Optional[float] = None,
    transaction_types: Optional[List[str]] = None,
    start_date: Optional[str] = None,
    end_date: Optional[str] = None,
    page: int = 1,
    per_page: int = 10,
    *,
    config: RunnableConfig,
) -> Dict[str, Any]:
    """Retrieve a raw list of transaction records. Best for finding specific orders or viewing history.

    IMPORTANT: This tool ONLY lists transactions. For any "analysis", "spending breakdown",
    "patterns", or "financial health", you MUST use the specialized skills in the catalog
    (e.g., spending-analyzer, cashflow-analyst).

    Defaults to last 7 days.
    """
    from app.core.database import db_manager as search_db_manager
    from app.services.transaction_query_service import (
        TransactionQueryParams,
        TransactionQueryService,
        TransactionType as TxType,
    )
    from app.utils.currency_utils import get_user_display_currency

    user_uuid_str = _get_user_uuid_str(config)
    if not user_uuid_str:
        return {"success": False, "message": "User context missing", "items": []}

    try:
        tx_types = None
        if transaction_types:
            tx_types = [TxType(t.upper()) for t in transaction_types]

        # Default date range: last 7 days
        effective_start_date = start_date
        effective_end_date = end_date

        if not start_date and not end_date:
            now = datetime.now(timezone.utc)
            effective_start_date = (now - timedelta(days=7)).isoformat()
            effective_end_date = now.isoformat()
            logger.debug(
                "search_transactions_default_date_range",
                start_date=effective_start_date,
                end_date=effective_end_date,
            )

        params = TransactionQueryParams(
            keyword=keyword,
            min_amount=min_amount,
            max_amount=max_amount,
            transaction_types=tx_types,
            start_date=effective_start_date,
            end_date=effective_end_date,
            page=page,
            per_page=per_page,
        )

        async with db_manager.session_factory() as session:
            service = TransactionQueryService(session)
            result = await service.search(user_uuid_str, params)

            # 获取用户的 primaryCurrency 用于汇总显示
            display_currency = await get_user_display_currency(session, uuid.UUID(user_uuid_str))

        items = []
        total_expense = Decimal("0.0")
        category_stats: Dict[str, Decimal] = {}

        for item in result.items:
            val = Decimal(str(item.amount))

            items.append(
                {
                    "id": item.id,
                    "amount": float(val),
                    "currency": item.currency,
                    "description": item.description or "",
                    "type": item.type,
                    "transaction_time": item.transaction_at,
                    "location": item.location,
                    "tags": item.tags or [],
                    "category": item.category_key,
                    "display": item.display.model_dump() if item.display else None,
                }
            )

            if item.type == "EXPENSE":
                abs_amount = abs(val)
                total_expense += abs_amount
                cat_key = item.category_key or "OTHERS"
                category_stats[cat_key] = category_stats.get(cat_key, Decimal("0.0")) + abs_amount

        distribution = []
        if total_expense > 0:
            sorted_cats = sorted(category_stats.items(), key=lambda x: x[1], reverse=True)
            for cat_key, amt in sorted_cats:
                distribution.append(
                    {"category": cat_key, "amount": float(amt), "percentage": float(amt / total_expense)}
                )

        top_items = sorted(
            [it for it in items if it["type"] == "EXPENSE"], key=lambda x: float(x.get("amount") or 0.0), reverse=True
        )[:3]

        return {
            "success": True,
            "componentType": "ExpenseSummaryCard",
            "summary": {
                "total_expense": float(total_expense),
                "currency": display_currency,  # 使用用户的 primaryCurrency
                "distribution": distribution,
                "top_items": top_items,
                "count": result.total,
            },
            "items": items,
            "total": result.total,
            "page": result.page,
            "per_page": result.per_page,
            "has_more": result.has_more,
            "metadata": {
                "keyword": keyword,
                "start_date": start_date,
                "end_date": end_date,
                "transaction_types": transaction_types,
                "min_amount": min_amount,
                "max_amount": max_amount,
            },
        }

    except ValueError as e:
        return {
            "success": False,
            "message": f"Invalid parameters: {str(e)}. transaction_types must be a list of EXPENSE, INCOME, or TRANSFER.",
            "items": [],
            "total": 0,
        }
    except Exception as e:
        logger.error(f"Search failed for user {user_uuid_str}: {str(e)}", exc_info=True)
        return {"success": False, "message": f"System error: {str(e)}", "items": [], "total": 0}


# ============================================================================
# Export
# ============================================================================

transaction_tools = [record_transactions, search_transactions]
