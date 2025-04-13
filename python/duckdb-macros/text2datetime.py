from pathlib import Path

import duckdb

from util import using_connection

NAME = "text2datetime"
PREPARE_SQL_FILE = Path(__file__).parent / "test" / NAME / "prepare.sql"
EXPECTED_RESULTS_FILE = Path(__file__).parent / "test" / NAME / "expected.txt"

def _text2datetime(conn: duckdb.DuckDBPyConnection) -> None:
    with open(PREPARE_SQL_FILE, "r") as prepare_file:
        conn.execute(prepare_file.read())
    
    print("----DuckDB result----")
    conn.sql("SELECT i, text2datetime(value) FROM t2ts").show(max_rows=1000)

    if EXPECTED_RESULTS_FILE.exists():
        print("----Postgres result----")
        with open(EXPECTED_RESULTS_FILE, "r") as expected_file:
            print(expected_file.read())

def main() -> None:
    with using_connection() as conn:
        _text2datetime(conn)
    

if __name__ == "__main__":
    main()