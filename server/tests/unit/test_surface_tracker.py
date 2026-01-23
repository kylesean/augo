"""Tests for SurfaceTracker."""

import time
from uuid import uuid4

import pytest

from app.core.genui import SurfaceInfo, SurfaceTracker


class TestSurfaceTracker:
    """Test suite for SurfaceTracker."""

    def test_register_surface(self) -> None:
        """Test registering a new surface."""
        tracker = SurfaceTracker()
        session_id = str(uuid4())
        surface_id = f"surface_{session_id}_call123"

        info = tracker.register_surface(
            session_id=session_id,
            surface_id=surface_id,
            component_type="TransactionCard",
            data={"amount": 100.0, "currency": "CNY"},
            tool_call_id="call123",
        )

        assert info.surface_id == surface_id
        assert info.session_id == session_id
        assert info.component_type == "TransactionCard"
        assert info.data["amount"] == 100.0
        assert info.is_active is True

    def test_find_reusable_surface(self) -> None:
        """Test finding a reusable surface of the same type."""
        tracker = SurfaceTracker()
        session_id = str(uuid4())
        surface_id = f"surface_{session_id}_call123"

        # Register a surface
        tracker.register_surface(
            session_id=session_id,
            surface_id=surface_id,
            component_type="TransactionCard",
            data={"amount": 100.0},
        )

        # Should find the same surface
        found = tracker.find_reusable_surface(
            session_id=session_id,
            component_type="TransactionCard",
        )
        assert found == surface_id

        # Should not find for different component type
        not_found = tracker.find_reusable_surface(
            session_id=session_id,
            component_type="TransferReceipt",
        )
        assert not_found is None

    def test_update_surface_data(self) -> None:
        """Test updating surface data at a specific path."""
        tracker = SurfaceTracker()
        session_id = str(uuid4())
        surface_id = f"surface_{session_id}_call123"

        # Register a surface
        tracker.register_surface(
            session_id=session_id,
            surface_id=surface_id,
            component_type="TransactionCard",
            data={"amount": 100.0, "currency": "CNY"},
        )

        # Update the amount
        result = tracker.update_surface_data(surface_id, "/amount", 200.0)
        assert result is True

        # Verify the update
        data = tracker.get_surface_data(surface_id)
        assert data is not None
        assert data["amount"] == 200.0
        assert data["currency"] == "CNY"  # Unchanged

    def test_delete_surface(self) -> None:
        """Test soft-deleting a surface."""
        tracker = SurfaceTracker()
        session_id = str(uuid4())
        surface_id = f"surface_{session_id}_call123"

        # Register a surface
        tracker.register_surface(
            session_id=session_id,
            surface_id=surface_id,
            component_type="TransactionCard",
            data={"amount": 100.0},
        )

        # Delete the surface
        result = tracker.delete_surface(surface_id)
        assert result is True

        # Should not be reusable anymore
        found = tracker.find_reusable_surface(
            session_id=session_id,
            component_type="TransactionCard",
        )
        assert found is None

    def test_get_session_surfaces(self) -> None:
        """Test getting all surfaces for a session."""
        tracker = SurfaceTracker()
        session_id = str(uuid4())

        # Register multiple surfaces
        tracker.register_surface(
            session_id=session_id,
            surface_id="surface_1",
            component_type="TransactionCard",
            data={},
        )
        tracker.register_surface(
            session_id=session_id,
            surface_id="surface_2",
            component_type="TransferReceipt",
            data={},
        )

        surfaces = tracker.get_session_surfaces(session_id)
        assert len(surfaces) == 2

    def test_clear_session(self) -> None:
        """Test clearing all surfaces for a session."""
        tracker = SurfaceTracker()
        session_id = str(uuid4())

        # Register surfaces
        tracker.register_surface(
            session_id=session_id,
            surface_id="surface_1",
            component_type="TransactionCard",
            data={},
        )
        tracker.register_surface(
            session_id=session_id,
            surface_id="surface_2",
            component_type="TransferReceipt",
            data={},
        )

        # Clear session
        count = tracker.clear_session(session_id)
        assert count == 2

        # Should have no active surfaces
        surfaces = tracker.get_session_surfaces(session_id)
        assert len(surfaces) == 0


class TestSurfaceInfo:
    """Test suite for SurfaceInfo dataclass."""

    def test_update_data_simple_path(self) -> None:
        """Test updating data at a simple path."""
        info = SurfaceInfo(
            surface_id="test",
            session_id="session",
            component_type="TestComponent",
            tool_call_id=None,
            data={"amount": 100.0, "name": "Test"},
        )

        info.update_data("/amount", 200.0)
        assert info.data["amount"] == 200.0
        assert info.data["name"] == "Test"

    def test_update_data_nested_path(self) -> None:
        """Test updating data at a nested path."""
        info = SurfaceInfo(
            surface_id="test",
            session_id="session",
            component_type="TestComponent",
            tool_call_id=None,
            data={"user": {"name": "Alice"}},
        )

        info.update_data("/user/name", "Bob")
        assert info.data["user"]["name"] == "Bob"

    def test_update_data_creates_nested_structure(self) -> None:
        """Test that update_data creates nested structure if needed."""
        info = SurfaceInfo(
            surface_id="test",
            session_id="session",
            component_type="TestComponent",
            tool_call_id=None,
            data={},
        )

        info.update_data("/user/profile/name", "Test")
        assert info.data["user"]["profile"]["name"] == "Test"
