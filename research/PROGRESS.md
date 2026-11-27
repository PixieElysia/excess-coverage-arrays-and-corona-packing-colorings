# 研究接续记录

最终核查日期为 2026 年 11 月 27 日，上海时间。研究笔记内的 11 月 26 日为最初形成结论的日期。

## 二元超额覆盖阵列

原始任务是决定是否存在 $19!$ 行、36 列、强度 18 的二元超额覆盖阵列。期刊第 5 节报告列对称整数系统无解。已给出 37 个整数重数，全部为正，并代回全部 19 个方程。覆盖阵列存在性已推广至所有强度 $t\ge1$ 和宽度 $2t$。数学证明和复现命令见[研究短文](../excess-arrays/paper.pdf)及[形式化定理](../excess-arrays/lean/MainResult.lean)。

小强度用有限证书。强度 22 起，先将全 1 子模式的计数四舍五入，再用布尔格上的容斥恢复整行重数。阶乘分母的整除性保证所需模式计数精确，经过严格的取整误差估计后得非负性。列对称最大宽度的渐近结果在短文中给出数学证明。

## 路、圈与一条边的冠积

原始问题是 $P_{12}\odot K_2$ 的七色下界及 $C_n\odot K_2$ 在 $n\ge12$ 时的精确色数。论文中用有限状态转移排除两个实例，用五个接缝兼容的着色块覆盖所有需要七色的长度。独立逐顶点搜索重新核对两项下界。两项完整分类在 Lean 中把有限下界和任意长度上界合成最终定理，并把距离公式连接到图边及游走。[研究短文](../packing-corona/paper.pdf) · [Lean 定理](../packing-corona/lean/EdgeColors.lean)

## 选题记录

路径隔离博弈的路、圈精确值已有[后续论文](https://arxiv.org/search/?query=Bounds+on+the+game+isolation+number+and+exact+values+for+paths+and+cycles&searchtype=title)。[OEIS A264515](https://oeis.org/A264515) 的平方关系可通过把列按奇偶性分块来解释，研究最终聚焦于上面两组有明确期刊出处的问题。

后续接续可从 [仓库首页](../README.md) 的复现命令和[文献检索记录](SOURCES.md)开始。两个 Lean 工程只依赖 Lean 4.19.0 的标准库。验证报告见 [VERIFICATION.md](VERIFICATION.md)。
