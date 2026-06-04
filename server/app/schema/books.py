from pydantic import BaseModel, Field, validator,ConfigDict ,BeforeValidator
from typing import Optional, List,Annotated
from datetime import datetime
from enum import Enum

class BooksCreate (BaseModel):
    message:str
    success:bool

class SortOrder(str, Enum):
    ASC = "asc"
    DESC = "desc"

class SortBy(str, Enum):
    TITLE = "title"
    AUTHOR = "author"
    PRICE = "price"
    RATING = "rating"
    CREATED_AT = "created_at"



class BooksFilterParams(BaseModel):
    
    # Pagination
    page: int = Field(default=1, ge=1, description="Page number (starts at 1)")
    limit: int = Field(default=20, ge=1, le=100, description="Items per page (max 100)")
    
    # Sorting
    sort_by: Optional[SortBy] = Field(default=SortBy.CREATED_AT, description="Field to sort by")
    sort_order: Optional[SortOrder] = Field(default=SortOrder.DESC, description="Sort order")
    
    # Search
    search: Optional[str] = Field(default=None, min_length=2, description="Search in title, author, description")
    
    # Filters
    author: Optional[str] = Field(default=None, description="Filter by author name")
    min_price: Optional[float] = Field(default=None, ge=0, description="Minimum price")
    max_price: Optional[float] = Field(default=None, ge=0, description="Maximum price")
    min_rating: Optional[float] = Field(default=None, ge=0, le=5, description="Minimum rating (0-5)")
    is_featured: Optional[bool] = Field(default=None, description="Show only featured books")
    is_free: Optional[bool] = Field(default=None, description="Show only free books")
    
    # Date filters
    published_after: Optional[datetime] = Field(default=None, description="Published after date")
    published_before: Optional[datetime] = Field(default=None, description="Published before date")
    
    # Multi-select filters (comma-separated)
    categories: Optional[str] = Field(default=None, description="Multiple categories (comma-separated)")
    authors: Optional[str] = Field(default=None, description="Multiple authors (comma-separated)")
    tags: Optional[str] = Field(default=None, description="Filter by tags (comma-separated)")
    
    @validator('max_price')
    def validate_price_range(cls, v, values):
        if v is not None and 'min_price' in values and values['min_price'] is not None:
            if v < values['min_price']:
                raise ValueError('max_price must be greater than min_price')
        return v


class Author(BaseModel):
    name: str
    bio: Optional[str] = None

PyObjectId = Annotated[str, BeforeValidator(str)]
class BookOut(BaseModel):

    id: PyObjectId = Field(alias="id")
    title: str
    author: Author
    rating: Optional[float]
    book_cover: Optional[str]
    collections:List[str]
    isFeatured: bool
    isFree: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

class PaginationMeta(BaseModel):
    current_page: int
    per_page: int
    total_items: int
    total_pages: int
    has_next: bool
    has_prev: bool

class BooksListResponse(BaseModel):
    success: bool
    data: List[BookOut]
    meta: PaginationMeta
    filters_applied: dict