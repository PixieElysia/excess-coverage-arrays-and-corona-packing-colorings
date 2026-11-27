# 文献与优先权检索记录

核查日期为 2026 年 11 月 26 日。以下记录给出原问题、已发表结果和检索范围，以便重跑。文献索引会滞后，未公开的手稿也可能包含同一结果。

## 二元超额覆盖阵列

**原问题。** Gentle、Horsley 和 Wanless 在期刊版第 5 节式 (3) 把具有列置换对称性的阵列化为非负整数方程。紧随该式的一段报告强度 1 至 17 均有解，强度 18 无解，同时保留一般 18 强度、36 列阵列存在的可能。期刊版于 2025 年 8 月 30 日发表。arXiv 的提交历史仅列 2024 年 11 月 26 日的 v1。论文的主定理涉及另一个参数组的序列覆盖阵列。[期刊版第 5 节](https://link.springer.com/article/10.1007/s10623-025-01722-9#Sec5) · [arXiv 版本历史](https://arxiv.org/abs/2411.17145) · [作者机构记录](https://research.monash.edu/en/publications/excess-coverage-arrays-and-levenshteins-conjecture/)

**勘误及引用追踪。** 以 DOI、完整标题搭配 `corrigendum`、`erratum`、`correction`，以及 `binary excess coverage arrays 18 36 construction` 和 `Gentle Horsley Wanless factorial symmetric 2t` 检索。结果仍指向原文。Crossref 更新查询返回 0 条，OpenAlex 把期刊 DOI 和预印本 DOI 归入同一记录，显示 0 次被引，更新时间为 2026 年 11 月 25 日。Semantic Scholar 也列出 0 篇引用文献。这些数目仅描述各索引在核查时的记录。[Crossref 更新查询](https://api.crossref.org/works?filter=updates%3A10.1007%2Fs10623-025-01722-9) · [OpenAlex](https://api.openalex.org/works/W4413852205) · [Semantic Scholar](https://api.semanticscholar.org/graph/v1/paper/1d2b6a7d196c2ef2bafda78c4677677d51f007b7?fields=title,citationCount,citations.title)

**相关领域。** Chee 等给出了从序列覆盖阵列获得超额覆盖阵列的必要条件。统计试验设计文献的二元 *balanced array* 允许每种重量的投影有指定重数。此处的指标向量为 $\mu_i=i!(t-i)!$。若行重数只依赖全行重量，这一对象在该文献中称为 *simple array*。另以 `simple arrays prescribed index set`、`maximum number of constraints balanced arrays`、`regular t-wise balanced design`、`restricted min-wise independent` 和 `exchangeable binary factorial marginals` 等表述检索。已有文献给出一般存在性判据、必要界及特定参数的构造。在检查的资料中，没有找到这组指标在 $(t+1)!$ 行上覆盖全部 $k=2t$ 的结论，也没有找到本项目列对称最大宽度的渐近式。部分早期文献只能核对出版摘要。[Chee 等](https://doi.org/10.1137/120894099) · [Longyear，二元阵列的一般存在条件](https://doi.org/10.1016/0378-3758%2884%2990075-2) · [Kuriki，平衡阵列综述](https://doi.org/10.1016/0012-365X%2893%2990398-D) · [simple array 的定义](https://www.sciencedirect.com/science/article/abs/pii/S037837581930120X) · [相对设计与加权平衡设计](https://arxiv.org/abs/2006.02054)

## 路、圈与一条边的冠积

**原问题。** Sampathkumar、Sivakaran 和 Unnikrishnan 的论文载于 *TWMS Journal of Applied and Engineering Mathematics* 16(1), 94–108 (2026)。印刷页 107 第 4 节明确猜想 $\chi_\rho(P_{12}\odot K_2)\ge7$，并要求计算所有 $n\ge12$ 时的 $\chi_\rho(C_n\odot K_2)$。同页已经给出 $n=13$ 的八色构造。刊物的记录列出版日期为 2026 年 1 月 8 日。[原文第 107 页](https://dergipark.org.tr/en/download/article-file/5580259#page=14) · [期刊记录](https://dergipark.org.tr/en/pub/twmsjaem/article/1858469) · [大学知识库](https://my.isik.edu.tr/xmlui/handle/iubelgelik/7155)

**交叉检索。** 以三位作者姓氏、完整文章标题、`packing chromatic number corona K2 P12 C13`、`packing coloring cycle corona with an edge` 和 `chain of triangles packing coloring` 等词组检索。所得同题条目指向上述论文。较早的 Laïche、Bouchemakh 和 Sopena 文中 $p$-冠积为每个基点添加 $p$ 个度为一的邻点，而本题中每对附加点之间也有一条边。Crossref 标题匹配返回其他图参数论文，无法由此建立可靠的引用计数。此次公开检索未找到解决上述两个问题的后续工作。[早期冠积论文及图的定义](https://arxiv.org/abs/1506.07248) · [Crossref 标题查询](https://api.crossref.org/works?query.title=packing%20colorings%20of%20the%20corona%20product%20of%20the%20path%20and%20the%20cycle%20with%20an%20edge&rows=3&select=title%2CDOI)

## 复核

上海时间 2026 年 11 月 27 日 00:45 起，按原论文发表后的日期范围再次检索两组确切参数、英美拼写、作者姓氏以及 `correction`、`construction`、`solution` 等词。返回结果中未发现处理这两项结论的新论文或勘误。直接读取 Springer 网页，确认 `Equ3` 锚点及其后的计算判断仍在。预印本对应锚点为 `S5.E3`。再次查询 Crossref 更新与 OpenAlex 引用数，均为 0。图论论文的原始 PDF 可打开，所列公开问题位于 PDF 第 14 页。[期刊式 (3)](https://link.springer.com/article/10.1007/s10623-025-01722-9#Equ3) · [预印本式 (3)](https://arxiv.org/html/2411.17145v1#S5.E3) · [图论原文](https://dergipark.org.tr/en/download/article-file/5580259#page=14)

## v0.3 revision

The revised source work records separately the journal and preprint theorem numbering for the array paper, the published Chee et al. projection, the exact earlier graph upper-bound exceptions, and limits on access to three classical balanced-array texts. Use the literature matrices for the current comparison. [Article and prior-art matrices](LITERATURE_MATRIX.md)
