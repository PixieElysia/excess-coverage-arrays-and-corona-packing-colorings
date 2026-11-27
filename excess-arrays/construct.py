"""Construct weight multiplicities by rounding intersection counts, then inverting."""

import argparse
import json
from math import factorial


def round_ratio(numerator, denominator):
    """Nearest integer, with an exact half rounded to the even integer."""
    quotient, remainder = divmod(numerator, denominator)
    twice = 2 * remainder
    return quotient + int(twice > denominator or (twice == denominator and quotient % 2 == 1))


def multiplicities(strength, columns):
    if not 1 <= strength <= columns:
        raise ValueError("expected 1 <= strength <= columns")
    rows = factorial(strength + 1)
    intersections = [round_ratio(rows, j + 1) for j in range(columns + 1)]
    # The value at index i after r passes counts i fixed ones and r fixed zeros.
    counts = [intersections[-1]]
    for _ in range(columns):
        intersections = [a - b for a, b in zip(intersections, intersections[1:])]
        counts.append(intersections[-1])
    return list(reversed(counts))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("strength", type=int)
    parser.add_argument("columns", type=int, nargs="?", help="defaults to twice the strength")
    args = parser.parse_args()
    width = 2 * args.strength if args.columns is None else args.columns
    counts = multiplicities(args.strength, width)
    if any(count < 0 for count in counts):
        parser.exit(1, "Rounding produced a negative multiplicity for these parameters.\n")
    print(json.dumps({"strength": args.strength, "columns": width, "multiplicities": counts}, indent=2))
