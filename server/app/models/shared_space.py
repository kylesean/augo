"""Shared space models for collaborative financial management.

This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING, Optional
from uuid import UUID

import sqlalchemy as sa
from sqlalchemy import String
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, col

if TYPE_CHECKING:
    from app.models.transaction import Transaction
    from app.models.user import User


class SharedSpace(Base):
    """Shared space model for collaborative financial tracking."""

    __tablename__ = "shared_spaces"

    id: Mapped[UUID | None] = mapped_column(primary_key=True, default=None)
    name: Mapped[str] = mapped_column(String(50))
    creator_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", column="uuid")
    status: Mapped[str] = mapped_column(String(50), default="ACTIVE")
    description: Mapped[str | None] = mapped_column(String, nullable=True)
    invite_code: Mapped[str | None] = mapped_column(String(20), nullable=True)
    invite_code_expires_at: Mapped[datetime | None] = col.datetime_tz(nullable=True)
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)

    creator: Mapped[User | None] = relationship(
        "User",
        foreign_keys="[SharedSpace.creator_uuid]",
        primaryjoin="SharedSpace.creator_uuid == User.uuid",
    )
    members: Mapped[list[SpaceMember]] = relationship(
        "SpaceMember",
        back_populates="space",
        cascade="all, delete-orphan",
    )
    space_transactions: Mapped[list[SpaceTransaction]] = relationship(
        "SpaceTransaction",
        back_populates="space",
        cascade="all, delete-orphan",
    )


class SpaceMember(Base):
    """Space member model for tracking members in shared spaces."""

    __tablename__ = "space_members"

    space_id: Mapped[UUID] = mapped_column(
        PGUUID(as_uuid=True),
        sa.ForeignKey("shared_spaces.id", ondelete="CASCADE"),
        primary_key=True,
    )
    user_uuid: Mapped[UUID] = mapped_column(
        PGUUID(as_uuid=True),
        sa.ForeignKey("users.uuid", ondelete="CASCADE"),
        primary_key=True,
    )
    role: Mapped[str] = mapped_column(String(50), default="MEMBER")
    status: Mapped[str] = mapped_column(String(50), default="ACCEPTED")
    created_at: Mapped[datetime] = col.timestamptz()

    space: Mapped[SharedSpace | None] = relationship("SharedSpace", back_populates="members")
    user: Mapped[User | None] = relationship(
        "User",
        foreign_keys="[SpaceMember.user_uuid]",
        primaryjoin="SpaceMember.user_uuid == User.uuid",
    )


class SpaceTransaction(Base):
    """Space transaction model for associating transactions with shared spaces."""

    __tablename__ = "space_transactions"

    id: Mapped[UUID | None] = mapped_column(primary_key=True, default=None)
    space_id: Mapped[UUID] = col.uuid_fk("shared_spaces", ondelete="NO ACTION")
    transaction_id: Mapped[UUID] = col.uuid_fk("transactions", ondelete="CASCADE")
    added_by_user_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", column="uuid")
    created_at: Mapped[datetime] = col.timestamptz()

    space: Mapped[SharedSpace | None] = relationship("SharedSpace", back_populates="space_transactions")
    transaction: Mapped[Transaction | None] = relationship(
        "Transaction",
        foreign_keys="[SpaceTransaction.transaction_id]",
    )
    added_by: Mapped[User | None] = relationship(
        "User",
        foreign_keys="[SpaceTransaction.added_by_user_uuid]",
        primaryjoin="SpaceTransaction.added_by_user_uuid == User.uuid",
    )
