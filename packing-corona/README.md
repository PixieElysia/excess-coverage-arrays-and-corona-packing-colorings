# Packing colorings of paths and cycles with an edge attached at every vertex

**AI-assisted research preprint · Revision draft for version 0.3.** Author attribution pending human review.

For base order $n\ge 12$, the path corona $P_n\odot K_2$ requires seven colors. The cycle corona $C_n\odot K_2$ requires eight colors at $n=13$ and seven at every other order in this range. The base order counts centers, and the corona has $3n$ vertices. Each center is attached to the two endpoints of an edge. Distinct vertices of color $c$ must have distance strictly greater than $c$. [Graph diagram and conventions](paper.md#graph-and-indexing-conventions)

## Files

- [中文 Markdown](paper.zh-CN.md) · [中文 PDF](paper.zh-CN.pdf) · [Formalization](FORMALIZATION.md) · [Theorem coverage](THEOREM_COVERAGE.md)

- [Manuscript Markdown](paper.md) · [PDF](paper.pdf) · [LaTeX](paper.tex) · [Prior art](PRIOR_ART.md)
- [Lean exact values from graph edges](lean/EdgeColors.lean) · [Formal model and trust](lean/README.md) · [Trust model](../research/TRUST_MODEL.md)
- [Transfer enumeration](verify.py) · [Vertex search](graph_search.py) · [Results CSV](results.csv) · [Complete SAT assignments](../research/audit/outputs/graph-witnesses.json)
- [Verification log](verification.log) · [Reproducibility audit](../REPRODUCIBILITY_AUDIT.md)

## Original questions and contributions

Sampathkumar, Sivakaran and Unnikrishnan determined the path values at base orders 2–11 and the cycle values at 3–11. Their Theorems 2.1 and 3.1 also give general upper bounds from order 12. Their open questions are in Section 4, printed page 107. [Original paper](https://dergipark.org.tr/en/download/article-file/5580259#page=14)

| Problem | Prior result | Contribution here |
| --- | --- | --- |
| $P_n\odot K_2$ for $n\ge 12$ | Seven-color upper bound | The nonexistence of a six-coloring at $n=12$ gives the matching lower bound at every required length. |
| $C_{13}\odot K_2$ | Explicit eight-coloring | The nonexistence of a seven-coloring establishes optimality of the published witness. |
| $C_n\odot K_2$ for $n\ge 12$, $n\ne 13$ | Seven-color upper bound at most lengths and eight at $n=15,21$ and $n\equiv11\pmod{12}$ | Five words based at one transfer state give a uniform seven-color construction covering all these lengths. |

The earlier work on $p$-coronas of Laïche, Bouchemakh and Sopena treats independent leaves. The bounds in Section 3.2 of the path-aligned clique study by Furmańczyk, Gözüpek and Özkan use at least two backbone vertices per clique. The path of triangles here uses one. [Literature comparison](PRIOR_ART.md)

## Reproduction

From this directory, run these commands with Python 3.10 or newer. Both programs use the standard library.

```bash
python3 verify.py
python3 graph_search.py path 12 6
python3 graph_search.py cycle 13 7
python3 graph_search.py path 11 6
python3 graph_search.py cycle 13 8
```

The first program enumerates a transfer graph of states reachable from the empty-prefix state. For six colors, $F_j$ is the set of states reachable in exactly $j$ transitions. For seven colors, $b_j$ is the number of states that start at least one closed walk of length $j$. A state contributes one to $b_j$ regardless of how many eligible walks start there. The closed-walk criterion for a cycle of order $n$ and palette size $k$ applies for $n\ge 3$ and $n>k$.

```text
Six-color path frontier, lengths 0–12: 1 60 226 271 219 151 91 53 32 19 7 2 0
Reachable seven-color transfer graph: 2999 states, 11778 arcs
Closed-walk starting states, lengths 1–13: 0 0 0 0 0 24 0 96 0 56 0 74 0
```

The vertex search builds the graphs from their edges and computes shortest paths by breadth-first search. It tries all available colors and prunes branches that violate a packing constraint or the canonical ordering of the two interchangeable satellites. The two Python programs use different algorithms to cross-check the results. Independent human review remains pending.

| Base | Base order | Available colors | Decision | Visited search nodes |
| --- | ---: | ---: | --- | ---: |
| Path | 12 | 6 | UNSAT | 10,221 |
| Cycle | 13 | 7 | UNSAT | 162,103 |
| Path | 11 | 6 | SAT | 34 |
| Cycle | 13 | 8 | SAT | 201 |

A SAT witness assigns a color to every vertex. It is checked against distances computed from the graph's edges. The witness file includes both search-generated assignments and the separate eight-color construction of Sampathkumar, Sivakaran and Unnikrishnan on printed page 107. The vertex order within column $i$ is center $3i$ and satellites $3i+1,3i+2$. Node counts record the current implementation's branching behavior. From the repository root, the semantic acceptance check compares decisions independently of those counts and validates the archived assignments. [Witness data and provenance](../research/audit/outputs/graph-witnesses.json) · [Acceptance script](../research/audit/verify_graph_semantics.py)

```bash
python3 -B research/audit/verify_graph_semantics.py
```

The written proof concatenates five loops starting and ending at the same transfer state. Their lengths are 6, 8, 15, 17 and 19. They construct length 12 and the six consecutive lengths 14–19, and appending a length-six loop covers every higher length. The upper bound for $P_n\odot K_2$ follows by restriction from $C_{n+2}\odot K_2$. [Construction and residue classes](paper.md#residue-classes-and-restriction-to-paths)

## Build the formalization and PDF

```bash
(cd lean && lake build)
latexmk -pdf -interaction=nonstopmode -halt-on-error paper.tex
```

Lean certifies the finite nonexistence assertions through `bv_decide` with compiler-backed LRAT replay. Lean's upper-bound proof uses base templates of lengths 14–25 and repetition of a 12-column word, with a local distance reduction. The final theorems give the exact values in terms of walks on the graph edges. The transfer graph counts are computational outputs of the Python enumeration. [Formalization and trust](lean/README.md) · [Repository trust model](../research/TRUST_MODEL.md)

OpenAI Codex was used in discovery, proof development, implementation, formalization, verification and writing. This research draft awaits human attribution and independent review. The human authors of a submitted version are responsible for its content, originality and correctness. [Contribution and AI disclosure record](../CONTRIBUTIONS.md)

The revised manuscript includes direct written proofs of the finite obstructions. The path weight table can be checked by hand with the printed recurrence. The cycle proof uses forced equalities and parity. [Arithmetic and BFS recheck](../research/audit/verify_written_obstructions.py)
