from beanie import Document

class Collection(Document):
    title:str
    thumbnail:str
    class Settings:
        name="collection"