from app.models.collection import Collection
from beanie import PydanticObjectId
async def create_collection(data: dict):
    try:
        collection = Collection(**data)

        await collection.insert()

        return collection
    except Exception as e:
        raise e
    

async def get_collection(title:str):
    try:
        # data=await Collection.find_one({"title":title})
        data = await Collection.find_one(Collection.title == title)

        print(data,"leah jaye")
        return data
    except Exception as e:
        print(e,"lollollol")
        raise e
    
async def get_collection_all():
    try:
        # data=await Collection.find_one({"title":title})
        data = await Collection.find_all().to_list()

        print(data,"leah jaye")
        return data
    except Exception as e:
        print(e,"lollollol")
        raise e

async def update_collection(collection_id: str, update_data: dict):
    try:
        # Find the collection document by its unique ID
        collection = await Collection.get(PydanticObjectId(collection_id))
        
        if not collection:
            return None
            
        # Apply the updates using MongoDB's $set operator
        await collection.update({"$set": update_data})
        
        # Return the newly updated collection document
        return collection
    except Exception as e:
        print(e, "error during update")
        raise e

async def delete_collection(collection_id: str):
    try:
        # Find the collection document by its unique ID
        collection = await Collection.get(PydanticObjectId(collection_id))
        
        if not collection:
            return False
            
        # Delete the document from MongoDB
        await collection.delete()
        return True
    except Exception as e:
        print(e, "error during delete")
        raise e