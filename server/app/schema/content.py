from pydantic import BaseModel,ConfigDict,Field
from typing import List
from beanie import PydanticObjectId
from app.models.content import Content

class CreateContentType(BaseModel):
    book_id:PydanticObjectId
    title:str
    page:int
    content:str

class ContentResponse(BaseModel):
    data:List[Content]
    success:bool

class CreateContentResponse(BaseModel):
    data:CreateContentType
    success:bool

class UpdateContentResponse(BaseModel):
    success: bool
    data: Content