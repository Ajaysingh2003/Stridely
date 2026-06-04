from fastapi import APIRouter, HTTPException, status,Response
from app.schema.books import BooksCreate
from app.models.books import Books
from app.repositories.books_repo import create_book_repo

from typing import Dict, List, Optional
from datetime import datetime
from beanie import PydanticObjectId

async def create_new_book(payload: Books):
    check = await Books.find_one(Books.title == payload.title)

    if check:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, 
            detail="Books With This Title already Exist's"
        )
    
    book_data=payload.model_dump()

    book=await create_book_repo(book_data)
    
    # print(book,"chiru")
    # print(book,"leah")
    if not book["success"] :
        print(book,"13")
        return {"success":False,"message": str(book['error'])} 

    return book
from beanie.operators import RegEx, And, Or, In, GTE, LTE


async def get_books(
    filters: Dict,
    sort_by: str = "created_at",
    sort_order: str = "desc",
    skip: int = 0,
    limit: int = 20
) -> Dict[str, any]:
    
    # Build query conditions
    conditions = []
    
    # Search across multiple fields
    if filters.get("search"):
        search_term = filters["search"]
        search_conditions = [
            RegEx(Books.title, search_term, "i"),
            RegEx(Books.author, search_term, "i"),
        ]
        conditions.append(Or(*search_conditions))
    
    if filters.get("collection"):

        collection_val=filters["collection"]

        if isinstance(collection_val, list):
            conditions.append(In(Books.collections, collection_val))
        else:
            conditions.append(Books.collections == collection_val)


    
    # Author filter (single)
    if filters.get("author"):
        author_name = filters.get("author", {})
        # print(author_data,"leah")
        conditions.append(RegEx(Books.author.name, author_name, "i"))
    
    # Authors filter (multiple - exact match)
    if filters.get("authors"):
        print("leah")
        conditions.append(In(Books.author.name, filters["authors"]))
    
    
    # Free books
    if filters.get("is_free") is not None:
        print("applied",filters["is_free"])
        conditions.append(Books.isFree==filters["is_free"])
    
    # Rating filter
    if filters.get("min_rating") is not None:
        conditions.append(Books.rating >= filters["min_rating"])
    
    # Featured filter
    if filters.get("is_featured") is not None:
        conditions.append(Books.isFeatured == filters["is_featured"])
    
    
    
    
    # Tags filter (array contains any)
    if filters.get("tags"):
        conditions.append(In(Books.tags, filters["tags"]))
    
    # Build final query
    if conditions:
        query = Books.find(And(*conditions))
    else:
        query = Books.find_all()
    
    # Get total count before pagination
    total_count = await query.count()
    
    # Apply sorting
    sort_direction = "+" if sort_order == "asc" else "-"
    sort_field = f"{sort_direction}{sort_by}"
    
    # Apply pagination and execute
    books = await query.sort(sort_field).skip(skip).limit(limit).to_list()
    
    print(books,"leah-luli")
    return {
        "books": books,
        "total": total_count
    }