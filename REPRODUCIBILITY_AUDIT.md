# Reproducibility audit for version 0.2

The packaged proofs were rebuilt from a fresh source copy on x86-64 Linux, using Python 3.12.14 and the official Lean 4.19.0 release at commit `6caaee842e94`. This edition revises manuscript exposition and repository presentation. Its formal proof sources are unchanged from the previous verified release, commit `00065dbcf77cbcbbee113072dff0d9c9371eb0e4`.

## Verification summary

| Check | Observed result | Evidence |
| --- | --- | --- |
| Array arithmetic and Lean build | The strength-18 witness has 37 positive entries, minimum 350847, total 121645100408832000 rows and all 19 target marginals. Small witnesses and the rounded cases through strength 22 pass. The all-strength theorem builds. | [Log](excess-arrays/verification.log) · [CSV](excess-arrays/results.csv) |
| Transfer-state graph verification | The six-color path frontier is empty after 12 columns. The seven-color transfer graph has 2999 reachable states and 11778 directed arcs. No state starts a closed walk of length 13. All five loops, 25 ordered block pairs, and the eight-color witness pass. | [Log](packing-corona/verification.log) · [Verifier](packing-corona/verify.py) |
| Independent graph search | The six-color path and seven-color cycle obstructions are reproduced after 10,221 and 162,103 search nodes, respectively. The path of order 11 with six colors and the cycle of order 13 with eight colors yield witnesses. | [Log](packing-corona/verification.log) · [CSV](packing-corona/results.csv) |
| Graph Lean build | Two exact formulas hold for every base order at least 12, where the coloring condition is stated on walks in the edge-defined graph. | [Final theorems](packing-corona/lean/EdgeColors.lean) |
| Manuscript build | Both PDFs are generated from the corresponding LaTeX sources. | [Array source](excess-arrays/paper.tex) · [Graph source](packing-corona/paper.tex) |

The finite computations use standard-library Python only. The tables contain finite verification results. The general mathematical conclusions follow from the manuscript arguments and their stated formalizations.

## Lean theorem dependencies

| Public statement | Dependencies reported by Lean |
| --- | --- |
| `Excess.equation_three_18` | None |
| `Excess.exists_binary_excess_array_18` | `propext`, `Quot.sound` |
| `Excess.exists_symmetric_binary_excess_array` | `propext`, `Classical.choice`, `Quot.sound` |
| `CoronaUpper.path_exact_on_edges`, `CoronaUpper.cycle_exact_on_edges` | `propext`, `Classical.choice`, `Quot.sound`, `Lean.ofReduceBool` |

The last two theorems use Lean 4.19's `bv_decide` for the two finite obstructions. The tactic invokes a SAT solver and checks its LRAT certificate with the standard library's verified checker. In this toolchain the replay uses `Lean.ofReduceBool`, so the Lean compiler is part of the trusted base. The independently implemented Python search reaches the same finite conclusions. The projects contain no admitted proofs or added axioms. The array manuscript's asymptotic width theorem has a written proof and is outside the formalized statements.

## Commands

From the repository root, with the pinned Lean toolchain available on the path, run

```sh
./verify.sh arrays
./verify.sh graphs
python3 -B research/collect_results.py --check
sha256sum -c SHA256SUMS
```

To regenerate the CSV files, run the Python command without `--check`. To regenerate the PDFs, run `latexmk -pdf -interaction=nonstopmode -halt-on-error paper.tex` inside each study directory. The checksum manifest covers the distributed bytes, including the archived verification logs and PDFs. Fresh logs and rebuilt PDFs may contain different build metadata.
