# from fastapi import APIRouter, HTTPException, status,Response
# from app.schema.collection import CreateCollection
# from app.models.collection import Collection
# from app.repositories.collection_repo import create_collection as create_collection_repo

# from typing import Dict, List, Optional
# from datetime import datetime
# from beanie import PydanticObjectId
# from app.db.client import init_db
# from app.repositories.collection_repo import get_collection ,get_collection_all ,update_collection,delete_collection

# async def create_collection(payload: CreateCollection):
#     try:
#         print("1")

#         exist = await get_collection(payload.title)

#         print("exist:", exist)

#         if exist:
#             raise HTTPException(
#                 status_code=400,
#                 detail="Collection already exists"
#             )

#         print("2")

#         collection_data = payload.model_dump()

#         print("3")

#         data = await create_collection_repo(collection_data)

#         print(data,"4")

#         return data

#     except Exception as e:
#         import traceback
#         traceback.print_exc()
#         raise

# async def get_collection_func():
#     try:
        
#         data =await get_collection_all()

#         print(data,"4")

#         return data

#     except Exception as e:
#         import traceback
#         traceback.print_exc()
#         raise e


import traceback
from typing import List, Optional
from fastapi import HTTPException, status
from beanie import PydanticObjectId

from app.schema.collection import CreateCollection
from app.models.collection import Collection
from app.repositories.collection_repo import (
    create_collection as create_collection_repo,
    get_collection,
    get_collection_all,
    update_collection,
    delete_collection
)

class CollectionService:
    
    @staticmethod
    async def create(payload: CreateCollection) -> Collection:
        """
        Creates a new collection if a matching title does not already exist.
        """
        try:
            # Check for existing collection with identical title
            existing = await get_collection(payload.title)
            if existing:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Collection already exists"
                )

            collection_data = payload.model_dump()
            new_collection = await create_collection_repo(collection_data)
            return new_collection

        except HTTPException:
            raise
        except Exception as e:
            traceback.print_exc()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to create collection: {str(e)}"
            )

    @staticmethod
    async def get_all() -> List[Collection]:
        """
        Retrieves all collections from the database.
        """
        try:
            return await get_collection_all()
        except Exception as e:
            traceback.print_exc()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to fetch collections: {str(e)}"
            )

    @staticmethod
    async def update(collection_id: str, update_payload: dict) -> Collection:
        """
        Validates the string ID, checks existence, and patches specified fields.
        """
        # Validate ID format before calling the database repo layer
        if not PydanticObjectId.is_valid(collection_id):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid collection ID format"
            )
            
        try:
            # Drop empty key values to prevent nullifying existing database keys
            sanitized_data = {k: v for k, v in update_payload.items() if v is not None}
            
            # collection=await Collection.get(collection_id)

            if sanitized_data.get("title") is not None:
    
    # 2. Search for ANY collection matching the new title
                existing_title = await Collection.find_one(
                    Collection.title == sanitized_data["title"]
                )

    # 3. If a collection exists AND it has a different ID, block it!
                if existing_title and str(existing_title.id) != collection_id:
                    raise HTTPException(
                        status_code=status.HTTP_400_BAD_REQUEST,
                        detail="Another collection with this title already exists"
                    )
                        
            # print("update,l",collection_id)

            
            updated_doc = await update_collection(collection_id, sanitized_data)
            if not updated_doc:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Collection not found to update"
                )
                
            return updated_doc

        except HTTPException:
            raise
        except Exception as e:
            traceback.print_exc()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to update collection: {str(e)}"
            )

    @staticmethod
    async def delete(collection_id: str) -> bool:
        """
        Validates ID format and removes the specified document.
        """
        if not PydanticObjectId.is_valid(collection_id):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid collection ID format"
            )
            
        try:
            is_deleted = await delete_collection(collection_id)
            if not is_deleted:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Collection not found to delete"
                )
                
            return True

        except HTTPException:
            raise
        except Exception as e:
            traceback.print_exc()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to delete collection: {str(e)}"
            )
