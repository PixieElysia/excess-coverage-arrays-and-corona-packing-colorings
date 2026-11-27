# 验证记录

验证环境使用 Lean 4.19.0 和 Python 3.12。仓库根目录的 `./verify.sh` 编译两套 Lean 工程，并重跑全部随附证书和独立图搜索。

## 覆盖阵列

- `Excess.equation_three_18` 核对论文原式 (3) 的全部取值。Lean 公理审计为空。
- `Excess.exists_binary_excess_array_18` 给出实际二元字的重数及任意指定模式的覆盖次数。Lean 报告 `propext` 和 `Quot.sound`。
- `Excess.exists_symmetric_binary_excess_array` 证明所有正强度的存在性。Lean 报告 `propext`、`Classical.choice` 和 `Quot.sound`。
- Python 核对了 $t=18$ 的 37 项证书、19 个边际方程及总行数 $121645100408832000$，并独立检查了小强度证书。附加的列对称最大宽度渐近结果采用研究短文中的数学证明。

## 图染色

- `CoronaUpper.path_exact_on_edges` 和 `CoronaUpper.cycle_exact_on_edges` 证明所有 $n\ge12$ 的精确色数。形式化从实际图边出发，证明最短游走长度等于短文给出的公式。两条定理经 Lean 审计均依赖 `propext`、`Classical.choice`、`Lean.ofReduceBool` 和 `Quot.sound`。`Lean.ofReduceBool` 用于 Lean 4.19 标准库 `bv_decide` 的 LRAT 回放，其信任基础包含 Lean 编译器。
- 路的六色状态前沿在第十二列为空。圈的七色转移图含 2999 个状态及 11778 条弧，长度 13 的闭游走数为零。独立顶点搜索分别访问 10221 和 162103 个搜索节点后报告无解。
- Python 检查了五个共用接缝的构造块、其全部 25 个有序配对和 $C_{13}$ 的显式八色着色。Lean 对所有长度的上界使用有限模板和已证明的周期缩减。

两篇 PDF 均从仓库中的 LaTeX 源码构建。
