from enum import Enum
from typing import Optional
from beanie import Document , Indexed ,init_beanie ,Link
from pydantic import EmailStr, Field,BaseModel
from datetime import datetime
from uuid import uuid4
from app.models.achivement import Achievements
from typing import List

class Streak (BaseModel):
    current:int=0
    longest:int=0
    last_active_data:datetime | None=None


class UserRole (str,Enum):
    ADMIN="admin"
    USER="user"

class User(Document):
    id: str = Field(default_factory=lambda: str(uuid4()))
    email : EmailStr =Indexed(unique=True)
    password:str
    name:str
    role:UserRole=Field(default=UserRole.USER)
    badges:List[Link[Achievements]]=Field(default_factory=list)
    img_url: Optional[str] = None
    is_premium:bool=False
    is_active: bool = True
    is_verified: bool = False
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
    streak:Streak=Streak()
    weakly_point:int=0
    class Settings:
        name="users"
    