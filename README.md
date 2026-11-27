# 两项离散数学研究结果

## 二元超额覆盖阵列

对每个正整数强度 $t$，存在一个有 $(t+1)!$ 行、$2t$ 列的二元超额覆盖阵列。任取 $t$ 列，在这些列中恰含 $a$ 个 1 的任一指定模式都出现 $a!(t-a)!$ 次。阵列的行重数在列置换下保持不变。$(t+1)!$ 是逐个模式求和给出的最少行数。

在 $t=18$ 时，37 个非负整数重数直接满足 Gentle、Horsley 和 Wanless 论文第 5 节式 (3) 的全部 19 个等式，最小值为 350847。它给出一个 $19!$ 行、36 列的阵列，并更正了该论文在这一参数下的不可行性报告。论文还证明了列置换对称阵列的最大宽度渐近为 $\log_2((t+1)!)$。[原文](https://doi.org/10.1007/s10623-025-01722-9)

- [研究短文](excess-arrays/paper.pdf) · [LaTeX](excess-arrays/paper.tex) · [强度 18 的整数证书](excess-arrays/t18.json)
- [全强度存在性 Lean 定理](excess-arrays/lean/MainResult.lean) · [原式 (3) 的无公理验算](excess-arrays/lean/ExcessArrays.lean)
- 渐近宽度结论由短文中的数学证明给出。阵列存在性和指定模式计数已通过 Lean 4.19 检查。

## 路、圈与一条边的冠积

对于 $n\ge12$，$P_n\odot K_2$ 的填充色数为 7，$C_n\odot K_2$ 的填充色数也为 7，唯一的例外是 $n=13$ 时为 8。这证明了 Sampathkumar、Sivakaran 和 Unnikrishnan 的猜想，并回答了他们在同一篇论文提出的精确求值问题。[原文第 107 页](https://dergipark.org.tr/en/download/article-file/5580259#page=14)

- [研究短文](packing-corona/paper.pdf) · [LaTeX](packing-corona/paper.tex) · [转移验证](packing-corona/verify.py) · [独立顶点搜索](packing-corona/graph_search.py)
- [全长度精确色数 Lean 定理](packing-corona/lean/EdgeColors.lean) · [检查范围和信任基础](packing-corona/lean/README.md)

## 复现与接续

使用 Python 3.10 或更新版本。Lean 文件只依赖固定版本 Lean 4.19.0 的标准库。安装 Elan 后，在仓库根目录运行以下命令。

```sh
./verify.sh
```

`verify.sh` 核验整数证书、图染色的有限枚举和显式构造，并编译两套 Lean 工程。手动重编译短文可分别在两个主题目录执行 `latexmk -pdf paper.tex`。

[研究接续记录](research/PROGRESS.md) · [文献与优先权检索](research/SOURCES.md) · [验证记录](research/VERIFICATION.md)

两篇短文由 OpenAI Codex 协助生成，作为研究稿提供。文献检索覆盖了期刊版本、较早的相关工作和可查询的引用索引，结果尚未经过独立同行评审。
