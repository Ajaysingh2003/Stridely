from fastapi import APIRouter, HTTPException, status,Response ,Depends ,Request,Query
from typing import List,Optional
from app.models.books import Books
from app.schema.users import UserCreate, UserOut ,RegisterResponse ,UserLogin
from app.schema.books import BooksCreate,BooksListResponse
from app.repositories.user_repo import create_user_repo
from app.core import hashing,jwt
from app.crud.middleware import auth
from app.service.books import create_new_book,get_books
import os
from dotenv import load_dotenv
from app.schema.books import (
    BooksCreate, 
    BooksFilterParams, 
    BooksListResponse,
    BookOut,
    PaginationMeta,
    SortBy,
    SortOrder
)
from app.models.content import Content
import math
books_router = APIRouter()
load_dotenv()

@books_router.post("/create", response_model=BooksCreate, status_code=status.HTTP_201_CREATED)
async def create_book(response:Response,payload: Books):
    
    data=await create_new_book(payload)
    current_env = os.getenv("ENV", "development").lower()
    print(data,"envaa")
    if not data["success"]:
        print(data,98)
        error_detail = data.get("message", "Unknown error")
        print(error_detail,123)
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, 
            detail= {
            "success": False,
            "message": error_detail if current_env == "development" else "Something went wrong"
            }
        )
        
        

    return {"success":True,"message":"Books Created Successfully"}


@books_router.get("/get-books", response_model=BooksListResponse, status_code=status.HTTP_200_OK)
async def getBooks(
    response: Response,
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    sort_by: SortBy = Query(SortBy.CREATED_AT),
    sort_order: SortOrder = Query(SortOrder.DESC),
    search: Optional[str] = Query(None, min_length=2),
    category: Optional[str] = Query(None),
    collection: str = Query(None),
    author: Optional[str] = Query(None),
    authors: Optional[str] = Query(None),
    is_free: Optional[bool] = Query(None),
    min_rating: Optional[float] = Query(None, ge=0, le=5),
    is_featured: Optional[bool] = Query(None),
    tags: Optional[str] = Query(None)
): # <--- Function body starts here
    
    filters = {
        "search": search,
        "author": author,
        "authors": authors.split(",") if authors else None,
        "is_free": is_free,
        "min_rating": min_rating,
        "is_featured": is_featured,
        "collection":collection,
        "tags": tags.split(",") if tags else None,
    }

    # Clean the filters
    filters = {k: v for k, v in filters.items() if v is not None and v != ""}
    
    skip = (page - 1) * limit

    result = await get_books(
        filters=filters,
        sort_by=sort_by.value,
        sort_order=sort_order.value,
        skip=skip,
        limit=limit
    )

    books = result["books"]
    total_count = result["total"]
    
    # Calculate pagination metadata
    total_pages = math.ceil(total_count / limit)
    
    meta = PaginationMeta(
        current_page=page,
        per_page=limit,
        total_items=total_count,
        total_pages=total_pages,
        has_next=page < total_pages,
        has_prev=page > 1
    )

    return {
        "success": True,
        "data": books,
        "meta": meta,
        "filters_applied": filters
    }