from app.core import jwt
from fastapi import APIRouter, HTTPException, Request,status,Response,Depends
from beanie import PydanticObjectId
from app.models.subscription import Subscription
from app.models.user import User
from app.models.books import Books

async def get_current_user_info(request: Request):
    auth_header = request.headers.get("Authorization")

    if not auth_header:
        raise HTTPException(
            status_code=401,
            detail="Missing Authorization header"
        )

    if not auth_header.startswith("Bearer "):
        raise HTTPException(
            status_code=401,
            detail="Invalid Authorization format"
        )

    token = auth_header.split(" ")[1]

    payload = jwt.decode_access_token(token)

    if not payload:
        raise HTTPException(
            status_code=401,
            detail="Invalid Token"
        )

    return {
        "id": payload.get("sub"),
        "role": payload.get("role")
    }

def required_role(*allowed_role):
    async def role_checker(user:dict=Depends(get_current_user_info)):

        if user["role"] not in allowed_role:
            raise HTTPException(
                status_code=403,
                detail={
                    "success":False,
                    "message":"Insufficient permissions"
                }
            )
        return user
    return role_checker

async def check_premium_book_access( book_id:str, user: dict = Depends(get_current_user_info)) -> dict:
   
    if user.get("role") == "admin":
        return user
    

    bookData =await Books.find_one(Books.id==PydanticObjectId(book_id)) 

    if not bookData:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"success": False, "message": "Target book not found"}
        )
    
    print(bookData,"kira")
    if bookData.isFree:
        return user

    user_id_str = user.get("id")
    print(user_id_str,"leah jaye")
    if  PydanticObjectId.is_valid(user_id_str):
        raise HTTPException(status_code=400, detail="Malformed payload token user identifier")

    print("lol")

    # subscription = await Subscription.find_one(
    #     Subscription.user_id == user_id_str
    # )

    userMetadata=await User.find_one(User.id==user_id_str)

    if not userMetadata or not userMetadata.is_premium:

        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "success": False,
                "message": "This premium content summary requires an active subscription."
            }
        )


    # # Block access if no record exists or if the entitlement tracking status is inactive
    # if not subscription or not subscription.is_active:
    #     raise HTTPException(
    #         status_code=status.HTTP_403_FORBIDDEN,
    #         detail={
    #             "success": False,
    #             "message": "This premium content summary requires an active subscription."
    #         }
    #     )



    return user  # Return user to the endpoint if cleared
