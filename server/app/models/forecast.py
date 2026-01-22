"""Forecast related models for financial prediction features.

This module contains models for:
- AccountDailySnapshot: Daily balance snapshots for high-performance time series analysis
- AIFeedbackMemory: User feedback on AI predictions for RAG context learning

This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import date, datetime
from decimal import Decimal
from typing import Any, Optional
from uuid import UUID, uuid4 as uuid4_factory

import sqlalchemy as sa
from sqlalchemy import Boolean, String
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base, col


class AccountDailySnapshot(Base):
    """Daily account balance snapshot for time series analysis."""

    __tablename__ = "account_daily_snapshots"

    snapshot_date: Mapped[date] = col.date_column()
    account_id: Mapped[UUID] = mapped_column(
        PGUUID(as_uuid=True),
        sa.ForeignKey("financial_accounts.id", ondelete="CASCADE"),
        primary_key=True,
    )

    user_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", index=True)

    balance: Mapped[Decimal] = col.numeric(precision=20, scale=8)
    currency: Mapped[str] = mapped_column(String(3))

    total_incoming: Mapped[Decimal] = col.numeric(precision=20, scale=8, default=Decimal("0"))
    total_outgoing: Mapped[Decimal] = col.numeric(precision=20, scale=8, default=Decimal("0"))
    exchange_rate_snapshot: Mapped[Decimal | None] = col.numeric(precision=20, scale=8, nullable=True)

    @property
    def net_flow(self) -> Decimal:
        """Calculate net cash flow for the day."""
        return self.total_incoming - self.total_outgoing

    @property
    def balance_float(self) -> float:
        """Get balance as float."""
        return float(self.balance)


class AIFeedbackMemory(Base):
    """User feedback on AI predictions for RAG context learning."""

    __tablename__ = "ai_feedback_memory"

    id: Mapped[UUID | None] = mapped_column(primary_key=True, default=None)
    user_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", index=True, column="uuid")

    insight_type: Mapped[str] = mapped_column(String(50))

    target_table: Mapped[str | None] = mapped_column(String(50), nullable=True)
    target_id: Mapped[UUID | None] = col.uuid_column(nullable=True)

    ai_content_snapshot: Mapped[dict[str, Any]] = col.jsonb_column()

    user_action: Mapped[str] = mapped_column(String(20))

    user_correction_data: Mapped[dict[str, Any] | None] = col.jsonb_column(nullable=True)
    preference_rule: Mapped[dict[str, Any] | None] = col.jsonb_column(nullable=True)

    is_processed: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = col.timestamptz()

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


__all__ = [
    "AccountDailySnapshot",
    "AIFeedbackMemory",
]
