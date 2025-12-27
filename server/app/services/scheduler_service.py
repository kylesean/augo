"""Scheduler service for recurring transaction execution.

This module provides APScheduler-based background task scheduling
for automatically processing recurring transactions.
"""

from datetime import date, datetime, timedelta
from decimal import Decimal
from typing import Optional

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger
from sqlalchemy import and_, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings
from app.core.database import get_session_context
from app.core.logging import logger
from app.models.transaction import RecurringTransaction, Transaction
from app.services.transaction_service import TransactionService


class RecurringTransactionScheduler:
    """Scheduler for processing recurring transactions."""

    def __init__(self):
        """Initialize the scheduler."""
        self._scheduler: Optional[AsyncIOScheduler] = None

    def init(self):
        """Initialize and configure the scheduler."""
        if self._scheduler is not None:
            return

        self._scheduler = AsyncIOScheduler(
            job_defaults={
                "coalesce": True,  # Combine missed jobs
                "max_instances": 1,  # Only one instance per job
                "misfire_grace_time": 3600,  # Allow 1 hour delay
            }
        )

        # Schedule daily job at 00:05 AM
        self._scheduler.add_job(
            self.process_due_transactions,
            trigger=CronTrigger(hour=0, minute=5),
            id="process_recurring_transactions",
            name="Process Due Recurring Transactions",
            replace_existing=True,
        )

        # Schedule hourly check for next_execution_at updates
        self._scheduler.add_job(
            self.update_next_execution_dates,
            trigger=CronTrigger(hour="*", minute=30),
            id="update_next_execution_dates",
            name="Update Next Execution Dates",
            replace_existing=True,
        )

        # Schedule daily exchange rate update
        # Default: 00:00 UTC = 08:00 Beijing Time (CST/UTC+8)
        # Can be configured via EXCHANGE_RATE_CRON_HOUR and EXCHANGE_RATE_CRON_MINUTE
        if settings.EXCHANGE_RATE_API_URL:
            self._scheduler.add_job(
                self._update_exchange_rates,
                trigger=CronTrigger(
                    hour=settings.EXCHANGE_RATE_CRON_HOUR,
                    minute=settings.EXCHANGE_RATE_CRON_MINUTE,
                ),
                id="update_exchange_rates",
                name="Update Exchange Rates",
                replace_existing=True,
            )
            logger.info(
                "exchange_rate_scheduler_initialized",
                cron_hour=settings.EXCHANGE_RATE_CRON_HOUR,
                cron_minute=settings.EXCHANGE_RATE_CRON_MINUTE,
            )

        logger.info("recurring_transaction_scheduler_initialized")

    def start(self):
        """Start the scheduler."""
        if self._scheduler is None:
            self.init()

        if not self._scheduler.running:
            self._scheduler.start()
            logger.info("recurring_transaction_scheduler_started")

    def shutdown(self):
        """Shutdown the scheduler."""
        if self._scheduler is not None and self._scheduler.running:
            self._scheduler.shutdown(wait=False)
            logger.info("recurring_transaction_scheduler_stopped")

    async def _update_exchange_rates(self):
        """Update exchange rates from external API and cache to Redis.

        This job runs daily to fetch the latest exchange rates
        and store them in Redis for currency conversion.
        """
        from app.services.exchange_rate_service import update_exchange_rates

        await update_exchange_rates()

    async def process_due_transactions(self):
        """Process all recurring transactions due today.

        This job runs daily and creates actual transaction records
        for any recurring transactions scheduled for today.
        """
        logger.info("processing_due_recurring_transactions_started")

        async with get_session_context() as db:
            try:
                today = date.today()
                today_start = datetime.combine(today, datetime.min.time())
                today_end = datetime.combine(today, datetime.max.time())

                # Find all active recurring transactions due today
                query = select(RecurringTransaction).where(
                    and_(
                        RecurringTransaction.is_active.is_(True),
                        RecurringTransaction.next_execution_at >= today_start,
                        RecurringTransaction.next_execution_at <= today_end,
                    )
                )

                result = await db.execute(query)
                due_transactions = result.scalars().all()

                processed_count = 0
                error_count = 0

                for recurring_tx in due_transactions:
                    try:
                        await self._create_transaction_from_recurring(db, recurring_tx)
                        await self._update_next_execution(db, recurring_tx)
                        processed_count += 1
                    except Exception as e:
                        error_count += 1
                        logger.error(
                            "recurring_transaction_processing_failed",
                            recurring_id=str(recurring_tx.id),
                            error=str(e),
                        )

                await db.commit()

                logger.info(
                    "processing_due_recurring_transactions_completed",
                    processed=processed_count,
                    errors=error_count,
                    total=len(due_transactions),
                )

            except Exception as e:
                logger.error(
                    "processing_due_recurring_transactions_failed",
                    error=str(e),
                )
                await db.rollback()

    async def _create_transaction_from_recurring(
        self,
        db: AsyncSession,
        recurring_tx: RecurringTransaction,
    ):
        """Create an actual transaction from a recurring transaction rule.

        Args:
            db: Database session
            recurring_tx: The recurring transaction rule
        """
        from uuid import uuid4

        from app.models.base import utc_now
        from app.services.exchange_rate_service import exchange_rate_service
        from app.utils.currency_utils import BASE_CURRENCY

        # Skip if requires confirmation (user needs to manually confirm)
        if recurring_tx.requires_confirmation:
            logger.info(
                "recurring_transaction_skipped_requires_confirmation",
                recurring_id=str(recurring_tx.id),
            )
            return

        # Currency conversion logic
        amount_original = recurring_tx.amount
        currency = recurring_tx.currency.upper()

        if currency == BASE_CURRENCY:
            amount = amount_original
            exchange_rate = Decimal("1.0")
        else:
            # Try to get exchange rate
            rate = await exchange_rate_service.convert(
                amount=1.0,
                from_currency=currency,
                to_currency=BASE_CURRENCY,
            )
            if rate is not None:
                exchange_rate = Decimal(str(rate))
                amount = (amount_original * exchange_rate).quantize(Decimal("0.00000001"))
            else:
                # Fallback if rate not found
                exchange_rate = None
                amount = amount_original
                logger.warning(
                    "exchange_rate_not_found_for_recurring",
                    currency=currency,
                    recurring_id=str(recurring_tx.id),
                )

        transaction = Transaction(
            id=uuid4(),
            user_uuid=recurring_tx.user_uuid,
            type=recurring_tx.type,
            amount_original=amount_original,
            amount=amount,
            currency=currency,
            exchange_rate=exchange_rate,
            category_key=recurring_tx.category_key,
            description=recurring_tx.description,
            raw_input=f"[自动生成] {recurring_tx.description or '周期交易'}",
            transaction_at=utc_now(),
            transaction_timezone=recurring_tx.timezone,
            source_account_id=recurring_tx.source_account_id,
            target_account_id=recurring_tx.target_account_id,
            tags=recurring_tx.tags,
            source="RECURRING",
            status="CONFIRMED",
        )

        db.add(transaction)

        # Update last_generated_at
        recurring_tx.last_generated_at = utc_now()

        logger.info(
            "transaction_created_from_recurring",
            transaction_id=str(transaction.id),
            recurring_id=str(recurring_tx.id),
            amount=str(recurring_tx.amount),
        )

    async def _update_next_execution(
        self,
        db: AsyncSession,
        recurring_tx: RecurringTransaction,
    ):
        """Update the next execution date for a recurring transaction.

        Args:
            db: Database session
            recurring_tx: The recurring transaction to update
        """
        service = TransactionService(db)

        next_execution = service._calculate_next_execution(
            recurring_tx.recurrence_rule,
            recurring_tx.start_date,
            recurring_tx.end_date,
            recurring_tx.exception_dates,
        )

        recurring_tx.next_execution_at = next_execution

        # If no more executions, deactivate the rule
        if next_execution is None:
            recurring_tx.is_active = False
            logger.info(
                "recurring_transaction_completed",
                recurring_id=str(recurring_tx.id),
            )

    async def update_next_execution_dates(self):
        """Update next_execution_at for all active recurring transactions.

        This ensures the next_execution_at field stays accurate,
        especially for transactions that may have been skipped.
        """
        logger.info("updating_next_execution_dates_started")

        async with get_session_context() as db:
            try:
                # Find all active recurring transactions
                query = select(RecurringTransaction).where(RecurringTransaction.is_active.is_(True))

                result = await db.execute(query)
                active_transactions = result.scalars().all()

                service = TransactionService(db)
                updated_count = 0

                for recurring_tx in active_transactions:
                    new_next_execution = service._calculate_next_execution(
                        recurring_tx.recurrence_rule,
                        recurring_tx.start_date,
                        recurring_tx.end_date,
                        recurring_tx.exception_dates,
                    )

                    # Only update if changed
                    if recurring_tx.next_execution_at != new_next_execution:
                        recurring_tx.next_execution_at = new_next_execution
                        updated_count += 1

                        # Deactivate if no more executions
                        if new_next_execution is None:
                            recurring_tx.is_active = False

                await db.commit()

                logger.info(
                    "updating_next_execution_dates_completed",
                    updated=updated_count,
                    total=len(active_transactions),
                )

            except Exception as e:
                logger.error(
                    "updating_next_execution_dates_failed",
                    error=str(e),
                )
                await db.rollback()

    async def run_now(self):
        """Manually trigger processing of due transactions.

        Useful for testing or admin-triggered execution.
        """
        await self.process_due_transactions()


# Global scheduler instance
recurring_scheduler = RecurringTransactionScheduler()


async def init_scheduler():
    """Initialize and start the recurring transaction scheduler."""
    recurring_scheduler.init()
    recurring_scheduler.start()


async def shutdown_scheduler():
    """Shutdown the recurring transaction scheduler."""
    recurring_scheduler.shutdown()
