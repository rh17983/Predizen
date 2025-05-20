# This function performs the core computation logic
def process_input(number: int, word: str) -> int:
    if not word.isalpha():  # Ensure only letters
        raise ValueError("Word must be alphabetic")
    return number + len(word)  # Return modified integer
