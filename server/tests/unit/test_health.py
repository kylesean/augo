def test_health_check(client):
    response = client.get("/health")
    # Even if services are down (503), the response format should be consistent
    assert response.status_code in [200, 503]

    json_data = response.json()
    # success_response format check
    assert "code" in json_data
    assert "message" in json_data
    assert "data" in json_data

    # Check data content
    data = json_data["data"]
    assert "status" in data
    assert "components" in data
