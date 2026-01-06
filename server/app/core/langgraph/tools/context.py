"""Context variables for LangGraph tools to avoid circular imports."""

from contextvars import ContextVar

# 用于在请求生命周期内存储用户身份
current_user_id: ContextVar[str] = ContextVar("current_user_id", default="")

# 用于在请求生命周期内存储会话语言
current_session_language: ContextVar[str] = ContextVar("current_session_language", default="zh")
