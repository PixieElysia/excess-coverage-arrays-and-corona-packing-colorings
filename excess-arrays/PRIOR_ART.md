# Literature comparison

## Gentle, Horsley and Wanless

Amber E. Gentle, Daniel Horsley and Ian M. Wanless introduced the precise question addressed here in *Excess coverage arrays and Levenshtein’s conjecture*, published online on 30 August 2025 in *Designs, Codes and Cryptography*. Section 5 specializes to binary arrays and reduces the case of width twice the strength to equation (3) by assigning one multiplicity to each row weight. The journal version and the sole arXiv version give the same account of the strength-18 case. [Journal Section 5 and equation (3)](https://link.springer.com/article/10.1007/s10623-025-01722-9#Equ3) · [arXiv equation (3)](https://arxiv.org/html/2411.17145v1#S5.E3) · [Version history](https://arxiv.org/abs/2411.17145)

| Question | Published result | Result in this repository |
| --- | --- | --- |
| Equation (3) for strengths 1 through 17 | Section 5 reports nonnegative integer solutions. | Independent certificates reproduce these cases. |
| Equation (3) for strength 18 | Section 5 reports infeasibility of the weight-symmetric system and leaves existence of a general $19!$-row, 36-column array open. | The 37 multiplicities in [t18.json](t18.json) are positive and satisfy all 19 equations. They yield a column-symmetric array with the required coverage. |
| Equation (3) for every positive strength | Section 5 analyzes the same system and presents computations through strength 18. | The construction proves existence for every $t\ge1$. Lean covers the complete parameter range and counts actual compatible binary words. |
| Largest column-symmetric width with $(t+1)!$ rows | The question in Section 5 concerns width $2t$. | The manuscript proves that the maximum width is asymptotic to $\log_2((t+1)!)$. This supplementary result has a written proof. |

The journal paper uses an implication from sequence covering arrays to excess coverage arrays. The existence theorem here removes this particular binary excess-array obstruction at width $2t$. The reverse implication would require a separate result about sequence covering arrays. The paper’s main result for strength-seven sequence coverage concerns different parameters. [Chee et al., sequence covering arrays](https://doi.org/10.1137/120894099) · [Gentle, Horsley and Wanless, Sections 2 and 5](https://doi.org/10.1007/s10623-025-01722-9)

## Balanced arrays and simple arrays

The prescribed pattern multiplicities $a!(t-a)!$ are an index vector in the theory of binary balanced arrays. Column symmetry is the simple-array case, in which the multiplicity of a full word depends only on its weight. Earlier work develops general existence conditions and constructions for balanced arrays, and uses the same weight representation. The contributions here concern the precise factorial index vector, the attainable width $2t$ at its minimum row count, and the symmetric width asymptotic. [Longyear, *Arrays of strength s on two symbols*](https://doi.org/10.1016/0378-3758%2884%2990075-2) · [Kuriki, *On existence and construction of balanced arrays*](https://doi.org/10.1016/0012-365X%2893%2990398-D) · [Shirakura, simple arrays and balanced fractional factorial designs](https://doi.org/10.32917/hmj/1206135961)

## Search scope and verification

The documented search on 26–27 November 2026 Shanghai time used the title, DOI, exact parameters, and correction terms, as well as terminology from balanced arrays and exchangeable binary marginals. The publisher text still contained the infeasibility report. Searches and the available Crossref, OpenAlex and Semantic Scholar records yielded no earlier correction or construction with these parameters. Some older literature was checked through publisher abstracts. The scope of this check is the public material retrieved through those searches. [Search record](../research/SOURCES.md) · [Crossref update lookup](https://api.crossref.org/works?filter=updates%3A10.1007%2Fs10623-025-01722-9) · [OpenAlex record](https://api.openalex.org/works/W4413852205)

The manuscript and its companion materials form an AI-assisted research draft. The Lean declarations for equation (3), actual array existence at strength 18, and the general existence theorem are listed in the verification record. Independent human review and author attribution remain pending. [Manuscript](paper.pdf) · [Lean entry point](lean/MainResult.lean) · [Verification record](../research/VERIFICATION.md)

## Revision cross-check

The journal version labels the projection Construction 4 and Lemma 5, with the exact row-count statement in Lemma 14. In arXiv v1 these are Construction 3, Lemma 4, and Lemma 12. Equation (3) keeps its number. With sequence strength $s=t+1$ and order $v=2t+1$, the forward implication gives the width-$2t$ binary array. Theorem 2.3 of Chee et al. supplies the corresponding boundary order $v\le2s-1$ for $s\ge3$. [Detailed matrix and locators](../research/ARRAY_LITERATURE.md)

The publisher records for Longyear, Shirakura and Kuriki establish related terminology and general work on existence. Accessible endpoints did not provide their complete texts. The extent to which those criteria specialize to the factorial index, integer multiplicities and asymptotic width remains unknown. This is a pending human literature review item.
