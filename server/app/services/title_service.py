"""Session title generation service.

Generates concise session titles using a fast LLM model with fallback support.
"""

from app.core.logging import logger
from app.services.llm import LLMRegistry

TITLE_GENERATION_PROMPT = """根据用户的第一条消息，生成一个简洁的中文会话标题。

要求：
- 最多20个字符
- 简洁明了，概括主题
- 不要使用引号或标点
- 直接输出标题，不要解释

用户消息：{user_message}

标题："""


async def generate_session_title(user_message: str, max_length: int = 25) -> str:
    """Generate a session title based on user's first message.

    Uses a fast model first, falls back to main model, then to truncation.

    Fallback chain:
    1. Fast model - 优先使用
    2. Main model - 快速模型失败时使用
    3. Truncation - 所有模型都失败时使用

    Args:
        user_message: The user's first message in the session
        max_length: Maximum title length (default 25)

    Returns:
        Generated title string
    """
    # 截取用户消息前200字符用于生成
    truncated_message = user_message[:200]

    # 定义要尝试的模型列表（按优先级排序）
    models_to_try = ["deepseek-chat"]

    for model_name in models_to_try:
        try:
            llm = LLMRegistry.get(model_name)

            response = await llm.ainvoke(TITLE_GENERATION_PROMPT.format(user_message=truncated_message))

            # 清理并截取标题
            title = response.content.strip()
            # 移除可能的引号
            title = title.strip("\"'")
            # 限制长度
            if len(title) > max_length:
                title = title[:max_length]

            logger.info(
                "session_title_generated",
                title=title,
                model=model_name,
                user_message_preview=truncated_message[:50],
            )

            return title

        except Exception as e:
            logger.warning(
                "session_title_model_failed",
                model=model_name,
                error=str(e),
                error_type=type(e).__name__,
            )
            # 继续尝试下一个模型
            continue

    # 所有模型都失败，使用最终 fallback
    logger.warning(
        "session_title_all_models_failed",
        fallback="truncation",
    )
    fallback_title = user_message[:15]
    if len(user_message) > 15:
        fallback_title += "..."
    return fallback_title
