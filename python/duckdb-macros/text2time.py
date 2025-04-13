from pathlib import Path

import duckdb

from util import using_connection

PREPARE_SQL_FILE = Path(__file__).parent / "test" / "text2time" / "prepare.sql"
EXPECTED_RESULTS_FILE = Path(__file__).parent / "test" / "text2time" / "expected.txt"

def _text2time(conn: duckdb.DuckDBPyConnection) -> None:
    with open(PREPARE_SQL_FILE, "r") as prepare_file:
        conn.execute(prepare_file.read())
    
    print("----DuckDB result----")
    conn.sql("SELECT i, text2time(value) FROM t2time").show(max_rows=1000)

    print("----Postgres result----")
    with open(EXPECTED_RESULTS_FILE, "r") as expected_file:
        print(expected_file.read())

def main() -> None:
    with using_connection() as conn:
        _text2time(conn)
    

if __name__ == "__main__":
    main()