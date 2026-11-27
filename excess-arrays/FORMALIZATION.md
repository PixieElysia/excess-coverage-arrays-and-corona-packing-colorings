# What the Lean array represents

For width $k$, give each binary word of length $k$ a natural-number multiplicity. A word with multiplicity four contributes four rows. Row order is immaterial. The witness in Lean is a total function `m : List Bool → Nat`. Measurements use completions of length-$k$ patterns, so changing the value of `m` at any other length leaves every measurement unchanged. [Patterns.lean](lean/Patterns.lean) · [Certificate.lean](lean/Certificate.lean)

| Mathematical object | Lean representation | Meaning |
| --- | --- | --- |
| Specified and free columns | `p : List (Option Bool)`, `free p`, `ones p` | `some true` and `some false` fix a bit. `none` leaves that column free. `ones` counts fixed true bits. |
| Compatible complete rows | `completions p`, `compatible p w` | `mem_completions_iff` characterizes the enumerated words. `completions_nodup` ensures each different completion contributes its multiplicity exactly once. |
| Mass of a pattern | `mass m p` | Sum of `m w` over the compatible words. The all-free pattern of length $k$ measures the total number of rows. |
| Exact margins | `ExactBinaryArray m N t k` | Total mass is $N$. Every pattern of length $k$ with $k-t$ free positions and $a$ fixed true bits has mass $a!(t-a)!$. |
| Column-permutation symmetry | `fun w => f (wordWeight w)` | Every word of weight $i$ receives the same multiplicity $f(i)$. Its entire weight layer contributes `binom(k,i) * f(i)` rows. |
| Finite certificate | `witness18`, `entry`, `pascalRow` | The 37 entries give multiplicities per word. The 19 finite sums group completions by how many of the free bits equal one. |

Lean uses truncated natural-number subtraction in `k - t`. Interpreting the definition as an array of strength $t$ requires $t\le k$. The universal result specializes to $k=2t$ with $t\ge1$, and the concrete result uses $(t,k)=(18,36)$. Column permutations preserve word weight. Complementing all bits changes $i$ to $k-i$. That additional symmetry would require $f(i)=f(k-i)$. [MainResult.lean](lean/MainResult.lean) · [ExcessArrays.lean](lean/ExcessArrays.lean)

For a fixed column set the $2^t$ patterns partition the rows. Summing their required masses gives $\sum_{a=0}^t\binom{t}{a}a!(t-a)!=(t+1)!$. With the same values as lower bounds, that sum proves a lower bound on the number of rows. The named Lean theorem supplies an exact-margin witness meeting it. The optimization statement and the maximum-width asymptotics have separate entries in the [coverage table](THEOREM_COVERAGE.md).
