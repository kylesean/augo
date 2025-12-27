"""Budget management tools for the LangGraph agent.

These tools enable AI-driven budget management:
- query_budget_status: Query budget usage and remaining amount
- create_budget: Create a new budget
- suggest_budget: AI-generated budget suggestions
- rebalance_budget: Transfer between budgets
"""

from decimal import Decimal
from typing import Any, Dict, Literal, Optional
from uuid import UUID

from langchain_core.runnables import RunnableConfig
from langchain_core.tools import tool
from pydantic import BaseModel, Field, field_validator

from app.core.constants.transaction_constants import EXPENSE_CATEGORIES
from app.core.database import db_manager
from app.core.logging import logger
from app.models.budget import BudgetPeriodType, BudgetScope, BudgetSource
from app.schemas.budget import BudgetCreateRequest
from app.services.budget_service import BudgetService

# 预算支持的分类键（只允许支出分类）
BUDGET_CATEGORY_KEYS = Literal[
    "FOOD_DINING",
    "SHOPPING_RETAIL",
    "TRANSPORTATION",
    "HOUSING_UTILITIES",
    "PERSONAL_CARE",
    "ENTERTAINMENT",
    "EDUCATION",
    "MEDICAL_HEALTH",
    "INSURANCE",
    "SOCIAL_GIFTING",
    "FINANCIAL_TAX",
    "OTHERS",
]

# 有效分类键集合（用于运行时验证）
VALID_BUDGET_CATEGORIES = {cat.value for cat in EXPENSE_CATEGORIES}


def get_user_uuid(config: RunnableConfig) -> str | None:
    """Extract user_uuid from RunnableConfig."""
    user_uuid = config.get("configurable", {}).get("user_uuid")
    if user_uuid is not None:
        return str(user_uuid)
    return None


# ============================================================================
# Query Budget Status Tool
# ============================================================================


class QueryBudgetStatusInput(BaseModel):
    """Input for query_budget_status tool."""

    category_key: Optional[BUDGET_CATEGORY_KEYS] = Field(
        default=None,
        description="Category key (NULL for total budget). Supported categories: FOOD_DINING, SHOPPING_RETAIL, TRANSPORTATION, HOUSING_UTILITIES, PERSONAL_CARE, ENTERTAINMENT, EDUCATION, MEDICAL_HEALTH, INSURANCE, SOCIAL_GIFTING, FINANCIAL_TAX, OTHERS",
    )


@tool("query_budget_status", args_schema=QueryBudgetStatusInput)
async def query_budget_status(
    category_key: Optional[str] = None,
    *,
    config: RunnableConfig,
) -> Dict[str, Any]:
    """Query budget balance and usage percentage. Suitable for quick inquiries like 'how much budget is left?'. For deep analysis, use the budget-expert skill."""
    user_uuid = get_user_uuid(config)

    logger.debug("query_budget_status_called", user_uuid=user_uuid, category_key=category_key)

    if not user_uuid:
        return {
            "success": False,
            "message": "用户上下文缺失",
        }

    try:
        async with db_manager.session_factory() as session:
            service = BudgetService(session)

            if category_key:
                # Query specific category budget
                budgets = await service.get_user_budgets(UUID(user_uuid))
                target_budget = None

                for budget in budgets:
                    if budget.category_key == category_key.upper() and budget.is_active:
                        target_budget = budget
                        break

                if not target_budget:
                    return {
                        "success": False,
                        "message": f"未找到 {category_key} 分类的预算。你可以说'帮我设一个{category_key}预算'来创建。",
                        "has_budget": False,
                    }

                period = await service.get_or_create_current_period(target_budget)
                period = await service.update_period_spent_amount(target_budget, period)

                return {
                    "success": True,
                    "componentType": "BudgetStatusCard",
                    "budget": {
                        "id": str(target_budget.id),
                        "name": target_budget.name,
                        "category_key": target_budget.category_key,
                        "amount": float(target_budget.amount),
                        "spent": float(period.spent_amount),
                        "remaining": float(period.remaining_amount),
                        "percentage": period.usage_percentage,
                        "status": period.status,
                        "period_start": period.period_start.isoformat(),
                        "period_end": period.period_end.isoformat(),
                    },
                    "has_budget": True,
                }
            else:
                # Query summary of all budgets
                summary = await service.get_budget_summary(UUID(user_uuid))

                if not summary.total_budget and not summary.category_budgets:
                    return {
                        "success": True,
                        "message": "你还没有设置任何预算。要我帮你分析消费记录并建议预算吗？",
                        "has_budget": False,
                        "budgets": [],
                    }

                budgets_list = []
                if summary.total_budget:
                    budgets_list.append(
                        {
                            "id": str(summary.total_budget.id),
                            "name": summary.total_budget.name,
                            "scope": "TOTAL",
                            "amount": summary.total_budget.amount,
                            "spent": summary.total_budget.spent_amount,
                            "remaining": summary.total_budget.remaining_amount,
                            "percentage": summary.total_budget.usage_percentage,
                            "status": summary.total_budget.period_status,
                        }
                    )

                for budget in summary.category_budgets:
                    budgets_list.append(
                        {
                            "id": str(budget.id),
                            "name": budget.name,
                            "scope": "CATEGORY",
                            "category_key": budget.category_key,
                            "amount": budget.amount,
                            "spent": budget.spent_amount,
                            "remaining": budget.remaining_amount,
                            "percentage": budget.usage_percentage,
                            "status": budget.period_status,
                        }
                    )

                return {
                    "success": True,
                    "componentType": "BudgetStatusCard",
                    "has_budget": True,
                    "overall_spent": summary.overall_spent,
                    "overall_remaining": summary.overall_remaining,
                    "overall_percentage": summary.overall_percentage,
                    "budgets": budgets_list,
                    "alerts": [
                        {
                            "budget_name": a.budget_name,
                            "alert_type": a.alert_type,
                            "message": a.message,
                        }
                        for a in summary.alerts
                    ],
                    "period_start": summary.period_start.isoformat() if summary.period_start else None,
                    "period_end": summary.period_end.isoformat() if summary.period_end else None,
                }

    except Exception as e:
        logger.error("query_budget_status_failed", error=str(e), exc_info=True)
        return {
            "success": False,
            "message": f"查询预算状态失败: {str(e)}",
        }


# ============================================================================
# Create Budget Tool
# ============================================================================


class CreateBudgetInput(BaseModel):
    """Input for create_budget tool."""

    scope: Literal["TOTAL", "CATEGORY"] = Field(
        default="TOTAL", description="TOTAL: Overall budget, CATEGORY: Specific category budget"
    )
    category_key: Optional[BUDGET_CATEGORY_KEYS] = Field(
        default=None,
        description="Category key (Required if scope is CATEGORY). Supported: FOOD_DINING, SHOPPING_RETAIL, TRANSPORTATION, etc.",
    )
    amount: float = Field(..., gt=0, description="Budget amount")
    period_anchor_day: int = Field(default=1, ge=1, le=31, description="Start day of the period (1-31)")
    rollover_enabled: bool = Field(
        default=True, description="Whether to carry over remaining balance to the next period"
    )

    @field_validator("category_key")
    @classmethod
    def validate_category(cls, v: Optional[str]) -> Optional[str]:
        """验证分类键是否有效"""
        if v is not None and v not in VALID_BUDGET_CATEGORIES:
            valid_list = ", ".join(sorted(VALID_BUDGET_CATEGORIES))
            raise ValueError(f"无效的分类键: {v}。有效的分类: {valid_list}")
        return v


@tool("create_budget", args_schema=CreateBudgetInput)
async def create_budget(
    amount: float,
    scope: str = "TOTAL",
    category_key: Optional[str] = None,
    period_anchor_day: int = 1,
    rollover_enabled: bool = True,
    *,
    config: RunnableConfig,
) -> Dict[str, Any]:
    """Create a new budget (Total or Category). Category budgets must provide a category_key."""
    user_uuid = get_user_uuid(config)

    if not user_uuid:
        return {
            "success": False,
            "message": "用户上下文缺失",
        }

    # Validate category_key for category budgets
    if scope.upper() == "CATEGORY" and not category_key:
        return {
            "success": False,
            "message": "创建分类预算需要指定 category_key",
        }

    if scope.upper() == "TOTAL" and category_key:
        return {
            "success": False,
            "message": "总预算不需要 category_key，请设置 scope='CATEGORY' 或移除 category_key",
        }

    try:
        async with db_manager.session_factory() as session:
            service = BudgetService(session)

            request = BudgetCreateRequest(
                scope=BudgetScope(scope.upper()),
                category_key=category_key.upper() if category_key else None,
                amount=Decimal(str(amount)),
                period_type=BudgetPeriodType.MONTHLY,
                period_anchor_day=period_anchor_day,
                rollover_enabled=rollover_enabled,
            )

            budget = await service.create_budget(
                UUID(user_uuid),
                request,
                source=BudgetSource.USER_DEFINED,
            )

            period = await service.get_or_create_current_period(budget)

            return {
                "success": True,
                "componentType": "BudgetReceipt",
                "budget_id": str(budget.id),
                "name": budget.name,
                "scope": budget.scope,
                "category_key": budget.category_key,
                "amount": float(budget.amount),
                "period_start": period.period_start.isoformat(),
                "period_end": period.period_end.isoformat(),
                "rollover_enabled": budget.rollover_enabled,
                "status": "created",
            }

    except Exception as e:
        logger.error("create_budget_failed", error=str(e), exc_info=True)

        error_str = str(e).lower()
        if (
            "409" in error_str
            or "duplicate" in error_str
            or "已存在" in error_str
            or "unique" in error_str
            or "integrityerror" in error_str
            or "violates unique constraint" in error_str
        ):
            scope_label = "该分类" if category_key else "总"
            return {
                "success": False,
                "message": f"{scope_label}预算已存在。如需调整金额，请说'帮我修改{category_key or '总'}预算'。",
            }

        return {
            "success": False,
            "message": f"创建预算失败: {str(e)}",
        }


# ============================================================================
# Export Tools
# ============================================================================

budget_tools = [
    query_budget_status,
    create_budget,
]
