"""Dynamic context middleware for injecting runtime context into agent prompts.

This middleware injects dynamic information like current time and user ID
into the system prompt before agent invocation.
"""

from datetime import datetime
from typing import Any

from langchain_core.messages import BaseMessage, HumanMessage

from app.core.langgraph.middleware.base import BaseMiddleware, inject_system_message
from app.core.logging import logger


def _detect_language(text: str) -> str:
    """Detect the primary language of the given text.

    This is a simple heuristic-based detection that works for common cases.
    For production use, consider using a proper language detection library.

    Returns:
        Language code: 'en', 'zh', 'ja', 'ko', or 'unknown'
    """
    if not text:
        return "unknown"

    # Count character types
    latin_chars = 0
    cjk_chars = 0
    japanese_chars = 0  # Hiragana and Katakana
    korean_chars = 0  # Hangul

    for char in text:
        code = ord(char)
        # Basic Latin and Latin Extended
        if (0x0041 <= code <= 0x007A) or (0x00C0 <= code <= 0x024F):
            latin_chars += 1
        # CJK Unified Ideographs (Chinese, Japanese Kanji)
        elif 0x4E00 <= code <= 0x9FFF:
            cjk_chars += 1
        # Hiragana
        elif 0x3040 <= code <= 0x309F:
            japanese_chars += 1
        # Katakana
        elif 0x30A0 <= code <= 0x30FF:
            japanese_chars += 1
        # Hangul Syllables
        elif 0xAC00 <= code <= 0xD7AF:
            korean_chars += 1
        # Hangul Jamo
        elif 0x1100 <= code <= 0x11FF:
            korean_chars += 1

    total = latin_chars + cjk_chars + japanese_chars + korean_chars
    if total == 0:
        return "unknown"

    # Determine primary language
    if korean_chars > 0 and korean_chars >= cjk_chars:
        return "ko"
    if japanese_chars > 0:
        return "ja"
    if cjk_chars > latin_chars:
        return "zh"
    if latin_chars > 0:
        return "en"

    return "unknown"


LANGUAGE_PROMPTS = {
    "en": "User is communicating in English. Respond in English.",
    "zh": "用户正在使用中文交流。请用中文回复。",
    "ja": "ユーザーは日本語でコミュニケーションしています。日本語で返答してください。",
    "ko": "사용자가 한국어로 소통하고 있습니다. 한국어로 응답하세요.",
}


class DynamicContextMiddleware(BaseMiddleware):
    """Middleware for injecting dynamic context into system prompt.

    This middleware adds runtime information such as:
    - Current timestamp
    - User ID (if available)
    - Language prompt (detected from user message or from session language)

    The context is injected as a system message to keep the base
    system prompt stable for better caching.

    Follows LangChain 1.0 middleware best practices.
    """

    name = "DynamicContextMiddleware"

    async def before_invoke(
        self,
        messages: list[BaseMessage],
        config: dict[str, Any],
    ) -> tuple[list[BaseMessage], dict[str, Any]]:
        """Inject dynamic context before agent invocation.

        Args:
            messages: List of messages to send to agent
            config: Configuration dict for agent invocation

        Returns:
            Modified (messages, config) tuple with context injected
        """
        from zoneinfo import ZoneInfo

        context_parts = []
        user_uuid = config.get("configurable", {}).get("user_uuid")

        # Get user timezone from config or default to Asia/Shanghai
        user_timezone = config.get("configurable", {}).get("user_timezone", "Asia/Shanghai")

        # Get current time in user's timezone (ISO 8601 format)
        current_time = datetime.now(ZoneInfo(user_timezone))
        time_str = current_time.isoformat()  # e.g., "2024-12-04T14:30:00+08:00"

        context_parts.append(f"Current time: {time_str}")

        # Add user ID if available
        if user_uuid:
            context_parts.append(f"User ID: {user_uuid}")

        # Detect language from the last user message
        detected_lang = "unknown"
        for msg in reversed(messages):
            if isinstance(msg, HumanMessage) and msg.content:
                content = msg.content if isinstance(msg.content, str) else str(msg.content)
                detected_lang = _detect_language(content)
                break

        # Fallback to session language from ContextVar (set by chatbot.py from Accept-Language header)
        if detected_lang == "unknown":
            from app.core.langgraph.tools import current_session_language

            session_lang = current_session_language.get()
            if session_lang and session_lang != "zh":  # "zh" is the default, might not be explicitly set
                detected_lang = session_lang

        # Add language prompt for non-Chinese languages (Chinese is typically handled well by DeepSeek)
        # For English and other languages, we need to explicitly instruct the model
        if detected_lang in LANGUAGE_PROMPTS:
            context_parts.append(f"Language: {LANGUAGE_PROMPTS[detected_lang]}")
            logger.debug("language_prompt_injected", detected_lang=detected_lang)

        # Build context string
        if context_parts:
            context_str = "\n".join(context_parts)
            context_message = f"# Dynamic Context\n{context_str}"

            # Inject into system message
            messages = inject_system_message(messages, context_message)

            logger.debug(
                "dynamic_context_injected",
                has_user_uuid=bool(user_uuid),
                timestamp=time_str,
                detected_lang=detected_lang,
            )

        return messages, config
