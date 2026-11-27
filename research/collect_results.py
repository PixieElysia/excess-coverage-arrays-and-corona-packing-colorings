"""Regenerate or verify the finite-result tables shipped with both research notes."""

import argparse
import csv
import io
import json
from math import factorial
from pathlib import Path
from runpy import run_path


ROOT = Path(__file__).resolve().parents[1]
ARRAYS = ROOT / "excess-arrays"
GRAPHS = ROOT / "packing-corona"


def array_results():
    construct = run_path(str(ARRAYS / "construct.py"))["multiplicities"]
    verify = run_path(str(ARRAYS / "verify.py"))["verify"]
    certificates = json.loads((ARRAYS / "small.json").read_text(encoding="utf-8"))
    strength_18 = json.loads((ARRAYS / "t18.json").read_text(encoding="utf-8"))
    header = ("strength", "columns", "rows", "equations", "minimum_multiplicity", "method")
    yield header
    for t in range(1, 23):
        k = 2 * t
        if t <= 16:
            record = certificates[t - 1]
            method = "stored_witness"
        else:
            record = {"strength": t, "columns": k, "multiplicities": construct(t, k)}
            method = "moment_rounding"
        if (record["strength"], record["columns"]) != (t, k):
            raise ValueError(f"Wrong parameter pair for strength {t}")
        if t == 18 and record != strength_18:
            raise ValueError("The rounded witness differs from t18.json")
        verify(record)
        yield t, k, factorial(t + 1), t + 1, min(record["multiplicities"]), method


def graph_results():
    solve = run_path(str(GRAPHS / "graph_search.py"))["solve"]
    yield "base_graph", "base_order", "vertices", "palette", "outcome", "search_nodes"
    for shape, n, k in (("path", 11, 6), ("path", 12, 6), ("cycle", 13, 7), ("cycle", 13, 8)):
        witness, nodes = solve(n, k, cycle=shape == "cycle")
        yield shape, n, 3 * n, k, "SAT" if witness is not None else "UNSAT", nodes


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="compare with the committed CSV files")
    args = parser.parse_args()
    for folder, rows in ((ARRAYS, array_results()), (GRAPHS, graph_results())):
        path = folder / "results.csv"
        buffer = io.StringIO()
        csv.writer(buffer, lineterminator="\n").writerows(rows)
        expected = buffer.getvalue()
        if args.check:
            if path.read_bytes() != expected.encode("utf-8"):
                parser.exit(1, f"{path.relative_to(ROOT)} differs from recomputed results.\n")
            print(f"{path.relative_to(ROOT)} verified")
        else:
            path.write_bytes(expected.encode("utf-8"))


if __name__ == "__main__":
    main()
