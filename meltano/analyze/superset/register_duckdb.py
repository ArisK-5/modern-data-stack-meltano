import os
from superset import db
from superset.models.core import Database

duckdb_path = os.path.abspath(
    os.getenv("ABS_DUCKDB_FILE_PATH", ".../duckdb/jaffle_shop.duckdb")
)
connection_uri = f"duckdb:///{duckdb_path}?access_mode=READ_ONLY"
db_name = "DuckDB (read-only)"

existing = db.session.query(Database).filter_by(database_name=db_name).first()

if not existing:
    print(f"Creating DuckDB connection at {connection_uri}")
    new_db = Database(database_name=db_name, sqlalchemy_uri=connection_uri)
    db.session.add(new_db)
    db.session.commit()
else:
    print(f"DuckDB connection already exists: {existing.sqlalchemy_uri}")
