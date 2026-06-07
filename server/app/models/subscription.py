from datetime import datetime
from typing import Optional
from beanie import Document
from pydantic import Field
from beanie import PydanticObjectId

class Subscription(Document):
    # Link back to your main user document
    user_id: PydanticObjectId
    
    # Subscription access states
    is_active: bool = False
    entitlement_id: Optional[str] = None  # e.g., "premium_access"
    product_id: Optional[str] = None      # e.g., "com.app.monthly_premium"
    expiration_date: Optional[datetime] = None
    original_purchase_date: Optional[datetime] = None
    store: Optional[str] = None            # "PLAY_STORE", "APP_STORE"

    class Settings:
        name = "subscriptions"
        indexes = [
            "user_id"
        ]
