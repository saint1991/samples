import os
from contextlib import contextmanager
from datetime import datetime
from pathlib import Path
from typing import Generator

import duckdb
from duckdb.typing import VARCHAR, TIMESTAMP

MACRO_DIR = Path(__file__).parent / "macros"

__ALL__ = ["using_connection"]


def _load_macros(conn: duckdb.DuckDBPyConnection) -> None:
    for file in os.listdir(MACRO_DIR):
        with open(MACRO_DIR / file, "r") as macro_file:
            macro_sql = macro_file.read()
            conn.execute(macro_sql)


def _register_udfs(conn: duckdb.DuckDBPyConnection) -> None:
    conn.create_function("try_strptime_ignoring_tz", try_strptime_ignoreing_tz, [VARCHAR, list[VARCHAR]], return_type=TIMESTAMP, null_handling='special', exception_handling="return_null", side_effects=False)    


def try_strptime_ignoreing_tz(timestamp_str: str, formats: list[str]) -> datetime | None:
    for fmt in formats:
        try:
            return datetime.strptime(timestamp_str, fmt).replace(tzinfo=None)
        except ValueError:
            continue
    return None


@contextmanager
def using_connection(db_path: str = ":memory:") -> Generator[duckdb.DuckDBPyConnection, None, None]:
    with duckdb.connect(db_path) as conn:
        _register_udfs(conn)
        _load_macros(conn)
        yield conn
