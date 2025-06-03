from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import List
from config import get_connection
from models import (
    AccountInDB, AccountCreate, AccountUpdate,
    SessionInDB, SessionCreate, SessionUpdate
)

app = FastAPI(title="Lab6 RESTful API - Account & Session")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ======== HELPER FUNCTIONS ==========

def fetch_all(table: str):
    with get_connection() as conn:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(f"SELECT * FROM {table}")
        return cursor.fetchall()

def fetch_by_id(table: str, key: str, value: int):
    with get_connection() as conn:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(f"SELECT * FROM {table} WHERE {key} = %s", (value,))
        result = cursor.fetchone()
        if not result:
            raise HTTPException(status_code=404, detail=f"{table.capitalize()} not found")
        return result

def insert_data(query: str, values: tuple):
    with get_connection() as conn:
        cursor = conn.cursor()
        try:
            cursor.execute(query, values)
            conn.commit()
        except Exception as e:
            conn.rollback()
            raise HTTPException(status_code=500, detail=str(e))

def update_data(table: str, key: str, value: int, update_data: dict):
    if not update_data:
        raise HTTPException(status_code=400, detail="No data to update")
    fields = ', '.join(f"{k} = %s" for k in update_data)
    query = f"UPDATE {table} SET {fields} WHERE {key} = %s"
    with get_connection() as conn:
        cursor = conn.cursor()
        try:
            cursor.execute(query, list(update_data.values()) + [value])
            conn.commit()
        except Exception as e:
            conn.rollback()
            raise HTTPException(status_code=500, detail=str(e))

def delete_by_id(table: str, key: str, value: int):
    with get_connection() as conn:
        cursor = conn.cursor()
        try:
            cursor.execute(f"DELETE FROM {table} WHERE {key} = %s", (value,))
            conn.commit()
            if cursor.rowcount == 0:
                raise HTTPException(status_code=404, detail=f"{table.capitalize()} not found")
        except Exception as e:
            conn.rollback()
            raise HTTPException(status_code=500, detail=str(e))

# ========== ACCOUNT ENDPOINTS ===========
@app.get("/account", response_model=List[AccountInDB], tags=["Account"])
async def get_all_accounts():
    return fetch_all("Account")

@app.get("/account/{account_id}", response_model=AccountInDB, tags=["Account"])
async def get_account(account_id: int):
    return fetch_by_id("Account", "id", account_id)

@app.post("/account", response_model=dict, status_code=201, tags=["Account"])
async def create_account(account: AccountCreate):
    insert_data(
        "INSERT INTO Account (settings, name, email) VALUES (%s, %s, %s)",
        (account.settings, account.name, account.email)
    )
    return {"message": "Account added"}

@app.put("/account/{account_id}", response_model=AccountInDB, tags=["Account"])
async def update_account(account_id: int, account_update: AccountUpdate):
    update_data("Account", "id", account_id, account_update.model_dump(exclude_unset=True))
    return await get_account(account_id)

@app.delete("/account/{account_id}", response_model=dict, tags=["Account"])
async def delete_account(account_id: int):
    delete_by_id("Account", "id", account_id)
    return {"message": f"Account with id {account_id} deleted"}

# ========== SESSION ENDPOINTS ===========
@app.get("/session", response_model=List[SessionInDB], tags=["Session"])
async def get_all_sessions():
    return fetch_all("Session")

@app.get("/session/{session_id}", response_model=SessionInDB, tags=["Session"])
async def get_session(session_id: int):
    return fetch_by_id("Session", "id", session_id)

@app.post("/session", response_model=dict, status_code=201, tags=["Session"])
async def create_session(session: SessionCreate):
    insert_data(
        "INSERT INTO Session (start_time, end_time, Account_id) VALUES (%s, %s, %s)",
        (session.start_time, session.end_time, session.account_id)
    )
    return {"message": "Session added"}

@app.put("/session/{session_id}", response_model=SessionInDB, tags=["Session"])
async def update_session(session_id: int, session_update: SessionUpdate):
    update_data("Session", "id", session_id, session_update.model_dump(exclude_unset=True))
    return await get_session(session_id)

@app.delete("/session/{session_id}", response_model=dict, tags=["Session"])
async def delete_session(session_id: int):
    delete_by_id("Session", "id", session_id)
    return {"message": f"Session with id {session_id} deleted"}

# ========= START SERVER ==========
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)
