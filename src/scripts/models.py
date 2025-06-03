from pydantic import BaseModel
from typing import Optional
from datetime import datetime


# ---------- Account ----------
class AccountBase(BaseModel):
    login: str
    password: str
    role: str


class AccountCreate(AccountBase):
    pass


class AccountUpdate(BaseModel):
    login: Optional[str] = None
    password: Optional[str] = None
    role: Optional[str] = None


class AccountInDB(AccountBase):
    id: int

    class Config:
        from_attributes = True


# ---------- Session ----------
class SessionBase(BaseModel):
    token: str
    account_id: int
    created_at: datetime


class SessionCreate(SessionBase):
    pass


class SessionUpdate(BaseModel):
    token: Optional[str] = None
    account_id: Optional[int] = None
    created_at: Optional[datetime] = None


class SessionInDB(SessionBase):
    id: int

    class Config:
        from_attributes = True
