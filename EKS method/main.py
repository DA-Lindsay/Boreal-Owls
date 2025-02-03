from fastapi import FastAPI, Depends, HTTPException
from pydantic import BaseModel, Field
import re
from typing import List

app = FastAPI()

# Sample in-memory database (replace with actual DB integration later)
users_db = {}
spelling_lists = {
    "Twirl": ["cat", "dog", "fish"],
    "Kit kat": ["elephant", "giraffe", "kangaroo"],
    "Bounty": ["hippopotamus", "rhinoceros", "chimpanzee"]
}

def validate_password(password: str):
    if len(password) < 8 or not re.search(r"[0-9]", password) or not re.search(r"[!@#$%^&*(),.?\":{}|<>]", password):
        raise HTTPException(status_code=400, detail="Password must be at least 8 characters long and include a number and a special character.")

class User(BaseModel):
    username: str
    password: str = Field(..., min_length=8)

class SpellingResult(BaseModel):
    username: str
    correct_words: int
    total_words: int

@app.post("/register")
def register(user: User):
    if user.username in users_db:
        raise HTTPException(status_code=400, detail="User already exists")
    validate_password(user.password)
    users_db[user.username] = {"password": user.password, "logins": 0, "tests_taken": 0, "accuracy": 0}
    return {"message": "User registered successfully"}

@app.post("/login")
def login(user: User):
    if user.username in users_db and users_db[user.username]["password"] == user.password:
        users_db[user.username]["logins"] += 1
        return {"message": "Login successful"}
    raise HTTPException(status_code=401, detail="Invalid credentials")

@app.get("/spellings/{group}")
def get_spellings(group: str):
    return spelling_lists.get(group, [])

@app.post("/submit-test")
def submit_test(result: SpellingResult):
    if result.username not in users_db:
        raise HTTPException(status_code=404, detail="User not found")
    users_db[result.username]["tests_taken"] += 1
    accuracy = (result.correct_words / result.total_words) * 100 if result.total_words > 0 else 0
    users_db[result.username]["accuracy"] = accuracy
    return {"message": "Test results recorded", "accuracy": accuracy}
