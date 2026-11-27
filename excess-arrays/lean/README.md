# Building the array proofs

Run `lake build` in this directory using the pinned Lean 4.19.0 toolchain. The manifest has no external Lake packages. To query the three published declarations independently after the build, run the following from the repository root.

```sh
python3 research/audit/audit_lean.py --project excess-arrays
```

The direct imports below come from the project sources. All public array results use the `Excess` namespace, with subsidiary development in `Excess.Inversion` and `Excess.General`.

| Module | Direct imports | Role |
| --- | --- | --- |
| [Patterns](Patterns.lean) | `Std` | Partial binary assignments, their completions and mass identities. |
| [Certificate](Certificate.lean) | `Patterns` | Row multiplicities, exact margins and their certification by adjacent sums. |
| [ExcessArrays](ExcessArrays.lean) | `Certificate` | Strength-18 witness, its binomial equations, concrete array and minimum coordinate. |
| [Inversion](Inversion.lean) | `Std` | Integer differences, marginal inversion and rounding of factorial moments. |
| [General](General.lean) | `Inversion` | Bounds on rounding error and nonnegative layers from strength 22 onward. |
| [Universal](Universal.lean) | `Certificate`, `General` | Turns nonnegative integer layers into exact marginal masses and row counts. |
| [Small](Small.lean) | `ExcessArrays` | Finite witnesses and exhaustive arithmetic checks for strengths 1 through 21. |
| [MainResult](MainResult.lean) | `Small`, `Universal` | Joins both ranges, exhibits a symmetric witness for every positive strength and prints three axiom reports. |

The formal statements, their scopes and the comparison to the paper appear in the [semantic guide](../FORMALIZATION.md) and [theorem coverage](../THEOREM_COVERAGE.md).
