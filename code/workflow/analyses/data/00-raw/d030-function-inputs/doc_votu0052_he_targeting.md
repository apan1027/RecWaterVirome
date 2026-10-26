# B. HE 靶向性检验：归巢内切酶是否偏好 nadM–NAMPT 连接

> **问题**：vOTU0052 的 ORF102 夹在 nadM 与 NAMPT 之间。这是**非随机的靶向**，
> 还是「HE 到处都插，恰好也插到了这里」？A2 关闭了原位扩增这条观察路线后，
> 这是主线**唯一**剩下的观察性可证伪点。对应 [HANDOFF.md](HANDOFF.md) §3-B。

**结论：没有 HE 向 nadM–NAMPT 位点富集的证据。**
在 104 个独立的 NARP2 携带噬菌体基因组中，严格位点（两基因之间）**观察 0，零假设期望 0.45**；
放宽到 ±2 / ±5 / ±10 ORF 邻域后，观察值与期望**互有高低、无一致方向**（p = 0.31–1.00）。
谱系去重后结论不变。

**但两种「没有」必须分开说**：

| 尺度 | 状态 | 依据 |
|---|---|---|
| **严格位点**（两基因之间） | **已排除 ≥2 倍富集；更弱的效应仍未检验** | 并入 Prophage-DB 并用同一套 HMM 重算后 n = 72、期望 1.48、观察 0 ⇒ Poisson 95% 单侧上限把富集倍数压到 **≤ 2.0**。但检出 OR = 3 的功效仍只有 46% |
| **邻域尺度**（±5 / ±10 ORF） | **零效应，已被检验** | ±10 窗口期望 9.0、有相当功效，观察 7 **低于**期望 |

⇒ 若存在「HE 广泛偏好 NAD 代谢位点」的效应，±10 尺度应该看得见 —— 没看见。
但**精确落在两基因之间**这种窄靶向，现有数据量根本无法判定（§4）。

## 1. 方法

**数据（复用 pc051e1，未重跑）**：`pc051e1-PhageNAMPT` 已从 INPHARED 提取
**1,369 个 NAMPT 阳性噬菌体基因组**（311,975 蛋白），且 ORF 由 **pyrodigal v3.7.1 统一调用** ——
这正好满足 HANDOFF §3-B 的硬要求「用同一套注释，不可混用各基因组原有注释」。
其中 **104 个**带本地 NMNAT（= 真 NARP2 模块），构成本次分析集。

**HE 判据**：从 Pfam-A 取归巢内切酶的**标准域家族**，`hmmsearch --cut_ga`（用 Pfam 自带的
gathering threshold，不设任意阈值）：

| 家族 | Pfam 模型 |
|---|---|
| GIY-YIG | `GIY-YIG`, `GIY_YIG_2`, `GIY_YIG_3`, `GIY_YIG_domain` |
| HNH / ββα-Me | `HNH`, `HNH_2`–`HNH_5`, `AHH`, `WHH` |
| LAGLIDADG | `LAGLIDADG_1`–`LAGLIDADG_4` |
| NUMOD（HE 的标志性 DNA 结合模块） | `NUMOD1`, `NUMOD3`, `NUMOD4` |

**明确排除**两个同折叠但非内切酶的模型：`GIY-YIG_UvrC`（核苷酸切除修复）与
`LAGLIDADG_WhiA`（转录调控因子，退化折叠）。

**阳性对照（必做）**：同一套 HMM 扫 p0061 的 5 个 NARP2 contig ——
`vctg2997_102` 命中 **GIY-YIG**（ievalue 4.1e-07），与 InterProScan 的独立判定一致；
`vctg3454_22` 命中 **NUMOD3**。⇒ 判据能检出本项目的目标蛋白，"观察 0" 不是流程失败。

**零假设**：每个基因组的 $k_g$ 个 HE 随机分布在它的 $n_g$ 个 ORF 位置上。
窗口大小 $m_g$，则该基因组窗口内含 ≥1 个 HE 的概率为 $1-(1-m_g/n_g)^{k_g}$，
期望即其在基因组间求和。

这个构造让 HANDOFF 要求的两个对照**自动成立**，不必另设：

- **对照 1「是不是哪儿都插」** = 期望值本身就是该基因组的全基因组 HE 密度。
- **对照 2「是不是这个基因组本来 HE 就多」** = 零假设**以各基因组自身的 $k_g$ 为条件**。
  这个对照非有不可：vctg3454 全基因组有 4 个 HE 样 ORF，不校正就会把它算成靶向证据。
- **对照 3 谱系** = 按 genus 折叠后重算（§3）。

## 2. 结果

![HE 靶向性检验](../analyses/figs/votu0052/he_targeting_test.png)

*A：每个窗口下「窗口内含 ≥1 个 HE 的基因组数」的观察值与零假设期望。红柱从未显著高于灰柱，
两种集合一致。B：功效曲线 —— 当前 n = 56 时检出 OR = 3 的功效只有 16%。*

| 集合 | 窗口 | 可评估基因组 | 观察 | 期望 | Poisson p |
|---|---|---:|---:|---:|---:|
| 全部 | 严格（两基因之间） | 56 | **0** | 0.45 | 1.00 |
| 全部 | ±2 ORF | 104 | 3 | 2.26 | 0.39 |
| 全部 | ±5 ORF | 104 | 4 | 4.88 | 0.72 |
| 全部 | ±10 ORF | 104 | 7 | 9.00 | 0.79 |
| 谱系去重 | 严格 | 31 | **0** | 0.25 | 1.00 |
| 谱系去重 | ±2 ORF | 54 | 2 | 1.12 | 0.31 |
| 谱系去重 | ±5 ORF | 54 | 3 | 2.39 | 0.43 |
| 谱系去重 | ±10 ORF | 54 | 5 | 4.40 | 0.45 |

**nadM–NAMPT 之间的 ORF 数分布**（104 个基因组）：相邻无插入 48 个 · 隔 1 个 ORF 42 个 ·
隔 2–4 个 5 个 · 隔 6–9 个 9 个。即**约一半的 NARP2 模块在两基因之间有插入**，
但插入的**不是** HE。

## 3. 谱系聚集是这个体系的系统性混杂

把 127 个间隔内 ORF 送 Pfam 全库比对，命中最高频的是 **`tRNA-synt_2b` ×7**，
其次 **`NADAR` ×3**（NAD/ADP-ribose 相关域）。这两个看上去都与主线机制高度呼应 ——
Chihara 的 SegB 扩增的正是含 tRNA^Tyr 的片段，而 NADAR 直接沾 NAD 代谢。

**但谱系一查就塌**：

| 域 | 命中数 | 来源 | 独立事件数 |
|---|---:|---|---:|
| `tRNA-synt_2b` | 7 | **全部为 Bertelyvirus 属**（MZ574429–433 连号 + OP620777/778），宿主 *Caulobacter* | **1** |
| `NADAR` | 3 | Synechococcus/Kyanoviridae 2 个连号 + Xanthomonas 1 个 | **2** |

而 Bertelyvirus 在这 104 个基因组里恰好就有 7 个 —— **该属全员携带，是共享祖先的基因组结构，
不是 7 次独立获得**。宿主为 *Caulobacter*，与 pc051e1 记录的「NAMPT+atd1 共携带者中
Caulobacterales 占 20/31 = 64.5%」完全吻合。

⇒ **在这个体系里，任何按基因组计数的模式都必须先做谱系折叠**，否则一个属就能制造出
看似 7 倍的"信号"。104 个基因组折叠后只剩 **54 个独立单元**（有插入的仅 31 个）。

## 4. 功效：现有数据规模无法检验严格位点

| 数据量 | 有插入的 NARP2 基因组 | 零假设期望 | 显著所需观察数 | 检出 OR=3 的功效 |
|---|---:|---:|---:|---:|
| **当前** | 56 | 0.45 | ≥3 | **16%** |
| ×2 | 112 | 0.90 | ≥4 | 29% |
| ×4 | 224 | 1.80 | ≥5 | 63% |
| ×8 | **448** | 3.60 | ≥8 | **84%** |

**要以 80% 功效检出 OR = 3，需要约 450 个「有插入的」NARP2 基因组 ≈ 830 个 NARP2 基因组。**

### 4.1 Prophage-DB 扩样的实测结果：救不了功效，但把上限压下来了

[narp2-prophage-insertion.md](narp2-prophage-insertion.md) 用 Prophage-DB（356,776 个 prophage，
6,348,394 条蛋白）实测了这条扩样路线：**全库只找到 21 个完整 NARP2 模块**（0.0059%），
而同一套 HMM 重算 INPHARED 得 128 个（0.3408%）—— 相差 58 倍，且这个差距在双向大小标准化后
压到 1.2–3.4 倍，**主因是基因组大小而非生态状态**（携带者 ORF 中位数 322 vs 39）。

严格位点的可评估基因组因此只从 56 涨到 72（Prophage-DB 仅贡献 4 个，期望 0.04），
**功效 16% → 46%，离 80% 仍需 n ≈ 150**。

**但观察 0 事件本身携带信息**：n = 72 下零假设期望 1.48，观察 0 ⇒ Poisson 95% 单侧上限为 3.0，
即真实富集倍数 **≤ 2.0**。⇒ 本检验的正确表述不是「未被检验」，而是
**「已排除 ≥2 倍的富集，2 倍以下无法判定」**。

**这个数量在可预见的数据源里拿不到**：INPHARED 是已发表噬菌体的全集，1,369 个 NAMPT 阳性里
只有 104 个 NARP2。要 8 倍只能转向宏基因组病毒库（IMG/VR、GOV2、GVD），
但那里的 contig 多为片段化组装 —— 而 [A2](votu0052-coverage-spike.md) 已经证明，
组装不全会同时破坏 NARP2 模块的完整性判定与 ORF 邻接关系。
**用质量更差的数据换样本量，会把系统误差引进检验本身。**

## 5. 对主线的影响

三道观察性闸门跑完，主线的账是这样：

| 检验 | 结果 | 对主线 |
|---|---|---|
| [A 宿主防御前提](votu0052-host-defense-prerequisite.md) | **PASS**（属内 24% 携带 NAD⁺ 耗竭型防御） | 生态前提成立 |
| [A2 原位扩增](votu0052-coverage-spike.md) | **阴性**（1.00×，低于对照） | "原位军备竞赛"卖点消失 |
| **B HE 靶向性** | **无信号**（严格位点功效不足；邻域零效应） | **靶向性未获支持** |

**唯一的正面观察性证据仍然只有一条**：ORF102 的 GC 强离群
（z = −3.32，contig 内百分位 1.4%，四个对照插入 ORF 均不离群 —— [A2 §4](votu0052-coverage-spike.md)），
支持它是近期水平获得的外源元件，但不支持它有催化活性、更不支持它靶向 NARP2。

**三个选项，按可行性排序**：

1. **降级为基因组学观察（推荐）**。把这条线写成「一个 GIY-YIG HE 插入 NARP2 位点的案例报告 +
   三道阴性/无信号的严格检验」。诚实、可发表（作为 short report 或并入主手稿的一节），
   且完整保留了方法学价值（§1 的零假设构造、§3 的谱系混杂案例）。
2. **直接走湿实验**。跳过观察性证据，直接测 ORF102 能否驱动扩增。但 vOTU0052 **没有分离株**
   （HANDOFF §4），须先解决异源表达体系，成本与周期都高，且此时缺乏观察性证据支撑立项。
3. **扩大数据集**。目标明确（~830 个 NARP2 基因组），但 §4 已说明这会以数据质量为代价，
   **不推荐**。

⇒ 建议取 **1**，并把 C（ORF102 定性收紧：HHpred/Foldseek 比对 I-TevI、核对 GIY-YIG 催化残基、
查是否 C 端截断）做完 —— 它成本只有 1–2 天，且能给"案例报告"补上蛋白层面的实质内容。

## 6. 数据出处

| 产物 | 内容 |
|---|---|
| `analyses/data/150-he-targeting/summary/he_targeting_test.tsv` | 8 行（2 集合 × 4 窗口）：可评估基因组数、观察、期望、p —— §2 表的出处 |
| `analyses/data/150-he-targeting/summary/power_analysis.tsv` | 功效曲线 —— §4 表的出处 |
| `analyses/data/150-he-targeting/hmmsearch/he_domains.domtbl` | 311,975 蛋白的 HE 域命中（3,190 个域） |
| `analyses/data/150-he-targeting/hmmsearch/p0061_he.domtbl` | **阳性对照**：p0061 5 个 NARP2 contig 的 HE 命中 |
| `analyses/data/150-he-targeting/hmmsearch/gap_orfs_pfam.domtbl` | 127 个间隔内 ORF 的 Pfam 全库注释 —— §3 的出处 |
| `analyses/data/150-he-targeting/hmm/he_domains.hmm` | 18 个 HE 域模型的子库（含 `he_domains.txt` 清单） |

**上游输入（来自 pc051e1，只读）**：
`pc051e1-PhageNAMPT/analyses/data/06-extract-accession-proteomes/nampt_positive_phages.{faa,gff}` ·
`05-call-local-narp2-modules/local_narp2_window10_{detail,summary}.tsv`

可复现代码（在 git 中）：[analyze.py](../dev/150-he-targeting/analyze.py) ·
[plot_targeting.R](../dev/150-he-targeting/plot_targeting.R)

工具：HMMER hmmsearch/hmmscan（pixi global）· Pfam-A（`~/data2/db/pfam`）。分析日 2026-08-18。

## 7. 相关

- 主线定位：[HANDOFF.md](HANDOFF.md)（本检验对应 §3-B）
- A：[votu0052-host-defense-prerequisite.md](votu0052-host-defense-prerequisite.md)
- A2：[votu0052-coverage-spike.md](votu0052-coverage-spike.md)
- Prophage-DB 扩样（§4 那条「扩大数据集」路线的实测结果）：[narp2-prophage-insertion.md](narp2-prophage-insertion.md)
- 完整分析与文献先验：[votu0052-narp2-antidefense.md](votu0052-narp2-antidefense.md)
