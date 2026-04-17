from beanie import Document

class Achievements(Document):
    title:str
    icon:str
    condition:str
    
    class Settings:
        name="achievements"