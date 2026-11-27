# Array result coverage

The declarations below reproduce the types in the pinned sources in namespace `Excess`. To query their elaborated types and transitive axioms, build the project and run `python3 research/audit/audit_lean.py --project excess-arrays` from the repository root. [Build guide](lean/README.md) · [Trust model](../research/TRUST_MODEL.md)

## The 19 equations

```lean
theorem equation_three_18 (a : Fin 19) :
    ((List.range 19).map (fun j =>
      entry (pascalRow 18) j * entry witness18 (a.val+j))).sum =
       factorial a.val * factorial (18-a.val)
```

For every possible number of fixed ones, the explicit Pascal-row sum matches Gentle, Horsley and Wanless's Section 5 equation (3) at strength 18. The finite calculation uses ordinary `decide` and carries no axiom dependencies. The separate declaration `least_multiplicity_18` verifies a minimum of 350847 across all 37 coordinates. [ExcessArrays.lean](lean/ExcessArrays.lean) · [Original equation](https://arxiv.org/html/2411.17145v1#S5.E3)

## Existence at strength 18

```lean
theorem exists_binary_excess_array_18 :
    ∃ m : List Bool → Nat, ExactBinaryArray m (factorial 19) 18 36
```

The concrete construction in the paper's correction section has exactly 19! rows, 36 columns and the prescribed multiplicity for every interaction of strength 18. `row_mass` and `array_of_table` convert the finite table to a statement about every pattern. `exact_18_36` supplies the witness used by this existential theorem. Dependencies are `propext` and `Quot.sound`. [Certificate.lean](lean/Certificate.lean) · [ExcessArrays.lean](lean/ExcessArrays.lean)

## Existence for every positive strength

```lean
theorem exists_symmetric_binary_excess_array (t : Nat) (ht : 1 ≤ t) :
    ∃ f : Nat → Nat,
      ExactBinaryArray (fun w => f (wordWeight w)) (factorial (t+1)) t (2*t)
```

This is the existence assertion of the paper's Theorem 1, with column symmetry expressed by the witness. `array_through_21` covers strengths 1–21. For larger strengths, `General.rounded_nonnegative` and `exact_of_rounded_nonnegative` supply nonnegative integral multiplicities and exact margins. The theorem uses `propext`, `Classical.choice` and `Quot.sound`. [Small.lean](lean/Small.lean) · [General.lean](lean/General.lean) · [Universal.lean](lean/Universal.lean) · [MainResult.lean](lean/MainResult.lean)

## Other claims in the paper

| Claim | Evidence and scope |
| --- | --- |
| Lower bound of $(t+1)!$ rows for any excess covering array | Written counting argument summing disjoint pattern requirements on any fixed set of $t$ columns. |
| Exact minimum row count in Theorem 1 | Mathematical corollary of the lower bound and the Lean existence theorem. There is no separate optimization declaration. |
| Rounding and inversion in Lemma 3 | Integer differences, their marginals, and sufficient width-$2t$ bounds are formalized in `Inversion`, `General` and `Universal`. The paper's statement and analytic presentation are not a separately named Lean lemma in that form. |
| Lemma 4 and Theorem 2, asymptotic maximum symmetric width | Written proof, including the approximation and asymptotic estimates. Formalization remains a separate task. |
| Effect on the sequence covering array obstruction | Mathematical implication using the cited reduction. No Lean theorem asserts existence of the originating sequence covering array. |

The proofs and scope of these statements appear together in the [paper](paper.md).
