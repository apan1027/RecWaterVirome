# C. ORF102 定性收紧：一个架构完整的 GIY-YIG 归巢内切酶候选

> **问题**：vOTU0052（contig `vctg2997`，132,528 bp，CheckV **medium-quality** 88.84%，宿主
> *Novosphingobium*）的 NARP2 位点是 `nadM(ORF101) – ORF102 – NAMPT(ORF103)`，
> 而 ORF102 是一个 **putative GIY-YIG homing endonuclease candidate**。
> 三道观察性闸门（[A](votu0052-host-defense-prerequisite.md)、
> [A2](votu0052-coverage-spike.md)、[B](votu0052-he-targeting.md)）已把主线定位在
> 「案例报告」这一档；C 的任务是给这个案例补上**蛋白层面的实质**：
> 它到底是一台形状完整的机器，还是一具残骸？对应 [HANDOFF.md](HANDOFF.md) §3-C。

**结论三条：**

1. **活性位点的保守核心残基齐全（预测）** —— GIY-YIG 活性位点的全部保守核心残基在 ORF102 中都在：
   **Y6**（GIY 盒不变 Tyr）、**Y18 / G20**（YIG 盒，SegB 中突变即失活的两位）、
   **R29 / E78**（Kowalski 1999 认定的两个催化残基），以及 motif E 的 **N95**。
   两条**互不依赖**的路线 —— PF01541 序列比对与**不看残基身份**的 TM-align 结构比对 ——
   给出**完全相同**的六个对应关系（§2）。
2. **没有发现 C 端截断的证据** —— 211 aa 与 I-TevI 245 aa 的差不必诉诸缺失。ORF102 具备归巢内切酶
   标准的**二分架构**：N 端 GIY-YIG 催化域（3–87）+ 柔性 linker + C 端 **NUMOD 型 DNA 结合模块**
   （envelope 143–188），且该模块之后**还剩 23 个残基**，即蛋白不是在模块中途被切断的。
   现有证据支持的最佳模型是「**结构域完整但天然较短**」，而不是「被截短」（§3）。
3. **基因边界由序列本身锁死，且与 operon 内翻译偶联相容** —— 上游同框区内**连稀有起始密码子都没有**；
   起止密码子的 read 支持均为 100%；3′ 端的 `TGA` 与 ORF103 的 `ATG` 重叠成 `ATGA`（§4）。

⚠ 全部结构层结论都是**预测**，不与实验验证并列：**保守残基齐全不等于有切割活性**（§5）。

## 1. 方法与工具选择

| 目的 | 做法 | 为什么这样选 |
|---|---|---|
| 催化残基映射 | `hmmalign --trim` 把 ORF102 与 8 条参考序列一起对到 **Pfam PF01541**（GIY-YIG catalytic，78 列） | 模型列是共享坐标系，比两两 pairwise 比对更不易产生 register 漂移；且可一次性把对照全放进同一坐标 |
| 同上，独立复核 | `foldseek --alignment-type 1`（**TM-align**，只优化结构叠合、**不使用残基身份**） | 序列比对与结构比对若给出同一套对应关系，结论就不依赖任一方法的假设 |
| 域架构 | `hmmscan` vs **完整 Pfam-A**（30,134 个模型） | 不预设要找什么 —— C 端到底有没有模块，让全库回答 |
| 远/近同源 | ESMFold 模型 + `foldseek` 检索**完整 PDB** 与 **BFVD**（病毒蛋白结构库） | 本机无 HHpred；PDB 给实验结构锚点，BFVD 给同家族的长度分布 |
| 基因边界 | 直接读 contig 核酸；三个基因调用器；**read 回贴**；三种遗传密码对比 | 见 §4 的独立性说明 |

**对照（每一条都必须有，否则结论无法解释）：**

- **阳性对照（方法有分辨力）**：同一套 ESMFold + foldseek 流程跑 I-TevI 全长 ——
  命中实验结构 `1mk0`（催化域）TM = **0.986**、`1t2t`（C 端 DNA 结合域）TM = 0.603。
  ⇒ 建模与检索都能重现已知答案。
- **同折叠、非归巢内切酶对照**：*E. coli* **UvrC** N 端 —— GIY-YIG 折叠，但功能是核苷酸切除修复。
  这是唯一一条「折叠对上但功能不同」的对照，用于说明折叠相似本身不足以定功能。
- **同家族对照**：噬菌体 T4 的 **SegA–SegE** 五个 GIY-YIG 内切酶（198–223 aa）。
- **映射流程对照**：把 **1LN0 的 R27A 构建体序列**混进比对，流程正确地在「中部 Arg」列报出 **A27**，
  其余列与野生型完全一致。⚠ 这只检验**列映射不出错**，**不是**分析特异性的阴性对照（§5）。
- **邻位特异性对照**：同一次 hmmscan 扫 ORF101 与 ORF103 ——
  ORF101 = `CTP_transf_like`(6–80) + `NUDIX`(220–351)，ORF103 = `NAMPT_N`(15–107) + `NAPRTase`(181–462)，
  两者都**没有**任何内切酶域。⇒ GIY-YIG 信号是 ORF102 独有的，不是全位点的背景。

**这条路走不通、已换掉的**：本机**未安装 InterProScan**（`vpipe which interproscan` → missing），
所以本报告的域边界**一律由自跑的 hmmscan + foldseek 得出**。HHpred 同样不在本机，由 foldseek 替代。

## 2. C1：活性位点的保守核心残基齐全（预测）

**先确定「哪些残基算核心」，再看 ORF102 有没有** —— 顺序不能反。
下表只列**有出处的事实**，不写机制推断：

| 依据 | 认定的内容 |
|---|---|
| InterPro **IPR000305** 家族定义 | N 端 `GIY` 与 `YIG` 两个基序 + **中部一个 Arg** + **C 端一个 Glu** |
| Kowalski et al. 1999 *NAR* | 「两个不变残基 **Arg27** 与 **Glu75** 具有催化残基的性质」；I-TevI 催化域 = 前 92 aa |
| 已解出的两个 I-TevI 催化域结构 | `1LN0` = **R27A**、`1MK0` = **E75A** —— 结构本身就是围绕这两个残基做的突变体 |
| [[2026-Phage_Chihara]] 的 SegB 失活突变 | **Y17A/G19A** 与 **Y17F/G19A** ⇒ YIG 盒的这两位**突变即失活**（经验事实） |
| Dunin-Horkawicz et al. 2006 *BMC Genomics* | motif E 的 Asn 在超家族层面**并非不变**（Slx-1 缺失，COG1833 换成 Asp） |

![ORF102 催化位点](../analyses/figs/votu0052/orf102_catalytic_site.png)

*A：PF01541 比对下 9 条序列在 9 个诊断位置上的残基（◆ = 保守核心位点）。ORF102 在全部核心列上与
I-TevI 一致。B：6 个残基的 15 对功能原子间距，ORF102 与 I-TevI 落在 y = x 线附近，偏差（≤ 1.0 Å）
与 I-TevI 模型对实验结构 1LN0 的自身偏差（≤ 1.3 Å，灰色误差条）同量级。
**结论：ORF102 的活性位点在预测层面与 I-TevI 定性一致。***

| I-TevI | 依据与角色 | **ORF102** | 5 个 T4 Seg 中保留数 | UvrC |
|---|---|---|---:|---|
| G4 / I5 | GIY 盒前两位，家族内可变 | T4 / V5 | 0 / 1 | G19 / V20 |
| **Y6** | GIY 盒不变 Tyr（超家族命名残基） | **Y6** ✅ | 5 | Y21 |
| **Y17** | 突变致失活（SegB Y17A/Y17F） | **Y18** ✅ | 5 | Y32 |
| V18 | YIG 盒中位，家族内可变 | I19 | 1 | V33 |
| **G19** | 突变致失活（SegB G19A） | **G20** ✅ | 5 | G34 |
| **R27** | 催化残基（Kowalski 1999；1LN0 = R27A） | **R29** ✅ | **0** | R42 |
| **E75** | 催化残基（Kowalski 1999；1MK0 = E75A） | **E78** ✅ | 5 | E81 |
| N90 | motif E Asn，**非超家族不变** | **N95** ✅（见下） | 1 | N93 |

**两条互不依赖的路线给出同一套对应关系** —— 这是本节最关键的一点：

| 位点 | PF01541 序列比对（HMM，只看序列） | TM-align 结构比对（只看坐标，**不看残基身份**） |
|---|---|---|
| I-TevI Y6 / Y17 / G19 / R27 / E75 | ORF102 Y6 / Y18 / G20 / R29 / E78 | **完全相同** |
| I-TevI **N90** | **该列未覆盖**（PF01541 对 ORF102 止于第 87 位） | **ORF102 N95** |

⇒ **N95 的指认不是「先找一个 Asn 再解释」**：TM-align 在不知道残基是什么的情况下把 I-TevI 的
N90 直接对到了 ORF102 的第 95 位，而那个位置恰好是 Asn。同一比对的全局 TM-score = 0.616。
即便如此，**N95 仍不是完整性的必要条件** —— motif E 的 Asn 本就非超家族不变，
4/5 的 T4 Seg 蛋白在 PF01541 上同样没有这一列。它是加分项，不是准入项。

另外两点：

- **中部 Arg 上，ORF102 更像 I-TevI 而不像 Seg**。5 个 T4 Seg 蛋白在该列都是 Tyr/Asn，
  只有 ORF102、I-TevI 与 UvrC 是 Arg。
- **比对 register 的稳健性已检验**。把每个诊断列放宽到 ±3 列，ORF102 的 Y6 / Y18 / G20 /
  R28-R29 / E78 依然在窗口内 —— 结论不依赖单列对齐是否精确。
  ⚠ 注意 `foldseek --alignment-type 2`（3Di+AA）在这段 β 链上比另两种方法整体**偏移 1 位**；
  本报告的残基对应取自序列比对与 TM-align 的一致结果，不用 3Di+AA。

**结构层数字**（ESMFold 模型 + foldseek 检索完整 PDB）：

| 项 | 数值 | 读法 |
|---|---|---|
| ORF102 (3–96) vs **1LN0_A**（I-TevI 催化域实验结构，2–92） | E = 5.2e-02，prob = 0.997，TM(aln) = **0.742**，target-TM = 0.729，RMSD = 3.09 Å | 折叠层面是同一个东西 |
| ORF102 (116–198) vs **1U3E_M**（I-HmuI–DNA 复合物，93–174） | E = **4.3e-03**，prob = 1.000，TM(aln) = 0.615，LDDT = 0.622 | C 端是 DNA 结合模块（§3） |
| 第 3 名及以后 | E ≥ 0.17，prob ≤ 0.16 | 与前两名之间有清楚断档 |
| ORF102 模型 pLDDT | 全长 0.88；催化域 env(2–90) 0.93；核心残基处 0.94–0.97；N95 0.88；91–142 段 0.72 | 结论所依赖的残基都在高置信区 |

⚠ **这些数字的效力有明确上限，写作时必须一起带上**：

- **对 I-TevI 催化域的 E 值只有 5.2e-02，本身只是 borderline**（用 1e-3 阈值会直接漏掉它）。
  `E`、`prob`、`TM` 三个量**来自同一次比对，不是三条独立证据**。真正独立的只有**两条**：
  序列层的 PF01541 命中（independent E = 2.5e-05）与结构层的 foldseek 比对 —— 两者同向。
- **15 对距离不是 15 条独立证据**，它们由同一组 6 个点生成，彼此高度相关。
- **两侧都是 ESMFold 模型**，共享同一套 learned structural prior，误差不独立；
  pLDDT 衡量的是局部主链置信度，**不能**把侧链功能原子间距的误差压到亚 Å 量级。
  ⇒ 几何一致性只能读作**定性结论**（「活性位点没有塌掉」），不能当作催化能力的定量证明。

## 3. C2：没有发现 C 端截断的证据

这是 C 里最有价值的一问。原假说是「211 aa vs I-TevI 245 aa ⇒ ORF102 已是截断形式」，
证据不支持它。

![ORF102 域架构](../analyses/figs/votu0052/orf102_domain_architecture.png)

*hmmscan 对完整 Pfam-A 的域架构（independent E < 0.05）。ORF102 与 I-TevI、T4 SegA/SegC/SegD
一样具备「N 端催化域 + C 端 DNA 结合模块」的二分架构。**结论：ORF102 的 C 端模块是完整的，
长度差与两者 C 端结合区的规模差同向，不必诉诸截断。***

| 蛋白 | 长度 | 催化域 | C 端 DNA 结合模块 | 结合区跨度 |
|---|---:|---|---|---:|
| **ORF102** | **211** | GIY-YIG 3–87 (i-E 2.5e-05) | `I-HmuI_NUMOD-like` 153–184 (i-E 2.8e-05；envelope 143–188) | ~46 aa |
| I-TevI | 245 | GIY-YIG 3–90 | `I-TevI_ZnF` 149–179 + `NUMOD3` 179–201 + `I-TevI_DNA-bd` 192–242 | **94 aa** |
| SegA | 221 | GIY-YIG 10–90 | `NUMOD3` 102–123 | 22 aa |
| SegC | 198 | GIY-YIG 9–78 | `NUMOD3` 105–124 + `I-TevI_DNA-bd` 152–191 | 40 aa |
| SegD | 223 | GIY-YIG 5–76 | `NUMOD3` 117–131 + `HTH_17` 194–217 | 24 aa |
| SegB / SegE | 221 / 205 | GIY-YIG 3–71 / 3–72 | Pfam 未检出 | — |

**四条支撑：**

1. **C 端模块本身是完整的，而且不在序列末端**。`I-HmuI_NUMOD-like`（PF22083）在 153–184 的
   independent E = 2.8e-05，envelope 143–188 —— 其后**还有 23 个残基**。
   一个被截断的蛋白应当在模块中途戛然而止，而不是模块完整、后面还带着尾巴。
   （`NUMOD1`/PF07453 覆盖 139–172，independent E = 0.51，**不显著**，只作与 PF22083 重叠的
   佐证信号，不算第二个独立命中。）
2. **结构层独立复现**。ORF102 116–198 结构比对到 **I-HmuI**（`1U3E`）的 93–174，
   即 I-HmuI 自己的 `I-HmuI_NUMOD-like`(124–169) 所在区段，E = 4.3e-03、prob = 1.000。
   该模块的 ESMFold pLDDT = **0.94**。
3. **两个结构域之间有一段低置信区**。ORF102 的 91–142 段 pLDDT 降到 0.72（两侧结构域为 0.93/0.94），
   与 I-TevI 的 93–148 段（pLDDT 0.80，实验上即那段柔性 linker）位置对应。
   ⚠ 单凭 pLDDT 不足以断定它是 linker（未做 PAE / disorder 预测），但它与「两域之间的连接段」相容。
4. **终止密码子有 read 支持**。ORF102 的 `TGA`（44,423–44,425）在 gd1v 的比对中
   **100% 被 reads 支持**（深度 15–16，MAPQ ≥ 20）—— 排除了「组装或碱基判读错误造出一个
   premature stop」这种最容易被忽略的截断机制（§4）。

**但「未截短」不能说成绝对结论**，本次做的近同源物对照给出了明确的边界：
ORF102 模型对 **BFVD**（病毒蛋白结构库）检索得到 **76 个同源物**（E < 1e-5），
它们的**全长中位 245 aa（IQR 221–300，范围 102–438）**，
**ORF102 的 211 aa 落在该分布的第 20 百分位** —— 它确实处在家族的偏短一端。
比对末端之后的 C 端余量中位数两侧相同（各 14 aa），但**42% 的同源物**在比对末端之后
比 ORF102 多出 50 aa 以上的序列。

⇒ 严格的表述是：**未发现 C 端截断的证据；现有结果支持「结构域完整、天然较短」的架构**。
不能排除该谱系的某个祖先曾携带额外的 C 端模块。
同时，I-TevI 那 94 aa 的多模块结合区与 ORF102 约 46 aa 的单模块并非同类边界，
**不应拿两者相减去「解释」精确的 34 aa 长度差** —— 只能说长度差与结合区规模差同向。

**与 winged-helix (IPR036388) 是否矛盾？不矛盾，二者说的是同一件事。**
`I-HmuI_NUMOD-like` 的官方定义就是「归巢内切酶 C 端的 NUMOD1 样 DNA 结合 **HTH** 结构域」
（InterPro IPR054307），而 IPR036388 是 HTH 折叠所属的上位超家族（winged helix-like）。
所以「有 winged-helix」正是「有完整 C 端 DNA 结合模块」的另一种说法 ——
它从一开始就与「C 端截断」互相排斥。

**这对借用 Chihara 模型意味着什么**：截断这条类比**不能用**。
⚠ 另需明确：常见转述「截短版 SegB 保留催化活性但降低自身特异性」**论文并不支持** ——
[[2026-Phage_Chihara]] 只报告 SegB^short 无生长毒性，从未测其体外切割活性。本线不沿用该说法。

## 4. C3：基因边界复核

![ORF102 基因边界](../analyses/figs/votu0052/orf102_locus_boundary.png)

*ORF102 的边界与它在 operon 中的位置。**结论：在标准遗传密码下起始密码子唯一；3′ 端与 ORF103
重叠成 `ATGA`，与 operon 内翻译偶联的排布相容。***

| 检查项 | 结果 |
|---|---|
| 坐标 / 链 | `vctg2997:43,790–44,425` (+)，636 bp = 211 aa |
| 起始 / 终止密码子 | `ATG` / `TGA`，`partial=00` |
| 上游同框终止子 | `TGA` @ 43,700–43,702（其后 29 个同框密码子到注释起点） |
| 这 29 个密码子中的 **ATG/GTG/TTG** | **0 个** |
| 这 29 个密码子中的**稀有起始** ATT/ATA/CTG | **0 个** |
| 起始密码子的 read 支持 | 43,790–43,792 各 **100%**（深度 16/17/17） |
| 终止密码子的 read 支持 | 44,423–44,425 各 **100%**（深度 16/16/15） |
| 全区间（43,785–44,430，646 bp）与参考不一致 >5% 的位点 | **2 个**（深度中位 22，最小 8） |
| 下游同框最近的终止子 | 仅 **15 个密码子**之后 ⇒ 即使读通 `TGA` 也只多 15 个残基 |
| 遗传密码重编码检验 | code 11 → 213 ORF / 86.9% 编码密度；code 4（TGA=Trp）→ 124 ORF / 83.4%；code 15（TAG=Gln）→ 198 ORF / 82.9% ⇒ **无重编码迹象** |
| ORF101 终点 → ORF102 起点 | 8 bp 间隔（`TCCATAGT`） |
| ORF102 终点 / ORF103 起点 | **重叠 4 bp**，序列为 `ATGA` |
| prodigal(single) / prodigal(meta) / pyrodigal | 三者给出**同一边界**，同为 `ATG`、`partial=00` |

三点关于「这条证据到底有多强」：

- ⚠ **三个调用器一致 ≠ 三份独立证据** —— 它们同属 prodigal 谱系、共享打分模型，
  一致只说明「结果不是某次运行的偶然」。同理 `partial=00` 只表示调用器在序列内部找到了起止密码子，
  **不证明生物学完整性**。
- **真正独立的是序列事实**：在同框的上游 87 bp（29 个密码子）里，
  连 `ATG/GTG/TTG` 带稀有起始 `ATT/ATA/CTG` 一个都没有。
  所以在**标准遗传密码 11、且起点取自这六种密码子**的前提下，43,790 的 `ATG`
  是这个阅读框内唯一的候选起点，基因不可能被叫得更长。
- **read 层面同样干净**：起止密码子各碱基 100% 被 reads 支持，
  全区间 646 个位点只有 2 个的参考一致率低于 95%。

`rbs_motif=None` 说明 ORF102 自己没有可识别的 Shine-Dalgarno 序列。结合 8 bp 的上游间隔
与 3′ 端的 `ATGA` 重叠，这套排布**与「ORF102 和两侧 NARP2 基因同处一个 operon、
靠翻译偶联表达」相容**（`ATGA` 是终止–再起始偶联的经典基序）。
⚠ 但这是**相容而非证明** —— 真正确认需要转录组数据。这与 A2 记录的 GC 强离群
（z = −3.32，contig 内百分位 1.4%）并不冲突：**GC 说的是「来源外来」，operon 结构说的是
「进来之后已被整合进宿主噬菌体的表达程序」**，两者互补。

## 5. 这些结论没有说什么

写作与后续决策必须把这几条一并带上：

1. **保守残基齐全 ≠ 有切割活性。** 本节所有判定都是**序列 + 预测结构**层面的。
   失活可以发生在别处（底物识别面、二价金属结合、折叠稳定性），单看核心残基看不出来。
   要证明活性只有一条路：体外切割实验。
2. **结构是 ESMFold 预测，不是实验结构。** I-TevI 阳性对照说明这套流程在**这个家族**上可靠
   （TM 0.986），但不能外推成「ORF102 的模型一定正确」。几何一致性只是**定性**结论（§2）。
3. **本次没有做特异性阴性对照。** R27A spike 只检验列映射不出错；
   要真正标定假阳性率，需要长度与二级结构匹配的非 GIY-YIG 折叠、或活性位点被破坏的 decoy 集合。
   现有的功能层对照只有 UvrC 一条（同折叠、非归巢内切酶）。
4. **实验结构的锚点本身有限。** I-TevI 催化域只有两个已解出的结构，且**都是催化突变体**
   （1LN0 = R27A、1MK0 = E75A）；没有野生型、金属结合或 DNA 结合态可用于比对。
5. **同源 ≠ 同底物。** 架构完整只说明它是一台**能工作的机器**的形状，
   完全没有说它切什么位点。[B](votu0052-he-targeting.md) 已表明没有证据显示这类 HE
   偏好 nadM–NAMPT 连接处。
6. **单个基因组的观察。** 这是一条 contig 上的一个 ORF；contig 本身是 **medium-quality**（88.84%），
   `provirus` 为**未检出**（不是已排除）。
7. **本节不改变 A2/B 的判定。** 架构完整既不复活「原位扩增」（A2 阴性），
   也不制造靶向性证据（B 无信号）。

## 6. 对主线的意义

| 命题 | C 之后的状态 |
|---|---|
| ORF102 是 GIY-YIG 归巢内切酶候选 | ✅ 加强：活性位点保守核心残基齐全 + 二分架构完整（**预测层**） |
| ORF102 已是 C 端截断形式 | ❌ **无证据** —— 最佳支持的模型是「结构域完整、天然较短」 |
| 可借用 Chihara 的「自我克制的武器化」类比 | ❌ 前提（截断）不成立，这条类比作废 |
| ORF102 是近期水平获得的外源元件 | ✅ 维持（GC z = −3.32，见 [A2](votu0052-coverage-spike.md) §4） |
| ORF102 与 NARP2 operon 翻译偶联 | ✅ **新增（相容级证据）**：`ATGA` 重叠 + 无自身 RBS + 8 bp 间隔 |
| ORF102 在原位驱动 NARP2 扩增 | ❌ 未发生（[A2](votu0052-coverage-spike.md) GATE 2 阴性） |
| HE 偏好 nadM–NAMPT 位点 | ⬜ 无证据（[B](votu0052-he-targeting.md)，严格位点功效不足） |

**判断**：C 给案例报告补上了它缺的那半 —— 现在可以说的是
「一个**架构完整、活性位点保守核心残基齐全**（预测）的 GIY-YIG 归巢内切酶候选，
以**近期水平转移**的方式插入 NARP2 位点，并已**翻译偶联**进该 operon；
但在这批样本里它既没有驱动扩增，也没有可检出的位点偏好」。
这是一个自洽、可发表的基因组学观察，**边界清晰**。

**下一步只有两条真正能推进的路，都不是生信**：
① ORF102 的体外切割实验（重组表达 + 底物筛选）—— 直接回答「是不是活的」；
② 扩大 NARP2 × HE 共现的基因组集合，把 [B](votu0052-he-targeting.md) 的功效提上去。
在两者之一落地之前，继续做生信只会重复已有结论。

## 7. 数据出处

| 产物 | 内容 |
|---|---|
| `analyses/data/160-orf102/summary/catalytic_residue_map.tsv` | 9 条序列 × 9 个诊断位置的残基映射 —— §2 主表全部数字 |
| `analyses/data/160-orf102/summary/catalytic_register_robustness.tsv` | ±3 列窗口的 register 稳健性检查 |
| `analyses/data/160-orf102/summary/active_site_geometry.tsv` | 15 对核心残基的功能原子间距（ORF102 / I-TevI 模型 / 1LN0） |
| `analyses/data/160-orf102/summary/extra_controls.tsv` | 稀有起始密码子、read 支持、遗传密码对比、TM-align 对应、BFVD 长度分布 —— §2 双路线表、§3 BFVD 段、§4 表的出处 |
| `analyses/data/160-orf102/summary/domain_architecture.tsv` | 9 条蛋白的 Pfam 域坐标与 E 值 —— §3 表与图 |
| `analyses/data/160-orf102/summary/gene_boundary.tsv` | §4 的边界数字（起止、密码子、上游同框终止子、替代起点计数、间隔与重叠） |
| `analyses/data/160-orf102/summary/genecall_concordance.tsv` | 三个基因调用器的边界一致性 |
| `analyses/data/160-orf102/hmm/*.domtbl` | hmmscan 原始输出（ORF102 / 参考集 / I-HmuI / 邻位对照） |
| `analyses/data/160-orf102/align/giyyig_pf01541.sto` | PF01541 的 hmmalign 比对 |
| `analyses/data/160-orf102/foldseek/models_vs_pdb.tsv` | foldseek 对完整 PDB 的检索（含 I-TevI 阳性对照） |
| `analyses/data/160-orf102/foldseek/orf102_vs_1ln0.tsv` · `orf102_vs_itevi_tmalign.tsv` | 与 1LN0 的两两比对（RMSD）；TM-align 的身份无关对应 |
| `analyses/data/160-orf102/foldseek/orf102_vs_bfvd.tsv` | BFVD 结构同源物 76 条 |
| `analyses/data/160-orf102/struct/*.pdb` | ESMFold 模型（ORF102、I-TevI）与下载的 `1LN0` |
| `analyses/data/160-orf102/reads/orf102_pileup.txt` | gd1v 在 43,785–44,430 的逐碱基 pileup |
| `analyses/data/160-orf102/genecall/*.gff` | prodigal(single/meta/code4/code15)、pyrodigal 的基因调用 |
| `analyses/data/00-raw/.../clust_votu_proteins.faa` · `clust_votu.fasta` | 只读上游产物：ORF102 蛋白与 vctg2997 核酸 |
| `/mnt/nasdata/.../06-abundance/gd1v.bam` | 上游 bowtie2 比对（只读，未修改） |

可复现代码（在 git 中）：

| 脚本 | 作用 |
|---|---|
| [01_extract_seqs.sh](../dev/160-orf102/01_extract_seqs.sh) | 取 ORF102 与邻位蛋白；下载 GIY-YIG 参考集（UniProt） |
| [02_map_catalytic.py](../dev/160-orf102/02_map_catalytic.py) | PF01541 比对 → 残基映射 + register 稳健性 |
| [03_struct_catalytic.py](../dev/160-orf102/03_struct_catalytic.py) | 结构层：活性位点几何 + motif E Asn 的结构定位 |
| [04_summarize.py](../dev/160-orf102/04_summarize.py) | 域架构、基因边界、基因调用一致性汇总 |
| [06_run_controls.sh](../dev/160-orf102/06_run_controls.sh) | read pileup、遗传密码对比、TM-align、BFVD 检索 |
| [06_controls.py](../dev/160-orf102/06_controls.py) | 上述对照的汇总表 |
| [05_plot.R](../dev/160-orf102/05_plot.R) | 三张图 |

工具：HMMER 3.4（`hmmscan`/`hmmalign`，Pfam-A 30,134 模型，`~/data2/db/pfam`）·
ESMFold v1（`~/bioinfo/bin/esmfold`，GB10 GPU）· foldseek 10.941cd33
（`~/data2/db/foldseek/{pdb,bfvd}`）· samtools · prodigal / pyrodigal v3.7.1 ·
UniProt REST · RCSB REST。

**外部参考**（前三条是核心残基认定的依据）：

- Kowalski JC et al. (1999) *Nucleic Acids Res* 27:2115 — I-TevI 的 Arg27/Glu75 与 92 aa 催化域。
  DOI [10.1093/nar/27.10.2115](https://doi.org/10.1093/nar/27.10.2115)
- Van Roey P et al. (2002) *Nat Struct Biol* 9:806 — I-TevI 催化域晶体结构与金属配位位点。
  DOI [10.1038/nsb853](https://doi.org/10.1038/nsb853)
- Dunin-Horkawicz S et al. (2006) *BMC Genomics* 7:98 — GIY-YIG 超家族分类；motif E Asn 非不变。
  DOI [10.1186/1471-2164-7-98](https://doi.org/10.1186/1471-2164-7-98)
- Truglio JJ et al. (2005) *EMBO J* 24:885 — UvrC N 端 GIY-YIG 域与单金属机制。
  DOI [10.1038/sj.emboj.7600568](https://doi.org/10.1038/sj.emboj.7600568)
- [[2026-Phage_Chihara]] — SegB 的 Y17A/G19A 失活策略（本项目的机制母本）。

## 8. 相关

- 主线定位与措辞纪律：[HANDOFF.md](HANDOFF.md)（本检验对应 §3-C）
- A 宿主防御前提：[votu0052-host-defense-prerequisite.md](votu0052-host-defense-prerequisite.md)
- A2 覆盖度尖峰与 GC 离群：[votu0052-coverage-spike.md](votu0052-coverage-spike.md)
- B HE 靶向性：[votu0052-he-targeting.md](votu0052-he-targeting.md)
- 完整分析与文献先验：[votu0052-narp2-antidefense.md](votu0052-narp2-antidefense.md)
