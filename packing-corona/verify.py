"""Reproduce the two finite obstructions and verify the upper-bound certificates."""
from collections import deque
from itertools import combinations, product


# Each three-digit column lists its center, then its two satellites.
BLOCKS = {
    6:  "123 412 127 312 126 512",
    8:  "123 412 123 712 123 612 123 512",
    15: "123 412 127 312 125 612 123 412 125 312 712 124 612 123 512",
    17: "123 412 123 712 123 512 123 612 123 412 125 312 712 124 612 123 512",
    19: "123 412 123 712 123 512 123 412 123 612 123 512 123 412 712 123 612 123 512",
}
ANCHOR = (-1, 0, 0, -1, 4, 3, 2)
# The construction for n=13 in Sampathkumar, Sivakaran & Unnikrishnan, p. 107.
THIRTEEN = "412 123 512 123 612 123 412 123 512 123 712 123 812"


def columns(word):
    return [tuple(map(int, triple)) for triple in word.split()]


def successors(state):
    """Yield every admissible column and the state before the next column."""
    satellites = [c for c, threshold in enumerate(state, 1) if threshold < 1]
    aged = [max(-1, t - 1) for t in state]
    for center, threshold in enumerate(state, 1):
        if threshold >= 0:
            continue
        for left, right in combinations(satellites, 2):
            if center in (left, right):
                continue
            new = aged.copy()
            new[center - 1] = center - 1
            new[left - 1] = left - 2
            new[right - 1] = right - 2
            yield (center, left, right), tuple(new)


def path_counts(k, n):
    frontier = {(-1,) * k}
    counts = [len(frontier)]
    for _ in range(n):
        frontier = {target for state in frontier for _, target in successors(state)}
        counts.append(len(frontier))
    return counts


def reachable_graph(k):
    """Return successor indices for all states reachable from the empty word."""
    empty = (-1,) * k
    index = {empty: 0}
    queue = deque([empty])
    graph = []
    while queue:
        targets = set()
        for _, target in successors(queue.popleft()):
            if target not in index:
                index[target] = len(index)
                queue.append(target)
            targets.add(index[target])
        graph.append(sorted(targets))
    return graph


def closed_walk_counts(graph, n):
    """Row i holds a bit for each endpoint of a walk of the given length from i."""
    rows = [1 << i for i in range(len(graph))]
    counts = []
    for _ in range(n):
        new_rows = []
        for targets in graph:
            row = 0
            for j in targets:
                row |= rows[j]
            new_rows.append(row)
        rows = new_rows
        counts.append(sum(bool(row & (1 << i)) for i, row in enumerate(rows)))
    return counts


def check_cycle(word, k):
    """Check packing directly against the distances on the quotient cycle."""
    n = len(word)
    for col in word:
        if len(col) != 3 or len(set(col)) != 3 or not all(1 <= c <= k for c in col):
            raise ValueError(f"invalid column {col}")
    for i, j in combinations(range(n), 2):
        base_distance = min(j - i, n - (j - i))
        for (h, c), (h2, c2) in product(enumerate(word[i]), enumerate(word[j])):
            distance = base_distance + int(h != 0) + int(h2 != 0)
            if c == c2 and distance <= c:
                raise ValueError(f"color {c} at distance {distance}, columns {i} and {j}")


def check_blocks():
    for length, word in BLOCKS.items():
        block = columns(word)
        if len(block) != length:
            raise ValueError(f"wrong length for {length}")
        state = ANCHOR
        for col in block:
            state = dict(successors(state))[col]
        if state != ANCHOR:
            raise ValueError(f"nonclosing block of length {length}")
    for a, b in product(BLOCKS.values(), repeat=2):
        check_cycle(columns(a) + columns(b), 7)
    check_cycle(columns(THIRTEEN), 8)


def main():
    path = path_counts(6, 12)
    graph = reachable_graph(7)
    arcs = sum(map(len, graph))
    closed = closed_walk_counts(graph, 13)
    check_blocks()
    expected_path = [1, 60, 226, 271, 219, 151, 91, 53, 32, 19, 7, 2, 0]
    expected_closed = [0, 0, 0, 0, 0, 24, 0, 96, 0, 56, 0, 74, 0]
    if path != expected_path or (len(graph), arcs) != (2999, 11778) or closed != expected_closed:
        raise ValueError("enumeration differs from the research note")
    print("Six-color path frontier, lengths 0–12:", *path)
    print("Reachable seven-color transfer graph:", len(graph), "states,", arcs, "arcs")
    print("Closed-walk starting states, lengths 1–13:", *closed)
    print("Verified five common-state blocks, their 25 ordered pairs and the 8-color C13 witness.")


if __name__ == "__main__":
    main()
