from app.models.user import User

async def create_user_repo(data: User):
    await data.insert()
    return data