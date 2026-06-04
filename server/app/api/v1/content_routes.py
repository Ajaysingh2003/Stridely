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

content_router = APIRouter()
current_env = os.getenv("ENV", "development").lower()

# ---------------------------------------------------------
# 🚀 CREATE COLLECTION
# ---------------------------------------------------------
@content_router.post(
    "/create", 
    response_model=CreatecollectionResponse, 
    status_code=status.HTTP_201_CREATED
)

async def create_content(
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
@content_router.get(
    "/get/{book_id}", 
    response_model=getCollection, 
    status_code=status.HTTP_200_OK
)
async def get_content(book_id:str):
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
@content_router.patch(
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
@content_router.delete(
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
