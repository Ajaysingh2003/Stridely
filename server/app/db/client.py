# from pymongo import MongoClient

# try:

#     client = MongoClient("mongodb://localhost:27017/", serverSelectionTimeoutMS=5000)
#     client.admin.command("ping")
#     db=client["stridely"]
#     userCollection=db["users"]
#     print(db.name)
#     print("✅ Connected to MongoDB successfully!")
    
# except Exception as e:
#     print("❌ Connection failed:")
#     print(e)

# db/client.py
from motor.motor_asyncio import AsyncIOMotorClient,AsyncIOMotorDatabase

MONGO_URI = "mongodb://localhost:27017"

async def init_db():
    client = AsyncIOMotorClient(MONGO_URI)
    db = client["stridely"]


    # await db.users.insert_one({
    #     "name": "Ajay",
    #     "email": "ajay@example.com"
    # })
    
    return client,db 

# async def test_insert(db: AsyncIOMotorDatabase):
    
#     return str(result.inserted_id)