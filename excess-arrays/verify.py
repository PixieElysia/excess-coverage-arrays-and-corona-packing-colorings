"""Verify a binary excess array encoded by one multiplicity per row weight."""

import argparse
import json
from math import comb, factorial
from pathlib import Path


def verify(certificate):
    t = certificate["strength"]
    k = certificate["columns"]
    x = certificate["multiplicities"]
    if type(t) is not int or type(k) is not int or not 1 <= t <= k:
        raise ValueError("invalid strength or width")
    if len(x) != k + 1 or any(type(a) is not int or a < 0 for a in x):
        raise ValueError("a nonnegative integer is required for every weight")

    # Choose the remaining ones in the k-t unrestricted positions.
    for ones in range(t + 1):
        actual = sum(comb(k - t, j) * x[ones + j] for j in range(k - t + 1))
        expected = factorial(ones) * factorial(t - ones)
        if actual != expected:
            raise ValueError(f"weight {ones}: {actual} != {expected}")

    rows = sum(comb(k, i) * count for i, count in enumerate(x))
    if rows != factorial(t + 1):
        raise ValueError(f"wrong number of rows: {rows}")
    return f"t={t}, k={k}, equations={t + 1}, min={min(x)}, rows={rows}"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("files", nargs="+", type=Path)
    args = parser.parse_args()
    for path in args.files:
        data = json.loads(path.read_text(encoding="utf-8"))
        for record in data if isinstance(data, list) else [data]:
            print(verify(record))
