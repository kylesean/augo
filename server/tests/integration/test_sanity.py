import pytest
from fastapi.testclient import TestClient

from app.main import app


def test_health_check_strict(client):
    """Integration test to verify that the health endpoint returns 200 OK
    and indicates that the database is healthy.
    This test runs in an environment where the database MUST be available (e.g. CI).
    """
    response = client.get("/health")

    # In integration test, we expect the system to be fully healthy
    assert response.status_code == 200

    data = response.json()
    assert data["code"] == 0
    assert data["data"]["status"] == "healthy"

    # Verify DB component is specifically mentioned as up/healthy if available
    components = data["data"].get("components", {})
    if "db" in components:
        # Implementation detail: check if db status is reported as true/up/healthy
        # Adjust based on actul health check implementation
        assert components["db"].get("status") == "up" or components["db"] is True
