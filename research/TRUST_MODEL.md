# Trust model for the five public Lean results

Each result below is a statement about a concrete mathematical model. The array and graph guides explain how its parameters, domain and quantifiers correspond to the papers. The two theorem coverage tables identify results established by written proofs or separate computations. [Array model](../excess-arrays/FORMALIZATION.md) · [Graph model](../packing-corona/FORMALIZATION.md) · [Array coverage](../excess-arrays/THEOREM_COVERAGE.md) · [Graph coverage](../packing-corona/THEOREM_COVERAGE.md)

| Declaration | Transitive dependencies reported by `#print axioms` |
| --- | --- |
| `Excess.equation_three_18` | Empty set |
| `Excess.exists_binary_excess_array_18` | `propext`, `Quot.sound` |
| `Excess.exists_symmetric_binary_excess_array` | `propext`, `Classical.choice`, `Quot.sound` |
| `CoronaUpper.path_exact_on_edges` | `propext`, `Classical.choice`, `Lean.ofReduceBool`, `Quot.sound` |
| `CoronaUpper.cycle_exact_on_edges` | `propext`, `Classical.choice`, `Lean.ofReduceBool`, `Quot.sound` |

The table records sets, so output ordering has no mathematical significance. The archived logs report these dependencies. During this revision we independently imported the existing local build products in new temporary Lean sessions and observed the same five sets. That check used cached objects. The revision build record is the source for clean-build status. [Array archive](../excess-arrays/verification.log) · [Graph archive](../packing-corona/verification.log) · [Revision verification](../REPRODUCIBILITY_AUDIT.md)

## Logic and computation

* `propext` permits proposition equality from logical equivalence. `Classical.choice` produces a witness from nonemptiness. `Quot.sound` identifies representatives related by a quotient relation. They are standard Lean dependencies. The project manifests declare no external Lake packages.
* `Excess.equation_three_18` checks a finite arithmetic assertion with `decide`. The two array existence results additionally connect arithmetic to completions and multiplicities. Neither existence result depends on a SAT oracle or compiler-backed Boolean reduction.
* For the graph obstructions, `bv_decide` reduces a bit-vector goal to Boolean satisfiability. The external SAT solver produces an LRAT certificate. Lean's verified checker validates that proof, and soundness transfers the result back to the original bit-vector formula. A solver answer by itself is insufficient. In Lean 4.19.0 the reflected checker result uses `Lean.ofReduceBool`, which relies on the compiler and execution runtime for Boolean evaluation. This dependency propagates to the two final edge-based theorems. The upper-bound constructions and semantic bridges can be inspected separately. [GraphProof.lean](../packing-corona/lean/GraphProof.lean) · [Lean 4.19 LRAT frontend](https://github.com/leanprover/lean4/blob/v4.19.0/src/Lean/Elab/Tactic/BVDecide/Frontend/LRAT.lean) · [Lean 4.19 Boolean reflection](https://github.com/leanprover/lean4/blob/v4.19.0/src/Lean/Elab/Tactic/BVDecide/Frontend/BVDecide.lean)

The local release binaries reported Lean 4.19.0, commit `6caaee842e94`, Lake `5.0.0-6caaee8`, and bundled CaDiCaL `2.1.3`. The default SAT frontend chooses the `cadical` executable adjacent to Lean when present, with a PATH lookup as fallback. The solver receives the generated CNF and a certificate output path with `--lrat`. The path and cycle obstructions set solver timeouts of 120 and 180 seconds. The repository regenerates these witnesses when elaborating the original `bv_decide` proofs. It has no standalone LRAT or CNF archive. [Pinned solver selection](https://github.com/leanprover/lean4/blob/v4.19.0/src/Lean/Elab/Tactic/BVDecide/Frontend/LRAT.lean) · [SAT invocation](https://github.com/leanprover/lean4/blob/v4.19.0/src/Lean/Elab/Tactic/BVDecide/External.lean)

## Rerunning the external audit

After `lake build` in each project's `lean` directory, run the following from the repository root. Supply `--lean /absolute/path/to/lean` when the pinned executable is outside PATH.

```sh
python3 research/audit/audit_lean.py
```

The script sets the project module search path, creates an importing file in a temporary directory, queries the five declarations and compares their axiom sets with the table. A missing target, unavailable executable, incompatible toolchain, unexpected axiom, or unrecognized output causes an error. A separate literal scan of hand-written Lean sources flags occurrences of `sorry`, `admit`, `sorryAx`, `unsafe`, `axiom` and selected compiler escape hatches for review. This scan includes comments and excludes generated directories. The dependency check inspects the imported theorems transitively, including imported proof dependencies that have no literal mention in the project sources. Build freshness, the mathematical adequacy of the definitions, and human peer review require their own evidence. [Audit script](audit/audit_lean.py) · [Repository verification](VERIFICATION.md)

The array asymptotic result currently has a written proof. A formalization of it, or a graph proof with a different computational trust basis, would require new mathematics or engineering beyond this revision.
