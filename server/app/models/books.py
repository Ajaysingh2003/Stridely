from typing import Optional, List
from beanie import Document, Indexed , Link
from pydantic import Field, BaseModel
from bson import ObjectId
from models.collection import Collection


class Author(BaseModel):
    name: str
    bio: Optional[str] = None

class Books(Document):
    title: str = Indexed(unique=True)
    author: Author
    collections:List[Link[Collection]]
    language: str
    book_cover:str
    isFree:bool
    isDraft:bool
    rating: float
    duration: Optional[str] = None
    whats_inside: Optional[str] = None
    takeaways: List[str] = Field(default_factory=list)
    quotes: List[str] = Field(default_factory=list)
    class Settings:
        name = "books"