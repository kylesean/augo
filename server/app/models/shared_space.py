"""Shared space models for collaborative financial management."""

from datetime import datetime
from typing import TYPE_CHECKING, List, Optional
from uuid import UUID

import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import (
    TIMESTAMP,
    UUID as PGUUID,
)
from sqlmodel import Column, Field, Relationship

from app.models.base import BaseModel

if TYPE_CHECKING:
    from app.models.transaction import Transaction
    from app.models.user import User


class SharedSpace(BaseModel, table=True):
    """Shared space model for collaborative financial tracking.

    Attributes:
        id: The primary key (UUID)
        name: Space name
        creator_uuid: Foreign key to users.uuid (creator)
        status: Space status (active, archived)
        description: Space description
        created_at: When the space was created
        updated_at: When the space was last updated
        creator: Relationship to creator user
        members: Relationship to space members
        space_transactions: Relationship to space transactions
        invite_code: Current invitation code
        invite_code_expires_at: Invitation code expiration time
    """

    __tablename__ = "shared_spaces"

    id: Optional[UUID] = Field(
        default=None,
        sa_column=Column(PGUUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
    )
    name: str = Field(max_length=50)
    creator_uuid: UUID = Field(
        sa_column=Column(PGUUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), nullable=False)
    )
    status: str = Field(max_length=50, default="ACTIVE")
    description: Optional[str] = Field(default=None)
    invite_code: Optional[str] = Field(default=None, max_length=20)
    invite_code_expires_at: Optional[datetime] = Field(
        default=None, sa_column=Column(TIMESTAMP(timezone=True), nullable=True)
    )

    # Relationships
    creator: Optional["User"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[SharedSpace.creator_uuid]",
            "primaryjoin": "SharedSpace.creator_uuid == User.uuid",
        }
    )
    members: List["SpaceMember"] = Relationship(
        back_populates="space", sa_relationship_kwargs={"cascade": "all, delete-orphan"}
    )
    space_transactions: List["SpaceTransaction"] = Relationship(
        back_populates="space", sa_relationship_kwargs={"cascade": "all, delete-orphan"}
    )


class SpaceMember(BaseModel, table=True):
    """Space member model for tracking members in shared spaces.

    Attributes:
        space_id: Foreign key to shared_spaces table (UUID)
        user_uuid: Foreign key to users.uuid
        role: Member role (owner, member)
        status: Member status (pending, accepted)
        created_at: When the record was created
        updated_at: When the record was last updated
        space: Relationship to shared space
        user: Relationship to user
    """

    __tablename__ = "space_members"

    space_id: UUID = Field(
        sa_column=Column(
            PGUUID(as_uuid=True),
            sa.ForeignKey("shared_spaces.id", ondelete="CASCADE"),
            primary_key=True,
            nullable=False,
        )
    )
    user_uuid: UUID = Field(
        sa_column=Column(
            PGUUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), primary_key=True, nullable=False
        )
    )
    role: str = Field(max_length=50, default="MEMBER")
    status: str = Field(max_length=50, default="ACCEPTED")

    # Relationships
    space: Optional[SharedSpace] = Relationship(back_populates="members")
    user: Optional["User"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[SpaceMember.user_uuid]",
            "primaryjoin": "SpaceMember.user_uuid == User.uuid",
        }
    )


class SpaceTransaction(BaseModel, table=True):
    """Space transaction model for associating transactions with shared spaces.

    This is a many-to-many relationship table that allows:
    - One transaction to be shared across multiple spaces
    - Tracking who added the transaction to the space
    - Maintaining transaction ownership while sharing

    Attributes:
        id: The primary key (UUID)
        space_id: Foreign key to shared_spaces table
        transaction_id: Foreign key to transactions table
        added_by_user_uuid: Foreign key to users.uuid (who added this)
        added_at: When the transaction was added to the space
        created_at: When the record was created
        updated_at: When the record was last updated
        space: Relationship to shared space
        transaction: Relationship to transaction
        added_by: Relationship to user who added
    """

    __tablename__ = "space_transactions"

    id: Optional[UUID] = Field(
        default=None,
        sa_column=Column(PGUUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
    )
    space_id: UUID = Field(
        sa_column=Column(PGUUID(as_uuid=True), sa.ForeignKey("shared_spaces.id", ondelete="NO ACTION"), nullable=False)
    )
    transaction_id: UUID = Field(
        sa_column=Column(PGUUID(as_uuid=True), sa.ForeignKey("transactions.id", ondelete="CASCADE"), nullable=False)
    )
    added_by_user_uuid: UUID = Field(
        sa_column=Column(PGUUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), nullable=False)
    )

    # Relationships
    space: Optional[SharedSpace] = Relationship(back_populates="space_transactions")
    transaction: Optional["Transaction"] = Relationship(
        sa_relationship_kwargs={"foreign_keys": "[SpaceTransaction.transaction_id]"}
    )
    added_by: Optional["User"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[SpaceTransaction.added_by_user_uuid]",
            "primaryjoin": "SpaceTransaction.added_by_user_uuid == User.uuid",
        }
    )


# Avoid circular imports
from app.models.transaction import Transaction  # noqa: E402
from app.models.user import User  # noqa: E402
