# Packing colorings of paths and cycles with an edge attached at every vertex

For base order at least twelve, the path corona always requires seven colors. The cycle corona requires eight colors at order thirteen and seven at every other order. Each graph has three vertices per base vertex.

[Read the three-page research note](paper.pdf) · [LaTeX source](paper.tex)

## Original questions

Sampathkumar, Sivakaran and Unnikrishnan posed both questions in Section 4 on page 107. Their Theorems 2.1 and 3.1 give the earlier bounds. The 13-column eight-color witness in the note is theirs. [Journal record](https://dergipark.org.tr/en/pub/twmsjaem/article/1858469) · [Original PDF](https://dergipark.org.tr/en/download/article-file/5580259)

The 2017 work of Laïche, Bouchemakh and Sopena covers a different attachment, consisting of independent leaves. The November 2025 study of path-aligned graph products by Furmańczyk, Gözüpek and Özkan concerns a broader setting. Its complete-product bounds in Section 3.2 focus on at least two path vertices in each clique. Our path of triangles identifies one vertex of each clique with the base path. [2017 paper](https://arxiv.org/abs/1506.07248) · [2025 paper](https://arxiv.org/html/2511.12761v1)

## Reproduction

From this directory, run these commands with Python 3.10 or newer. Both programs use the standard library.

```sh
python3 verify.py
python3 graph_search.py path 12 6
python3 graph_search.py cycle 13 7
python3 graph_search.py path 11 6
python3 graph_search.py cycle 13 8
```

The first program enumerates the transfer graph, iterates Boolean reachability for closed walks and checks all five seven-color blocks against the same state. It independently checks the cyclic distances in all 25 ordered pairs of blocks and the explicit eight-coloring. Its tables are

```text
Six-color path frontier, lengths 0–12: 1 60 226 271 219 151 91 53 32 19 7 2 0
Reachable seven-color transfer graph: 2999 states, 11778 arcs
Closed-walk starting states, lengths 1–13: 0 0 0 0 0 24 0 96 0 56 0 74 0
```

The second program builds the graph from edges and computes shortest paths by breadth-first search. It exhaustively assigns vertex colors and prunes only choices that conflict with an assigned vertex or with the canonical ordering of the two interchangeable satellites. The default search order gives the following outcomes.

| Base | Base order | Available colors | Result | Visited search nodes |
| --- | ---: | ---: | --- | ---: |
| Path | 12 | 6 | UNSAT | 10,221 |
| Cycle | 13 | 7 | UNSAT | 162,103 |
| Path | 11 | 6 | SAT | 34 |
| Cycle | 13 | 8 | SAT | 201 |

The infinite families follow from the length argument in Section 4 of the note. The five loops have lengths 6, 8, 15, 17 and 19. They realize length 12, each of 14 through 19, and every increment by six.

## Rebuild the PDF

```sh
latexmk -pdf -interaction=nonstopmode -halt-on-error paper.tex
```

The PDF and its verification code were prepared using OpenAI Codex. This is a research draft and has not been submitted for journal review.
