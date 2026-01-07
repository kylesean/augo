"""Forecast related models for financial prediction features.

This module contains models for:
- AccountDailySnapshot: Daily balance snapshots for high-performance time series analysis
- AIFeedbackMemory: User feedback on AI predictions for RAG context learning
"""

from __future__ import annotations

from datetime import date
from decimal import Decimal
from typing import Any
from uuid import UUID, uuid4

import sqlalchemy as sa
from sqlalchemy import Numeric
from sqlalchemy.dialects.postgresql import (
    JSONB,
    UUID as PGUUID,
)
from sqlmodel import Column, Field

from app.models.base import BaseModel


class AccountDailySnapshot(BaseModel, table=True):
    """Daily account balance snapshot for time series analysis.

    Purpose:
        High-performance storage for historical balance curves.
        Avoids real-time aggregation when drawing charts or training ML models.

    Design Notes:
        - Uses composite primary key (account_id, snapshot_date)
        - Denormalized fields (currency, user_uuid) for query optimization
        - Compatible with time-series analysis tools (ARIMA, Prophet)

    Attributes:
        snapshot_date: The date of this snapshot
        account_id: Foreign key to financial_accounts.id
        user_uuid: Redundant user UUID for fast user-level queries
        balance: Account balance at end of day
        currency: Currency code (redundant from account)
        total_incoming: Sum of all incoming transactions on this day
        total_outgoing: Sum of all outgoing transactions on this day
        exchange_rate_snapshot: Optional exchange rate for multi-currency
        created_at: When this snapshot was created
    """

    __tablename__ = "account_daily_snapshots"

    # Composite primary key fields
    snapshot_date: date = Field(sa_column=Column(sa.Date, primary_key=True), description="快照日期")
    account_id: UUID = Field(
        sa_column=Column(
            PGUUID(as_uuid=True),
            sa.ForeignKey("financial_accounts.id", ondelete="CASCADE"),
            primary_key=True,
            nullable=False,
        ),
        description="关联的账户ID",
    )

    # Denormalized fields for query performance
    user_uuid: UUID = Field(
        sa_column=Column(
            PGUUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), nullable=False, index=True
        ),
        description="冗余的用户UUID，用于加速用户级查询",
    )

    # Core balance data
    balance: Decimal = Field(sa_column=Column(Numeric(20, 8), nullable=False), description="当日结束时的账户余额")

    currency: str = Field(max_length=3, description="货币代码")

    # Daily flow statistics
    total_incoming: Decimal = Field(
        default=Decimal("0"),
        sa_column=Column(Numeric(20, 8), nullable=False, server_default="0"),
        description="当日总流入",
    )

    total_outgoing: Decimal = Field(
        default=Decimal("0"),
        sa_column=Column(Numeric(20, 8), nullable=False, server_default="0"),
        description="当日总流出",
    )

    # Optional exchange rate for multi-currency support
    exchange_rate_snapshot: Decimal | None = Field(
        default=None, sa_column=Column(Numeric(20, 8), nullable=True), description="当日汇率快照"
    )

    @property
    def net_flow(self) -> Decimal:
        """Calculate net cash flow for the day."""
        return self.total_incoming - self.total_outgoing

    @property
    def balance_float(self) -> float:
        """Get balance as float."""
        return float(self.balance)


class AIFeedbackMemory(BaseModel, table=True):
    """User feedback on AI predictions for RAG context learning.

    Purpose:
        Store user feedback on AI-generated insights to build personalized
        RAG context. NOT for traditional RLHF model fine-tuning.

    Use Cases:
        1. User dismisses a spending warning → Store preference rule
        2. User corrects a forecast → Store correction data
        3. User likes a suggestion → Reinforce similar patterns

    How It Works:
        When calling LLM, fetch relevant feedback records and inject them
        as context: "User previously marked X as not important..."

    Attributes:
        id: Primary key (UUID)
        user_uuid: User who provided feedback
        insight_type: Type of AI insight (SPENDING_FORECAST, ANOMALY_DETECTION, etc.)
        target_table: Optional related table name (transactions, budgets)
        target_id: Optional related record ID
        ai_content_snapshot: Snapshot of AI's original prediction
        user_action: User's feedback action (THUMBS_UP, DISMISSED, CORRECTED, STOP_REMINDING)
        user_correction_data: User's corrected values if applicable
        preference_rule: Structured preference rule for future prompts
        is_processed: Flag for batch processing optimization
        created_at: When feedback was recorded
    """

    __tablename__ = "ai_feedback_memory"

    id: UUID | None = Field(
        default_factory=uuid4, sa_column=Column(PGUUID(as_uuid=True), primary_key=True), description="主键"
    )

    user_uuid: UUID = Field(
        sa_column=Column(
            PGUUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), nullable=False, index=True
        ),
        description="用户UUID",
    )

    # Insight classification
    insight_type: str = Field(
        max_length=50, description="洞察类型：SPENDING_FORECAST, ANOMALY_DETECTION, BUDGET_ADVICE, TAGGING_SUGGESTION"
    )

    # Optional relation to specific records
    target_table: str | None = Field(default=None, max_length=50, description="关联的表名")

    target_id: UUID | None = Field(
        default=None, sa_column=Column(PGUUID(as_uuid=True), nullable=True), description="关联记录的ID"
    )

    # AI content snapshot
    ai_content_snapshot: dict[str, Any] = Field(
        default_factory=dict, sa_column=Column(JSONB, nullable=False), description="AI预测的原始内容快照"
    )

    # User feedback
    user_action: str = Field(max_length=20, description="用户反馈：THUMBS_UP, DISMISSED, CORRECTED, STOP_REMINDING")

    user_correction_data: dict[str, Any] | None = Field(
        default=None, sa_column=Column(JSONB, nullable=True), description="用户修正的数据"
    )

    preference_rule: dict[str, Any] | None = Field(
        default=None, sa_column=Column(JSONB, nullable=True), description="用户偏好规则，用于构建Prompt上下文"
    )

    is_processed: bool = Field(default=False, description="是否已处理")

    @classmethod
    def create_dismissal(
        cls,
        user_uuid: UUID,
        insight_type: str,
        ai_content: dict[str, Any],
        preference_rule: dict[str, Any] | None = None,
    ) -> AIFeedbackMemory:
        """Factory method for creating a dismissal feedback."""
        return cls(
            user_uuid=user_uuid,
            insight_type=insight_type,
            ai_content_snapshot=ai_content,
            user_action="DISMISSED",
            preference_rule=preference_rule,
        )

    @classmethod
    def create_correction(
        cls,
        user_uuid: UUID,
        insight_type: str,
        ai_content: dict[str, Any],
        correction_data: dict[str, Any],
        target_table: str | None = None,
        target_id: UUID | None = None,
    ) -> AIFeedbackMemory:
        """Factory method for creating a correction feedback."""
        return cls(
            user_uuid=user_uuid,
            insight_type=insight_type,
            ai_content_snapshot=ai_content,
            user_action="CORRECTED",
            user_correction_data=correction_data,
            target_table=target_table,
            target_id=target_id,
        )


# Export all models
__all__ = [
    "AccountDailySnapshot",
    "AIFeedbackMemory",
]
