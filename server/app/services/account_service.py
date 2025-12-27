"""Account service for managing financial accounts."""

from typing import Any, Dict, List, Optional
from uuid import UUID

import structlog
from sqlalchemy import and_, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.financial_account import FinancialAccount

logger = structlog.get_logger(__name__)


class AccountService:
    """账户服务：处理财务账户相关的业务逻辑"""

    def __init__(self, db: AsyncSession):
        self.db = db

    async def list_user_accounts(
        self, user_uuid: UUID, account_type: Optional[str] = None, include_inactive: bool = False
    ) -> List[FinancialAccount]:
        """获取用户的财务账户列表"""
        query = select(FinancialAccount).where(FinancialAccount.user_uuid == user_uuid)

        if not include_inactive:
            query = query.where(FinancialAccount.status == "ACTIVE")

        if account_type:
            query = query.where(FinancialAccount.type == account_type.upper())

        # Nature (ASSET < LIABILITY), then name
        query = query.order_by(FinancialAccount.nature.asc(), FinancialAccount.name.asc())

        result = await self.db.execute(query)
        return list(result.scalars().all())

    async def get_account_by_id(self, account_id: UUID, user_uuid: UUID) -> Optional[FinancialAccount]:
        """获取特定账户并验证所有权"""
        query = select(FinancialAccount).where(
            and_(FinancialAccount.id == account_id, FinancialAccount.user_uuid == user_uuid)
        )
        result = await self.db.execute(query)
        return result.scalar_one_or_none()
