from app.core import jwt
from fastapi import APIRouter, HTTPException, Request,status,Response,Depends

# from fastapi import Request, HTTPException

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
        return role_checker
    return role_checker