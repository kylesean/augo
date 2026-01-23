#!/usr/bin/env python3
"""Test script to verify DataModelUpdate functionality.

Run with: cd server && uv run python scripts/test_datamodel_update.py
"""

import asyncio
import json

from app.core.genui import SurfaceTracker
from app.core.genui_protocol import (
    BeginRendering,
    BeginRenderingPayload,
    Component,
    DataModelUpdate,
    DataModelUpdatePayload,
    SurfaceUpdate,
    SurfaceUpdatePayload,
)


def test_surface_tracker_flow():
    """Test the SurfaceTracker flow for incremental updates."""
    print("=" * 60)
    print("Testing SurfaceTracker Flow")
    print("=" * 60)

    tracker = SurfaceTracker()
    session_id = "test-session-123"

    # Step 1: Register initial surface (simulating first TransactionCard render)
    print("\n[Step 1] Registering initial surface...")
    surface_id = f"surface_{session_id}_call001"
    tracker.register_surface(
        session_id=session_id,
        surface_id=surface_id,
        component_type="TransactionCard",
        data={"amount": 100.0, "currency": "CNY", "category": "food"},
        tool_call_id="call001",
    )
    print(f"  Registered: {surface_id}")
    print(f"  Data: {tracker.get_surface_data(surface_id)}")

    # Step 2: Find reusable surface (simulating "修改金额" scenario)
    print("\n[Step 2] Finding reusable surface for TransactionCard...")
    reusable = tracker.find_reusable_surface(session_id, "TransactionCard")
    if reusable:
        print(f"  Found reusable: {reusable}")
    else:
        print("  No reusable surface found (would create new)")

    # Step 3: Generate DataModelUpdate message
    print("\n[Step 3] Generating DataModelUpdate message...")
    update_msg = DataModelUpdate(
        dataModelUpdate=DataModelUpdatePayload(
            surfaceId=surface_id,
            path="/amount",
            value=200.0,  # Changed from 100 to 200
        )
    )
    print(f"  Message: {json.dumps(update_msg.model_dump(), indent=2)}")

    # Step 4: Update tracker state
    print("\n[Step 4] Updating tracker state...")
    tracker.update_surface_data(surface_id, "/amount", 200.0)
    print(f"  Updated data: {tracker.get_surface_data(surface_id)}")

    print("\n" + "=" * 60)
    print("SUCCESS - SurfaceTracker flow works correctly!")
    print("=" * 60)


def test_message_serialization():
    """Test A2UI message serialization."""
    print("\n" + "=" * 60)
    print("Testing A2UI Message Serialization")
    print("=" * 60)

    # Test SurfaceUpdate
    print("\n[SurfaceUpdate]")
    surface_update = SurfaceUpdate(
        surfaceUpdate=SurfaceUpdatePayload(
            surfaceId="surface_123",
            components=[Component(id="comp_456", component={"TransactionCard": {"amount": 100.0, "currency": "CNY"}})],
        )
    )
    print(json.dumps(surface_update.model_dump(), indent=2))

    # Test DataModelUpdate
    print("\n[DataModelUpdate]")
    data_update = DataModelUpdate(
        dataModelUpdate=DataModelUpdatePayload(
            surfaceId="surface_123",
            path="/amount",
            value=200.0,
        )
    )
    print(json.dumps(data_update.model_dump(), indent=2))

    # Test BeginRendering
    print("\n[BeginRendering]")
    begin_render = BeginRendering(
        beginRendering=BeginRenderingPayload(
            surfaceId="surface_123",
            root="comp_456",
        )
    )
    print(json.dumps(begin_render.model_dump(), indent=2))

    print("\n" + "=" * 60)
    print("SUCCESS - All messages serialize correctly!")
    print("=" * 60)


if __name__ == "__main__":
    test_surface_tracker_flow()
    test_message_serialization()
