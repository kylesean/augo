"""Schemas for conversation management API."""

from __future__ import annotations

from pydantic import BaseModel, Field


class ConversationListItem(BaseModel):
    """Schema for conversation list item."""

    id: str
    title: str
    createdAt: str
    updatedAt: str


class PaginationMeta(BaseModel):
    """Schema for pagination metadata."""

    currentPage: int
    lastPage: int
    perPage: int
    total: int
    hasMore: bool


class ConversationListResponse(BaseModel):
    """Schema for conversation list response."""

    data: list[ConversationListItem]
    meta: PaginationMeta


class AttachmentInfo(BaseModel):
    """Schema for attachment information in messages."""

    id: int
    attachmentId: int
    filename: str
    objectKey: str
    mimeType: str
    size: int
    uri: str
    url: str


class ToolComponent(BaseModel):
    """Schema for tool component in assistant messages."""

    name: str
    type: str
    props: dict
    transactionId: int | None = None


class MessageDetail(BaseModel):
    """Schema for message detail."""

    id: str
    role: str
    timestamp: str
    text: str
    attachments: list[AttachmentInfo] = Field(default_factory=list)
    toolComponents: list[ToolComponent] | None = None


class ConversationDetail(BaseModel):
    """Schema for conversation detail with messages."""

    id: str
    title: str
    updatedAt: str
    messages: list[MessageDetail]


class SearchResult(BaseModel):
    """Schema for message search result."""

    id: str  # conversation_id
    title: str
    messageId: str
    snippet: str
    createdAt: str
    updatedAt: str


class SearchResultsResponse(BaseModel):
    """Schema for search results response."""

    data: list[SearchResult]
