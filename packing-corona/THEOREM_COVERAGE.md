# Packing coloring result coverage

These are the source declaration types in namespace `CoronaUpper`. Both parts of the paper's Theorem 1 are stated for every backbone order at least twelve. From the repository root, run `python3 research/audit/audit_lean.py --project packing-corona` after building to see the elaborated types and transitive dependencies. [Build guide](lean/README.md) · [Trust model](../research/TRUST_MODEL.md)

## Path coronas

```lean
theorem path_exact_on_edges {n : Nat} (hn : 12 ≤ n) :
    ExactWalkPacking n 7 (fun i j r s l => PathWalk n j s i r l)
```

`no_path_six` transfers a putative six-coloring of the twelve-column path to an impossible bit-vector cover. `path_exact` combines restriction and the seven-color upper bound. `path_distance_attained` and `path_walk_bounds` transfer the result to graph walks. Dependencies are `propext`, `Classical.choice`, `Lean.ofReduceBool` and `Quot.sound`. [Bridge.lean](lean/Bridge.lean) · [ExactColors.lean](lean/ExactColors.lean) · [Attainment.lean](lean/Attainment.lean) · [EdgeColors.lean](lean/EdgeColors.lean)

## Cycle coronas

```lean
theorem cycle_exact_on_edges {n : Nat} (hn : 12 ≤ n) :
    ExactWalkPacking n (if n = 13 then 8 else 7) (fun i j r s l => CycleWalk n j s i r l)
```

`no_cycle_seven` handles the exceptional lower bound. `seven_upper`, `eight_upper` and `cycle_exact` supply the exact metric result for every required order. `cycle_distance_attained` and `walk_length_bound` identify that metric with actual walks. The axiom set is the same as for the path theorem. [Bridge.lean](lean/Bridge.lean) · [Upper.lean](lean/Upper.lean) · [CoronaWalk.lean](lean/CoronaWalk.lean) · [EdgeColors.lean](lean/EdgeColors.lean)

## Other claims in the paper

| Claim | Evidence and scope |
| --- | --- |
| The transfer rule and closed-walk characterization in Lemmas 2 and 3 | Written proofs giving a second route to the finite obstructions. These lemmas are not project Lean declarations. |
| Seven-color transfer graph has 2,999 reachable states and 11,778 distinct arcs | Enumerated by the independent Python transfer computation. Its table and state counts are outside the final Lean statements. |
| No six-color path cover at 12, no seven-color cycle cover at 13 | The named bit-vector obstructions and their metric bridges are formalized. The paper also gives computational checks using transfer states and direct graph search. |
| Published small-order values below 12 | Prior work. The parameter hypothesis in both Lean declarations begins at 12. |

See the [paper](paper.md), [transfer enumerator](verify.py), [direct search](graph_search.py) and [original small-order theorems](https://dergipark.org.tr/en/download/article-file/5580259).
