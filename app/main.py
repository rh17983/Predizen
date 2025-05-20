# Import FastAPI, exception handling, and input validation
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from app.logic import process_input  # logic module

app = FastAPI()

# Define request body schema
class InputModel(BaseModel):
    """
    Input model for processing data.
    """

    number: int
    word: str


@app.get("/")
def read_root():
    """
    Root endpoint to check if the server is running.
    """

    return {"message": "Hello from FastAPI!"}

# Route to process input
@app.post("/process")
def process(data: InputModel):
    """
    Process the input data and return the result.
    """

    try:
        result = process_input(data.number, data.word)
        return {"result": result}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e)) from e  # Return 400 on validation error
