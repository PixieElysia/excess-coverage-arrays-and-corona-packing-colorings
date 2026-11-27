# From a triangle column to a packing chromatic number

Column $i$ contains three vertices with roles in `Fin 3`. Role 0 is the backbone vertex. Roles 1 and 2 form the attached edge and each is adjacent to role 0. A vertex used by a walk or coloring has $i<n$. The function `f : Nat → Fin 3 → Nat` extends beyond the last column, but the statements constrain only its values on the graph. [CycleMetric.lean](lean/CycleMetric.lean) · [CoronaWalk.lean](lean/CoronaWalk.lean) · [Attainment.lean](lean/Attainment.lean)

| Object | Lean identifiers in `CoronaUpper` | Interpretation |
| --- | --- | --- |
| Edges | `PathEdge`, `CycleEdge` | Inside a column all distinct roles are adjacent. Between different columns only consecutive backbone vertices are adjacent, with the endpoint edge additionally allowed on a cycle. |
| Length of a walk | `PathWalk`, `CycleWalk` | The zero-length walk begins at a valid column. A step uses an edge and increases the length by one, maintaining the column bounds. |
| Shortest-path metric | `pathDistance`, `cycleDistance` | In one column the distance is zero or one. For distinct columns it is the backbone distance plus one for each satellite endpoint. The cycle uses the shorter of its two arcs. |
| Metric is realized | `path_walk_bounds`, `walk_length_bound`, `path_distance_attained`, `cycle_distance_attained` | Every walk has length at least the formula. An actual walk along the specified edges achieves it for every pair of valid vertices. |
| Admissible colors | `Packing`, `WalkPacking` | Labels lie in $1,\dots,k$. Two distinct vertices sharing color $c$ have distance greater than $c$, equivalently every joining walk has length greater than $c$. |
| Exact number | `ExactWalkPacking` | There exists a walk-packing coloring with palette size $k$. Every other palette size $l$ admitting such a coloring satisfies $k\le l$. |

For the lower bounds, each color class has three bit rows for the hub and two satellite roles. Left shifts test separations on the path. Rotations test cyclic separations. The rows for one color exclude repeated membership of adjacent vertices in a triangle. Across triangles the allowed separation depends on both roles. The two finite statements prohibit *covering* all vertices with suitable packing sets. Any admitted coloring would produce such a cover. `Bridge.lean` proves that implication for the pairwise graph metric, including wraparound. [GraphProof.lean](lean/GraphProof.lean) · [Bridge.lean](lean/Bridge.lean)

The arbitrary-length upper bound comes from explicitly checked column words and a proof that repeated portions preserve local tests. The lower bound for longer paths follows by restriction to twelve columns. Restricting a cycle to a path also weakens its distance constraints. The final theorems combine these bounds with distance attainment and walk-length lower bounds. The graph representation is local to this project. A translation into Mathlib's `SimpleGraph` would be a separate formalization. [Upper.lean](lean/Upper.lean) · [ExactColors.lean](lean/ExactColors.lean) · [EdgeColors.lean](lean/EdgeColors.lean)
