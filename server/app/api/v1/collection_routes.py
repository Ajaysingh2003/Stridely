# from  fastapi import APIRouter,HTTPException,status,requests,Response,Depends
# from app.models.collection import Collection
# from app.repositories.collection_repo import create_collection
# from app.crud.middleware.auth import required_role 
# from app.schema.collection import CreateCollection as createCollectionRequest,CreatecollectionResponse,getCollection
# from app.service.collection import CollectionService 
# import os
# from typing import Any 
# collection_router = APIRouter()

# current_env = os.getenv("ENV", "development").lower()
# @collection_router.post("/create", response_model=CreatecollectionResponse, status_code=status.HTTP_201_CREATED)

# async def create_collection(response:Response,payload:createCollectionRequest):
#     try:

#         print(payload)
#         print(type(payload))
        
#         print("user data is here",user)

#         data= await create_collection_func(payload)

#         # collection_obj = data["data"]

#         return {"success":True,"data":data}
    
#     except Exception as e:
#         status_code = getattr(
#         e,
#         "status_code",
#         status.HTTP_500_INTERNAL_SERVER_ERROR
#     )

        
#         error_detail  = str(e)
#         print(e,"singh")
#         raise HTTPException(
#             status_code=status_code, 
#             detail= {
#             "success": False,
#             "message": error_detail if current_env == "development" else "Something went wrong"
#             }
#         )


# @collection_router.get("/get", response_model=getCollection, status_code=status.HTTP_200_OK)

# async def get_collection_route():
#     try:
#         # Call your database function
#         data = await get_collection_all()
        
#         if not data:
#             raise HTTPException(
#                 status_code=status.HTTP_404_NOT_FOUND,
#                 detail="Collection not found"
#             )
            
#         # Match your expected successful response structure exactly
#         return {
#             "success": True,
#             "data": data
#         }
        
#     except HTTPException:
#         # Re-raise FastAPIs HTTPExceptions so they bypass the response_model validation
#         raise
#     except Exception as e:
#         # Turn unexpected system errors into clean HTTP responses
#         raise HTTPException(
#             status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
#             detail={
#                 "success": False,
#                 "message": str(e)
#             }
#         )



import os
from typing import List, Any
from fastapi import APIRouter, HTTPException, status, Response, Depends

from app.crud.middleware.auth import required_role 
from app.schema.collection import (
    CreateCollection as createCollectionRequest,
    CreatecollectionResponse,
    getCollection
)
from app.service.collection import CollectionService 

collection_router = APIRouter()
current_env = os.getenv("ENV", "development").lower()

# ---------------------------------------------------------
# 🚀 CREATE COLLECTION
# ---------------------------------------------------------
@collection_router.post(
    "/create", 
    response_model=CreatecollectionResponse, 
    status_code=status.HTTP_201_CREATED
)
async def create_collection(
    payload: createCollectionRequest,
    user: Any = Depends(required_role("admin"))
    ):
    try:
        # Service handles duplication check and creation logic
        data = await CollectionService.create(payload)

        return {
            "success": True,
            "data": data
        }
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail={
                "success": False,
                "message": str(e) if current_env == "development" else "Something went wrong"
            }
        )

# ---------------------------------------------------------
# 🚀 GET ALL COLLECTIONS
# ---------------------------------------------------------
@collection_router.get(
    "/get", 
    response_model=getCollection, 
    status_code=status.HTTP_200_OK
)
async def get_collection_route():
    try:
        # Call clean service layer method
        data = await CollectionService.get_all()
        
        return {
            "success": True,
            "data": data
        }
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail={
                "success": False,
                "message": str(e) if current_env == "development" else "Something went wrong"
            }
        )

# ---------------------------------------------------------
# 🚀 UPDATE COLLECTION (New)
# ---------------------------------------------------------
@collection_router.patch(
    "/update/{collection_id}", 
    response_model=CreatecollectionResponse, 
    status_code=status.HTTP_200_OK
)
async def update_collection_route(
    collection_id: str,
    payload: dict,  # Or replace with an UpdateCollection Pydantic schema
    user: Any = Depends(required_role("admin"))
):
    try:
        updated_data = await CollectionService.update(collection_id, payload)
        
        return {
            "success": True,
            "data": updated_data
        }
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail={
                "success": False,
                "message": str(e) if current_env == "development" else "Something went wrong"
            }
        )

# ---------------------------------------------------------
# 🚀 DELETE COLLECTION (New)
# ---------------------------------------------------------
@collection_router.delete(
    "/delete/{collection_id}", 
    status_code=status.HTTP_200_OK
)
async def delete_collection_route(
    collection_id: str,
    user: Any = Depends(required_role("admin"))
):
    try:
        await CollectionService.delete(collection_id)
        
        return {
            "success": True,
            "message": "Collection deleted successfully"
        }
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail={
                "success": False,
                "message": str(e) if current_env == "development" else "Something went wrong"
            }
        )
