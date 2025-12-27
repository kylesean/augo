"""Database models entry point.

This file provides a centralized import for all SQLModel tables.
It mirrors app/models/__init__.py for backward compatibility.
"""

from app.models import (
    AccountDailySnapshot,
    AIFeedbackMemory,
    Attachment,
    Budget,
    BudgetPeriod,
    BudgetSettings,
    FinancialAccount,
    FinancialSettings,
    Notification,
    RecurringTransaction,
    SearchableMessage,
    Session,
    SharedSpace,
    SpaceMember,
    SpaceTransaction,
    StorageConfig,
    Transaction,
    TransactionComment,
    TransactionShare,
    User,
    UserSettings,
)

__all__ = [
    "User",
    "UserSettings",
    "Session",
    "Notification",
    "SharedSpace",
    "SpaceMember",
    "SpaceTransaction",
    "Transaction",
    "TransactionComment",
    "RecurringTransaction",
    "TransactionShare",
    "StorageConfig",
    "Attachment",
    "SearchableMessage",
    "FinancialAccount",
    "FinancialSettings",
    "Budget",
    "BudgetPeriod",
    "BudgetSettings",
    "AccountDailySnapshot",
    "AIFeedbackMemory",
]
