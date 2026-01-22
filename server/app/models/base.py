"""SQLAlchemy 2.0 Base model with Mapped types support.

This module provides a type-safe base class for all ORM models using
SQLAlchemy 2.0's Declarative system with Mapped[...] annotations.
"""

from __future__ import annotations

import logging as _logging
from collections.abc import Callable
from datetime import UTC, date, datetime, time
from decimal import Decimal
from typing import TYPE_CHECKING, Any, Optional
from uuid import UUID

import sqlalchemy as sa
from pydantic import ConfigDict
from sqlalchemy import Column, DateTime, MetaData, Numeric, String, Text, Time, text
from sqlalchemy.dialects.postgresql import (
    INET,
    JSONB,
    TIMESTAMP,
    UUID as PGUUID,
)
from sqlalchemy.orm import (
    DeclarativeBase,
    Mapped,
    mapped_column,
    relationship,
)

if TYPE_CHECKING:
    from sqlalchemy.orm import RelationshipProperty

_logger = _logging.getLogger(__name__)


class Base(DeclarativeBase):
    """SQLAlchemy 2.0 Declarative Base.

    Features:
    - Type-safe Mapped[...] annotations
    - Automatic table name generation
    - Pydantic integration support
    - Custom type handlers
    """

    # Use PostgreSQL naming convention for constraints
    metadata = MetaData(
        naming_convention={
            "ix": "ix_%(column_0_label)s",
            "uq": "uq_%(table_name)s_%(column_0_name)s",
            "ck": "ck_%(table_name)s_%(constraint_name)s",
            "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
            "pk": "pk_%(table_name)s",
        }
    )

    # Pydantic config for all models
    model_config = ConfigDict(
        populate_by_name=True,
        str_strip_whitespace=True,
        arbitrary_types_allowed=True,
    )


# Type-safe column helpers for PostgreSQL
class BaseColumn:
    """Helper class for creating type-safe columns."""

    @staticmethod
    def uuid_pk(default_factory: Callable[[], UUID] | None = None) -> Mapped[UUID]:
        """UUID primary key column."""
        return mapped_column(
            PGUUID(as_uuid=True),
            primary_key=True,
            default=default_factory,
        )

    @staticmethod
    def uuid_fk(
        foreign_table: str,
        ondelete: str = "CASCADE",
        nullable: bool = False,
        index: bool = True,
        column: str = "id",
    ) -> Mapped[UUID]:
        """UUID foreign key column."""
        return mapped_column(
            PGUUID(as_uuid=True),
            sa.ForeignKey(f"{foreign_table}.{column}", ondelete=ondelete),
            nullable=nullable,
            index=index,
        )

    @staticmethod
    def uuid_column(nullable: bool = False, index: bool = False) -> Mapped[UUID]:
        """UUID column without foreign key."""
        return mapped_column(
            PGUUID(as_uuid=True),
            nullable=nullable,
            index=index,
        )

    @staticmethod
    def numeric(
        precision: int = 20,
        scale: int = 8,
        nullable: bool = False,
        default: Decimal | None = None,
    ) -> Mapped[Decimal]:
        """Numeric column with precision."""
        return mapped_column(
            sa.Numeric(precision, scale),
            nullable=nullable,
            default=default,
            server_default=text("0") if default == 0 else None,
        )

    @staticmethod
    def timestamptz(
        nullable: bool = False,
        default: Callable[[], datetime] | None = None,
    ) -> Mapped[datetime]:
        """Timestamp with timezone."""
        return mapped_column(
            TIMESTAMP(timezone=True),
            nullable=nullable,
            default=default or utc_now,
            server_default=text("NOW()"),
        )

    @staticmethod
    def datetime_tz(nullable: bool = False) -> Mapped[datetime]:
        """DateTime with timezone."""
        return mapped_column(
            DateTime(timezone=True),
            nullable=nullable,
        )

    @staticmethod
    def date_column(nullable: bool = False) -> Mapped[date]:
        """Date column."""
        return mapped_column(sa.Date, nullable=nullable)

    @staticmethod
    def time_column(nullable: bool = True) -> Mapped[time]:
        """Time column."""
        return mapped_column(Time, nullable=nullable)

    @staticmethod
    def jsonb_column(
        default_factory: Callable[[], dict[str, Any]] | None = None,
        nullable: bool = False,
    ) -> Mapped[dict[str, Any]]:
        """JSONB column."""
        return mapped_column(
            JSONB,
            default=default_factory or dict,
            nullable=nullable,
        )

    @staticmethod
    def inet_column(nullable: bool = True) -> Mapped[str]:
        """PostgreSQL INET column for IP addresses."""
        return mapped_column(INET, nullable=nullable)

    @staticmethod
    def text_column(nullable: bool = False) -> Mapped[str]:
        """Text column for long strings."""
        return mapped_column(Text, nullable=nullable)

    @staticmethod
    def string_column(length: int, nullable: bool = False, default: str | None = None) -> Mapped[str]:
        """String column with length."""
        return mapped_column(String(length), nullable=nullable, default=default)

    @staticmethod
    def server_default_uuid() -> str:
        """Get server-side UUID generation expression."""
        return "gen_random_uuid()"


# Convenience column instances
col = BaseColumn()


def utc_now() -> datetime:
    """Get current UTC time with timezone info."""
    return datetime.now(UTC)


# Export for convenience
__all__ = [
    "Base",
    "BaseColumn",
    "col",
    "utc_now",
]
