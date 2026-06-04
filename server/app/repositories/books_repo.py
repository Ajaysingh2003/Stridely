# app/repositories/books_repo.py
from app.models.books import Books, Author
from app.models.collection import Collection

async def create_book_repo(data: dict):
    
    try:
        author_obj = Author(**data.get("author", {}))

        book_payload = data.copy()
        book_payload["author"] = author_obj

        print(data,"123ajay")
        new_book = Books(**book_payload)

        await new_book.insert()
        
        return {"success":True,"data":new_book}
    except  Exception as e:
        return {"success":False,"error":e}