import os
import duckdb
from pathlib import Path

MACRO_DIR = Path(__file__).parent / "macros"

def _load_macros(conn: duckdb.DuckDBPyConnection) -> None:
    for file in os.listdir(MACRO_DIR):
        with open(MACRO_DIR / file, "r") as macro_file:
            macro_sql = macro_file.read()
            conn.execute(macro_sql)

def _main(conn: duckdb.DuckDBPyConnection) -> None:
    values = [
        '-34,338,492',
        '-34,338,492.654,878',
        '-34.123.2424.34',
        '<564646.654564>',
        '0.00001-',
        '5.01-',
        '5.01-',
        '5 4 4 4 4 8 . 7 8',
        '.01',
        '.0',
        '0',
        '.-01',
        '.01-',
        ' . 0 1-',
        '34,50',
        '123,000',
        '123456',
        '$1234.56',
        '$1234.56',
        '$1,234.56',
        '1234.56',
        '1,234.56',
        '42nd',
        '123456',
    ]

    create_query = "CREATE TABLE test (i INTEGER, value VARCHAR);"
    insert_query = f'INSERT INTO test VALUES {",".join([f"({i}, '{v}')" for i, v in enumerate(values)]) + f", ({len(values) + 1}, NULL)"}'
    conn.execute(create_query)
    conn.execute(insert_query)
    conn.sql("SELECT i, text2int(value) FROM test").show(max_rows=1000)

def main() -> None:
    with duckdb.connect() as conn:
        _load_macros(conn)
        _main(conn)




if __name__ == "__main__":
    main()
