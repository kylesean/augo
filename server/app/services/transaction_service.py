"""Transaction service facade for managing financial transactions.

This module provides a unified interface to transaction-related operations
while delegating to specialized services internally.
"""

from datetime import date, datetime
from uuid import UUID

from sqlalchemy.ext.asyncio import AsyncSession

from app.models.financial_account import FinancialAccount
from app.services.transaction.cash_flow_service import CashFlowService
from app.services.transaction.crud_service import TransactionCRUDService
from app.services.transaction.query_service import TransactionQueryService
from app.services.transaction.recurring_service import RecurringTransactionService


class TransactionService:
    """Transaction service facade for managing financial transactions.

    This is a Facade that delegates to specialized services:
    - TransactionCRUDService: Basic CRUD operations
    - TransactionQueryService: Search and feed operations
    - RecurringTransactionService: Recurring transaction management
    - CashFlowService: Cash flow forecasting
    """

    def __init__(self, db: AsyncSession):
        self.db = db
        self._crud = TransactionCRUDService(db)
        self._query = TransactionQueryService(db)
        self._recurring = RecurringTransactionService(db)
        self._cash_flow = CashFlowService(db, self._recurring)

    # ===== CRUD Operations (delegated to TransactionCRUDService) =====

    async def get_financial_account(self, account_id: UUID, user_uuid: UUID) -> FinancialAccount | None:
        """Get and validate financial account."""
        return await self._crud.get_financial_account(account_id, user_uuid)

    async def create_transaction(
        self,
        user_uuid: UUID,
        amount: float,
        transaction_type: str = "expense",
        transaction_at: datetime | None = None,
        category_key: str = "OTHERS",
        currency: str = "CNY",
        raw_input: str | None = None,
        source_account_id: UUID | None = None,
        target_account_id: UUID | None = None,
        subject: str = "SELF",
        intent: str = "SURVIVAL",
        tags: list[str] | None = None,
    ) -> dict:
        """Create a single transaction record."""
        return await self._crud.create_transaction(
            user_uuid=user_uuid,
            amount=amount,
            transaction_type=transaction_type,
            transaction_at=transaction_at,
            category_key=category_key,
            currency=currency,
            raw_input=raw_input,
            source_account_id=source_account_id,
            target_account_id=target_account_id,
            subject=subject,
            intent=intent,
            tags=tags,
        )

    async def get_transaction_detail(self, transaction_id: UUID, user_uuid: UUID) -> dict | None:
        """Get transaction detail (including comments)."""
        return await self._crud.get_transaction_detail(transaction_id, user_uuid)

    async def delete_transaction(self, transaction_id: UUID, user_uuid: UUID) -> bool:
        """Delete transaction record."""
        return await self._crud.delete_transaction(transaction_id, user_uuid)

    async def create_batch_transactions(
        self,
        user_uuid: UUID,
        data: dict,
        source_thread_id: UUID | None = None,
    ) -> dict:
        """Create multiple transactions."""
        return await self._crud.create_batch_transactions(user_uuid, data, source_thread_id)

    async def update_batch_transactions_account(
        self,
        user_uuid: UUID,
        transaction_ids: list[UUID],
        account_id: UUID | None,
    ) -> dict:
        """Update multiple transactions' account."""
        return await self._crud.update_batch_transactions_account(user_uuid, transaction_ids, account_id)

    async def update_transaction_account(
        self,
        transaction_id: UUID,
        user_uuid: UUID,
        account_id: UUID | None,
    ) -> dict | None:
        """Update transaction's account."""
        return await self._crud.update_transaction_account(transaction_id, user_uuid, account_id)

    # ===== Query Operations (delegated to TransactionQueryService) =====

    async def get_transaction_feed(
        self,
        user_uuid: UUID,
        date_filter: str | None = None,
        type_filter: str = "all",
        page: int = 1,
        limit: int = 10,
    ) -> dict:
        """Get transaction feed (with automatic currency conversion)."""
        return await self._query.get_transaction_feed(user_uuid, date_filter, type_filter, page, limit)

    async def search_transactions(self, user_uuid: UUID, filters: dict) -> dict:
        """Search transaction records."""
        return await self._query.search_transactions(user_uuid, filters)

    # ===== Recurring Transaction Operations (delegated to RecurringTransactionService) =====

    async def create_recurring_transaction(self, user_uuid: UUID, data: dict) -> dict:
        """Create a recurring transaction rule."""
        return await self._recurring.create_recurring_transaction(user_uuid, data)

    async def list_recurring_transactions(
        self, user_uuid: UUID, type_filter: str | None = None, is_active: bool | None = None
    ) -> list[dict]:
        """List recurring transactions."""
        return await self._recurring.list_recurring_transactions(user_uuid, type_filter, is_active)

    async def get_recurring_transaction(self, recurring_id: UUID, user_uuid: UUID) -> dict | None:
        """Get recurring transaction details."""
        return await self._recurring.get_recurring_transaction(recurring_id, user_uuid)

    async def update_recurring_transaction(self, recurring_id: UUID, user_uuid: UUID, data: dict) -> dict | None:
        """Update recurring transaction."""
        return await self._recurring.update_recurring_transaction(recurring_id, user_uuid, data)

    async def delete_recurring_transaction(self, recurring_id: UUID, user_uuid: UUID) -> bool:
        """Delete recurring transaction."""
        return await self._recurring.delete_recurring_transaction(recurring_id, user_uuid)

    def parse_rrule_occurrences(
        self,
        rrule_string: str,
        start_date: date,
        end_date: date | None,
        forecast_start: date,
        forecast_end: date,
    ) -> list[date]:
        """Parse RRULE and generate dates within the specified range."""
        return self._recurring.parse_rrule_occurrences(
            rrule_string, start_date, end_date, forecast_start, forecast_end
        )

    def _calculate_next_execution(
        self,
        rrule_str: str,
        start_date: date,
        end_date: date | None = None,
        exception_dates: list | None = None,
    ) -> datetime | None:
        """Calculate the next execution date for a recurring transaction."""
        return self._recurring._calculate_next_execution(rrule_str, start_date, end_date, exception_dates)

    # ===== Cash Flow Operations (delegated to CashFlowService) =====

    async def forecast_cash_flow(
        self,
        user_uuid: UUID,
        forecast_days: int = 60,
        granularity: str = "daily",
        scenarios: list[dict] | None = None,
    ) -> dict:
        """Forecast future cash flow."""
        return await self._cash_flow.forecast_cash_flow(user_uuid, forecast_days, granularity, scenarios)

    # ===== Comment Operations (delegated to TransactionCRUDService) =====

    async def get_comments_for_transaction(self, transaction_id: UUID, user_uuid: UUID) -> list[dict]:
        """Get comments for a transaction."""
        return await self._crud.get_comments_for_transaction(transaction_id, user_uuid)

    async def add_comment(
        self,
        transaction_id: UUID,
        user_uuid: UUID,
        comment_text: str,
        parent_comment_id: int | None = None,
    ) -> dict:
        """Add a comment to a transaction."""
        return await self._crud.add_comment(transaction_id, user_uuid, comment_text, parent_comment_id)

    async def delete_comment(self, comment_id: int, user_uuid: UUID) -> bool:
        """Delete a comment."""
        return await self._crud.delete_comment(comment_id, user_uuid)
