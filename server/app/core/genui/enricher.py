"""Component Enricher Protocol.

This module defines the protocol and registry for component enrichers.
Enrichers are responsible for hydrating historical UI components with live data
from the database, ensuring that users always see the most up-to-date state.
"""

from __future__ import annotations

from abc import ABC, abstractmethod
from typing import Any

from app.core.logging import logger


class ComponentEnricher(ABC):
    """Abstract base class for component enrichers."""

    @property
    @abstractmethod
    def component_name(self) -> str:
        """The name of the UI component this enricher handles (e.g., 'TransactionReceipt')."""
        pass

    @abstractmethod
    async def enrich(self, tool_call_id: str, data: dict[str, Any], context: dict[str, Any]) -> dict[str, Any]:
        """Enrich component data with live information.

        Args:
            tool_call_id: The ID of the tool call that generated this component.
            data: The original component data (from the tool result).
            context: Additional context (e.g., user_uuid, session_id).

        Returns:
            The enriched component data.
        """
        pass


class EnricherRegistry:
    """Registry for component enrichers."""

    _enrichers: dict[str, ComponentEnricher] = {}

    @classmethod
    def register(cls, enricher: ComponentEnricher) -> None:
        """Register a new enricher."""
        if enricher.component_name in cls._enrichers:
            logger.warning("enricher_overwritten", component_name=enricher.component_name)
        cls._enrichers[enricher.component_name] = enricher
        logger.info("enricher_registered", component_name=enricher.component_name)

    @classmethod
    def get(cls, component_name: str) -> ComponentEnricher | None:
        """Get an enricher by component name."""
        return cls._enrichers.get(component_name)

    @classmethod
    async def enrich_component(
        cls, component_name: str, tool_call_id: str, data: dict[str, Any], context: dict[str, Any]
    ) -> dict[str, Any]:
        """Enrich a component if an enricher is available."""
        enricher = cls.get(component_name)
        if enricher:
            try:
                enriched_data = await enricher.enrich(tool_call_id, data, context)
                return enriched_data
            except Exception as e:
                logger.error(
                    "enrichment_failed",
                    component_name=component_name,
                    tool_call_id=tool_call_id,
                    error=str(e),
                    exc_info=True,
                )
                # Fallback to original data on error
                return data
        return data
