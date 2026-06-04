from fastapi import FastAPI
from contextlib import asynccontextmanager
from beanie import init_beanie
# from models.user import User 
from app.models.user import User
from app.models.books import Books 
from app.models.subscription import Subscription 
from app.models.collection import Collection 
from app.models.content import Content 
from app.api.v1.users_routes import user_router
from app.db.client import init_db
from app.api.v1.books_routes import books_router
from app.api.v1.collection_routes import collection_router
from app.api.v1.content_routes import content_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    client, db = await init_db()
    
    try:
        await init_beanie(
            database=db,
            document_models=[User,Books,Collection,Subscription,Content]
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

app.include_router(user_router, prefix="/api/v1/users", tags=["Users"])
app.include_router(books_router, prefix="/api/v1/books", tags=["Books"])
app.include_router(collection_router, prefix="/api/v1/collection", tags=["Collection"])
app.include_router(content_router, prefix="/api/v1/content", tags=["Content"])

async def root():
    return {"hello": "fine"} 