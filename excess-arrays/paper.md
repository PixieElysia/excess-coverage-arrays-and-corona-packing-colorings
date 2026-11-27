# Minimum-size binary excess coverage arrays

**Exact existence and asymptotic width under column symmetry**

**Research preprint v0.2 · 27 November 2026**

AI-assisted research manuscript. Author attribution pending human review.

[Manuscript PDF](paper.pdf) · [LaTeX source](paper.tex) · [Reproducibility audit](../REPRODUCIBILITY_AUDIT.md)

## Abstract

Gentle, Horsley and Wanless (2025, Section 5) reported that a system of binomial equations for column-symmetric binary excess coverage arrays has no nonnegative integer solution at strength $18$ and width $36$. We give a strictly positive solution. All $37$ multiplicities are explicit, with minimum $350{,}847$. More generally, every positive strength $t$ admits a column-symmetric array with $2t$ columns and the minimum possible number of rows, $(t+1)!$. The construction rounds intersection counts and uses inclusion–exclusion to recover the row multiplicities. Exact certificates cover the remaining small strengths. For the largest achievable width under column symmetry we prove the asymptotic formula $(1+o(1))\log_2((t+1)!)$. Lean 4.19 verifies the strength-$18$ certificate and the existence theorem for all positive strengths. The asymptotic formula is proved mathematically in the text. [Original paper, Section 5](https://link.springer.com/article/10.1007/s10623-025-01722-9#Sec5)

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

## 2. Rounding intersection counts

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
