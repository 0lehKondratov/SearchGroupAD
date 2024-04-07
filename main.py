from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI()

# In-memory database substitute
db = []

# Define the data model for the data to be received
class Item(BaseModel):
    name: str
    description: Optional[str] = None

@app.post("/submit/")
async def submit_item(item: Item):
    db.append(item)
    return {"message": "Item added successfully"}

@app.get("/data/")
async def get_data():
    if not db:
        raise HTTPException(status_code=404, detail="No data found")
    return db
