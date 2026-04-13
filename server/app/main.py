from fastapi import FastAPI
from contextlib import asynccontextmanager
from beanie import init_beanie
from models.user import User 
from models.books import Books 
from db.client import init_db

@asynccontextmanager
async def lifespan(app: FastAPI):
    client, db = await init_db()
    
    try:
        await init_beanie(
            database=db,
            document_models=[User,Books]
        )
        print("✅ Database connected and Beanie initialized")
    except Exception as e:
        print(f"❌ Initialization failed: {e}")
        raise e

    yield
    # ---- SHUTDOWN ---- 
    client.close()
    print("❌ Database disconnected")

app = FastAPI(
    title="Stridely API",
    lifespan=lifespan
)
 
@app.get("/")
async def root():
    return {"hello": "fine"} 