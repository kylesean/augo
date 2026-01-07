"""This file contains the chat schema for the application."""
from __future__ import annotations

import re
from typing import (
    Literal,
    Sequence,
)
from uuid import UUID

from pydantic import (
    BaseModel,
    Field,
    field_validator,
)

from app.schemas.client_state import ClientStateMutation


class Message(BaseModel):
    """Message model for chat endpoint.

    Attributes:
        role: The role of the message sender (user or assistant).
        content: The content of the message.
    """

    model_config = {"extra": "ignore"}

    role: Literal["user", "assistant", "system"] = Field(..., description="The role of the message sender")
    content: str = Field(..., description="The content of the message", min_length=1, max_length=3000)

    @field_validator("content")
    @classmethod
    def validate_content(cls, v: str) -> str:
        """Validate the message content.

        Args:
            v: The content to validate

        Returns:
            str: The validated content

        Raises:
            ValueError: If the content contains disallowed patterns
        """
        # Check for potentially harmful content
        if re.search(r"<script.*?>.*?</script>", v, re.IGNORECASE | re.DOTALL):
            raise ValueError("Content contains potentially harmful script tags")

        # Check for null bytes
        if "\0" in v:
            raise ValueError("Content contains null bytes")

        return v


class ChatRequest(BaseModel):
    """Request model for chat endpoint.

    Attributes:
        messages: List of messages in the session.
        session_id: Optional session ID for existing sessions.
    """

    messages: list[Message] = Field(
        ...,
        description="List of messages in the session",
        min_length=1,
    )
    session_id: UUID | None = Field(
        default=None, description="Session ID for existing session. If null, a new session will be created."
    )


class AttachmentRef(BaseModel):
    """Reference to an uploaded attachment.

    Used in chat messages to reference files that have been
    previously uploaded via the /files/upload endpoint.
    """

    id: UUID = Field(..., description="Attachment UUID")


class MessageWithAttachments(Message):
    """Extended message model with attachment support.

    This model extends the base Message to support multimodal content
    by allowing references to uploaded files (images, documents).
    """

    attachments: list[AttachmentRef] | None = Field(default=None, description="List of attachment references")


class ChatRequestWithAttachments(BaseModel):
    """Request model for chat endpoint with attachment support.

    Attributes:
        messages: List of messages with optional attachments.
        session_id: Optional session ID for existing sessions.
        client_state: Optional client state mutation for GenUI atomic mode.
    """

    messages: list[MessageWithAttachments] = Field(
        ...,
        description="List of messages with optional attachments",
        min_length=1,
    )
    session_id: UUID | None = Field(
        default=None, description="Session ID for existing session. If null, a new session will be created."
    )
    client_state: ClientStateMutation | None = Field(
        default=None, description="Client state mutation for GenUI atomic mode (replaces state_updates)"
    )


class ChatResponse(BaseModel):
    """Response model for chat endpoint.

    Attributes:
        messages: List of messages in the session.
        session_id: Optional session ID (only for new sessions).
    """

    messages: list[Message] = Field(..., description="List of messages in the session")
    session_id: UUID | None = Field(default=None, description="Session ID for new sessions")


class StreamResponse(BaseModel):
    """Response model for streaming chat endpoint.

    Attributes:
        content: The content of the current chunk.
        done: Whether the stream is complete.
        session_id: Optional session ID (only in first chunk for new sessions).
        tool_call: Optional tool call information for rendering tool execution status.
        message_id: Optional message ID (only in final chunk when done=True).
    """

    content: str = Field(default="", description="The content of the current chunk")
    done: bool = Field(default=False, description="Whether the stream is complete")
    session_id: UUID | None = Field(default=None, description="Session ID for new sessions")
    tool_call: dict | None = Field(default=None, description="Tool call information (name, args, status)")
    message_id: str | None = Field(default=None, description="Message ID (only when done=True)")


# ============== History Message Schema ==============


class ToolCallInfo(BaseModel):
    """Tool call information for history messages."""

    id: str = Field(..., description="Tool call ID")
    name: str = Field(..., description="Tool name")
    args: dict = Field(default_factory=dict, description="Tool arguments")


class UIComponentInfo(BaseModel):
    """UI component information for GenUI rendering."""

    surfaceId: str = Field(..., description="GenUI surface ID")
    componentType: str = Field(..., description="Component type name")
    data: dict = Field(default_factory=dict, description="Component data")


class AttachmentInfo(BaseModel):
    """Attachment information with signed URL for history messages."""

    id: UUID = Field(..., description="Attachment UUID")
    attachmentId: UUID = Field(..., description="Alias for ID, required by client")
    type: str = Field(..., description="Attachment type (image/document/other)")
    filename: str = Field(..., description="Original filename")
    objectKey: str = Field(..., description="Object storage key, required by client")
    mimeType: str = Field(..., description="MIME type")
    signedUrl: str | None = Field(default=None, description="Time-limited access URL")
    expiresAt: str | None = Field(default=None, description="Expiration timestamp")


class HistoryMessage(BaseModel):
    """Complete message model for history retrieval.

    Includes all data needed to fully render messages including
    tool calls, UI components, and attachments.
    """

    id: UUID = Field(..., description="Message UUID")
    role: Literal["user", "assistant", "tool"] = Field(..., description="Message role")
    content: str = Field(default="", description="Text content")
    timestamp: str | None = Field(default=None, description="ISO timestamp")
    attachments: list[AttachmentInfo] = Field(default_factory=list, description="Attached files")
    toolCalls: list[ToolCallInfo] = Field(default_factory=list, description="Tool calls made")
    uiComponents: list[UIComponentInfo] = Field(default_factory=list, description="GenUI components")
    toolCallId: str | None = Field(default=None, description="For tool messages, the call ID being responded to")


class HistoryMessagesResponse(BaseModel):
    """Response model for session messages endpoint."""

    messages: list[HistoryMessage] = Field(..., description="Complete message history")
    session_id: UUID = Field(..., description="Session ID")
    title: str | None = Field(default=None, description="Session title")
