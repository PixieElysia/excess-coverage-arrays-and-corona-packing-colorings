# Binary excess coverage arrays and exact corona packing colorings

**AI-assisted research preprints · version 0.2 · 27 November 2026.**

This repository contains two combinatorics manuscripts, their Lean 4.19 proofs, and independent computational checks. Human author attribution and independent review are pending.

## Results

1. **Binary excess coverage arrays.** For every positive strength $t$, there is a binary array with $(t+1)!$ rows and $2t$ columns whose row multiplicities are invariant under column permutations. On any specified $t$ columns, a pattern with $a$ ones occurs exactly $a!(t-a)!$ times. The strength-18 certificate has 37 positive weight multiplicities and satisfies every equation in Gentle, Horsley and Wanless's equation (3), which the paper reported infeasible. [Original article, equation (3)](https://link.springer.com/article/10.1007/s10623-025-01722-9#Equ3)
2. **Packing colorings of corona graphs.** For every $n \ge 12$, the packing chromatic number of $P_n \odot K_2$ is 7. For $C_n \odot K_2$, it is 8 at $n=13$ and 7 at every other $n \ge 12$. These formulas resolve the conjecture and the problem on page 107. [Original article, §4](https://dergipark.org.tr/en/download/article-file/5580259#page=14)

## Files

| | Binary excess coverage arrays | Corona packing colorings |
| --- | --- | --- |
| Manuscript | [PDF](excess-arrays/paper.pdf) · [LaTeX](excess-arrays/paper.tex) | [PDF](packing-corona/paper.pdf) · [LaTeX](packing-corona/paper.tex) |
| Formal statements | [Existence for every strength](excess-arrays/lean/MainResult.lean) · [Equation (3)](excess-arrays/lean/ExcessArrays.lean) | [Exact values from graph edges](packing-corona/lean/EdgeColors.lean) |
| Computation | [Strength-18 certificate](excess-arrays/t18.json) · [Results CSV](excess-arrays/results.csv) · [Build and check log](excess-arrays/verification.log) | [Transfer-state verifier](packing-corona/verify.py) · [Independent vertex search](packing-corona/graph_search.py) · [Results CSV](packing-corona/results.csv) · [Build and check log](packing-corona/verification.log) |
| Study notes | [Readme](excess-arrays/README.md) · [Prior art](excess-arrays/PRIOR_ART.md) | [Readme](packing-corona/README.md) · [Prior art](packing-corona/PRIOR_ART.md) |

## Reproduce

Use Python 3.10 or later and the official Lean 4.19.0 toolchain. Both Lean projects use the standard library. With Elan installed, the `lean-toolchain` files select the pinned version for each project.

```sh
./verify.sh
python3 -B research/collect_results.py --check
sha256sum -c SHA256SUMS
```

The [reproducibility audit](REPRODUCIBILITY_AUDIT.md) records the clean build, formal theorem dependencies, computational checks, and PDF build commands. The [checksum manifest](SHA256SUMS) fingerprints the distributed files.

## Prior work and scope

The array manuscript gives a construction at the parameters in equation (3) and proves existence at width $2t$ for all strengths. It also proves the asymptotic maximum width within the column-symmetric class by a written argument. The Lean development covers the full existence theorem and the strength-18 certificate. The graph manuscript credits the original eight-color witness at $n=13$ and supplies the missing lower bounds and a construction covering every other order. Lean proves the exact graph formulas from the underlying edges. The finite graph lower bounds use the standard LRAT checker through `bv_decide`. [Array comparison](excess-arrays/PRIOR_ART.md) · [Graph comparison](packing-corona/PRIOR_ART.md)

[中文说明](research/OVERVIEW.zh-CN.md) · [研究接续记录](research/PROGRESS.md) · [文献检索记录](research/SOURCES.md)
