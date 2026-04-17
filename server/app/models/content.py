from beanie import Document
from bson import ObjectId
from datetime import datetime
from pydantic import Field

class Content(Document):
    book_id:ObjectId
    title:str
    page:int
    content:str
    created_at:datetime=Field(default_factory=datetime.utcnow)
    updated_at:datetime=Field(default_factory=datetime.utcnow)

    class Settings:
        name="content"