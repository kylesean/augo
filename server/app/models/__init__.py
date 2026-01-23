"""Models package.

This package has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from app.models.attachment import Attachment
from app.models.budget import Budget, BudgetPeriod, BudgetSettings
from app.models.financial_account import FinancialAccount
from app.models.financial_settings import BurnRateMode, FinancialSettings
from app.models.forecast import AccountDailySnapshot, AIFeedbackMemory
from app.models.notification import Notification
from app.models.searchable_message import SearchableMessage
from app.models.session import Session
from app.models.shared_space import SharedSpace, SpaceMember, SpaceTransaction
from app.models.storage_config import ProviderType, StorageConfig
from app.models.transaction import (
    RecurringTransaction,
    Transaction,
    TransactionComment,
    TransactionShare,
)
from app.models.user import User
from app.models.user_settings import UserSettings
from app.models.genui_surface import GenUISurface

__all__ = [
    "User",
    "UserSettings",
    "GenUISurface",
    "Session",
    "Attachment",
    "StorageConfig",
    "ProviderType",
    "Notification",
    "SharedSpace",
    "SpaceMember",
    "SpaceTransaction",
    "Transaction",
    "TransactionComment",
    "RecurringTransaction",
    "TransactionShare",
    "SearchableMessage",
    "FinancialAccount",
    "FinancialSettings",
    "BurnRateMode",
    "Budget",
    "BudgetPeriod",
    "BudgetSettings",
    "AccountDailySnapshot",
    "AIFeedbackMemory",
]
