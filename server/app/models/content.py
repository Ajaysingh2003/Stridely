from beanie import Document,PydanticObjectId
from bson import ObjectId
from datetime import datetime
from pydantic import Field

class Content(Document):
    book_id:PydanticObjectId
    title:str
    page:int
    content:str
    created_at:datetime=Field(default_factory=datetime.utcnow)
    updated_at:datetime=Field(default_factory=datetime.utcnow)

    class Settings:
        name="content"
        indexes = [
            [
                ("book_id", 1), 
                ("page", 1)
            ]
        ]