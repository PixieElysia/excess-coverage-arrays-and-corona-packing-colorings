# Packing colorings in Lean 4.19

The model uses the three vertices of each triangle as the three roles in a
column. Within a triangle, distinct vertices have distance one. Between
columns, add the path or cycle separation to the number of satellite
endpoints. These are the shortest-path formulas proved in the research note.

- [CycleMetric.lean](CycleMetric.lean) defines the pairwise packing predicate and
  proves that the local checks imply its global inequalities. It also proves
  restriction from a cycle to a path.
- [GraphProof.lean](GraphProof.lean) rules out a six-set packing cover on twelve
  path columns and a seven-set packing cover on thirteen cycle columns.
- [Bridge.lean](Bridge.lean) converts every hypothetical packing coloring of
  the specified graph into the corresponding bit-vector cover.
- [Upper.lean](Upper.lean) verifies the finite templates and proves the upper
  bound for arbitrary lengths using reduction of the repeated portions.
- [ExactColors.lean](ExactColors.lean) proves both exact formulas for
  every length at least 12, using the explicit shortest-path formulas.
- [CoronaWalk.lean](CoronaWalk.lean) and [Attainment.lean](Attainment.lean)
  define the underlying graph edges and prove the shortest-path formulas by
  bounding all walks and exhibiting a walk achieving each distance.
- [EdgeColors.lean](EdgeColors.lean) proves both exact formulas directly in
  terms of walks on the underlying graph edges.

Run `lake build` in this directory with the toolchain in `lean-toolchain`.
The two impossibility theorems use the standard `bv_decide` tactic and its
verified LRAT checker. In Lean 4.19 the checker is replayed with
`Lean.ofReduceBool`, which relies on the Lean compiler. The final file
prints the exact axiom dependencies. The research note additionally gives
two Python routes to reproduce the finite obstructions.

## Direct imports and audit command

| Module | Direct imports |
| --- | --- |
| [CycleMetric](CycleMetric.lean) | `Std` |
| [GraphProof](GraphProof.lean) | `Std.Tactic.BVDecide` |
| [Bridge](Bridge.lean) | `GraphProof`, `CycleMetric` |
| [PackingTools](PackingTools.lean) | `CycleMetric` |
| [Upper](Upper.lean) | `CycleMetric` |
| [ExactColors](ExactColors.lean) | `PackingTools`, `Bridge`, `Upper` |
| [CoronaWalk](CoronaWalk.lean) | `CycleMetric` |
| [Attainment](Attainment.lean) | `CoronaWalk` |
| [EdgeColors](EdgeColors.lean) | `Attainment`, `ExactColors` |

`PackingTools` supplies palette enlargement, path restriction and the metric minimum-palette predicate. The manifest has no external Lake packages. After the build, run the following from the repository root to query both public edge-based results and compare their transitive axiom dependencies with the recorded sets.

```sh
python3 research/audit/audit_lean.py --project packing-corona
```

See the [semantic guide](../FORMALIZATION.md), [theorem coverage](../THEOREM_COVERAGE.md) and [trust model](../../research/TRUST_MODEL.md).
