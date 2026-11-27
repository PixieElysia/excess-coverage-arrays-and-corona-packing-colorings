# Binary excess coverage arrays at minimum size

**AI-assisted research preprint · v0.3 revision draft · CHATGPT ASTRA 6.2.**

## Result

For every positive strength $t$, $(t+1)!$ rows suffice for $2t$ binary columns with column-permutation symmetry. For each prescribed pattern with $a$ ones on $t$ columns, the model counts precisely $a!(t-a)!$ rows. The 37 entries of the strength-18 certificate give multiplicities for individual words of each weight. The smallest entry is 350847. [Original array problem and equation (3)](https://link.springer.com/article/10.1007/s10623-025-01722-9#Equ3)

## Files

- [中文 Markdown](paper.zh-CN.md) · [中文 PDF](paper.zh-CN.pdf) · [Formalization](FORMALIZATION.md) · [Theorem coverage](THEOREM_COVERAGE.md)

- [Manuscript Markdown](paper.md) · [PDF](paper.pdf) · [LaTeX](paper.tex) · [Prior art](PRIOR_ART.md)
- [Lean existence theorem](lean/MainResult.lean) · [Formal check of equation (3)](lean/ExcessArrays.lean)
- [Construction](construct.py) · [Independent integer checker](verify.py) · [Strength-18 certificate](t18.json) · [Certificates for strengths 1 through 16](small.json)
- [Results CSV](results.csv) · [Verification log](verification.log) · [Reproducibility audit](../REPRODUCIBILITY_AUDIT.md)

## Reproduce

Run from this directory with Python 3.10 or later and Lean 4.19.0.

```sh
python3 verify.py small.json t18.json
python3 construct.py 18 > /tmp/array-t18.json
python3 verify.py /tmp/array-t18.json
(cd lean && lake build)
latexmk -pdf -interaction=nonstopmode -halt-on-error paper.tex
```

The integer checker sums the prescribed marginal equations directly from the certificate. The Lean existence proof uses explicit small witnesses through strength 21 and a proved rounding construction from strength 22 onward. The manuscript also proves that the widest minimum-size array under column-permutation symmetry has width asymptotic to $\log_2((t+1)!)$. This final result is given as a written proof. [Formal coverage and axiom dependencies](../REPRODUCIBILITY_AUDIT.md)

The revised manuscript prints the full small-strength certificates and gives an explicit correction for strength 18. [Residual table](../research/audit/outputs/t18-residuals.csv) · [Independent integer check](../research/audit/verify_t18.py)
