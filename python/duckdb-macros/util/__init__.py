import os
from contextlib import contextmanager
from pathlib import Path
from typing import Generator

import duckdb

MACRO_DIR = Path(__file__).parent / "macros"

__ALL__ = ["using_connection", "prepare"]

def _load_macros(conn: duckdb.DuckDBPyConnection) -> None:
    for file in os.listdir(MACRO_DIR):
        with open(MACRO_DIR / file, "r") as macro_file:
            macro_sql = macro_file.read()
            conn.execute(macro_sql)

@contextmanager
def using_connection(db_path: str = ":memory:") -> Generator[duckdb.DuckDBPyConnection, None, None]:
    with duckdb.connect(db_path) as conn:
        _load_macros(conn)
        yield conn
