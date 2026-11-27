"""Check archived SAT witnesses by BFS and reproduce SAT/UNSAT using the original solver."""

import argparse
import json
from collections import deque
from itertools import combinations, product
from pathlib import Path
from runpy import run_path

HERE = Path(__file__).resolve().parent
GRAPH = HERE.parents[1] / "packing-corona"
DEFAULT_OUTPUT = HERE / "outputs" / "graph-witnesses.json"
CASES = {
    ("path", 11, 6): "SAT", ("path", 12, 6): "UNSAT",
    ("cycle", 13, 7): "UNSAT", ("cycle", 13, 8): "SAT",
}
SOURCE = "https://dergipark.org.tr/en/download/article-file/5580259#page=14"


def distance_matrix(shape, n):
    """BFS on explicit K3 columns and adjacent centers, including the cycle seam."""
    if shape not in ("path", "cycle") or n < (3 if shape == "cycle" else 1):
        raise ValueError("invalid base graph")
    edges = []
    for i in range(n):
        edges.extend(combinations(range(3*i, 3*i+3), 2))
    edges.extend((3*i, 3*i+3) for i in range(n-1))
    if shape == "cycle":
        edges.append((3*n-3, 0))
    adj = [[] for _ in range(3*n)]
    for u, v in edges:
        adj[u].append(v)
        adj[v].append(u)
    matrix = []
    for u in range(3*n):
        row = [-1] * (3*n)
        row[u] = 0
        queue = deque([u])
        while queue:
            v = queue.popleft()
            for w in adj[v]:
                if row[w] == -1:
                    row[w] = row[v]+1
                    queue.append(w)
        matrix.append(row)
    return matrix


def verify_assignment(shape, n, k, columns):
    if not isinstance(columns, list) or len(columns) != n:
        raise ValueError("wrong number of columns")
    for col in columns:
        if not isinstance(col, list) or len(col) != 3:
            raise ValueError("each column needs three colors")
        if any(type(c) is not int or not 1 <= c <= k for c in col):
            raise ValueError("color outside palette")
    matrix = distance_matrix(shape, n)
    colors = [c for triple in columns for c in triple]
    for u, v in combinations(range(3*n), 2):
        c = colors[u]
        if c == colors[v] and matrix[u][v] <= c:
            raise ValueError(f"packing conflict: vertices {u},{v}, color {c}, distance {matrix[u][v]}")


def solve_cases():
    solve = run_path(str(GRAPH / "graph_search.py"))["solve"]
    records = []
    for (shape, n, k), expected in CASES.items():
        colors, visits = solve(n, k, cycle=(shape == "cycle"))
        outcome = "UNSAT" if colors is None else "SAT"
        if outcome != expected:
            raise ValueError(f"{shape} {n} palette {k}: expected {expected}, got {outcome}")
        columns = None
        if colors is not None:
            columns = [colors[i:i+3] for i in range(0, len(colors), 3)]
            verify_assignment(shape, n, k, columns)
        records.append(dict(base_graph=shape, n=n, k=k, outcome=outcome,
                            search_nodes=visits, colors_by_column=columns))
        print(f"{shape} {n}, {k} colors: {outcome}; observed search nodes {visits}")
    return records


def published_coloring():
    # Theorem 3.1(ix), pp. 106–107. At even i, x_i has color 2
    # and y_i color 1. Sorting the interchangeable satellites gives [1,2].
    even_centers = [4, 5, 6, 4, 5, 7, 8]
    return [[even_centers[i//2], 1, 2] if i % 2 == 0 else [1, 2, 3] for i in range(13)]


def verify_archive(document):
    if document["schema_version"] != 1:
        raise ValueError("unsupported graph witness schema")
    seen = set()
    for record in document["search"]:
        shape, n, k = record["base_graph"], record["n"], record["k"]
        case = (shape, n, k)
        if type(n) is not int or type(k) is not int or case in seen or case not in CASES:
            raise ValueError(f"unexpected or repeated case {case}")
        seen.add(case)
        if record["outcome"] != CASES[case]:
            raise ValueError(f"wrong archived outcome for {case}")
        if type(record["search_nodes"]) is not int or record["search_nodes"] < 0:
            raise ValueError("invalid search node count metadata")
        if CASES[case] == "SAT":
            verify_assignment(shape, n, k, record["colors_by_column"])
        elif record["colors_by_column"] is not None:
            raise ValueError(f"unexpected assignment for UNSAT case {case}")
    if seen != CASES.keys():
        raise ValueError("archived case missing")
    given = document["published_cycle_13"]
    if given["source"] != SOURCE or given["colors_by_column"] != published_coloring():
        raise ValueError("published coloring differs from Theorem 3.1(ix)")
    verify_assignment("cycle", 13, 8, given["colors_by_column"])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true", help="verify archived assignments (default)")
    mode.add_argument("--write", action="store_true", help="generate the witness data from a fresh search")
    args = parser.parse_args()
    if not args.write:
        verify_archive(json.loads(args.output.read_text(encoding="utf-8")))
    search = solve_cases()
    original = run_path(str(GRAPH / "verify.py"))
    published = published_coloring()
    if [list(map(int, triple)) for triple in original["THIRTEEN"].split()] != published:
        raise ValueError("original eight-color witness differs from its published source")
    verify_assignment("cycle", 13, 8, published)
    blocks = original["BLOCKS"]
    if sorted(blocks) != [6, 8, 15, 17, 19]:
        raise ValueError("unexpected block lengths")
    for a, b in product(blocks, repeat=2):
        word = [list(map(int, c)) for c in (blocks[a] + " " + blocks[b]).split()]
        verify_assignment("cycle", a+b, 7, word)
    if args.write:
        document = dict(schema_version=1, search=search,
                        published_cycle_13=dict(source=SOURCE, colors_by_column=published))
        verify_archive(document)
        args.output.write_text(json.dumps(document, indent=2) + "\n", encoding="utf-8")
    print("BFS checked the SAT assignments, the published eight-color witness and all 25 block pairs.")


if __name__ == "__main__":
    main()
