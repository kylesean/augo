"""Transaction Receipt Enricher.

Hydrates TransactionReceipt components with live data from the database.
"""

import uuid
from decimal import Decimal
from typing import Any, Dict

from sqlalchemy import select
from sqlalchemy.orm import selectinload

from app.core.database import db_manager
from app.core.genui.enricher import ComponentEnricher, EnricherRegistry
from app.core.logging import logger
from app.models.financial_account import FinancialAccount
from app.models.transaction import Transaction


class TransactionReceiptEnricher(ComponentEnricher):
    """Enricher for TransactionReceipt component."""

    @property
    def component_name(self) -> str:
        """Name of the GenUI component for frontend rendering."""
        return "TransactionReceipt"

    async def enrich(self, tool_call_id: str, data: Dict[str, Any], context: Dict[str, Any]) -> Dict[str, Any]:
        """Enrich transaction receipt with latest status and account info.

        Args:
            tool_call_id: Tool call ID
            data: Original data from tool result (contains transaction_id)
            context: Context with user_uuid

        Returns:
            Enriched data with latest transaction state and linked account info.
        """
        transaction_id = data.get("transaction_id")
        user_uuid = context.get("user_uuid")

        if not transaction_id or not user_uuid:
            return data

        try:
            async with db_manager.session_factory() as session:
                # Query transaction with account relations
                # Note: Transaction model has relationships source_account and target_account
                stmt = (
                    select(Transaction)
                    .where(Transaction.id == uuid.UUID(transaction_id), Transaction.user_uuid == uuid.UUID(user_uuid))
                    .options(selectinload(Transaction.source_account), selectinload(Transaction.target_account))
                )

                result = await session.execute(stmt)
                transaction = result.scalar_one_or_none()

                if not transaction:
                    logger.warning("enrichment_transaction_not_found", transaction_id=transaction_id)
                    return data

                logger.debug("enriching_transaction", transaction_id=transaction_id, type=transaction.type)

                # Prepare enriched data structure
                # We start with a copy of original data to preserve fields we don't update
                enriched = data.copy()

                # Update basic fields that might have changed
                enriched["amount"] = float(transaction.amount)
                enriched["currency"] = transaction.currency
                enriched["type"] = transaction.type.upper() if transaction.type else "EXPENSE"
                if transaction.category_key:
                    enriched["category_key"] = transaction.category_key.upper()

                # Update status (e.g. if it was pending and now cleared)
                enriched["status"] = transaction.status.lower() if transaction.status else "success"

                # Enrich Account Information
                # Logic: Check which account is linked based on transaction type
                # For EXPENSE: source_account is the paying account
                # For INCOME: target_account is the receiving account
                # For TRANSFER: both are relevant, but TransactionReceipt usually shows "linked_account"
                # which is the one selected by user context.

                linked_acc = None
                if transaction.type == "EXPENSE":
                    linked_acc = transaction.source_account
                elif transaction.type == "INCOME":
                    linked_acc = transaction.target_account
                elif transaction.type == "TRANSFER":
                    # For transfer, we might show source or target depending on context,
                    # but typically TransactionReceipt for creation shows the 'primary' one.
                    # We'll default to source for now as that's usually the 'from' account.
                    linked_acc = transaction.source_account

                # Update "linked_account" field
                # This matches what create_transaction tool returns
                if linked_acc:
                    enriched["linked_account"] = {
                        "id": str(linked_acc.id),
                        "name": linked_acc.name,
                        "type": linked_acc.type,
                    }
                    enriched["account_linked"] = True
                else:
                    # Explicitly set to None if no account is linked anymore
                    enriched["linked_account"] = None
                    enriched["account_linked"] = False

                # Update specific account IDs if present
                if transaction.source_account_id:
                    enriched["source_account_id"] = str(transaction.source_account_id)
                if transaction.target_account_id:
                    enriched["target_account_id"] = str(transaction.target_account_id)

                return enriched

        except Exception as e:
            logger.error("enrichment_failed", error=str(e), exc_info=True)
            # On any error (DB, parsing), fallback to original data
            return data


# Register the enricher (automatically done when module is imported if we do this)
# But we'll manually register in simple_agent.py to keep control valid.
transaction_enricher = TransactionReceiptEnricher()
