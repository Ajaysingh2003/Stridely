from app.models.content import Content
from beanie import PydanticObjectId
from app.schema.content import CreateContentType
from fastapi import status,HTTPException

async def create_content(data: CreateContentType):
    try:
        content = Content(**data)

        await content.insert()

        return content
    except Exception as e:
        raise e
    
async def get_content(book_id:str):
    try:
        # data=await Collection.find_one({"title":title})

        if not PydanticObjectId.is_valid(book_id):
            print(f"Invalid book_id format received: {book_id}")
            return []
        data = await Content.find(Content.book_id == PydanticObjectId(book_id)).sort("+page").to_list()

        return data
        
    except Exception as e:
        # print(e,"lollollol")
        raise e
    
async def checkDuplicateTitle(title:str):
    try:
        # data=await Collection.find_one({"title":title})
        data = await Content.find_one(Content.title == title)
    
        # print(data,"leah jaye")
        return data
    except Exception as e:
        # print(e,"lollollol")
        raise e

async def check_duplicate_page(book_id:str,page:int):
    # Search for an existing document with the SAME book_id AND SAME page number
    existing_page = await Content.find_one(
        Content.book_id == book_id,
        Content.page == page
    )

    if existing_page:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Page {page} already exists for this book."
        )
    
async def update_content(content_id: str, update_data: dict):
    try:
        # Find the collection document by its unique ID
        content = await Content.get(PydanticObjectId(content_id))
        
        if not content:
            return None
            
        # Apply the updates using MongoDB's $set operator
        await content.update({"$set": update_data})
        
        # Return the newly updated collection document
        return content
    except Exception as e:
        print(e, "error during update")
        raise e

async def delete_content(content_id: str):

    try:
        content = await Content.get(PydanticObjectId(content_id))
        
        if not content:
            return False
            
        # Delete the document from MongoDB
        await content.delete()
        return True
    except Exception as e:
        print(e, "error during delete")
        raise e