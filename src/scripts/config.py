import mysql.connector


def get_connection():
    return mysql.connector.connect(
        host="localhost",
        port="3306",
        user="root",
        password="280224",
        database="my_db"
    )