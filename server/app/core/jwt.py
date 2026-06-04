import jwt
from datetime import datetime, timedelta, timezone
from typing import Optional

# Use environment variables for these in production!
SECRET_KEY = "kjjljfdjf980284823948" 
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 300

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=65)
    
    # Add the expiration time to the payload
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def decode_access_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except jwt.ExpiredSignatureError:
        return None # Token has expired
    except jwt.InvalidTokenError:
        return None # Token is fake or tampered with