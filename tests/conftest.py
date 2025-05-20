import pytest

# Fixture to reuse valid input
@pytest.fixture
def valid_payload():
    """ Fixture to provide valid payload for testing. """

    return {"number": 5, "word": "hello"}
