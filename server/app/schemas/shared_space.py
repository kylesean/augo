"""Shared space schemas for request/response validation."""
from __future__ import annotations

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field

# ============================================================================
# Request Schemas
# ============================================================================


class CreateSpaceRequest(BaseModel):
    """Request schema for creating a shared space."""

    name: str = Field(..., min_length=1, max_length=255, description="空间名称")
    description: str | None = Field(None, max_length=255, description="空间描述")


class UpdateSpaceRequest(BaseModel):
    """Request schema for updating a shared space."""

    name: str | None = Field(None, min_length=1, max_length=255, description="空间名称")
    description: str | None = Field(None, max_length=255, description="空间描述")
    status: str | None = Field(None, pattern="^(active|archived)$", description="空间状态")


class GenerateInviteCodeRequest(BaseModel):
    """Request schema for generating an invite code."""

    max_uses: int = Field(default=1, ge=1, le=100, description="最大使用次数")
    expires_days: int = Field(default=7, ge=1, le=30, description="过期天数")


class JoinWithCodeRequest(BaseModel):
    """Request schema for joining a space with invite code."""

    code: str = Field(..., min_length=1, max_length=50, description="邀请码")


class AddTransactionToSpaceRequest(BaseModel):
    """Request schema for adding a transaction to a space."""

    transaction_id: UUID = Field(..., description="交易ID")


# ============================================================================
# Response Schemas
# ============================================================================


class SpaceCreatorResponse(BaseModel):
    """Response schema for space creator info."""

    id: str = Field(..., description="用户ID")
    username: str = Field(..., description="用户名")
    avatar_url: str | None = Field(None, description="头像URL")

    model_config = ConfigDict(from_attributes=True)


class SpaceMemberResponse(BaseModel):
    """Response schema for space member info."""

    user_id: str = Field(..., description="用户UUID")
    username: str = Field(..., description="用户名")
    avatar_url: str | None = Field(None, description="头像URL")
    role: str = Field(..., description="成员角色")
    status: str = Field(..., description="成员状态")
    created_at: datetime | None = Field(None, description="加入时间")
    contribution_amount: str = Field(default="0.00", description="成员累计支出金额")

    model_config = ConfigDict(from_attributes=True)


class SharedSpaceResponse(BaseModel):
    """Response schema for shared space."""

    id: str = Field(..., description="空间ID")
    name: str = Field(..., description="空间名称")
    description: str | None = Field(None, description="空间描述")
    creator: SpaceCreatorResponse = Field(..., description="创建者信息")
    created_at: datetime = Field(..., description="创建时间")
    updated_at: datetime = Field(..., description="更新时间")
    members: list[SpaceMemberResponse] | None = Field(None, description="成员列表")
    transaction_count: int = Field(default=0, description="交易数量")
    current_invite_code: str | None = Field(None, description="当前邀请码")
    invite_code_expires_at: datetime | None = Field(None, description="邀请码过期时间")
    total_expense: str = Field(default="0.00", description="空间累计总支出")

    model_config = ConfigDict(from_attributes=True)


class InviteCodeResponse(BaseModel):
    """Response schema for invite code."""

    code: str = Field(..., description="邀请码")
    space_id: str = Field(..., description="空间ID")
    space_name: str = Field(..., description="空间名称")
    expires_at: datetime | None = Field(None, description="过期时间")
    created_at: datetime = Field(..., description="创建时间")
    created_by: str = Field(..., description="创建者用户名")
    max_uses: int = Field(..., description="最大使用次数")
    uses: int = Field(..., description="已使用次数")

    model_config = ConfigDict(from_attributes=True)


class SettlementItemResponse(BaseModel):
    """Response schema for a single settlement item."""

    from_user_id: str = Field(..., description="付款方用户ID")
    from_username: str = Field(..., description="付款方用户名")
    to_user_id: str = Field(..., description="收款方用户ID")
    to_username: str = Field(..., description="收款方用户名")
    amount: str = Field(..., description="结算金额")


class SettlementResponse(BaseModel):
    """Response schema for settlement info."""

    space_id: str = Field(..., description="空间ID")
    items: list[SettlementItemResponse] = Field(..., description="结算项目")
    total_amount: str = Field(..., description="总金额")
    calculated_at: datetime = Field(..., description="计算时间")
    is_settled: bool = Field(default=False, description="是否已结算")


class SpaceTransactionResponse(BaseModel):
    """Response schema for a transaction in a space."""

    id: str = Field(..., description="交易ID")
    type: str = Field(..., description="交易类型")
    amount: str = Field(..., description="金额")
    currency: str = Field(..., description="货币")
    description: str | None = Field(None, description="描述")
    category_key: str = Field(..., description="分类")
    transaction_at: datetime = Field(..., description="交易时间")
    added_by_username: str = Field(..., description="添加者用户名")
    added_at: datetime = Field(..., description="添加时间")

    model_config = ConfigDict(from_attributes=True)
