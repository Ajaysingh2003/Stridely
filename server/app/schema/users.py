from pydantic import BaseModel, EmailStr
from enum import Enum

class UserRole (str,Enum):
    ADMIN="admin"
    USER="user"


class UserOut(BaseModel):
    name: str
    email: EmailStr
    # role:UserRole
    
class RegisterResponse(BaseModel):
    message: str
    access_token: str
    user: UserOut
    # role:UserRole

class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str
    role:UserRole
    
class UserLogin(BaseModel):
    email:EmailStr
    password:str
    
class UserLogin(BaseModel):
    email:str
    password:str
    
