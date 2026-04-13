from typing import Optional
from beanie import Document , Indexed ,init_beanie
# from pydantic import string
from pydantic import EmailStr, Field,BaseModel
from datetime import datetime


class Streak (BaseModel):
    current:int=0
    longest:int=0
    last_active_data:datetime | None=None

class User(Document):
    email : EmailStr =Indexed(unique=True)
    password:str
    name:str
    streak:Streak=Streak()
    class Settings:
        name="users"
    