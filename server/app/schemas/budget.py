"""Budget schemas for API request/response handling."""

from datetime import date, time
from decimal import Decimal
from typing import List, Optional
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field, field_validator

# ============================================================================
# Enums (imported from models for consistency)
# ============================================================================
from app.models.budget import (
    BudgetPeriodStatus,
    BudgetPeriodType,
    BudgetScope,
    BudgetSource,
    BudgetStatus,
    BudgetType,
    OverspendBehavior,
)

# ============================================================================
# Request Schemas
# ============================================================================


class BudgetCreateRequest(BaseModel):
    """Request schema for creating a new budget."""

    model_config = ConfigDict(use_enum_values=True)

    name: Optional[str] = Field(
        default=None, max_length=100, description="Budget name. If not provided, will be auto-generated."
    )
    scope: BudgetScope = Field(
        ..., description="Budget scope: TOTAL for overall budget, CATEGORY for category-specific."
    )
    category_key: Optional[str] = Field(
        default=None, max_length=25, description="Category key for category budgets. Required if scope is CATEGORY."
    )
    amount: Decimal = Field(..., gt=0, description="Budget limit amount. Must be greater than 0.")
    period_type: BudgetPeriodType = Field(default=BudgetPeriodType.MONTHLY, description="Budget period type.")
    period_anchor_day: int = Field(
        default=1, ge=1, le=31, description="Day of month to start new period (1-31). Supports salary day mode."
    )
    rollover_enabled: bool = Field(default=True, description="Whether unused budget rolls over to next period.")
    currency_code: str = Field(default="CNY", max_length=3, description="Currency code.")

    @field_validator("category_key")
    @classmethod
    def validate_category_key(cls, v, info):
        """Validate category_key based on scope."""
        scope = info.data.get("scope")
        if scope == BudgetScope.CATEGORY and not v:
            raise ValueError("category_key is required for CATEGORY scope")
        if scope == BudgetScope.TOTAL and v:
            raise ValueError("category_key must be empty for TOTAL scope")
        return v


class BudgetUpdateRequest(BaseModel):
    """Request schema for updating a budget."""

    model_config = ConfigDict(use_enum_values=True)

    name: Optional[str] = Field(default=None, max_length=100)
    amount: Optional[Decimal] = Field(default=None, gt=0)
    rollover_enabled: Optional[bool] = None
    status: Optional[BudgetStatus] = None
    period_anchor_day: Optional[int] = Field(default=None, ge=1, le=31)


class BudgetRebalanceRequest(BaseModel):
    """Request schema for rebalancing between budgets."""

    from_budget_id: UUID = Field(..., description="Source budget ID to transfer from.")
    to_budget_id: UUID = Field(..., description="Target budget ID to transfer to.")
    amount: Decimal = Field(..., gt=0, description="Amount to transfer.")

    @field_validator("to_budget_id")
    @classmethod
    def validate_different_budgets(cls, v, info):
        """Ensure source and target are different."""
        from_id = info.data.get("from_budget_id")
        if from_id and v == from_id:
            raise ValueError("Cannot rebalance to the same budget")
        return v


class BudgetSettingsUpdateRequest(BaseModel):
    """Request schema for updating budget settings."""

    model_config = ConfigDict(use_enum_values=True)

    warning_threshold: Optional[int] = Field(default=None, ge=0, le=100)
    alert_threshold: Optional[int] = Field(default=None, ge=0, le=100)
    overspend_behavior: Optional[OverspendBehavior] = None
    weekly_summary_enabled: Optional[bool] = None
    weekly_summary_day: Optional[str] = None
    monthly_summary_enabled: Optional[bool] = None
    anomaly_detection_enabled: Optional[bool] = None
    anomaly_threshold: Optional[Decimal] = Field(default=None, ge=0)
    quiet_hours_start: Optional[time] = None
    quiet_hours_end: Optional[time] = None

    @field_validator("weekly_summary_day")
    @classmethod
    def validate_weekly_day(cls, v):
        """Validate weekly summary day."""
        if v is not None:
            valid_days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
            if v.lower() not in valid_days:
                raise ValueError(f"Must be one of: {', '.join(valid_days)}")
            return v.lower()
        return v


# ============================================================================
# Response Schemas
# ============================================================================


class BudgetPeriodResponse(BaseModel):
    """Response schema for a budget period."""

    model_config = ConfigDict(from_attributes=True)

    id: UUID
    period_start: date
    period_end: date
    spent_amount: float
    rollover_in: float
    rollover_out: float
    adjusted_target: float
    remaining_amount: float
    usage_percentage: float
    status: str
    ai_forecast: Optional[float] = None
    notes: Optional[str] = None


class BudgetResponse(BaseModel):
    """Response schema for a budget with current period status."""

    model_config = ConfigDict(from_attributes=True)

    id: UUID
    name: str
    scope: str
    category_key: Optional[str] = None
    amount: float
    currency_code: str
    period_type: str
    period_anchor_day: int
    rollover_enabled: bool
    rollover_balance: float
    source: str
    ai_confidence: Optional[float] = None
    status: str

    # Calculated fields for current period
    spent_amount: float = 0.0
    remaining_amount: float = 0.0
    usage_percentage: float = 0.0
    period_status: str = "ON_TRACK"
    period_start: Optional[date] = None
    period_end: Optional[date] = None
    ai_forecast: Optional[float] = None

    # Timestamps
    created_at: Optional[str] = None
    updated_at: Optional[str] = None


class BudgetAlert(BaseModel):
    """Budget alert information."""

    budget_id: UUID
    budget_name: str
    category_key: Optional[str] = None
    alert_type: str  # "warning" | "exceeded" | "forecast_exceed"
    message: str
    usage_percentage: float
    remaining_amount: float


class BudgetSummaryResponse(BaseModel):
    """Response schema for budget overview."""

    total_budget: Optional[BudgetResponse] = None
    category_budgets: List[BudgetResponse] = []
    overall_spent: float = 0.0
    overall_remaining: float = 0.0
    overall_percentage: float = 0.0
    alerts: List[BudgetAlert] = []
    period_start: Optional[date] = None
    period_end: Optional[date] = None


class BudgetSuggestion(BaseModel):
    """AI-generated budget suggestion."""

    scope: str  # TOTAL or CATEGORY
    category_key: Optional[str] = None
    suggested_amount: float
    confidence: float
    reasoning: str
    based_on_months: int = 3


class BudgetSettingsResponse(BaseModel):
    """Response schema for budget settings."""

    model_config = ConfigDict(from_attributes=True)

    user_uuid: UUID
    warning_threshold: int
    alert_threshold: int
    overspend_behavior: str
    weekly_summary_enabled: bool
    weekly_summary_day: str
    monthly_summary_enabled: bool
    anomaly_detection_enabled: bool
    anomaly_threshold: float
    quiet_hours_start: Optional[time] = None
    quiet_hours_end: Optional[time] = None
