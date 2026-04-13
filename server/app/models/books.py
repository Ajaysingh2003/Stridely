from typing import Optional
from beanie import Document , Indexed ,init_beanie
from pydantic import EmailStr, Field

class Books(Document):
    Title : str =Indexed(unique=True)
    Strr:str

    class Setting:
        name="users"

