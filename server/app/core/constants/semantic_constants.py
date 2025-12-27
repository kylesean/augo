"""Semantic constants for AI-driven transaction classification.

This module defines Subject (Who) and Intent (Why) dimensions for
multi-dimensional transaction analysis beyond the existing Category (What).

These fields are automatically inferred by AI from natural language input,
enabling OLAP-style queries like:
- "How much did I spend on kids this year?" → GROUP BY subject WHERE subject='KIDS'
- "What's my ratio of enjoyment vs survival spending?" → GROUP BY intent
"""

from enum import Enum


class TransactionSubject(str, Enum):
    """Transaction Subject (Who)

    Identifies the primary beneficiary of the transaction.
    """

    SELF = "SELF"  # Self (default)
    SPOUSE = "SPOUSE"  # Spouse/Partner
    KIDS = "KIDS"  # Children
    PARENTS = "PARENTS"  # Parents
    PETS = "PETS"  # Pets
    FAMILY = "FAMILY"  # Shared household (rent, utilities)
    SOCIAL = "SOCIAL"  # Social/Friends (gifts, lending)


class TransactionIntent(str, Enum):
    """Transaction Intent (Why)

    Identifies the underlying motivation for the transaction (used for financial health analysis).
    """

    SURVIVAL = "SURVIVAL"  # Essentials - Survival/Must-haves
    ENJOYMENT = "ENJOYMENT"  # Lifestyle - Enjoyment/Wants
    DEVELOPMENT = "DEVELOPMENT"  # Investment - Personal development/Future returns
    OBLIGATION = "OBLIGATION"  # Commitment - Obligations/Taxes/Insurance
