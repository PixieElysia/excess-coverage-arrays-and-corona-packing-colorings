"""Check printed weighted path bounds and cycle class inequalities with integers."""
from functools import lru_cache
from itertools import combinations
import json
from pathlib import Path

from verify_graph_semantics import distance_matrix


CERTIFICATE = Path(__file__).resolve().parent / "outputs/path-weight-certificate.json"


def prefix_bound(weights, fixed_color, color):
    """Evaluate the recurrence printed in the written proof."""
    prefix = [[], []]

    def lookup(role, column):
        return prefix[role][column] if column >= 0 else 0

    for i, pair in enumerate(weights):
        for h, weight in enumerate(pair):
            if (i, h) == (1, 0):
                permitted = color == fixed_color
            else:
                permitted = color != fixed_color or (i != 1 and abs(i - 1) + h > color)
            same_role = lookup(h, i - 1)
            if permitted:
                end = weight + max(
                    lookup(s, i - max(1, color + 1 - h - s)) for s in (0, 1)
                )
                same_role = max(same_role, end)
            prefix[h].append(same_role)
    return max(row[-1] for row in prefix)


def bfs_bound(weights, fixed_color, color, dist):
    """Find the actual maximum weight with the same allowed types using graph edges."""
    fixed = 3
    candidates = []
    for column, pair in enumerate(weights):
        for role, weight in enumerate(pair):
            vertex = 3 * column + role
            if vertex == fixed:
                allowed = color == fixed_color
            else:
                allowed = color != fixed_color or dist[fixed][vertex] > color
            if allowed and weight:
                candidates.append((vertex, weight))
    conflicts = [sum(1 << j for j, (v, _) in enumerate(candidates)
                     if dist[u][v] <= color) for u, _ in candidates]

    @lru_cache(maxsize=None)
    def maximum(available):
        if available == 0:
            return 0
        bit = available & -available
        i = bit.bit_length() - 1
        return max(maximum(available ^ bit),
                   candidates[i][1] + maximum(available & ~conflicts[i]))

    # One canonical satellite per column suffices for a single color because
    # a triangle has three distinct colors, and the satellites are symmetric.
    return maximum((1 << len(candidates)) - 1)


def check_path():
    document = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    if document["fixed_column"] != 1 or [c["fixed_color"] for c in document["cases"]] != list(range(1, 7)):
        raise ValueError("The certificate must cover all six colors of the second center")
    distances = distance_matrix("path", 12)
    for case in document["cases"]:
        fixed_color = case["fixed_color"]
        weights = document["weights"][case["weights"]]
        if len(weights) != 12 or any(len(pair) != 2 for pair in weights):
            raise ValueError(f"Bad weight array for fixed color {fixed_color}")
        if any(type(a) is not int or a < 0 for pair in weights for a in pair):
            raise ValueError(f"Noninteger or negative weight for fixed color {fixed_color}")
        total = sum(h + 2 * s for h, s in weights)
        bounds = [prefix_bound(weights, fixed_color, c) for c in range(1, 7)]
        independent = [bfs_bound(weights, fixed_color, c, distances) for c in range(1, 7)]
        if bounds != independent or bounds != case["bounds"] or not sum(bounds) < total == case["total"]:
            raise ValueError(f"Invalid weight bound for fixed color {fixed_color}")
        print(f"Path: fixed color {fixed_color}, weights {case['weights']}, bounds {bounds}, "
              f"sum {sum(bounds)} < total {total}")


def check_cycle():
    # This table uses only the individual gap inequalities from the paper.
    bounds = [19]
    for c in range(2, 8):
        allowed = [(m, q) for m in range(14) for q in range(m+1)
                   if m < 2 or (c-1)*m + 2*q <= 13]
        bound = max(m+q for m, q in allowed)
        bounds.append(bound)
        achievers = set((m, q) for m, q in allowed if m+q == bound)
        if c in (2, 4) and achievers != ({(13, 0)} if c == 2 else {(3, 2)}):
            raise ValueError(f"Invalid equality case for color {c}")
    if bounds != [19, 13, 6, 5, 4, 3, 2] or sum(bounds) != 52:
        raise ValueError("Cycle class weight bound is incorrect")
    # After rotation the single unassigned slot is a center in every even
    # column and a satellite in every odd column. Check all two-center /
    # one-satellite possibilities for the mandatory color 4.
    dist = distance_matrix("cycle", 13)
    for a, b in combinations(range(0, 13, 2), 2):
        for s in range(1, 13, 2):
            vertices = (3*a, 3*b, 3*s+1)
            if all(dist[u][v] > 4 for u, v in combinations(vertices, 2)):
                raise ValueError("Cycle parity obstruction failed on the actual corona")
    print(f"Cycle: bounds {bounds}, sum 52. Equality forces the incompatible color-4 gaps.")


if __name__ == "__main__":
    check_path()
    check_cycle()
