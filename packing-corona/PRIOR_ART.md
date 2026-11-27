# Literature comparison

## Sampathkumar, Sivakaran and Unnikrishnan

R. Sampathkumar, T. Sivakaran and R. Unnikrishnan studied precisely the coronas $P_n\odot K_2$ and $C_n\odot K_2$ in *TWMS Journal of Applied and Engineering Mathematics* 16(1), 94–108 (2026). Their Section 4 on printed page 107 conjectures that $P_{12}\odot K_2$ needs at least seven colors and asks for the exact packing chromatic number of the cycle corona for all $n\ge12$. [Journal record](https://dergipark.org.tr/en/pub/twmsjaem/article/1858469) · [Printed page 107](https://dergipark.org.tr/en/download/article-file/5580259#page=14)

| Question | Published result | Result in this repository |
| --- | --- | --- |
| Path coronas with $n\ge12$ | Theorem 2.1 gives a seven-color upper bound. Section 4 conjectures the matching lower bound at $n=12$. | The six-color obstruction at $n=12$ establishes the sharp lower bound and hence the exact value seven for every $n\ge12$. |
| The cycle corona at $n=13$ | Theorem 3.1 and its proof give an eight-coloring. | A seven-color obstruction gives exact value eight. The manuscript credits the eight-coloring to the original authors. |
| Cycle coronas with $n\ge12$ and $n\ne13$ | Theorem 3.1 gives a seven-color upper bound except at $n\in\{15,21\}$ or $n\equiv11\pmod{12}$, where its upper bound is eight. | Compatible explicit words give a seven-color upper bound at every length in this range, including the cases where the earlier bound was eight. The path obstruction supplies the lower bound. |

The original paper also gives exact values for $2\le n\le11$ for paths and $3\le n\le11$ for cycles. Those values sit outside the theorem here. The new Lean theorems express the exact formulas through walks in the explicitly defined graph and cover every $n\ge12$. [Theorem 2.1](https://dergipark.org.tr/en/download/article-file/5580259#page=2) · [Theorem 3.1](https://dergipark.org.tr/en/download/article-file/5580259#page=4) · [Lean exact formulas](lean/EdgeColors.lean)

## Related graph families

Laïche, Bouchemakh and Sopena’s earlier work on path and cycle $p$-coronas attaches $p$ independent leaves per base vertex. The attached vertices in the present graphs are adjacent and form a triangle with the base vertex. [2017 paper](https://arxiv.org/abs/1506.07248)

Furmańczyk, Gözüpek and Özkan define path-aligned graph products. Their clique-chain bounds in Section 3.2 consider at least two backbone vertices in each clique. The path corona here has just one backbone vertex in each triangle. [2025 preprint, Section 3.2](https://arxiv.org/html/2511.12761v1#S3.SS2)

## Search scope and verification

The documented search on 26–27 November 2026 Shanghai time used the authors’ names, the paper’s complete title, exact graph parameters, and variants of *packing coloring*, *packing colouring* and *chain of triangles*. The search retrieved the original paper and related graph families. No prior proof of either exact formula was located in the material examined. The journal source and its page-107 questions were verified directly. [Search record](../research/SOURCES.md) · [OpenAlex record](https://openalex.org/W7127745577)

The manuscript is an AI-assisted research draft. Two independent Python programs reproduce the finite obstructions, and the Lean project gives the complete classification. The verification record identifies the certificate checker and its trust dependencies. Independent human review and author attribution remain pending. [Manuscript](paper.pdf) · [Verification record](../research/VERIFICATION.md)

## Revision cross-check

The full-text recheck confirms the exception set in Theorem 3.1 and attributes the particular eight-color word to its authors. The path-aligned preprint's Section 3.2.1 asks boundedness in the single-backbone-vertex case. The 2026 target paper already bounded the triangle case, whose exact eventual value is given here. The added written lower-bound arguments handle the same finite instances as the preserved transfer proof. [Detailed primary-source comparison](../research/GRAPH_LITERATURE.md)
