from unittest.mock import patch
import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

# Parametrized test to check various word lengths
@pytest.mark.parametrize("word,expected", [("hi", 7), ("abc", 8)])
def test_parametrized(word, expected):
    """
    Test the process function with different word lengths.
    """

    response = client.post("/process", json={"number": 5, "word": word})
    assert response.status_code == 200
    assert response.json()["result"] == expected


# Negative test for non-alphabetic word
def test_invalid_word():
    """
    Test the process function with a non-alphabetic word.
    """

    response = client.post("/process", json={"number": 5, "word": "123"})
    assert response.status_code == 400


# Marked test for basic valid case
@pytest.mark.smoke
def test_valid_input(valid_payload):
    """
    Test the process function with valid input.
    """

    response = client.post("/process", json=valid_payload)
    assert response.status_code == 200


# Mock the logic to simulate specific return value
def test_mock_logic():
    """
    Test the process function with mocked logic.
    """

    with patch("app.main.process_input", return_value=999):
        response = client.post("/process", json={"number": 1, "word": "a"})
        assert response.json()["result"] == 999
