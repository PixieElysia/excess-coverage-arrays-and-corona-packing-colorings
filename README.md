# Binary excess coverage arrays and exact corona packing colorings

**v0.3 revision draft · 27 November 2026 · CHATGPT ASTRA 6.2**

The two manuscripts give separate mathematical results, complete written proofs, and corresponding Lean 4.19.0 developments. The display byline follows the repository steward's request. Human authorship, accountability and independent review remain pending. [Contribution record](CONTRIBUTIONS.md) · [中文导览](research/OVERVIEW.zh-CN.md)

## Results and evidence

| Claim | Written mathematical evidence | Lean coverage and review status |
| --- | --- | --- |
| The strength-18 column-symmetric instance of equation (3) admits a solution | Explicit certificate of 37 positive weight multiplicities, with all 19 integer checks and the row total | Certificate arithmetic and existence formalized; independent human review pending |
| For every positive strength $t$, minimum-row binary excess coverage exists at width $2t$ | Rounding, inclusion–exclusion and finite certificates; the minimum row count is $(t+1)!$ | Existence formalized; the row-count lower bound is proved in the manuscript; independent human review pending |
| The maximum width in the column-symmetric class is asymptotic to $\log_2((t+1)!)$ | Written proof using an integer kernel basis for the lower bound and occupied weight layers for the upper bound | Written proof only; independent human review pending |
| For $n\ge12$, $P_n\odot K_2$ has packing chromatic number 7, and $C_n\odot K_2$ has value 8 at $n=13$ and 7 elsewhere | Written finite obstructions, transfer formulation and explicit upper-bound constructions | Both exact formulas formalized using graph edges, with compiler-backed LRAT checking for the finite obstructions; independent human review pending |

The array construction answers the precise binary question in the 2025 paper's Section 5. The revised Levenshtein conjecture and the unrestricted maximum width are outside the result. The graph paper's earlier seven-color path bound, smaller exact instances and published eight-color witness retain their original attribution. [Array original, equation (3)](https://link.springer.com/article/10.1007/s10623-025-01722-9#Equ3) · [Graph original, §4](https://dergipark.org.tr/en/download/article-file/5580259#page=14)

## Manuscripts and evidence

| | Binary excess coverage arrays | Corona packing colorings |
| --- | --- | --- |
| English | [Markdown](excess-arrays/paper.md) · [PDF](excess-arrays/paper.pdf) · [LaTeX](excess-arrays/paper.tex) | [Markdown](packing-corona/paper.md) · [PDF](packing-corona/paper.pdf) · [LaTeX](packing-corona/paper.tex) |
| 中文 | [Markdown](excess-arrays/paper.zh-CN.md) · [PDF](excess-arrays/paper.zh-CN.pdf) | [Markdown](packing-corona/paper.zh-CN.md) · [PDF](packing-corona/paper.zh-CN.pdf) |
| Formalization | [Model](excess-arrays/FORMALIZATION.md) · [Theorem coverage](excess-arrays/THEOREM_COVERAGE.md) | [Model](packing-corona/FORMALIZATION.md) · [Theorem coverage](packing-corona/THEOREM_COVERAGE.md) |
| Certificates | [Strength-18 vector](excess-arrays/t18.json) · [Residuals](research/audit/outputs/t18-residuals.csv) · [Results CSV](excess-arrays/results.csv) | [SAT assignments](research/audit/outputs/graph-witnesses.json) · [Weighted proof table](research/audit/outputs/path-weight-certificate.json) · [Results CSV](packing-corona/results.csv) |
| Project notes | [Readme](excess-arrays/README.md) · [Prior art](excess-arrays/PRIOR_ART.md) | [Readme](packing-corona/README.md) · [Prior art](packing-corona/PRIOR_ART.md) |

## Reproduce

Use Python 3.10 or later and the pinned Lean 4.19.0 standard library. The English PDFs use LaTeX and the Chinese PDFs use Pandoc, XeLaTeX and Noto CJK fonts. See the [reproducibility audit](REPRODUCIBILITY_AUDIT.md) for clean execution and the verification log.

```sh
./verify.sh arrays
./verify.sh graphs
python3 -B research/audit/proof_baseline.py
python3 -B research/audit/verify_t18.py --check
python3 -B research/audit/verify_graph_semantics.py --check
python3 -B research/audit/verify_written_obstructions.py
python3 -B research/audit/test_negative_controls.py
python3 -B research/collect_results.py --check
sha256sum -c SHA256SUMS
```

[Revision audit](REVISION_AUDIT.md) · [Proof baseline](research/PROOF_BASELINE.md) · [Claims matrix](research/CLAIMS_MATRIX.md) · [Literature matrix](research/LITERATURE_MATRIX.md) · [Lean trust model](research/TRUST_MODEL.md) · [Changelog](CHANGELOG.md)
