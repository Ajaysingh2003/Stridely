from fastapi import APIRouter, HTTPException, status,Response ,Depends ,Request
from typing import List
from app.models.user import User
from app.schema.users import UserCreate, UserOut ,RegisterResponse ,UserLogin
from app.repositories.user_repo import create_user_repo
from app.core import hashing,jwt
from app.crud.middleware import auth
from app.service.users import register_new_user,user_login

user_router = APIRouter()

@user_router.post("/register", response_model=RegisterResponse, status_code=status.HTTP_201_CREATED)

async def register_user(response:Response,payload: UserCreate):

    user=await register_new_user(payload)
    # print(user,765)
    jwt_payload={
        "sub":user.id,
        "email":user.email,
        "role":user.role,

    }
    access_token= jwt.create_access_token(jwt_payload)

    response.set_cookie(
        key="access_token", 
        value=f"Bearer {access_token}", 
        httponly=True, 
        max_age=1800, # 30 minutes
        samesite="lax",
        secure=False  
    )

    print(user,"look")

    return {"message":"User Created Successfully","access_token":access_token,"user":user}

@user_router.get("/", response_model=List[UserOut])
async def list_users():
    """
    Fetches all users from the collection.
    """
    return await User.find_all().to_list()


@user_router.post("/login",response_model= RegisterResponse,status_code=status.HTTP_201_CREATED)
async def login(response:Response,payload:UserLogin):
     
    user = await user_login(payload)

    jwt_payload={
        "sub":user.id,
        "email":user.email,
        "role":user.role,
    }

    access_token= jwt.create_access_token(jwt_payload)

    response.set_cookie(
        key="access_token", 
        value=f"Bearer {access_token}", 
        httponly=True, 
        max_age=900000000000,
        samesite="lax",
        secure=False  
    )

    return {"message":"Login Successfully","access_token":access_token,"user":user}

   
@user_router.get("/me", response_model=User)
async def me(user_data: dict = Depends(auth.get_current_user_info)):

    print("test232", user_data)

    # Ensure user_data['id'] exists before querying
    user = await User.get(user_data["id"])
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    return user
   

