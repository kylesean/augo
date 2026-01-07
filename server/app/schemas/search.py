"""Search-related schemas for conversation search API."""

from datetime import datetime

from pydantic import BaseModel, Field


class HighlightRange(BaseModel):
    """Highlight range for search result text."""

    start: int = Field(..., description="Start index of highlight")
    end: int = Field(..., description="End index of highlight")
    field: str = Field(..., description="Field name: 'title' or 'snippet'")


class SearchResult(BaseModel):
    """Search result item from conversation search."""

    id: str = Field(..., description="Session ID")
    title: str = Field(..., description="Session title")
    snippet: str = Field(..., description="Matching content snippet")
    message_id: str | None = Field(None, alias="messageId", description="Message ID if applicable")
    created_at: datetime | None = Field(None, alias="createdAt", description="Creation time")
    updated_at: datetime | None = Field(None, alias="updatedAt", description="Last update time")
    highlights: list[HighlightRange] = Field(default_factory=list, description="Highlight ranges")

    model_config = {
        "populate_by_name": True,
        "json_schema_extra": {
            "example": {
                "id": "session-uuid",
                "title": "关于记账的对话",
                "snippet": "记账助手可以帮助您...",
                "messageId": None,
                "createdAt": "2024-01-01T00:00:00Z",
                "updatedAt": "2024-01-01T00:00:00Z",
                "highlights": [{"start": 2, "end": 4, "field": "title"}],
            }
        },
    }
