from timeout_decorator import timeout, TimeoutError

from pathlib import Path
import duckdb
import traceback
import signal
import datetime

DATA_DIR = Path(__file__).parent / "data"
DB_PATH = DATA_DIR / "duckdb.db"

def dump_current_trace(signal_number, frame) -> None:
    """Dump the current stack trace to the console."""
    print("Current stack trace:")
    traceback.print_stack()

def print_time(msg: str) -> None:
    print(f"{msg} at {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")


@timeout(seconds=5, use_signals=True)
def run_heavy_query(conn: duckdb.DuckDBPyConnection) -> None:
    query = f"SELECT * FROM generate_series(1, 1000), parquet_scan('{DATA_DIR.absolute()}/videos.parquet') AS i;"
    rel = conn.sql(query)
    result = None
    try:
        result = rel.fetchall()
    except RuntimeError as e:
        if str(e) == "Query interrupted":
            print_time("Query interrupted!")
            conn.interrupt()
            print_time("conn interrupted!")
        pass
    return result

@timeout(seconds=5, use_signals=False)
def run_heavy_query2() -> None:
    with duckdb.connect(DB_PATH, read_only=False, config={"threads": 4, "memory_limit": "1G"}) as conn:
        query = f"SELECT * FROM generate_series(1, 1000), parquet_scan('{DATA_DIR.absolute()}/videos.parquet') AS i;"
        rel = conn.sql(query)
        result = None
        try:
            result = rel.fetchall()
        except RuntimeError as e:
            return result
        return result


def main() -> None:

    signal.signal(signal.SIGUSR1, dump_current_trace)

    with duckdb.connect(DB_PATH, read_only=False, config={"threads": 4, "memory_limit": "1G"}) as conn:
        for i in range(10):
            print(f"Running query {i + 1}...")
            try:
                run_heavy_query(conn)
            except TimeoutError:
                print("Timeout!")
                conn.interrupt()
                print("conn interrupted!")  
            except RuntimeError as e:
                if str(e) == "Query interrupted":
                    print("Query interrupted!")
                    conn.interrupt()
                    print("conn interrupted!")
                    

    print("End!")

if __name__ == "__main__":
    main()
