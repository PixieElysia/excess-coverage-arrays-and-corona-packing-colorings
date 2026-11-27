"""An independent exhaustive vertex-color search using all-pairs shortest paths."""
import argparse
from collections import deque


def make_graph(n, cycle):
    graph = [set() for _ in range(3 * n)]

    def edge(a, b):
        graph[a].add(b)
        graph[b].add(a)

    for i in range(n):
        center = 3 * i
        edge(center, center + 1)
        edge(center, center + 2)
        edge(center + 1, center + 2)
        if i:
            edge(center, center - 3)
    if cycle:
        edge(0, 3 * (n - 1))
    return graph


def distances(graph):
    result = []
    for start in range(len(graph)):
        row = [-1] * len(graph)
        row[start] = 0
        queue = deque([start])
        while queue:
            vertex = queue.popleft()
            for neighbor in graph[vertex]:
                if row[neighbor] == -1:
                    row[neighbor] = row[vertex] + 1
                    queue.append(neighbor)
        result.append(row)
    return result


def solve(n, k, cycle=False):
    if n < (3 if cycle else 1) or k < 1:
        raise ValueError("invalid length or palette")
    d = distances(make_graph(n, cycle))
    conflicts = [[tuple(v for v, distance in enumerate(row) if 0 < distance <= c)
                  for c in range(k + 1)] for row in d]
    palette = (1 << k) - 1
    nodes = 0

    def search(domains):
        nonlocal nodes
        nodes += 1
        # Positive masks are available colors; a negative singleton marks an assignment.
        active = [v for v, mask in enumerate(domains) if mask > 0]
        if not active:
            return [(-mask).bit_length() for mask in domains]
        v = min(active, key=lambda u: domains[u].bit_count())
        options = domains[v]
        while options:
            choice = options & -options
            options ^= choice
            c = choice.bit_length()
            child = domains.copy()
            child[v] = -choice
            for w in conflicts[v][c]:
                if child[w] > 0:
                    child[w] &= ~choice
                    if child[w] == 0:
                        break
            else:
                # The two satellites of a triangle have identical external neighborhoods.
                # Their order is free, so retain only assignments with left color < right color.
                if v % 3 == 1 and child[v + 1] > 0:
                    child[v + 1] &= palette ^ (2 * choice - 1)
                    if child[v + 1] == 0:
                        continue
                if v % 3 == 2 and child[v - 1] > 0:
                    child[v - 1] &= choice - 1
                    if child[v - 1] == 0:
                        continue
                solution = search(child)
                if solution is not None:
                    return solution
        return None

    witness = search([palette] * len(d))
    if witness is not None:
        for i, row in enumerate(d):
            for j in range(i):
                if witness[i] == witness[j] and row[j] <= witness[i]:
                    raise ValueError("invalid coloring returned by search")
    return witness, nodes


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("shape", choices=["path", "cycle"])
    parser.add_argument("n", type=int)
    parser.add_argument("k", type=int)
    args = parser.parse_args()
    witness, nodes = solve(args.n, args.k, args.shape == "cycle")
    print("SAT" if witness is not None else "UNSAT", "search nodes", nodes)
    if witness is not None:
        print(" ".join("".join(map(str, witness[i:i + 3])) for i in range(0, len(witness), 3)))
