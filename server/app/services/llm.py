"""LLM service for managing LLM calls with retries and fallback mechanisms."""

from __future__ import annotations

import logging
from typing import (
    Any,
    cast,
)

from langchain_core.language_models.chat_models import BaseChatModel
from langchain_core.messages import BaseMessage
from langchain_openai import ChatOpenAI
from openai import (
    APIError,
    APITimeoutError,
    OpenAIError,
    RateLimitError,
)
from tenacity import (
    before_sleep_log,
    retry,
    retry_if_exception_type,
    stop_after_attempt,
    wait_exponential,
)

from app.core.config import (
    Environment,
    settings,
)
from app.core.logging import logger


class LLMRegistry:
    """Registry of available LLM models with pre-initialized instances.

    This class maintains a list of LLM configurations and provides
    methods to retrieve them by name with optional argument overrides.
    """

    # Class-level variable containing all available LLM models
    LLMS: list[dict[str, Any]] = [
        {
            "name": "gpt-5-mini",
            "llm": ChatOpenAI(
                model="gpt-5-mini",
                api_key=settings.OPENAI_API_KEY,
                base_url=settings.OPENAI_BASE_URL,
                max_tokens=settings.MAX_TOKENS,
                reasoning={"effort": "low"},
            ),
        },
        {
            "name": "doubao-seed-1-6-251015",
            "llm": ChatOpenAI(
                model="doubao-seed-1-6-251015",
                api_key=settings.OPENAI_API_KEY,
                base_url=settings.OPENAI_BASE_URL,
                max_tokens=settings.MAX_TOKENS,
                temperature=settings.DEFAULT_LLM_TEMPERATURE,
                # 注意: 移除 reasoning 参数以兼容多模态图片调用
            ),
        },
        {
            "name": "gpt-5",
            "llm": ChatOpenAI(
                model="gpt-5",
                api_key=settings.OPENAI_API_KEY,
                base_url=settings.OPENAI_BASE_URL,
                max_tokens=settings.MAX_TOKENS,
                reasoning={"effort": "medium"},
            ),
        },
        {
            "name": "gpt-5-nano",
            "llm": ChatOpenAI(
                model="gpt-5-nano",
                api_key=settings.OPENAI_API_KEY,
                base_url=settings.OPENAI_BASE_URL,
                max_tokens=settings.MAX_TOKENS,
                reasoning={"effort": "minimal"},
            ),
        },
        {
            "name": "gpt-4o",
            "llm": ChatOpenAI(
                model="gpt-4o",
                temperature=settings.DEFAULT_LLM_TEMPERATURE,
                api_key=settings.OPENAI_API_KEY,
                base_url=settings.OPENAI_BASE_URL,
                max_tokens=settings.MAX_TOKENS,
                top_p=0.95 if settings.ENVIRONMENT == Environment.PRODUCTION else 0.8,
                presence_penalty=0.1 if settings.ENVIRONMENT == Environment.PRODUCTION else 0.0,
                frequency_penalty=0.1 if settings.ENVIRONMENT == Environment.PRODUCTION else 0.0,
            ),
        },
        {
            "name": "gpt-4o-mini",
            "llm": ChatOpenAI(
                model="gpt-4o-mini",
                temperature=settings.DEFAULT_LLM_TEMPERATURE,
                api_key=settings.OPENAI_API_KEY,
                base_url=settings.OPENAI_BASE_URL,
                max_tokens=settings.MAX_TOKENS,
                top_p=0.95 if settings.ENVIRONMENT == Environment.PRODUCTION else 0.8,
            ),
        },
        {
            "name": "mimo-v2-flash",
            "llm": ChatOpenAI(
                model="mimo-v2-flash",
                api_key=settings.OPENAI_API_KEY,
                base_url=settings.OPENAI_BASE_URL,
                max_tokens=settings.MAX_TOKENS,
                temperature=settings.DEFAULT_LLM_TEMPERATURE,
            ),
        },
        {
            "name": "deepseek-chat",
            "llm": ChatOpenAI(
                model="deepseek-chat",
                api_key=settings.OPENAI_API_KEY,
                base_url=settings.OPENAI_BASE_URL,
                max_tokens=settings.MAX_TOKENS,
                temperature=settings.DEFAULT_LLM_TEMPERATURE,
            ),
        },
        {
            "name": "xiaomi/mimo-v2-flash:free",
            "llm": ChatOpenAI(
                model="xiaomi/mimo-v2-flash:free",
                api_key=settings.OPENAI_API_KEY,
                base_url=settings.OPENAI_BASE_URL,
                max_tokens=settings.MAX_TOKENS,
                temperature=settings.DEFAULT_LLM_TEMPERATURE,
            ),
        },
    ]

    @classmethod
    def get(cls, model_name: str, **kwargs: Any) -> BaseChatModel:
        """Get an LLM by name with optional argument overrides.

        Args:
            model_name: Name of the model to retrieve
            **kwargs: Optional arguments to override default model configuration

        Returns:
            BaseChatModel instance

        Raises:
            ValueError: If model_name is not found in LLMS
        """
        # Find the model in the registry
        model_entry = None
        for entry in cls.LLMS:
            if entry["name"] == model_name:
                model_entry = entry
                break

        # If model not found in registry, create a dynamic entry
        if not model_entry:
            logger.info("model_not_found_in_registry_creating_dynamic", model_name=model_name)
            # Create a new dynamic entry
            dynamic_llm = ChatOpenAI(
                model=model_name,
                api_key=settings.OPENAI_API_KEY,
                base_url=settings.OPENAI_BASE_URL,  # Support custom base URL
                max_tokens=settings.MAX_TOKENS,
                temperature=settings.DEFAULT_LLM_TEMPERATURE,
            )
            model_entry = {"name": model_name, "llm": dynamic_llm}
            # Add to registry so it can be used in fallback loop
            cls.LLMS.append(model_entry)

        # If user provides kwargs, create a new instance with those args
        if kwargs:
            logger.debug("creating_llm_with_custom_args", model_name=model_name, custom_args=list(kwargs.keys()))
            return ChatOpenAI(
                model=model_name,
                api_key=settings.OPENAI_API_KEY,
                base_url=settings.OPENAI_BASE_URL,
                **kwargs,
            )

        # Return the default instance
        logger.debug("using_default_llm_instance", model_name=model_name)
        from langchain_core.language_models import BaseChatModel

        return cast(BaseChatModel, model_entry["llm"])

    @classmethod
    def get_all_names(cls) -> list[str]:
        """Get all registered LLM names in order.

        Returns:
            List of LLM names
        """
        return [entry["name"] for entry in cls.LLMS]

    @classmethod
    def get_model_at_index(cls, index: int) -> dict[str, Any]:
        """Get model entry at specific index.

        Args:
            index: Index of the model in LLMS list

        Returns:
            Model entry dict
        """
        if 0 <= index < len(cls.LLMS):
            return cls.LLMS[index]
        return cls.LLMS[0]  # Wrap around to first model


class LLMService:
    """Service for managing LLM calls with retries and circular fallback.

    This service handles all LLM interactions with automatic retry logic,
    rate limit handling, and circular fallback through all available models.
    """

    def __init__(self) -> None:
        """Initialize the LLM service."""
        self._llm: BaseChatModel | None = None
        self._current_model_index: int = 0

        # Find index of default model in registry
        all_names = LLMRegistry.get_all_names()
        try:
            self._current_model_index = all_names.index(settings.DEFAULT_LLM_MODEL)
            self._llm = LLMRegistry.get(settings.DEFAULT_LLM_MODEL)
            logger.info(
                "llm_service_initialized",
                default_model=settings.DEFAULT_LLM_MODEL,
                model_index=self._current_model_index,
                total_models=len(all_names),
                environment=settings.ENVIRONMENT.value,
            )
        except (ValueError, Exception) as e:
            # Default model not found, use first model
            self._current_model_index = 0
            self._llm = LLMRegistry.LLMS[0]["llm"]
            logger.warning(
                "default_model_not_found_using_first",
                requested=settings.DEFAULT_LLM_MODEL,
                using=all_names[0] if all_names else "none",
                error=str(e),
            )

    def _get_next_model_index(self) -> int:
        """Get the next model index in circular fashion.

        Returns:
            Next model index (wraps around to 0 if at end)
        """
        total_models = len(LLMRegistry.LLMS)
        next_index = (self._current_model_index + 1) % total_models
        return next_index

    def _switch_to_next_model(self) -> bool:
        """Switch to the next model in the registry (circular).

        Returns:
            True if successfully switched, False otherwise
        """
        try:
            next_index = self._get_next_model_index()
            next_model_entry = LLMRegistry.get_model_at_index(next_index)

            logger.warning(
                "switching_to_next_model",
                from_index=self._current_model_index,
                to_index=next_index,
                to_model=next_model_entry["name"],
            )

            self._current_model_index = next_index
            self._llm = next_model_entry["llm"]

            logger.info("model_switched", new_model=next_model_entry["name"], new_index=next_index)
            return True
        except Exception as e:
            logger.error("model_switch_failed", error=str(e))
            return False

    @retry(
        stop=stop_after_attempt(settings.MAX_LLM_CALL_RETRIES),
        wait=wait_exponential(multiplier=1, min=2, max=10),
        retry=retry_if_exception_type((RateLimitError, APITimeoutError, APIError)),
        before_sleep=before_sleep_log(logger, logging.WARNING),
        reraise=True,
    )
    async def _call_llm_with_retry(self, messages: list[BaseMessage]) -> BaseMessage:
        """Call the LLM with automatic retry logic.

        Args:
            messages: List of messages to send to the LLM

        Returns:
            BaseMessage response from the LLM

        Raises:
            OpenAIError: If all retries fail
        """
        if not self._llm:
            raise RuntimeError("llm not initialized")

        try:
            response = await self._llm.ainvoke(messages)
            logger.debug("llm_call_successful", message_count=len(messages))
            return response
        except (RateLimitError, APITimeoutError, APIError) as e:
            logger.warning(
                "llm_call_failed_retrying",
                error_type=type(e).__name__,
                error=str(e),
                exc_info=True,
            )
            raise
        except OpenAIError as e:
            logger.error(
                "llm_call_failed",
                error_type=type(e).__name__,
                error=str(e),
            )
            raise

    async def call(
        self,
        messages: list[BaseMessage],
        model_name: str | None = None,
        **model_kwargs: Any,
    ) -> BaseMessage:
        """Call the LLM with the specified messages and circular fallback.

        Args:
            messages: List of messages to send to the LLM
            model_name: Optional specific model to use. If None, uses current model.
            **model_kwargs: Optional kwargs to override default model configuration

        Returns:
            BaseMessage response from the LLM

        Raises:
            RuntimeError: If all models fail after retries
        """
        # If user specifies a model, get it from registry
        if model_name:
            try:
                self._llm = LLMRegistry.get(model_name, **model_kwargs)
                # Update index to match the requested model
                all_names = LLMRegistry.get_all_names()
                try:
                    self._current_model_index = all_names.index(model_name)
                except ValueError:
                    pass  # Keep current index if model name not in list
                logger.info("using_requested_model", model_name=model_name, has_custom_kwargs=bool(model_kwargs))
            except ValueError as e:
                logger.error("requested_model_not_found", model_name=model_name, error=str(e))
                raise

        # Track which models we've tried to prevent infinite loops
        total_models = len(LLMRegistry.LLMS)
        models_tried = 0
        starting_index = self._current_model_index
        last_error = None

        while models_tried < total_models:
            try:
                # Log current model details for debugging
                if self._llm and hasattr(self._llm, "model_name"):
                    base_url = getattr(self._llm, "base_url", "default")
                    api_key = getattr(self._llm, "api_key", "")
                    masked_key = f"{api_key[:8]}..." if api_key else "None"
                    logger.info(
                        "attempting_llm_call",
                        model=self._llm.model_name,
                        base_url=base_url,
                        api_key_prefix=masked_key,
                        attempt=models_tried + 1,
                    )

                response = await self._call_llm_with_retry(messages)
                return response
            except OpenAIError as e:
                last_error = e
                models_tried += 1

                current_model_name = LLMRegistry.LLMS[self._current_model_index]["name"]
                logger.error(
                    "llm_call_failed_after_retries",
                    model=current_model_name,
                    models_tried=models_tried,
                    total_models=total_models,
                    error=str(e),
                )

                # If we've tried all models, give up
                if models_tried >= total_models:
                    logger.error(
                        "all_models_failed",
                        models_tried=models_tried,
                        starting_model=LLMRegistry.LLMS[starting_index]["name"],
                    )
                    break

                # Switch to next model in circular fashion
                if not self._switch_to_next_model():
                    logger.error("failed_to_switch_to_next_model")
                    break

                # Continue loop to try next model

        # All models failed
        raise RuntimeError(
            f"failed to get response from llm after trying {models_tried} models. last error: {str(last_error)}"
        )

    def get_llm(self) -> BaseChatModel | None:
        """Get the current LLM instance.

        Returns:
            Current BaseChatModel instance or None if not initialized
        """
        return self._llm

    def bind_tools(self, tools: list) -> LLMService:
        """Bind tools to the current LLM.

        Args:
            tools: List of tools to bind

        Returns:
            Self for method chaining
        """
        if self._llm:
            from langchain_core.language_models import BaseChatModel

            self._llm = cast(BaseChatModel, self._llm.bind_tools(tools))
        return self


# Create global LLM service instance
llm_service = LLMService()
