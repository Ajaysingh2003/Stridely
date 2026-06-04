
import traceback
from typing import List, Optional
from fastapi import HTTPException, status
from beanie import PydanticObjectId

from app.schema.content import CreateContentType
from app.models.content import Content
from app.repositories.content_repo import (
    create_content,
    get_content,
    delete_content,update_content,
    checkDuplicateTitle,
    check_duplicate_page
)

class ContentService:
    
    @staticmethod
    async def create(payload: CreateContentType) -> Content:
        """
        Creates a new content if a matching title does not already exist.
        """
        try:
            # Check for existing content with identical title
            existing = await checkDuplicateTitle(payload.title)
            if existing:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail={
                        "success":False,
                        "message":"Content already exists with this title."
                    }
                )
            # checking page duplicate

            await check_duplicate_page(payload.book_id,payload.page)

            # print(existingPage,"kira queen")

            # if existingPage :
            #     raise HTTPException (
            #         status_code=status.HTTP_400_BAD_REQUEST,
            #         detail=f"This book already have {payload.page} number page."
            #     )
            
            await Content.find_one(Content.page==payload.page)
            content_data = payload.model_dump()
            new_content = await create_content(content_data)
            return new_content

        except HTTPException:
            raise
        except Exception as e:
            traceback.print_exc()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to create content: {str(e)}"
            )

    @staticmethod
    async def get_all(book_id:str) -> List[Content]:
        """
        Retrieves all content from the database.
        """
        try:
            print(f"Querying for book_id: '{book_id}' (Length: {len(book_id)})")

            print("executed")
            return await get_content(book_id)
        
        except Exception as e:
            traceback.print_exc()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to fetch content: {str(e)}"
            )

    @staticmethod
    async def update(content_id: str, update_payload: dict) -> Content:
        """
        Validates the string ID, checks existence, and patches specified fields.
        """
        # Validate ID format before calling the database repo layer
        if not PydanticObjectId.is_valid(content_id):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid content ID format"
            )
            
        try:
            content_data=await Content.find_one(Content.id==PydanticObjectId(content_id))

            if content_data is None:
                raise HTTPException(
                    status_code=404,
                    detail="Invalid Content id"
                )

            # Drop empty key values to prevent nullifying existing database keys
            sanitized_data = {k: v for k, v in update_payload.items() if v is not None}
            
            # content=await content.get(content_id)

            if sanitized_data.get("title") is not None:
    
    # 2. Search for ANY content matching the new title
                existing_title = await Content.find_one(
                    Content.title == sanitized_data["title"]
                )

    # 3. If a content exists AND it has a different ID, block it!
                if existing_title and str(existing_title.id) != content_id:
                    raise HTTPException(
                        status_code=status.HTTP_400_BAD_REQUEST,
                        detail="Another content with this title already exists"
                    )
                        
            # print("update,l",content_id)

            if sanitized_data.get("page") is not None:
                existing_content=await Content.find_one(Content.book_id==content_data.book_id,Content.page==sanitized_data["page"])
            
                if existing_content:
                    raise HTTPException(status_code=400,detail=f"this book already have {sanitized_data['page']}")
            updated_doc = await update_content(content_id, sanitized_data)
            if not updated_doc:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="content not found to update"
                )
                
            return updated_doc

        except HTTPException:
            raise
        except Exception as e:
            traceback.print_exc()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to update content: {str(e)}"
            )

    @staticmethod
    async def delete(content_id: str) -> bool:
        """
        Validates ID format and removes the specified document.
        """
        if not PydanticObjectId.is_valid(content_id):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid content ID format"
            )
            
        try:
            is_deleted = await delete_content(content_id)
            if not is_deleted:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="content not found to delete"
                )
                
            return True

        except HTTPException:
            raise
        except Exception as e:
            traceback.print_exc()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to delete content: {str(e)}"
            )
