"""Session title generation service.

Simple title generation based on first user message truncation.
No LLM dependency - fast, reliable, and predictable.
"""


def generate_session_title(user_message: str, max_length: int = 15) -> str:
    """Generate a session title by truncating the user's first message.

    Simple and fast - no LLM calls, no async, no network issues.

    Args:
        user_message: The user's first message in the session
        max_length: Maximum title length (default 15)

    Returns:
        Generated title string
    """
    if not user_message:
        return "新会话"

    # Clean up whitespace and newlines
    clean_message = " ".join(user_message.split())

    # Truncate and add ellipsis if needed
    if len(clean_message) > max_length:
        return clean_message[:max_length] + "..."

    return clean_message

