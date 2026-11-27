# Mathematical review guide

The original theorem and proof blocks are protected. This guide records the main checks a reader can repeat using the manuscripts alone. The present review is internal to the revision. Independent human review remains open.

| Step | Mathematical check |
| --- | --- |
| Binary minimum row count | Every row realizes exactly one pattern on the chosen columns. The sum of the required counts is (t+1)!. |
| Exact margins after rounding | For j≤t, j+1 divides (t+1)!. Inclusion–exclusion uses only these moments for a strength-t margin. Negative coefficients are permitted during inversion, with nonnegativity handled separately. |
| Array nonnegativity and finite cases | Verify the base integer inequality at t=22 and the one-step ratio. For t=17–21 the difference recurrence gives the listed minima. For t=1–16 use the full printed vectors and Pascal's recurrence. The strength-18 residuals also appear as a separate certificate. |
| Lattice rounding in the width lower bound | The equation matrix has rank t+1 from its triangular block. The d alternating-polynomial columns are independent by a different triangular block. Rounding coordinates costs at most half the Vandermonde sum. |
| Probability in the width upper bound | Conditioning on the occupied weight gives uniformity among words of that weight. An expectation gives at least one occupied layer. The near-central estimate is uniform for k≥t. For fixed t, take s=1 to get a bound. Stirling's formula gives the asymptotic constant 1. |
| Path lower bound | Fix the second center's color. The permitted-type restrictions hold for actual colors. The recurrence bounds each class from above by its last vertex. For all six cases the printed upper bounds add up to less than the total weight. |
| Cycle lower bound | The individual weight bounds add up to 52, forcing equality. Color 4 would have two centers and one satellite. Each of its three directed gaps has parity requiring the same unique seam, although those gaps partition the cycle. |
| Graph upper bound | Use the three threshold tests and componentwise update on all five printed words. Check the common initial and final state, show its reachability, cover all residue classes and apply the lifted-cycle lemma with n>k. The original eight-color word is checked by pair distances. |
| Final logical closure | Restriction to subgraphs preserves a packing coloring. Both lower bounds and each necessary upper bound now have a route in the written papers using complete finite input. |

The path weight table consists of integer data. An optimization solver is unnecessary to verify it. The new audit evaluates the printed recurrence and recomputes the individual maxima separately on explicit graph distances. The earlier algorithms and Lean certificates continue to provide separate evidence. [Array manuscript](../excess-arrays/paper.md) · [Graph manuscript](../packing-corona/paper.md) · [Baseline](PROOF_BASELINE.md)
