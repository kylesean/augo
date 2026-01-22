"""Account service for managing financial accounts."""

from __future__ import annotations

from typing import Any, cast
from uuid import UUID

import structlog
from sqlalchemy import and_, asc, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.financial_account import FinancialAccount

logger = structlog.get_logger(__name__)


class AccountService:
    """Account service for handling financial account business logic."""

    def __init__(self, db: AsyncSession):
        self.db = db

    async def list_user_accounts(
        self, user_uuid: UUID, account_type: str | None = None, include_inactive: bool = False
    ) -> list[FinancialAccount]:
        """Get user's financial account list."""
        query = select(FinancialAccount).where(cast(Any, FinancialAccount.user_uuid == user_uuid))

        if not include_inactive:
            query = query.where(cast(Any, FinancialAccount.status == "ACTIVE"))

        if account_type:
            query = query.where(cast(Any, FinancialAccount.type == account_type.upper()))

        # Nature (ASSET < LIABILITY), then name
        query = query.order_by(asc(FinancialAccount.nature), asc(FinancialAccount.name))

        result = await self.db.execute(query)
        return list(result.scalars().all())

    async def get_account_by_id(self, account_id: UUID, user_uuid: UUID) -> FinancialAccount | None:
        """Get a specific account and verify ownership."""
        query = select(FinancialAccount).where(
            cast(
                Any,
                and_(cast(Any, FinancialAccount.id == account_id), cast(Any, FinancialAccount.user_uuid == user_uuid)),
            )
        )
        result = await self.db.execute(query)
        return result.scalar_one_or_none()
