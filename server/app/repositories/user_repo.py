from app.db.client import db


def Create_user(data):
    return db.insert()