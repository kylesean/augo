"""Graph utilities for the application.

This module provides utility functions for message processing in LangGraph workflows.
"""

from typing import Any, Union

from langchain_core.language_models.chat_models import BaseChatModel
from langchain_core.messages import (
    BaseMessage,
    trim_messages as _trim_messages,
)

from app.core.config import settings
from app.core.logging import logger
from app.schemas import Message


def dump_messages(messages: list[Union[Message, dict]]) -> list[dict]:
    """Dump messages to a list of dictionaries.

    Args:
        messages: The messages to dump (can be Message objects or dicts).

    Returns:
        list[dict]: The dumped messages.
    """
    result = []
    for message in messages:
        if hasattr(message, "model_dump"):
            result.append(message.model_dump())
        elif isinstance(message, dict):
            result.append(message)
        else:
            result.append({"role": "user", "content": str(message)})
    return result


def process_llm_response(response: BaseMessage) -> BaseMessage:
    """Process LLM response to handle structured content blocks (e.g., from GPT-5 models).

    GPT-5 models return content as a list of blocks like:
    [
        {'id': '...', 'summary': [], 'type': 'reasoning'},
        {'type': 'text', 'text': 'actual response'}
    ]

    This function extracts the actual text content from such structures.

    Args:
        response: The raw response from the LLM

    Returns:
        BaseMessage with processed content
    """
    if isinstance(response.content, list):
        # Extract text from content blocks
        text_parts = []
        for block in response.content:
            if isinstance(block, dict):
                # Handle text blocks
                if block.get("type") == "text" and "text" in block:
                    text_parts.append(block["text"])
                # Log reasoning blocks for debugging
                elif block.get("type") == "reasoning":
                    logger.debug(
                        "reasoning_block_received",
                        reasoning_id=block.get("id"),
                        has_summary=bool(block.get("summary")),
                    )
            elif isinstance(block, str):
                text_parts.append(block)

        # Join all text parts
        response.content = "".join(text_parts)
        logger.debug(
            "processed_structured_content",
            block_count=len(response.content) if isinstance(response.content, list) else 1,
            extracted_length=len(response.content) if isinstance(response.content, str) else 0,
        )

    return response


def prepare_messages(
    messages: list[Union[Message, dict]],
    llm: BaseChatModel,
    system_prompt: str,
) -> list[dict]:
    """Prepare messages for LLM invocation with token trimming.

    This function:
    1. Trims messages to fit within token limits
    2. Prepends the system prompt

    Note: Dynamic context (time, user_uuid) should be injected separately
    via the context module to preserve prompt cache efficiency.

    Args:
        messages: The messages to prepare.
        llm: The LLM to use for token counting.
        system_prompt: The stable system prompt.

    Returns:
        list[dict]: The prepared messages with system prompt.
    """
    message_dicts = dump_messages(messages)

    try:
        trimmed_messages: Any = _trim_messages(
            message_dicts,
            strategy="last",
            token_counter=llm,
            max_tokens=settings.MAX_TOKENS,
            start_on="human",
            include_system=False,
            allow_partial=False,
        )
    except ValueError as e:
        # Handle unrecognized content blocks (e.g., reasoning blocks from GPT-5)
        if "Unrecognized content block type" in str(e):
            logger.warning(
                "token_counting_failed_skipping_trim",
                error=str(e),
                message_count=len(messages),
            )
            trimmed_messages = message_dicts
        else:
            raise

    return [{"role": "system", "content": system_prompt}] + dump_messages(trimmed_messages)
