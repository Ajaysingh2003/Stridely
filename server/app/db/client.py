from motor.motor_asyncio import AsyncIOMotorClient,AsyncIOMotorDatabase

MONGO_URI = "mongodb://localhost:27017"

async def init_db():
    client = AsyncIOMotorClient(MONGO_URI)
    db = client["stridely"]
    
    return client,db 
