"""Recompute all 19 published marginal equations directly from the 37 integers."""

import argparse
import csv
import hashlib
import io
import json
from math import comb, factorial
from pathlib import Path

HERE = Path(__file__).resolve().parent
DEFAULT_INPUT = HERE.parents[1] / "excess-arrays" / "t18.json"
DEFAULT_OUTPUT = HERE / "outputs" / "t18-residuals.csv"


def audit(certificate):
    t, k = certificate["strength"], certificate["columns"]
    x = certificate["multiplicities"]
    if type(t) is not int or type(k) is not int or (t, k) != (18, 36):
        raise ValueError("expected strength 18 and 36 columns")
    if not isinstance(x, list) or len(x) != 37:
        raise ValueError("expected 37 multiplicities")
    if any(type(value) is not int or value <= 0 for value in x):
        raise ValueError("each multiplicity must be a positive integer")

    buf = io.StringIO()
    out = csv.writer(buf, lineterminator="\n")
    out.writerow(("i", "lhs", "rhs", "residual"))
    for i in range(t + 1):
        lhs = sum(comb(k - t, j) * x[i + j] for j in range(k - t + 1))
        rhs = factorial(i) * factorial(t - i)
        if lhs != rhs:
            raise ValueError(f"equation {i}: residual {lhs-rhs}")
        out.writerow((i, lhs, rhs, lhs - rhs))

    rows = sum(comb(k, i) * value for i, value in enumerate(x))
    if min(x) != 350847 or rows != factorial(19):
        raise ValueError(f"minimum {min(x)} or row total {rows} differs")
    return buf.getvalue().encode("ascii"), rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true", help="verify the archived CSV (default)")
    mode.add_argument("--write", action="store_true", help="generate the residual CSV")
    args = parser.parse_args()
    raw = args.certificate.read_bytes()
    result, rows = audit(json.loads(raw))
    if args.write:
        args.output.write_bytes(result)
    elif args.output.read_bytes() != result:
        raise ValueError("archived CSV differs from the calculated equations")
    print(f"SHA-256 {hashlib.sha256(raw).hexdigest()}  {args.certificate.name}")
    print(f"19 residuals zero; 37 positive multiplicities; minimum 350847; row total {rows}")


if __name__ == "__main__":
    main()
