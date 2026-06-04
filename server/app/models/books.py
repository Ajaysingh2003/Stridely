from typing import Optional, List
from beanie import Document, Indexed , Link
from pydantic import Field, BaseModel
from bson import ObjectId
from app.models.collection import Collection
from datetime import datetime, timezone

class Author(BaseModel):
    name: str
    bio: Optional[str] = None

class Books(Document):
    title: str = Indexed(unique=True)
    author: Author
    collections:List[Optional[str]]=Field(default_factory=list)
    language: str
    book_cover:str
    isFree:bool=False
    isDraft:bool=True
    isFeatured:bool=False
    rating: float
    duration: Optional[str] = None
    whats_inside: Optional[str] = None
    takeaways: List[str] = Field(default_factory=list)
    quotes: List[str] = Field(default_factory=list)
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    updated_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))

    class Settings:
        name = "books"
        