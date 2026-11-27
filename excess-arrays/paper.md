# Minimum-size binary excess coverage arrays

**Exact existence and asymptotic width under column symmetry**

**Research preprint · revision draft for version 0.3 · 27 November 2026**

**CHATGPT ASTRA 6.2** · AI display byline

Human authorship and submission responsibility remain pending.

[Manuscript PDF](paper.pdf) · [LaTeX source](paper.tex) · [中文版](paper.zh-CN.md) · [中文 PDF](paper.zh-CN.pdf) · [Reproducibility audit](../REPRODUCIBILITY_AUDIT.md)

## Abstract

Gentle, Horsley and Wanless (2025, Section 5, equation (3)) reported infeasibility of their column-symmetric integer system at strength $18$. We give a strictly positive solution to all $19$ equations, establishing the existence of a binary excess coverage array with $36$ columns and $19!$ rows. More generally, every positive integer strength $t$ admits a column-symmetric array with $2t$ columns and the minimum row count $(t+1)!$. Within the column-permutation-invariant class, we also determine the asymptotic maximum width as $(1+o(1))\log_2((t+1)!)$. Lean 4.19.0 verifies the strength-$18$ certificate and the all-strength existence theorem. The width asymptotic has a separate written proof and remains outside the Lean development. The array results address the specific binary nonexistence obstruction discussed in Section 5. The revised Levenshtein conjecture remains outside their scope. [Journal equation (3)](https://link.springer.com/article/10.1007/s10623-025-01722-9#Equ3)

## 1. Problem and main results

A binary excess coverage array of strength $t\ge1$ and width $k\ge t$ is a multiset of binary words of length $k$. In each choice of $t$ coordinates, each prescribed pattern with $a$ ones must occur at least $a!(t-a)!$ times. Summing these requirements over the patterns in one choice of coordinates gives the lower bound

$$
\sum_{a=0}^{t}\binom{t}{a}a!(t-a)! = (t+1)!.
$$

An array with $N=(t+1)!$ rows therefore realizes each requirement with equality. This is a binary balanced array with index vector $\mu_a=a!(t-a)!$. We call the array *column-symmetric* when permuting its columns preserves the row multiset. The multiplicity $x_i$ is then the number of copies of *each* word of weight $i$. Weight-based representations are standard in balanced-array theory. [Kuriki](#ref-kuriki) · [Shirakura](#ref-shirakura)

The constraints for such an array at minimum size are precisely

<a name="equation-1"></a>

$$
\sum_{j=0}^{k-t}\binom{k-t}{j}x_{a+j}=a!(t-a)!,
\qquad 0\le a\le t,\qquad x_i\in\mathbb Z_{\ge0}. \tag{1}
$$

Indeed, the $k-t$ remaining positions supply the $j$ additional ones. Summing the left sides over the $2^t$ patterns gives the total number of rows. In the width-$2t$ case this is equation (3) of Gentle, Horsley and Wanless. They found solutions at strengths through $17$, reported infeasibility for the symmetric system at $18$, and left existence without the symmetry constraint open. The following result settles the instance within the symmetric class. [Gentle, Horsley and Wanless, Section 5](#ref-ghw)

### Theorem 1

For every integer $t\ge1$, a column-symmetric $\mathsf{CA}_X((t+1)!;t,2t,2)$ exists. The certificate for $t=18$ has $37$ positive coordinates and minimum coordinate $350{,}847$.

Let $K_{\mathrm{sym}}(t)$ denote the maximum width of a column-symmetric array with strength $t$ and exactly $(t+1)!$ rows, for $t\ge2$. The following theorem includes finiteness of this maximum.

### Theorem 2

As $t\to\infty$, $K_{\mathrm{sym}}(t)\sim\log_2((t+1)!)\sim t\log_2 t$.

### Background and relation to sequence covering arrays

A sequence covering array $\operatorname{SCA}(M;s,v)$ consists of $M$ permutations of $v$ symbols such that each ordered selection of $s$ distinct symbols occurs as a subsequence of at least one permutation. Here $s$ is sequence covering strength, while $t$ is binary excess coverage strength. The revised Levenshtein conjecture states that for $s\ge5$ and $v\ge s$, an $\operatorname{SCA}(s!;s,v)$ exists exactly when $v=s$ or $v=s+1$. The earlier conjecture included strength $4$, where Mathon and Tran Van Trung found an $\operatorname{SCA}(24;4,6)$. [Gentle, Horsley and Wanless, Section 1](https://arxiv.org/html/2411.17145v1#S1) · [Mathon and Tran van Trung](#ref-mathon)

Gentle, Horsley and Wanless form a binary row by fixing one symbol in a permutation and marking whether each other symbol lies before or after it. Their Section 5 uses the parameter shift $s=t+1$ and $v=2t+1$ and the implication

$$
\operatorname{SCA}((t+1)!;t+1,2t+1)\text{ exists}
\quad\Longrightarrow\quad
\mathsf{CA}_X((t+1)!;t,2t,2)\text{ exists}.
$$

The construction appears in Construction 4 and Lemma 5 of the journal paper. The corresponding preprint labels are Construction 3 and Lemma 4. [Journal Section 2](https://link.springer.com/article/10.1007/s10623-025-01722-9#FPar4) · [Preprint Section 2](https://arxiv.org/html/2411.17145v1#S2)

[Theorem 1](#theorem-1) establishes the right-hand condition for every positive $t$. Hence absence of that binary array cannot supply the proposed exclusion of the sequence covering array. The reverse implication and conditions relating several derived arrays or different alphabet sizes are separate questions. The journal article's main result excluding $\operatorname{SCA}(7!;7,10)$ is distinct from its strength-$18$ computation. The case $\operatorname{SCA}(7!;7,9)$ and the full revised conjecture remain outside the results here. [Journal equation (3)](https://link.springer.com/article/10.1007/s10623-025-01722-9#Equ3) · [Preprint v1 equation (3)](https://arxiv.org/html/2411.17145v1#S5.E3)

### Notation and array semantics

| Symbol | Meaning |
| --- | --- |
| $t$ | Strength of the binary excess coverage array |
| $k$ | Number of columns |
| $N$ | Number of rows counted with multiplicity |
| $a$ | Number of ones in one prescribed pattern |
| $i$ | Number of ones in a complete row |
| $x_i$ | Multiplicity of each individual word of weight $i$ |
| $y_j$ | Number of rows containing ones in a fixed set of $j$ positions |
| $K_{\mathrm{sym}}(t)$ | Maximum width at strength $t$ and row count $(t+1)!$ under column-permutation symmetry |

Rows form a multiset and can repeat. A column permutation preserves the multiset as a whole. It may carry an individual word to a different word with the same weight. The entire weight-$i$ layer contains $\binom{k}{i}x_i$ rows, and $N=\sum_{i=0}^{k}\binom{k}{i}x_i$. Summing the margins in [(1)](#equation-1) over all prescriptions on any fixed $t$ coordinates counts every complete row once and gives the same total.

Global exchange of zeros and ones would impose the additional equations $x_i=x_{k-i}$. The strength-$18$ certificate has unequal entries $x_0$ and $x_{36}$, as column-permutation symmetry permits.

At row count $(t+1)!$ the paper's $\mathsf{CA}_X$ condition reduces to the exact margins in [(1)](#equation-1). Lean's [ExactBinaryArray](lean/Certificate.lean) encodes that row count and those exact prescribed-pattern multiplicities. The symbol $\mathsf{CAN}_X(t,2t,2)$ denotes the minimum row count at the given strength, width, and alphabet. The maximum width at fixed row count is the separate quantity $K_{\mathrm{sym}}(t)$.

## 2. Rounding intersection counts

### Reading guide for the existence proof

Start with the real intersection counts $y_j^*=N/(j+1)$ and ideal row multiplicities $x_i^*=N/((k+1)\binom{k}{i})$. For $j\le t$, the divisor $j+1$ divides $N=(t+1)!$, so rounding preserves precisely the intersection counts used to compute a prescribed $t$-column margin. Inclusion–exclusion recovers integer $x_i$ and preserves those margins. A separate argument establishes nonnegativity, which the $x_i$ need to represent row multiplicities.

| Strength | Source of nonnegative integer multiplicities |
| --- | --- |
| $1\le t\le16$ | Explicit certificates in [small.json](small.json) |
| $17\le t\le21$ | Finite certificates from the rounding construction |
| $t\ge22$ | General bound on the rounding error |

The inequality in the proof supplies a sufficient threshold at $22$. The successful finite rounding cases already include strengths $17$ through $21$. In [construct.py](construct.py), the quotient and remainder of $N$ by $j+1$ determine rounding to nearest, with an exact tie rounded to even. Lean's [Inversion.nearestQuotient](lean/Inversion.lean) uses the same quotient–remainder criterion for the nonnegative numerator and positive divisor used here.

The stored $t=2$ certificate is $(2,0,0,1,0)$. It represents two copies of $0000$ and one copy of each of $0111$, $1011$, $1101$, and $1110$. On any two columns a prescribed $11$ pattern has count $x_2+2x_3+x_4=2=2!0!$. The other prescribed patterns $00$, $01$, and $10$ have counts $2$, $1$, and $1$. The row count is $6=3!$.

Write $\left\lfloor z\right\rceil$ for a nearest integer to $z$, taking the even integer at a tie. Define

<a name="equation-2"></a>

$$
y_j=\left\lfloor\frac{N}{j+1}\right\rceil,\qquad
x_i=\sum_{r=0}^{k-i}(-1)^r\binom{k-i}{r}y_{i+r}
\quad(0\le i,j\le k). \tag{2}
$$

### Lemma 3

The integers in [(2)](#equation-2) satisfy the equalities in [(1)](#equation-1). Each $x_i$ is within $2^{k-i}/2$ of $x_i^*=N/((k+1)\binom{k}{i})$.

**Proof.** Assign $y_j$ as the total multiplicity of words containing any fixed $j$-subset in their support. Inclusion–exclusion over the remaining positions gives [(2)](#equation-2) for the signed multiplicity of a word with exactly that support. This inversion is valid before positivity is established. If $j\le t$ then $j+1$ divides $N$, so $y_j=N/(j+1)$. On a prescribed set of $a$ ones and $b=t-a$ zeros, inclusion–exclusion therefore gives the signed count

$$
\sum_{r=0}^{b}(-1)^r\binom{b}{r}\frac{N}{a+r+1}
= N\int_0^1 p^a(1-p)^b\,dp
= a!b!.
$$

With every $y_j$ replaced by $N/(j+1)$ the same integral at degree $k$ gives $x_i^*=N i!(k-i)!/(k+1)!$. Each term rounded in [(2)](#equation-2) contributes error at most half its binomial coefficient. $\square$

**Proof of [Theorem 1](#theorem-1).** By [Lemma 3](#lemma-3), the condition $2N\ge(k+1)3^k$ implies $x_i\ge0$ for every $i$, since

$$
\binom{k}{i}2^{k-i}\le\sum_{j=0}^k\binom{k}{j}2^{k-j}=3^k.
$$

At $k=2t$, the condition holds at $t=22$ by integer arithmetic. Increasing $t$ by one multiplies the ratio $2(t+1)!/((2t+1)3^{2t})$ by $(t+2)(2t+1)/(9(2t+3))>1$ for $t\ge22$. At $17\le t\le21$, direct evaluation of [(2)](#equation-2) gives the positive minima recorded in [Section 4](#4-finite-verification-and-reproducibility). The companion file [small.json](small.json) supplies the nonnegative integer vectors at $1\le t\le16$. The same section describes verification of the margins and row totals in all these cases. [Appendix A](#a-the-strength-18-certificate) lists the full positive solution at $t=18$. $\square$

The lower bound on the number of rows is attained, so $\mathsf{CAN}_X(t,2t,2)=(t+1)!$. In the sequence-covering argument of Gentle, Horsley and Wanless, absence of this binary array would supply an obstruction. [Theorem 1](#theorem-1) removes that particular obstruction at every strength. [Gentle, Horsley and Wanless, Section 5](#ref-ghw)

## 3. Maximum width under column symmetry

Throughout this section $N=(t+1)!$. We use the convention $\binom{n}{r}=0$ when $n\ge0$ and $r\notin\{0,\ldots,n\}$.

The precise limit in [Theorem 2](#theorem-2) is

$$
\lim_{t\to\infty}\frac{K_{\mathrm{sym}}(t)}{\log_2((t+1)!)}=1.
$$

Stirling's formula gives $\log_2((t+1)!)\sim t\log_2 t$. At strength $1$, the length-$k$ all-zero word and all-one word give a column-symmetric minimum-size array at every width $k\ge1$. The finite maximum is therefore defined here from strength $2$ onward.

### Reading guide for the width proof

The lower bound uses an integer basis of the kernel to move from a real ideal solution to a nearby integer solution. Check the dimension, linear independence, and coordinatewise rounding error, including the Vandermonde identity. The condition in [Lemma 4](#lemma-4) is sufficient for nonnegativity. For the upper bound, column symmetry turns one occupied weight into an entire layer of distinct words. Check the conditional distribution for a uniformly chosen row, the uniformity of the bound over $k\ge t$, fixed-strength finiteness, and the Stirling estimates. The asymptotic estimates remain outside the current Lean development.

### Lemma 4

For $d=k-t\ge1$, the equalities in [(1)](#equation-1) have an integer solution $x$ with

$$
\max_i\lvert x_i-x_i^*\rvert \le \tfrac12\binom{k}{t+1}.
$$

In particular, a nonnegative solution exists whenever $2N\ge(k+1)\binom{k}{\lfloor k/2\rfloor}\binom{k}{t+1}$.

**Proof.** There is an integer particular solution $z$. Set $z_0,\ldots,z_{d-1}$ to zero, then solve successively for $z_{d+a}$, whose coefficient in equation $a$ is one. This also proves that the $t+1$ equations are independent, so their real kernel has dimension $d$.

For $0\le h<d$, let

$$
B_{ih}=(-1)^i\binom{i}{h}\binom{k-i}{d-1-h},
\qquad 0\le i\le k.
$$

Apart from the sign this is a polynomial in $i$ of degree at most $d-1$. Its alternating $d$th difference vanishes. Thus every column of $B$ belongs to the kernel. In rows $0,\ldots,d-1$ the entries above the diagonal vanish and its diagonal entries are nonzero. The columns are consequently a real basis of the kernel consisting of integer vectors. The beta-integral calculation from [Lemma 3](#lemma-3) shows that $x^*$ also satisfies the equations, so write $x^*-z=Bv$ and round the coordinates of $v$. The vector $x=z+B\left\lfloor v\right\rceil$ is integral, and the error in its $i$th coordinate is at most

$$
\tfrac12\sum_{h=0}^{d-1}\binom{i}{h}\binom{k-i}{d-1-h}
=\tfrac12\binom{k}{d-1}=\tfrac12\binom{k}{t+1}.
$$

The smallest coordinate of $x^*$ is $N/((k+1)\binom{k}{\lfloor k/2\rfloor})$, giving the last assertion. $\square$

**Proof of [Theorem 2](#theorem-2).** For the lower bound take fixed $0<\epsilon<1$ and set $k=\lfloor(1-\epsilon)\log_2 N\rfloor$. By Stirling's formula, $k=\Theta(t\log t)$, so $k\ge t+1$ for sufficiently large $t$. The estimate $\binom{k}{t+1}\le(ek/(t+1))^{t+1}$ gives $\log((k+1)\binom{k}{t+1})=O(t\log\log t)=o(\log N)$. Also $\binom{k}{\lfloor k/2\rfloor}\le 2^k\le N^{1-\epsilon}$. Their product is at most $N^{1-\epsilon+o(1)}$, which meets the condition in [Lemma 4](#lemma-4) for sufficiently large $t$.

For the upper bound select a uniformly random row from any such array and write $W$ for its weight. On any $j\le t$ prescribed positions, a specified pattern of $a$ ones and $b=j-a$ zeros has probability $\int_0^1p^a(1-p)^b\,dp$. At $j=t$ this is the defining equality. At smaller $j$ sum over the other $t-j$ coordinates, which multiplies the integrand by $(p+(1-p))^{t-j}=1$. Conditional on $W=w$, the support is uniform over the $w$-subsets by column symmetry. For $2s\le t$, the probability of a specified $s$ ones and $s$ zeros is therefore

$$
\frac{1}{(2s+1)\binom{2s}{s}}
=\mathbb E\!\left[\frac{(W)_s(k-W)_s}{(k)_{2s}}\right],
$$

where $(u)_r$ denotes a falling factorial. Some occupied weight $w$ attains at least the displayed average. Using $\binom{2s}{s}\le4^s$ and $(k)_{2s}\ge(k-2s+1)^{2s}$ yields

$$
\frac{w(k-w)}{k^2}\ge
\frac{(1-(2s-1)/k)^2}{4(2s+1)^{1/s}}.
$$

With $s=\lfloor\sqrt t\rfloor$ for $t\ge4$, the right side tends to $1/4$ uniformly in $k\ge t$. Thus $w/k=1/2+o(1)$. The whole layer of $\binom{k}{w}$ distinct words occurs, so $\log_2 N\ge\log_2\binom{k}{w}=(1-o(1))k$ by Stirling's formula. For fixed $t\ge2$, the earlier probability identity with $s=1$ gives an occupied weight $w$ with $w(k-w)\ge k(k-1)/6$. Writing $m=\min(w,k-w)$ gives $m\ge(k-1)/6$ and $\binom{k}{w}=\binom{k}{m}\ge\binom{2m}{m}\ge2^m$. Thus $N\ge2^{(k-1)/6}$, proving finiteness. Letting $\epsilon$ decrease to zero finishes the proof. $\square$

## 4. Finite verification and reproducibility

The rounding calculation uses only integers. To form $y_j$, divide $N$ by $j+1$ with remainder. Round up if twice the remainder exceeds $j+1$. At equality, round to the even of the two neighboring integers. The generator [construct.py](construct.py) then forms consecutive differences of the list $(y_j)$ to obtain $(x_i)$. The verifier [verify.py](verify.py) checks the nonnegativity of the supplied multiplicities, evaluates each sum in [(1)](#equation-1) directly, and independently checks the row total $\sum_i\binom{k}{i}x_i$.

| Strength $t$ | Width $2t$ | $\min_i x_i$ | Certificate source |
| ---: | ---: | ---: | --- |
| 1–16 | 2–32 | $\ge0$ | [small.json](small.json) |
| 17 | 34 | 77,537 | Rounding construction |
| 18 | 36 | 350,847 | Rounding construction and [t18.json](t18.json) |
| 19 | 38 | 1,792,479 | Rounding construction |
| 20 | 40 | 9,032,086 | Rounding construction |
| 21 | 42 | 48,444,386 | Rounding construction |

From the `excess-arrays/` directory, reproduce the stored and generated strength-$18$ certificates with the Python standard library.

```sh
python3 verify.py small.json t18.json
python3 construct.py 18 36 > /tmp/excess-t18.json
python3 verify.py /tmp/excess-t18.json
```

The strength-$18$ check reports $19$ validated equations and row total $121{,}645{,}100{,}408{,}832{,}000$. To regenerate the other rounded cases, use [construct.py](construct.py) with the strength as its sole argument. The width defaults to twice the strength. The finite output is in [results.csv](results.csv) and the build and computation record is in [verification.log](verification.log). The repository also includes a [SHA-256 manifest](../SHA256SUMS).


### Correction of the strength-18 computation

The journal reports that equation (3) has no nonnegative integer solution at strength $18$ in its symmetric system. The vector in [Appendix A](#a-the-strength-18-certificate) gives a positive solution to that precise system. All 37 entries are positive, the minimum is $350{,}847$, and their layer-weighted sum is $121{,}645{,}100{,}408{,}832{,}000=19!$. The [residual table](../research/audit/outputs/t18-residuals.csv) gives the two integer sides and the zero residual for each prescribed weight $a=0,\ldots,18$. The mathematical check requires only the printed vector and the binomial coefficients. The [independent checker](../research/audit/verify_t18.py) repeats it using the original JSON, whose SHA-256 is `3a47a3097137861a846d3bc62b72240cc96e6190831a978f4fd5cfd563cd6986`. [Original equation (3)](https://link.springer.com/article/10.1007/s10623-025-01722-9#Equ3)

From the repository root the check can also be performed as follows.

```python
import json
from math import comb, factorial
from pathlib import Path

d = json.loads(Path("excess-arrays/t18.json").read_text(encoding="utf-8"))
x = d["multiplicities"]
assert (d["strength"], d["columns"]) == (18, 36)
assert len(x) == 37 and all(type(v) is int and v > 0 for v in x)
assert min(x) == 350847
for a in range(19):
    lhs = sum(comb(18, j) * x[a+j] for j in range(19))
    rhs = factorial(a) * factorial(18-a)
    assert lhs == rhs
    print(a, lhs, rhs, lhs-rhs)
assert sum(comb(36, i) * v for i, v in enumerate(x)) == factorial(19)
```

## 5. Machine-checked proof

The Lean model represents an array by a function from binary words to natural-number multiplicities. It enumerates the compatible binary words for each partial pattern and proves that the enumeration has no duplicates. The total mass of all width-$k$ words is checked separately. The existence statement quantifies over each pattern of length $k$ with precisely $k-t$ unspecified positions.

For the small certificates, iterated Pascal sums compute the margins from the literal vectors of weight-indexed multiplicities. From strength $22$ on, the proof rescales the rational counts to integers and verifies the error estimate and exact margins through identities for consecutive differences. This gives a proof for arbitrary $t$, including strengths outside the finite checks.

| Declaration in namespace `Excess` | Mathematical content |
| --- | --- |
| [`equation_three_18`](lean/ExcessArrays.lean) | All 19 equations of the original system |
| [`exists_binary_excess_array_18`](lean/ExcessArrays.lean) | The concrete width-36 array |
| [`exists_symmetric_binary_excess_array`](lean/MainResult.lean) | Existence for every positive strength at width $2t$ |

Run `lake build` within `excess-arrays/lean/` using the pinned Lean 4.19.0 toolchain. The build prints an axiom audit in [MainResult.lean](lean/MainResult.lean). Theorem `equation_three_18` has an empty axiom list. The concrete existence theorem uses `propext` and `Quot.sound`, and the general existence theorem also uses `Classical.choice`. [Theorem 2](#theorem-2) and its asymptotic estimates are proved in [Section 3](#3-maximum-width-under-column-symmetry).

## 6. Prior work and scope

Chee, Colbourn, Horsley and Zhou relate sequence covering arrays to excess coverage arrays. Gentle, Horsley and Wanless apply that relation to the binary system considered here. A binary array addresses the resulting necessary condition. The results here address the binary system in Section 5. Theorem 1 of Gentle, Horsley and Wanless, which bounds the order of minimum-size sequence covering arrays of strength $7$, concerns a different parameter and construction. [Chee et al.](#ref-chee) · [Gentle, Horsley and Wanless](#ref-ghw)

Longyear, Shirakura and Kuriki study general existence criteria and constructions for balanced arrays. Our claims concern the particular factorial index vector, the exact row count $N=(t+1)!$, and, in [Theorem 2](#theorem-2), column symmetry. Its upper bound applies within that symmetry class. [Longyear](#ref-longyear) · [Shirakura](#ref-shirakura) · [Kuriki](#ref-kuriki)

The repository's literature comparison records the journal and preprint versions, searches for corrections, and searches under both excess coverage and balanced-array terminology. Those public searches identified neither a correction for the strength-$18$ system nor a prior proof of the symmetric width formula. Priority remains subject to sources outside the search coverage. This preprint and its artifacts were prepared with substantial AI assistance in discovery, proof development, formalization, verification and writing. Author attribution and independent human review are pending. [Literature comparison](PRIOR_ART.md)

### Scope of the results

| Statement | Evidence in this paper |
| --- | --- |
| Equation (3) is feasible at strength 18 | Explicit integer certificate and Lean audit |
| Minimum-row width $2t$ exists for every positive strength | Written proof with explicit finite inputs, also formalized in Lean |
| Maximum symmetric width is asymptotic to $\log_2((t+1)!)$ | Written proof |
| Exact finite maximum width at arbitrary strength | Outside the results |
| Maximum width without column symmetry | Outside the results |
| The revised Levenshtein conjecture | Outside the results |

## A. The strength-18 certificate

For each weight $i$, include $x_i$ copies of every binary word of length $36$ and weight $i$. The same vector is supplied in [t18.json](t18.json).

| $i$ | $x_i$ | $i$ | $x_i$ | $i$ | $x_i$ |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 3287704746234543 | 13 | 1711162 | 26 | 12934239 |
| 1 | 91325561677561 | 14 | 717000 | 27 | 34922343 |
| 2 | 5218331986327 | 15 | 668613 | 28 | 108647345 |
| 3 | 460609882625 | 16 | 408459 | 29 | 393846602 |
| 4 | 55728278943 | 17 | 404361 | 30 | 1687914016 |
| 5 | 8769561774 | 18 | 350847 | 31 | 8720889081 |
| 6 | 1660738944 | 19 | 388109 | 32 | 55813690119 |
| 7 | 408707871 | 20 | 447235 | 33 | 460462943481 |
| 8 | 100683849 | 21 | 591566 | 34 | 5218580026119 |
| 9 | 39109461 | 22 | 865672 | 35 | 91325150457081 |
| 10 | 10767879 | 23 | 1422819 | 36 | 3287705416454919 |
| 11 | 6580331 | 24 | 2626677 |  |  |
| 12 | 2062333 | 25 | 5472117 |  |  |


## B. The finite arithmetic in the all-strength proof

The following vectors are the printed certificates for $1\le t\le16$. Entries are in order of increasing weight and the width is $2t$. The same vectors appear in [small.json](small.json).

```text
t= 1: 1, 0, 1
t= 2: 2, 0, 0, 1, 0
t= 3: 0, 2, 0, 0, 0, 2, 0
t= 4: 4, 5, 0, 0, 0, 1, 0, 0, 20
t= 5: 60, 9, 1, 0, 1, 0, 0, 1, 2, 3, 75
t= 6: 384, 35, 4, 3, 0, 1, 0, 1, 0, 3, 4, 35, 384
t= 7: 2660, 207, 22, 11, 1, 2, 1, 0, 2, 1, 0, 17, 7, 236, 2611
t= 8: 21404, 1307, 188, 36, 11, 6, 2, 2, 2, 1, 4, 4, 9, 52, 138, 1426,
      21160
t= 9: 190751, 10687, 1238, 225, 72, 17, 12, 6, 4, 4, 5, 4, 15, 12, 85,
      183, 1365, 10349, 191552
t=10: 1901427, 94793, 10075, 1664, 379, 134, 43, 27, 14, 12, 10, 11, 16,
      23, 52, 116, 405, 1651, 10005, 95114, 1900513
t=11: 20823663, 947618, 89827, 13613, 2831, 791, 280, 122, 65, 42, 32, 30,
      31, 45, 57, 143, 227, 914, 2577, 14067, 89159, 948299, 20823718
t=12: 249082448, 10377396, 903011, 122785, 23567, 5813, 1862, 721, 335,
      193, 126, 100, 92, 100, 127, 190, 338, 730, 1805, 6003, 23069,
      123919, 900668, 10381895, 249074297
t=13: 3228809222, 124193097, 9931612, 1243160, 215492, 49245, 13980, 4917,
      2067, 1032, 609, 417, 335, 310, 335, 416, 612, 1027, 2074, 4902,
      14030, 49083, 215942, 1242071, 9933977, 124188378, 3228818023
t=14: 45092220022, 1610439292, 119288784, 13766272, 2201311, 459256,
      119533, 38122, 14507, 6523, 3440, 2098, 1483, 1204, 1124, 1205,
      1480, 2106, 3420, 6568, 14419, 38268, 119331, 459496, 2200981,
      13767153, 119285548, 1610450186, 45092188223
t=15: 674928631941, 22497649522, 1551551934, 166241131, 24627062, 4736577,
      1136398, 331706, 115213, 47227, 22439, 12366, 7799, 5637, 4641,
      4351, 4641, 5636, 7804, 12349, 22488, 47101, 115504, 331104,
      1137513, 4734709, 24630013, 166236216, 1551562049, 22497623313,
      674928706043
t=16: 10778407135878, 336825119220, 21730698238, 2173051362, 299738047,
      53522456, 11894434, 3202275, 1024707, 384280, 167079, 83532, 47740,
      31026, 22864, 19052, 17932, 19052, 22864, 31026, 47741, 83524,
      167114, 384173, 1024945, 3201952, 11894225, 53525772, 299723538,
      2173098878, 21730564584, 336825458846, 10778406336130
```

For each displayed vector form a triangular array by setting $D_{0,i}=x_i$ and $D_{r+1,i}=D_{r,i}+D_{r,i+1}$ for $0\le i<2t-r$. Pascal's identity gives $D_{r,i}=\sum_{j=0}^{r}\binom rj x_{i+j}$ by induction on $r$. The row at $r=t$ is $(i!(t-i)!)_{i=0}^{t}$ for each printed vector. At $t=2$, for example, the rows starting at $(2,0,0,1,0)$ give $(2,0,1,1)$ and then $(2,1,2)$. This verifies all prescribed marginals using integer addition and the explicit vectors. The total row count follows by summing the prescribed margins on any fixed set of columns.

For $17\le t\le21$, all values needed for the corresponding finite checks follow from [(2)](#equation-2) by integer division with the stated tie rule and consecutive differences. In particular, starting at the list $(y_0,\ldots,y_{2t})$, replace each adjacent pair by its first entry minus its second, repeatedly. The first entry on step $2t-i$ of the same process applied to the tail starting at $y_i$ is $x_i$. This is [(2)](#equation-2) by induction using Pascal's identity. The margins already follow from [Lemma 3](#lemma-3), so these five cases require only the positivity checks in Section 4. At the general threshold $t=22$, the two sides $2(23!)$ and $45\cdot3^{44}$ are respectively $51704033477769953280000$ and $44314690598262505479645$. The monotonic ratio in the proof then handles every greater strength.

## References

<a name="ref-ghw"></a>

1. A. E. Gentle, D. Horsley, and I. M. Wanless. *Excess coverage arrays and Levenshtein's conjecture*. Designs, Codes and Cryptography **93** (2025), 5257–5269. [doi:10.1007/s10623-025-01722-9](https://doi.org/10.1007/s10623-025-01722-9)

<a name="ref-kuriki"></a>

2. S. Kuriki. *On existence and construction of balanced arrays*. Discrete Mathematics **116** (1993), 137–155. [doi:10.1016/0012-365X(93)90398-D](https://doi.org/10.1016/0012-365X(93)90398-D)

<a name="ref-shirakura"></a>

3. T. Shirakura. *Contributions to balanced fractional* $2^m$ *factorial designs derived from balanced arrays of strength* $2l$. Hiroshima Mathematical Journal **7** (1977), 217–285. [doi:10.32917/hmj/1206135961](https://doi.org/10.32917/hmj/1206135961)

<a name="ref-chee"></a>

4. Y. M. Chee, C. J. Colbourn, D. Horsley, and J. Zhou. *Sequence covering arrays*. SIAM Journal on Discrete Mathematics **27** (2013), 1844–1861. [doi:10.1137/120894099](https://doi.org/10.1137/120894099)

<a name="ref-longyear"></a>

5. J. Q. Longyear. *Arrays of strength* $s$ *on two symbols*. Journal of Statistical Planning and Inference **10** (1984), 227–239. [doi:10.1016/0378-3758(84)90075-2](https://doi.org/10.1016/0378-3758%2884%2990075-2)

<a name="ref-mathon"></a>

6. R. Mathon and Tran van Trung. *Directed t-Packings and Directed t-Steiner Systems*. Designs, Codes and Cryptography **18** (1999), 187–198. [DOI](https://doi.org/10.1023/A:1008353723204)
