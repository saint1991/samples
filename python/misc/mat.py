from typing import Any, Callable
from decimal import Decimal

d1 = { "data": [
    {"df1_0001": "b", "df1_0002": "c", "measure_1": 0.1},
    {"df1_0001": "a", "df1_0002": "b", "measure_1": 0.4},
]}

d2 = { "data": [
    {"df1_0001": "a", "df1_0002": "b", "measure_1": 0.4},
    {"df1_0001": "b", "df1_0002": "c", "measure_1": 0.2},
]}

def axes_key(axes: list[str]) -> Callable[[dict[str, Any]], tuple[Any, ...]]:
    
    def key_fn(x: dict[str, Any]) -> tuple[Any, ...]:
        return tuple(x[axis] for axis in axes)
    
    return key_fn

def _float_eq(a: float | Decimal, b: float | Decimal, tolerance: float = 1e-9) -> bool:
    return abs(a - b) < tolerance


def _eq(a: Any, b: Any, tolerance: float = 1e-9) -> bool:
    if type(a) is float or type(b) is float:
        return _float_eq(a, b, tolerance)
    return a == b

def _strict_eq(a: Any, b: Any, tolerance: float = 1e-9) -> bool:
    if type(a) is not type(b):
        return False
    elif type(a) is float:
        return _float_eq(a, b)
    else:
        return a == b

def compare_records(d1: dict[str, list[dict[str, Any]]], d2: dict[str, list[dict[str, Any]]], axes: list[str], eq_fn: Callable[[Any, Any, float], bool] = _eq) -> bool:
    records1 = d1["data"]
    records2 = d2["data"]

    if len(records1) != len(records2):
        raise AssertionError("The number of records does not match.")
    
    key_fn = axes_key(axes)
    sorted1 = sorted(records1, key=key_fn)
    sorted2 = sorted(records2, key=key_fn)

    for record1, record2 in zip(sorted1, sorted2):
        for key, value in record1.items():
            comparison = record2.get(key)
            if not eq_fn(value, comparison):
                raise AssertionError(f"records does not match: {repr(record1)} != {repr(record2)}")

    for record1, record2 in zip(records1, records2):
        key1 = key_fn(record1)
        key2 = key_fn(record2)
        if key1 != key2:
            raise AssertionError(f"The result values matched but the order of records does not match.")

compare_records(d1, d2, ["df1_0001", "df1_0002"])