# Exact packing chromatic numbers of path and cycle coronas with an edge

**AI-assisted research manuscript.** Author attribution pending human review.

**27 November 2026 · Version 0.2** (machine-checked research draft)

[Manuscript PDF](paper.pdf) · [LaTeX source](paper.tex)

## Abstract

Sampathkumar, Sivakaran and Unnikrishnan (2026, Section 4) conjectured that $P_{12}\odot K_2$ requires seven packing colors and asked for the exact packing chromatic number of $C_n\odot K_2$ for all $n\ge 12$. We prove that $\chi_{\rho}(P_n\odot K_2)=7$ throughout this range and that $\chi_{\rho}(C_n\odot K_2)=7$ except at $n=13$, where it is $8$. A transfer calculation rules out six colors on the 36-vertex path corona and seven colors on the 39-vertex cycle corona. An independent exhaustive search on the graph vertices verifies both obstructions. Five explicit words that return to the same transfer state give seven-colorings for every required cycle length except $13$, where the published eight-coloring attains the lower bound. The complete formulas, expressed using walks on the graph edges, have been formalized in Lean 4.19.0.

## 1. Problem and definitions

All graphs are finite, undirected and simple. A *packing $k$-coloring* of $G$ assigns each vertex a color in $\{1,\ldots,k\}$, with any two distinct vertices of color $c$ at distance greater than $c$. The packing chromatic number $\chi_{\rho}(G)$ is the least such $k$. Write $P_n$ and $C_n$ for the path and cycle of order $n$. In the corona $G\odot K_2$, a fresh copy of $K_2$ is attached to each vertex of $G$ by joining that vertex to both ends of the copy. Each vertex of $P_n$ or $C_n$ is the center of a triangle, whose other two vertices are its satellites. Call these triangles the *columns*.

Sampathkumar, Sivakaran and Unnikrishnan gave exact values through base order eleven in their stated ranges and upper bounds at every larger order. Their conjecture for $P_{12}\odot K_2$ and problem for $C_n\odot K_2$ appear together on page 107. [Theorems 2.1 and 3.1 and the two questions](#1-sampathkumar-sivakaran-and-unnikrishnan-2026)

### Theorem 1

For every $n\ge 12$,

$$
\chi_{\rho}(P_n\odot K_2)=7,\qquad
\chi_{\rho}(C_n\odot K_2)=
\begin{cases}
8,&n=13,\\
7,&n\ne 13.
\end{cases}
$$

The lower bounds reduce to two finite instances. For the upper bounds we give five finite words that can be concatenated without a new packing violation at their boundaries.

## 2. A finite transfer graph

Assign height $0$ to a center and height $1$ to a satellite. Distinct vertices in one column have distance $1$. Between columns $i<j$, a walk must pass through both centers, and the shortest route uses a shortest path between them. With endpoint heights $h,g$, the distances are

$$
d_{\mathrm{path}}=j-i+h+g,\qquad
d_{\mathrm{cycle}}=\min(j-i,n-(j-i))+h+g .
$$

The two satellites are interchangeable. Write a column as a triple $(v,x,y)$ of distinct colors, with center color $v$ and satellite colors ordered by $x<y$.

### Threshold (1)

Just before column $j$, record for each color $c$ the threshold

$$
s_c=\max\!\left(\{-1\}\cup
    \{c-(j-i)-h : i<j\text{ and color }c
                  \text{ occurs at height }h\text{ in column }i\}\right).
\tag{1}
$$

It lies between $-1$ and $c-1$. The initial state is $e=(-1,\ldots,-1)$.

### Lemma 2

A triple extends a valid prefix precisely when $s_v<0$, $s_x<1$ and $s_y<1$. The next state satisfies

$$
s'_c=
\begin{cases}
c-1,&c=v,\\
c-2,&c\in\{x,y\},\\
\max(-1,s_c-1),&\text{otherwise}.
\end{cases}
$$

*Proof.* An occurrence of $c$ at height $h$ in column $i<j$ forbids a new occurrence at height $g$ exactly when $g\le c-(j-i)-h$. Taking the maximum gives the three tests. All old contributions decrease by one before the next column. If $c$ was just used at height $g$, admissibility gives $s_c-1\le g-2$, which is at most the new contribution $c-1-g$ because $c\ge 1$ and $g$ is $0$ or $1$. If $c$ was unused, only decrement and truncation remain. $\square$

Let $D_k$ be the directed graph of states reachable from $e$ under [Lemma 2](#lemma-2) for the palette $\{1,\ldots,k\}$. Merge parallel arcs for counting, while keeping track of an admissible label when a coloring is to be reconstructed. The state space has size at most $\prod_{c=1}^k(c+1)=(k+1)!$. Induction on the number of columns shows that packing $k$-colorings of a path corona, with satellites ordered by color in each column, correspond to the admissibly labeled walks of the appropriate length beginning at $e$.

### Lemma 3

If $n\ge 3$ and $n>k$, then $C_n\odot K_2$ has a packing $k$-coloring if and only if $D_k$ has a closed walk of length $n$.

*Proof.* Repeat the columns of a cycle coloring along the two-way infinite path. Two vertices with distinct images on the cycle are at least as far apart on the path as their images are on the cycle. Different copies of one vertex are at least $n>k$ apart. The infinite word therefore obeys the packing inequalities. [Equation (1)](#threshold-1) depends only on the last $k$ columns, since earlier contributions are at most $-1$. Reading the first period from $e$ gives the state of the infinite word at that boundary. The next period returns to the same state.

Conversely, choose an admissible label on each arc of a closed walk and repeat its labels and states in both directions. Applying the updates over any $k$ preceding columns eliminates dependence on the inherited state. A coordinate is either overwritten by a color occurrence or decremented to $-1$. The repeated state is thus given by [Equation (1)](#threshold-1) at every step, so the packing tests hold on the infinite path. For two vertices in different cycle columns, choose lifts separated by the shorter of the two cyclic column gaps. Their path distance equals the cycle distance. Vertices in the same column have distinct colors. $\square$

## 3. The finite lower bounds

For $k=6$, let $F_0=\{e\}$ and $F_{j+1}=\bigcup_{s\in F_j}N^+(s)$, where $N^+(s)$ denotes the successors of $s$ in $D_6$. For $k=7$, compute the sets of endpoints of walks of length $j$ in $D_7$ by

$$
R_0(s)=\{s\},\qquad
R_{j+1}(s)=\bigcup_{t\in N^+(s)}R_j(t),\qquad
b_j=\bigl\lvert\{s:s\in R_j(s)\}\bigr\rvert .
$$

Here $b_j$ counts the states that start a closed walk of length $j$. The reachable transfer graph $D_7$ has 2,999 states and 11,778 distinct arcs. The enumeration gives the counts below.

| $j$ | $\lvert F_j\rvert$ | $b_j$ |
| ---: | ---: | ---: |
| 0 | 1 | 2,999 |
| 1 | 60 | 0 |
| 2 | 226 | 0 |
| 3 | 271 | 0 |
| 4 | 219 | 0 |
| 5 | 151 | 0 |
| 6 | 91 | 24 |
| 7 | 53 | 0 |
| 8 | 32 | 96 |
| 9 | 19 | 0 |
| 10 | 7 | 56 |
| 11 | 2 | 0 |
| 12 | 0 | 74 |
| 13 | — | 0 |

Use the tests and update of [Lemma 2](#lemma-2) in the following enumeration.

```text
queue ← [e]
seen ← {e}
while queue is nonempty:
    s ← remove the first state from queue
    N+(s) ← empty set
    for all triples (v, x, y) in the palette with x < y and v outside {x, y}:
        if the triple passes the admissibility tests at s:
            t ← successor of s under the triple
            insert t into N+(s)
            if t is absent from seen:
                insert t into seen
                append t to queue
```

[Section 5](#5-computational-verification-and-reproducibility) describes two implementations of the finite checks.

Since $F_{12}$ is empty, $P_{12}\odot K_2$ has no packing six-coloring. It is a subgraph of each corona in [Theorem 1](#theorem-1). Deleting edges or vertices can only increase the distance of a surviving pair. Consequently each required packing chromatic number is at least seven. Since $b_{13}=0$, [Lemma 3](#lemma-3) strengthens the $n=13$ cycle lower bound to eight.

## 4. Coloring words for the upper bounds

In the display each three-digit word denotes one column. For example, $412$ denotes center color $4$ and satellite colors $1,2$. A continued line is part of the preceding word.

```text
 6   123 412 127 312 126 512
 8   123 412 123 712 123 612 123 512
15   123 412 127 312 125 612 123 412 125 312 712 124 612 123 512
17   123 412 123 712 123 512 123 612 123 412 125 312 712 124
     612 123 512
19   123 412 123 712 123 512 123 412 123 612 123 512 123 412
     712 123 612 123 512
```

Start each word at $a=(-1,0,0,-1,4,3,2)$. Applying the tests and updates in [Lemma 2](#lemma-2) returns to $a$ for each row. For example, the first column of the six-column word gives $(0,0,1,-1,3,2,1)$. Its penultimate state is $(0,0,1,0,-1,4,3)$, and the final column $512$ resets coordinates $5,1,2$ and decrements the rest, giving $a$.

For the reachability of $a$, first observe that $e\le a$ coordinatewise and the test and update for a fixed label preserve coordinatewise order. Every label admissible at the larger state is admissible at the smaller one, with ordered successor states. Therefore we can run two copies of the six-column word from $e$ or from $a$. The state at the end of these twelve columns depends only on the last seven columns, so the two runs end at the same state $a$. The five words thus give closed walks in $D_7$ with a common start.

Concatenation realizes length $12=6+6$ and the six consecutive lengths $14,\ldots,19$, using $6+8,\ 15,\ 8+8,\ 17,\ 6+6+6,\ 19$. Appending a six-column word yields the next length in each residue class modulo six. This covers every $n\ge 14$. [Lemma 3](#lemma-3) turns these walks into seven-colorings. For each path in [Theorem 1](#theorem-1), restrict the coloring of the cycle of order $n+2$ to a path of $n$ consecutive columns.

At $n=13$, the eight-coloring below is due to Sampathkumar, Sivakaran and Unnikrishnan. [Original construction on page 107](#1-sampathkumar-sivakaran-and-unnikrishnan-2026)

```text
412 123 512 123 612 123 412 123 512 123 712 123 812
```

Colors $4,5$ occur only on centers and each repeats at cyclic distance six. Colors $6,7,8$ occur once. Color $2$ always occurs on a satellite, so repeats have distance at least three. Color $3$ occurs on satellites in columns whose indices are odd, starting the index at zero. Their column separations are at least two and their vertex distances at least four. The centers of color $1$ are nonadjacent, and each satellite of color $1$ is distinct from its own center in color. This proves the upper bound at $n=13$ and completes [Theorem 1](#theorem-1).

## 5. Computational verification and reproducibility

The Python standard-library implementation enumerates the transfer graph and evaluates the recurrences in [Section 3](#3-the-finite-lower-bounds). It represents an endpoint set $R_j(s)$ by a bit mask and uses bitwise union to form $R_{j+1}(s)$. The program checks all five words in [Section 4](#4-coloring-words-for-the-upper-bounds) from the same state $a$. It also checks the cyclic distances in all 25 ordered pairs of the words and in the eight-coloring at $n=13$. [`verify.py`](verify.py)

The independent implementation builds the 36- and 39-vertex graphs from their adjacency lists and computes distances by breadth-first search from each vertex. It branches over available colors of an unassigned vertex, discarding that color from each nearby unassigned vertex whose distance would violate the packing condition. The two satellites of a column can be interchanged by an automorphism independently of all other columns, so fixing their relative color order loses no solution. At every branch the remaining domains contain all extensions of the assignments made so far that respect this order. An empty domain certifies that the branch cannot extend. A successful assignment is checked directly against the distance matrix before it is returned. [`graph_search.py`](graph_search.py)

| Base | Base order | Palette size | Search outcome | Nodes visited |
| --- | ---: | ---: | --- | ---: |
| Path | 12 | 6 | UNSAT | 10,221 |
| Cycle | 13 | 7 | UNSAT | 162,103 |
| Path | 11 | 6 | SAT | 34 |
| Cycle | 13 | 8 | SAT | 201 |

The two satisfiable runs check one nearby path case and the exceptional cycle with its optimal palette. Run these commands from this directory.

```bash
python3 verify.py
python3 graph_search.py path 12 6
python3 graph_search.py cycle 13 7
python3 graph_search.py path 11 6
python3 graph_search.py cycle 13 8
```

The repository includes the machine-readable search summary and the build and computation record. [`results.csv`](results.csv) · [`verification.log`](verification.log)

## 6. Machine-checked proof

The proof compiles with Lean 4.19.0 and its bundled library. The graph formalization uses vertices indexed by a column and a role (center or one of two satellites). It defines an edge relation for each corona and walks of given length. To establish the distance formulas, it bounds the length of any walk below by the claimed distance, then constructs a walk attaining that distance. The exact packing results are stated directly in terms of the lengths of walks between distinct same-color vertices.

| Lean declaration | Mathematical content |
| --- | --- |
| [`no_path_six`, `no_cycle_seven`](lean/Bridge.lean) | Finite obstructions for the distance inequalities |
| [`seven_upper`, `eight_upper`](lean/Upper.lean) | Explicit upper bounds for all required cycles |
| [`path_distance_attained`, `cycle_distance_attained`](lean/Attainment.lean) | Walks attaining the respective distance formulas |
| [`path_exact_on_edges`, `cycle_exact_on_edges`](lean/EdgeColors.lean) | Exact packing chromatic numbers for every $n\ge 12$ |

The finite lower bounds transfer a hypothetical coloring to a bit-vector covering by color classes. Each color class is encoded by three bit vectors of column positions, one vector per vertex role. The bit-vector assertions test within-column disjointness and forbidden shifts or cyclic rotations at small column gaps. They exclude even a cover by such classes where different colors may overlap. Lean's `bv_decide` proves the two assertions by checking LRAT unsatisfiability certificates. [`Bridge.lean`](lean/Bridge.lean) · [`GraphProof.lean`](lean/GraphProof.lean)

The upper bounds use the words of [Section 4](#4-coloring-words-for-the-upper-bounds) in a separate verification of the local distance tests. Every $n\ge 14$ can be written $n=b+12q$ with $14\le b\le 25$. The witness starts with a base word of length $b$ and appends $q$ repetitions of the length-twelve word formed by two copies of the length-six word. Lean checks the finite bases, including up to two repetitions. Because only forward offsets at most seven can impose new conditions for seven colors, every relevant pair in a longer template is mapped to a corresponding pair in a verified shorter template. The cases $n=12,13$ are checked directly. The final declarations convert the distance-based result to the walk formulation. [`Upper.lean`](lean/Upper.lean) · [`EdgeColors.lean`](lean/EdgeColors.lean)

Run `lake build` in `lean/` using the pinned toolchain. The axiom audit reports `propext`, `Classical.choice`, `Quot.sound` and `Lean.ofReduceBool` for both final declarations. The last is used by Lean 4.19's compiler-backed replay of the verified LRAT checker. There are no admitted declarations or project-defined axioms. [`lean-toolchain`](lean/lean-toolchain) · [Reproducibility audit](../REPRODUCIBILITY_AUDIT.md)

## 7. Comparison with earlier bounds

Theorem 2.1 of Sampathkumar, Sivakaran and Unnikrishnan already gives a seven-color upper bound for $P_n\odot K_2$ when $n\ge 12$. Here the obstruction at $n=12$ gives the matching lower bound for every larger path. Their Theorem 3.1 already bounds the cycle value above by seven at many lengths. Its eight-color upper bounds for $n=15,21$ and $n\equiv 11\pmod{12}$ are improved to seven by the words in [Section 4](#4-coloring-words-for-the-upper-bounds). At $n=13$ we prove that their eight-coloring is optimal. The previously determined smaller cases retain their original proofs. [Original results](#1-sampathkumar-sivakaran-and-unnikrishnan-2026)

Laïche, Bouchemakh and Sopena treat $p$-coronas with independent pendant vertices. The fixed attachment here is one edge between two satellites in a column. The path family here also lies in the framework of path-aligned clique products of Furmańczyk, Gözüpek and Özkan. The bounds in their Section 3.2 assume at least two backbone vertices per clique. Each triangle considered here has one backbone vertex. The repository's literature comparison records the scope of the searches and the evidence for each attribution. [Laïche, Bouchemakh and Sopena](#2-laïche-bouchemakh-and-sopena-2017) · [Furmańczyk, Gözüpek and Özkan](#3-furmańczyk-gözüpek-and-özkan-2025) · [Literature comparison](PRIOR_ART.md)

**Research status.** OpenAI Codex was used in discovery, proof development, formalization, verification and writing. This manuscript is a research draft with author attribution and independent human review pending.

## References

### 1. Sampathkumar, Sivakaran and Unnikrishnan (2026)

R. Sampathkumar, T. Sivakaran and R. Unnikrishnan. *Packing colorings of the corona product of the path $P_n$ and the cycle $C_n$ with an edge $K_2$*. TWMS Journal of Applied and Engineering Mathematics **16** (2026), no. 1, 94–108. [Publisher's full text](https://dergipark.org.tr/en/download/article-file/5580259)

### 2. Laïche, Bouchemakh and Sopena (2017)

D. Laïche, I. Bouchemakh and É. Sopena. *Packing coloring of some undirected and oriented coronae graphs*. Discussiones Mathematicae Graph Theory **37** (2017), 665–690. [DOI 10.7151/dmgt.1963](https://doi.org/10.7151/dmgt.1963)

### 3. Furmańczyk, Gözüpek and Özkan (2025)

H. Furmańczyk, D. Gözüpek and S. Özkan. *Packing coloring of graphs with long paths*. [arXiv:2511.12761](https://arxiv.org/abs/2511.12761) (2025).
