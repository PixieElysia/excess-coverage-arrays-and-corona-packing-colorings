# 两项离散数学研究结果

本仓库收录两份英文研究稿、Lean 4.19 形式化、独立计算核验、可复现日志和文献对照。论文为 AI 辅助研究稿，作者署名及独立评审待定。

## 二元超额覆盖阵列

对每个正整数强度 $t$，存在一个有 $(t+1)!$ 行、$2t$ 列的二元超额覆盖阵列。任取 $t$ 列，在这些列中恰含 $a$ 个 1 的任一指定模式都出现 $a!(t-a)!$ 次。列置换保持阵列的行重数。逐个模式求和表明 $(t+1)!$ 是最少行数。

强度 18 时，37 个正整数重数满足期刊论文第 5 节式 (3) 的全部 19 个等式，最小值 350847。该证书更正了该论文在此参数下的不可行性报告。所有正强度的存在性和强度 18 的精确方程均通过 Lean。附加的列对称最大宽度渐近结论采用论文中的书面证明。 [原论文](https://link.springer.com/article/10.1007/s10623-025-01722-9#Equ3) · [研究稿](../excess-arrays/paper.pdf) · [Lean](../excess-arrays/lean/MainResult.lean)

## 路、圈与一条边的冠积

当 $n\ge12$ 时，$P_n\odot K_2$ 的填充色数恒为 7。$C_n\odot K_2$ 的填充色数在 $n=13$ 时为 8，其余均为 7。这解决了原论文第 107 页的两个问题。Lean 直接从图边及游走定义出发证明任意长度的精确值。 [原论文](https://dergipark.org.tr/en/download/article-file/5580259#page=14) · [研究稿](../packing-corona/paper.pdf) · [Lean](../packing-corona/lean/EdgeColors.lean)

在仓库根目录运行 `./verify.sh` 可重编译两套形式化并执行独立计算验证。 [仓库入口](../README.md) · [复现审计](../REPRODUCIBILITY_AUDIT.md) · [研究接续记录](PROGRESS.md)
