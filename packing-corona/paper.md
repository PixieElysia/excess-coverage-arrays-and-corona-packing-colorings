# Exact packing chromatic numbers of path and cycle coronas with an edge

**CHATGPT ASTRA 6.2** · AI display byline

Human authorship and submission responsibility remain pending.

**27 November 2026 · Revision draft for version 0.3**

[Manuscript PDF](paper.pdf) · [LaTeX source](paper.tex) · [中文版](paper.zh-CN.md) · [中文 PDF](paper.zh-CN.pdf)

## Abstract

Sampathkumar, Sivakaran and Unnikrishnan (2026, Section 4) conjectured that $P_{12}\odot K_2$ requires seven packing colors and asked for the exact packing chromatic number of $C_n\odot K_2$ for all $n\ge 12$. We prove that $\chi_{\rho}(P_n\odot K_2)=7$ throughout this range and that $\chi_{\rho}(C_n\odot K_2)=7$ except at $n=13$, where it is $8$. A transfer calculation rules out six colors on the 36-vertex path corona and seven colors on the 39-vertex cycle corona. An independent exhaustive search on the graph vertices verifies both obstructions. Five explicit words that return to the same transfer state give seven-colorings for every required cycle length except $13$, where the published eight-coloring attains the lower bound. The earlier paper supplied the path upper bound and the exceptional eight-coloring. The new finite lower bounds establish their optimality. Both finite obstructions also have direct written proofs. The complete formulas, expressed using walks on the graph edges, have been formalized in Lean 4.19.0.

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

### Attribution and new contributions

Sampathkumar, Sivakaran and Unnikrishnan determine the small path cases for $2\le n\le 11$ and the small cycle cases for $3\le n\le 11$. Their general bounds apply from $n=12$. The two questions addressed here appear in Section 4, on printed page 107. [Theorems 2.1 and 3.1 and Section 4](https://dergipark.org.tr/en/download/article-file/5580259#page=14)

| Problem | Prior result | Contribution here |
| --- | --- | --- |
| $P_n\odot K_2$ for $n\ge 12$ | Seven-color upper bound | Six colors are impossible at $n=12$. Subgraph monotonicity gives the matching lower bound at every larger order. |
| $C_{13}\odot K_2$ | Explicit eight-coloring | Seven colors are impossible, so the published eight-coloring is optimal. |
| $C_n\odot K_2$ for $n\ge 12$, $n\ne 13$ | Seven-color upper bound at most lengths. The bound is eight at $n=15,21$ and $n\equiv 11\pmod {12}$. | Five words based at one transfer state give a uniform seven-color construction, including the three remaining groups of lengths. |

### Graph and indexing conventions

The parameter $n$ is the order of the base graph, meaning the number of center vertices. The corona has $3n$ vertices. Each center $v_i$ has satellites $x_i,y_i$ joined by the edge $x_i y_i$. In the corona $G\odot I_2$, the two satellites at each center are independent. Any two distinct vertices of color $c$ in $G\odot K_2$ must have distance strictly greater than $c$.

```text
    x_i ----- y_i      x_(i+1) --- y_(i+1)      x_(i+2) --- y_(i+2)
       \     /              \         /              \         /
 ...     v_i ---------------- v_(i+1) ---------------- v_(i+2)     ...
```

Shown are three consecutive columns and the center-to-center edges between them. The dotted ends indicate the continuation of the path of centers. In a cycle, the final and initial centers are also adjacent. The labels identify vertices and roles.

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

### How the transfer check is used

The coordinate $s_c$ summarizes all restrictions from earlier occurrences of color $c$ on the next column. The floor at $-1$ makes inactive restrictions indistinguishable. Both admissible heights are at least zero, so a smaller threshold would impose the same tests. The two satellites can be interchanged within each column by a graph automorphism, which is why the procedure tries one sorted pair for each unordered pair of satellite colors.

The search starts at the empty-prefix state $e$ and uses only states reachable by the displayed transition. A path is tested by successive frontiers. A cycle is tested by a closed walk per [Lemma 3](#lemma-3), whose hypotheses are $n\ge 3$ and $n>k$, with $k$ the palette size. The latter condition ensures that two lifts of the same cycle vertex in distinct periods are farther apart than any color. The seven-color test for $n=13$ and all target cycles in the upper-bound argument satisfy the condition.

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

Here $F_j$ is the set of states reached by walks of exactly $j$ transitions from $e$. Each state in $b_j$ is counted once if it starts any closed walk of length $j$, regardless of how many such closed walks it starts. Thus $b_{13}=0$ excludes every length-13 closed walk in $D_7$.

Since $F_{12}$ is empty, $P_{12}\odot K_2$ has no packing six-coloring. It is a subgraph of each corona in [Theorem 1](#theorem-1). Deleting edges or vertices can only increase the distance of a surviving pair. Consequently each required packing chromatic number is at least seven. Since $b_{13}=0$, [Lemma 3](#lemma-3) strengthens the $n=13$ cycle lower bound to eight.

### Direct arithmetic proof of the two finite obstructions

The two lower bounds can also be checked from the following inequalities and small integer tables. This derivation is independent of the transfer enumeration, the vertex search, and the Lean development.

**The path of order 12.** Assume a packing coloring using colors $1,\ldots,6$. Number columns $0,\ldots,11$ and fix $b$, the color of the center in column 1. Give the center and each of the two satellites in column $i$ the respective weights $w_{i,0},w_{i,1}$ from the selected column of the weight table. The weight of all vertices is $D=\sum_{i=0}^{11}(w_{i,0}+2w_{i,1})$.

| Column $i$ | A | B | C | D |
| ---: | ---: | ---: | ---: | ---: |
| 0 | $(5,0)$ | $(3,3)$ | $(0,0)$ | $(0,0)$ |
| 1 | $(0,5)$ | $(0,3)$ | $(0,0)$ | $(0,0)$ |
| 2 | $(13,0)$ | $(28,17)$ | $(4,2)$ | $(7,2)$ |
| 3 | $(17,8)$ | $(41,25)$ | $(6,4)$ | $(12,7)$ |
| 4 | $(22,12)$ | $(49,27)$ | $(8,4)$ | $(12,12)$ |
| 5 | $(21,14)$ | $(61,35)$ | $(9,4)$ | $(14,10)$ |
| 6 | $(23,13)$ | $(58,34)$ | $(8,5)$ | $(13,5)$ |
| 7 | $(18,9)$ | $(57,34)$ | $(9,5)$ | $(7,3)$ |
| 8 | $(15,10)$ | $(44,23)$ | $(7,4)$ | $(5,3)$ |
| 9 | $(10,6)$ | $(33,20)$ | $(5,3)$ | $(5,3)$ |
| 10 | $(6,1)$ | $(20,10)$ | $(3,1)$ | $(3,2)$ |
| 11 | $(1,0)$ | $(10,0)$ | $(1,0)$ | $(2,1)$ |

Each color class meets a triangle at most once. For purposes of its weight bound, a potential vertex in column $i$ has role $h=0$ for the center and $h=1$ for either satellite. For color $c\ne b$, the only forbidden type is $(1,0)$. For color $c=b$, the fixed center is allowed, the other two vertices of its triangle are forbidden, and a type $(i,h)$ in a different column is allowed only when $|i-1|+h>b$. For an upper bound we permit the color-$b$ set to omit the fixed center. Every actual color class still satisfies the restrictions.

For each $c$, let $P_{c,h}(j)$ bound the weight of a permissible color-$c$ set whose last selected vertex is of role $h$ and lies in a column at most $j$. Start with $P_{c,h}(j)=0$ for $j<0$. For an allowed type $(i,h)$ compute
$$
T_c(i,h)=w_{i,h}+
\max_{s\in\{0,1\}}P_{c,s}\!\left(i-\max\{1,c+1-h-s\}\right)
$$
and set $P_{c,h}(i)=\max\{P_{c,h}(i-1),\,T_c(i,h)\}$. For a forbidden type copy $P_{c,h}(i-1)$. This is a valid upper bound by induction. If the set ends in column $i$ with role $h$, its previous vertex has role $s$ in a column at most $i-\max\{1,c+1-h-s\}$, by both the ordering of columns and the required distance $>c$. If there is no previous vertex, the bound still applies because the recurrence begins at zero and uses nonnegative weights. A set ending before $i$ is covered by the copied prefix bound. Thus $M_c=\max_{h\in\{0,1\}}P_{c,h}(11)$ bounds the whole class, including the empty case.

| $b$ | Weights | $M_1$ | $M_2$ | $M_3$ | $M_4$ | $M_5$ | $M_6$ | Sum | $D$ |
| ---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | A | 103 | 78 | 42 | 32 | 28 | 23 | 306 | 307 |
| 2 | B | 319 | 208 | 117 | 85 | 74 | 61 | 864 | 866 |
| 3 | B | 319 | 231 | 94 | 85 | 74 | 61 | 864 | 866 |
| 4 | C | 46 | 32 | 16 | 9 | 11 | 9 | 123 | 124 |
| 5 | D | 64 | 48 | 24 | 17 | 7 | 15 | 175 | 176 |
| 6 | D | 64 | 48 | 24 | 17 | 17 | 5 | 175 | 176 |

The displayed entries follow by updating the two rows $P_{c,0},P_{c,1}$ in column order. For example, with $b=c=4$ use weights C. The allowed ending bounds $T_4(i,0)$ at columns $1,6,7,8,9,10,11$ are $0,8,9,7,9,8,9$. The allowed values $T_4(i,1)$ at columns $5,6,\ldots,11$ are $4,5,5,8,8,9,9$. Both prefix rows therefore end at 9. In every row of the table, $\sum_{c=1}^6 M_c<D$. Since a coloring partitions all vertices among the six classes, the sum of their weights is $D$, contradicting the table regardless of $b$.

**The cycle of order 13.** Assign weight 2 to each center and weight 1 to each satellite, giving total $52$. A color class has $m$ vertices and $q$ centers, hence weight $m+q$. Color 1 has $m\le13$ and $q\le6$, because its centers form an independent set on the 13-cycle. For $c\ge2$ and $m\ge2$, list the occupied columns in cyclic order and let $g$ be a directed gap from one to the next. Write $r=1$ at a center and $r=0$ at a satellite. The distance constraint implies $g\ge c-1+r+r'$, where $r,r'$ describe the endpoints. Indeed the graph distance is at most $g+2-r-r'$. Summing the gaps gives
$$
(c-1)m+2q\le 13.
$$
When $m\le1$, the weight is at most 2. The resulting individual weight bounds for colors $1,\ldots,7$ are $19,13,6,5,4,3,2$. For colors 2 and 3 this follows from $m+2q\le13$ and $2(m+q)\le13$. For colors 4, 5, 6, and 7 use $(c-1)m+2q=2(m+q)+(c-3)m$ and $m\ge\lceil(m+q)/2\rceil$; weights of at least 6, 5, 4, and 3, respectively, would exceed 13 in that inequality.

These upper bounds sum to 52, so a seven-coloring would attain all of them. Color 1 uses every column and has six centers. Their six cyclic gaps are five gaps of length 2 and one of length 3: they are all at least 2 and sum to 13. Color 2 also uses every column, all at satellites, because $m+q=13$ and $m+2q\le13$ force $q=0$. One position remains in each column. Rotate so its roles are center in the even columns $0,2,\ldots,12$ and satellite in the odd columns $1,3,\ldots,11$. The seam from column 12 to column 0 is the only place where consecutive remaining positions have the same role.

The weight bound for color 4 is attained only at $(m,q)=(3,2)$, since $3m+2q=10+m\le13$ and $m\ge3$. Its three directed gaps must all attain their lower bounds, as these bounds already sum to $3m+2q=13$. They are a gap of 5 between centers and two gaps of 4 between a center and a satellite. Off the seam, an arc between equal roles has even length and an arc between different roles has odd length. Thus each of the three required gaps must cross the seam. The three directed gaps partition the edges of the cycle, so only one can cross it. This contradiction rules out seven colors.

The original upper-bound proof below uses only the five printed words, the threshold update, and the attributed eight-coloring. Together with these two obstructions and subgraph monotonicity, it proves Theorem 1 without a call to any software. The weighted table is supplied as [structured data](../research/audit/outputs/path-weight-certificate.json), and a [separate arithmetic and BFS check](../research/audit/verify_written_obstructions.py) checks it independently.

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

### Residue classes and restriction to paths

The rows for $14$ through $19$ give one starting length in each residue class modulo six. Appending any number of copies of the length-six word preserves the common start and end state. Together with the separate case $12$, these rows cover the whole seven-color range.

| Starting length | Residue modulo 6 | Lengths of concatenated words |
| ---: | ---: | --- |
| 12 | 0 | $6+6$ |
| 14 | 2 | $6+8$ |
| 15 | 3 | $15$ |
| 16 | 4 | $8+8$ |
| 17 | 5 | $17$ |
| 18 | 0 | $6+6+6$ |
| 19 | 1 | $19$ |

For a path of order $n\ge 12$, the cycle of order $n+2$ has a seven-coloring by this range, since $n+2\ge 14$. Keep any $n$ consecutive columns and their path edges. This gives a copy of $P_n\odot K_2$, and a surviving same-color pair has distance at least the distance it had in the cycle.

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

### Satisfiable and unsatisfiable instances

For the satisfiable runs, a witness gives a color for every vertex. The two output words are listed in the [appendix](#appendix-finite-color-assignments-and-provenance). The vertex search validates the witnesses with its breadth-first-search distance matrix. The transfer code also checks the published eight-coloring from [Section 4](#4-coloring-words-for-the-upper-bounds) against the cyclic distance formula.

For the unsatisfiable runs, the exhaustive search covers every extension within the sorted-satellite convention. Its pruning preserves all those extensions, and the swaps of the two satellites recover all other orderings. The Lean assertions also exclude the two palettes by checking LRAT certificates through `bv_decide`. Their compiler-backed replay is part of the audited trust basis. [Trust model](../research/TRUST_MODEL.md)

The numbers of nodes visited depend on the implementation and branching order. The mathematical decisions are existence or nonexistence of a coloring of the stated graph with the stated palette. The two Python programs are cross-checks using different algorithms. Independent human review remains pending.

From the repository root, run the semantic acceptance check. It compares the SAT and UNSAT decisions independently of search-node counts and validates the archived color assignments. [Acceptance script](../research/audit/verify_graph_semantics.py)

```bash
python3 -B research/audit/verify_graph_semantics.py
```

### Evidence for each step

| Evidence | Role in the result |
| --- | --- |
| Transfer-state enumeration | Produces $F_{12}=\varnothing$ for six colors and $b_{13}=0$ for seven colors. |
| Direct finite vertex search | Reproduces both nonexistence decisions and returns complete assignments for the two satisfiable reference instances. |
| Lean `bv_decide` and LRAT | Checks the two finite obstructions in a separate color-class bit-vector encoding. |
| Common-state coloring words and residue argument | Supply the written seven-color upper bound for all required cycle lengths other than 13. |
| Published eight-coloring | Supplies the upper bound at $n=13$. |
| Lean local-distance templates and edge-walk theorems | Establish the general upper bounds by local checks and the two exact results in terms of walks. |

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

The proof in [Section 4](#4-coloring-words-for-the-upper-bounds) extends closed walks by six columns. Lean uses base templates of lengths 14 through 25 and a repeated 12-column segment with local-distance reductions. The final theorem statements formalize the exact packing numbers. The transfer counts, including 2,999 reachable states and 11,778 arcs, are computed by the Python enumeration.

Run `lake build` in `lean/` using the pinned toolchain. The axiom audit reports `propext`, `Classical.choice`, `Quot.sound` and `Lean.ofReduceBool` for both final declarations. The last is used by Lean 4.19's compiler-backed replay of the verified LRAT checker. There are no admitted declarations or project-defined axioms. [`lean-toolchain`](lean/lean-toolchain) · [Reproducibility audit](../REPRODUCIBILITY_AUDIT.md)

## 7. Comparison with earlier bounds

Theorem 2.1 of Sampathkumar, Sivakaran and Unnikrishnan already gives a seven-color upper bound for $P_n\odot K_2$ when $n\ge 12$. Here the obstruction at $n=12$ gives the matching lower bound for every larger path. Their Theorem 3.1 already bounds the cycle value above by seven at many lengths. Its eight-color upper bounds for $n=15,21$ and $n\equiv 11\pmod{12}$ are improved to seven by the words in [Section 4](#4-coloring-words-for-the-upper-bounds). At $n=13$ we prove that their eight-coloring is optimal. The previously determined smaller cases retain their original proofs. [Original results](#1-sampathkumar-sivakaran-and-unnikrishnan-2026)

Laïche, Bouchemakh and Sopena treat $p$-coronas with independent pendant vertices. The fixed attachment here is one edge between two satellites in a column. The path family here also lies in the framework of path-aligned clique products of Furmańczyk, Gözüpek and Özkan. The bounds in their Section 3.2 assume at least two backbone vertices per clique. Each triangle considered here has one backbone vertex. The repository's literature comparison records the scope of the searches and the evidence for each attribution. [Laïche, Bouchemakh and Sopena](#2-laïche-bouchemakh-and-sopena-2017) · [Furmańczyk, Gözüpek and Özkan](#3-furmańczyk-gözüpek-and-özkan-2025) · [Literature comparison](PRIOR_ART.md)

**Research status.** OpenAI Codex was used in discovery, proof development, formalization, verification and writing. This manuscript is a research draft with author attribution and independent human review pending.

No earlier exact result with these precise parameters was identified in the sources examined. This statement is limited by the scope of the literature search. Author attribution and responsibility for a submitted version await confirmation by human contributors. A human author is responsible for content, originality and correctness. [Literature comparison](PRIOR_ART.md) · [Contribution and AI disclosure record](../CONTRIBUTIONS.md)

## Appendix. Finite color assignments and provenance

For column $i$ indexed from zero, the vertex search numbers the center by $3i$ and the satellites by $3i+1$ and $3i+2$. Each triple below lists their colors in that order. The two words are the complete assignments returned by the Python vertex search. The program checks each pair of vertices using shortest-path distances from the graph adjacency lists.

```text
P_11 ⊙ K_2, six colors
123 412 123 512 123 612 123 412 123 512 123

C_13 ⊙ K_2, eight colors
123 412 123 612 127 312 412 125 812 136 214 137 512
```

The eight-color word printed in [Section 4](#4-coloring-words-for-the-upper-bounds) is the separate construction of Sampathkumar, Sivakaran and Unnikrishnan. The data file records its provenance separately from that of the search-generated assignments. [Published construction on page 107](https://dergipark.org.tr/en/download/article-file/5580259#page=14) · [Graph witnesses](../research/audit/outputs/graph-witnesses.json)

## References

### 1. Sampathkumar, Sivakaran and Unnikrishnan (2026)

R. Sampathkumar, T. Sivakaran and R. Unnikrishnan. *Packing colorings of the corona product of the path $P_n$ and the cycle $C_n$ with an edge $K_2$*. TWMS Journal of Applied and Engineering Mathematics **16** (2026), no. 1, 94–108. [Publisher's full text](https://dergipark.org.tr/en/download/article-file/5580259)

### 2. Laïche, Bouchemakh and Sopena (2017)

D. Laïche, I. Bouchemakh and É. Sopena. *Packing coloring of some undirected and oriented coronae graphs*. Discussiones Mathematicae Graph Theory **37** (2017), 665–690. [DOI 10.7151/dmgt.1963](https://doi.org/10.7151/dmgt.1963)

### 3. Furmańczyk, Gözüpek and Özkan (2025)

H. Furmańczyk, D. Gözüpek and S. Özkan. *Packing coloring of graphs with long paths*. [arXiv:2511.12761](https://arxiv.org/abs/2511.12761) (2025).
