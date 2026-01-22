"""Recurring transaction scheduled job functions.

This module contains the actual job logic for processing
recurring transactions. These functions are called by the
scheduler service.
"""

from datetime import date, datetime
from decimal import Decimal
from typing import Any, cast as type_cast

from sqlalchemy import and_, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_session_context
from app.core.logging import logger
from app.models.transaction import RecurringTransaction, Transaction
from app.services.transaction_service import TransactionService


async def process_due_transactions() -> None:
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
                type_cast(
                    Any,
                    and_(
                        type_cast(Any, RecurringTransaction.is_active) == True,  # noqa: E712
                        type_cast(Any, RecurringTransaction.next_execution_at) != None,  # noqa: E711
                        type_cast(Any, RecurringTransaction.next_execution_at) >= today_start,
                        type_cast(Any, RecurringTransaction.next_execution_at) <= today_end,
                    ),
                )
            )

            result = await db.execute(query)
            due_transactions = result.scalars().all()

            processed_count = 0
            error_count = 0

            for recurring_tx in due_transactions:
                try:
                    await _create_transaction_from_recurring(db, recurring_tx)
                    await _update_next_execution(db, recurring_tx)
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


async def update_next_execution_dates() -> None:
    """Update next_execution_at for all active recurring transactions.

    This ensures the next_execution_at field stays accurate,
    especially for transactions that may have been skipped.
    """
    logger.info("updating_next_execution_dates_started")

    async with get_session_context() as db:
        try:
            query = select(RecurringTransaction).where(
                type_cast(Any, RecurringTransaction.is_active == True)  # noqa: E712
            )

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

                if recurring_tx.next_execution_at != new_next_execution:
                    recurring_tx.next_execution_at = new_next_execution
                    updated_count += 1

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


async def _create_transaction_from_recurring(
    db: AsyncSession,
    recurring_tx: RecurringTransaction,
) -> None:
    """Create an actual transaction from a recurring transaction rule."""
    from uuid import uuid4

    from app.models.base import utc_now
    from app.services.exchange_rate_service import exchange_rate_service
    from app.utils.currency_utils import BASE_CURRENCY

    # Skip if requires confirmation
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
        rate = await exchange_rate_service.convert(
            amount=1.0,
            from_currency=currency,
            to_currency=BASE_CURRENCY,
        )
        if rate is not None:
            exchange_rate = Decimal(str(rate))
            amount = (amount_original * exchange_rate).quantize(Decimal("0.00000001"))
        else:
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
    recurring_tx.last_generated_at = utc_now()

    logger.info(
        "transaction_created_from_recurring",
        transaction_id=str(transaction.id),
        recurring_id=str(recurring_tx.id),
        amount=str(recurring_tx.amount),
    )


async def _update_next_execution(
    db: AsyncSession,
    recurring_tx: RecurringTransaction,
) -> None:
    """Update the next execution date for a recurring transaction."""
    service = TransactionService(db)

    next_execution = service._calculate_next_execution(
        recurring_tx.recurrence_rule,
        recurring_tx.start_date,
        recurring_tx.end_date,
        recurring_tx.exception_dates,
    )

    recurring_tx.next_execution_at = next_execution

    if next_execution is None:
        recurring_tx.is_active = False
        logger.info(
            "recurring_transaction_completed",
            recurring_id=str(recurring_tx.id),
        )
