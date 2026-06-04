import os
from motor.motor_asyncio import AsyncIOMotorClient,AsyncIOMotorDatabase

MONGO_URI = (
    f"mongodb://{os.getenv('MONGO_USER')}:"
    f"{os.getenv('MONGO_PASSWORD')}"
    "@mongodb:27017/?authSource=admin"
)

async def init_db():
    
    client = AsyncIOMotorClient(MONGO_URI)
    db = client["stridely"]
    
    return client,db 
