from fastapi import APIRouter, HTTPException, status,Response
from app.schema.users import UserCreate, UserOut ,RegisterResponse ,UserLogin
from app.models.user import User
from app.repositories.user_repo import create_user_repo
from app.core import hashing,jwt
from typing import Optional

async def register_new_user(payload: UserCreate):
    existing_user = await User.find_one(User.email == payload.email)

    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, 
            detail="User with this email already exists"
        )
    
    user_data=payload.model_dump()

    user_data["password"]=hashing.hash_password(payload.password);
    
    new_user = User(**user_data)

    user=await create_user_repo(new_user)

    return user

async def user_login(payload:UserLogin):
    existing_user :Optional[User] = await User.find_one(User.email == payload.email)

    if existing_user==None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="User with this email Not exists"
        )
    
    if not existing_user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, 
            detail="This account is deactivated"
        )
    
    isValid=hashing.verify_password(payload.password,existing_user.password)

    if not isValid:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, 
            detail="Email and Password did not Match."
        )
    
    return existing_user