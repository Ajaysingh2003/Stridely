from pydantic import BaseModel,ConfigDict,Field
from typing import List
from beanie import PydanticObjectId

class CreateCollection(BaseModel):
    title:str
    thumbnail:str
    

class CollectionType(BaseModel):
    title:str
    id:PydanticObjectId
    thumbnail:str

class CreatecollectionResponse (BaseModel):
    data:CollectionType
    success:bool

class getCollection (BaseModel):
    success:bool
    data:list[CollectionType]

