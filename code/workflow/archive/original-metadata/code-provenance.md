# 代码与模板来源

作者（显示顺序）：Jinlong Ru, Cunli Pan

## qproj 生成、随后改写的文件

脚手架由已安装的 **qproj 0.1.5** 生成：`RemoteSha 4665814be79e13f7440f26b95279c014e6a5e209`（安装元数据，未独立核对远端），作者 Jinlong Ru（qproj DESCRIPTION：`Jinlong Ru [aut, cre]`）。已安装 qproj 的 DESCRIPTION 写 `License: GPL-3`；原项目的 qproj 源码审阅记录指出，GitHub 页面标签显示的是 MIT。两者不一致，尚未解决，见 `docs/BOOTSTRAP-STATUS.md` 的待决事项。

生成命令（2026-09-27，通过 Rscript 执行，项目根目录为绝对路径）：`qproj::proj_create(<root>, fields = list(Title, Authors@R, Description, License))`；在项目根目录执行 `qproj::proj_use_workflow("analyses")`、`qproj::use_qmd("010-input-manifest", path_proj = "analyses", open = FALSE)` 和 `qproj::use_qmd("090-style-proof", ...)`。随后用 `desc::desc_del()` 删除 `desc` 模板留下的 `{{ Maintainer }}`、`{{ URL }}`、`{{ BugReports }}` 占位字段（不虚构这些值），并用 `desc::desc_set_dep()` 声明依赖。

| 本项目文件 | 生成方式 | 生成时 SHA256 | 之后的改动 |
|---|---|---|---|
| `DESCRIPTION` | `proj_create` | `18ef729f412d0bffcdaec1bb5e2888180e4c4fcd6e5fb76e010d1b7678847d38`（删除占位字段后） | 用 `desc` 添加 Imports |
| `NAMESPACE` | `proj_create` | `53248d066122bbbf7fefbbca5b547a05a2ef79b4d01f8adce5487c937d37351f` | 未改 |
| `README.md` | `proj_create` | `14852203cfa603cf245c44a447d1e0dfd1c9ba2c800a29d8a3553cab90dcaa2b` | 重写为中文说明，保留“由 qproj 搭建”的说明 |
| `.gitignore` | `proj_create` + `proj_use_workflow` | `17778d09be4a66eff20dbedf278012dcf9ce42b43aad3800304a3e5fed086821` | 保留原有规则，追加缓存、本地环境与 IDE 规则 |
| `RecWaterVirome.Rproj` | `proj_create` | `3a81ccc25a62f1a31c7d3404389935ced50831abea5e848408745ad1a1bf6126` | `RestoreWorkspace`、`SaveWorkspace`、`AlwaysSaveHistory` 由 Default 改为 No |
| `analyses/_quarto.yml` | `proj_use_workflow` 复制模板 `templates/_quarto.yml` | `0628ce3a722c4a2e9bf64d9193539c2ccf26c114228506be5dbf1329e3b1f532`（与模板相同） | 作者列表、`cache: false`、`warning: true`、格式由 GFM 改为自包含 HTML；加说明注释 |
| `analyses/README.md` | `proj_use_workflow` | `34ccaba7e173b1296bd0fcb115efd7e6219f36a8af75b853fbafc41c2727c846` | 重写为本项目约定 |
| `analyses/data/README.md` | `proj_use_workflow` | `c534746afaa2b588b94a235206e10ae2d01904904c2efb21ca0c9631240187f4` | 保留首两行，追加目录约定 |
| `analyses/010-input-manifest.qmd` | `use_qmd`，模板 `templates/workflow.qmd`（SHA256 `c323c6825bfea70fbad76ec7d021a7813847245b7d17a163b4141d117daa6214`） | `1d7ab5e5280a323db23e2c85b495de60847896e16ab9d2a9fcac3e5095e1298d` | 见下文 |
| `analyses/090-style-proof.qmd` | 同上 | `83fd0e15159c1480f5e9b0012db05b0b1023ed6a305d76cf822713124bbd8109` | 见下文 |

生成后的两个QMD与模板逐行一致（仅 name、UUID、path_proj 被替换）。改写内容：

- 保留模板原样：`params` 块、`setup` 块（含各自 UUID、`clean = FALSE` 与五个路径绑定）、“Updated”时间行、`Files written` 块。
- `packages` 块：去掉模板中的 `library(here)`、`conflicted`、`tidyverse`、`data.table` 和 `conflicts_prefer()`，只保留 `devtools::load_all()`；090 另加载 `ggplot2` 与 `patchwork`。
- 新增 YAML 中的 `subtitle` 和有序的 `author`（Jinlong Ru → Cunli Pan），新增 `step-guard` 块和任务内容；删除模板中的示例说明和 `cache: true` 示例块。

## 本批新写的代码与配置

`R/workflow.R`、`R/style.R`、`R/fonts.R`、`R/export.R`、`scripts/render.R`、两个QMD中的任务代码、`config/*`、`metadata/frozen-files.tsv`：2026-09-27 阶段0由 Claude Code 编码代理按 Codex 的设计新写，尚待 Codex 审核。

2026-09-28 全套制图批次同样为新写：`R/figures.R`（配置读取、数值核验台账、排版与字符格式、导出核查、图注写出）、`scripts/stage-inputs.R`（从只读原项目迁移输入并登记来源哈希与 git 状态）、`analyses/020`–`050`、`110`–`150`、`210`–`240`、`310`–`330`、`900` 各步骤的任务代码，以及 `config/palettes.yml`、`config/figures.yml`、`config/definitions.tsv`、`metadata/visual-review.tsv`。同日的自审轮（AI 会诊 + 导师/编辑/可复现三个角色）对上述文件作了修订，未引入外部代码。

使用的第三方包均通过命名空间调用（`ggplot2`、`patchwork`、`ggrepel`、`ggforce`、`svglite`、`ragg`、`pdftools`、`writexl`、`readxl` 等），没有复制其源码。

没有复制 SwDGVirome 或原研究项目中的任何脚本。只从原项目 `outputs/figure-production-design-2026-09-27/reference-swdg/DESCRIPTION` 取用了其中已公开的姓名、邮箱和 ORCID。其中 Jinlong Ru 的邮箱按该文件原样记为 `jinlong.ru@tum.com`；qproj 自身的 DESCRIPTION 写的是另一个地址，最终用哪个待作者确认。

2026-10-06 VF 丰度集成 v13 的修正批次：`R/figures.R` 新增 `rwv_heatmap_colours()`（读 `config/palettes.yml` 的连续色带规格，通过命名空间调用 `viridisLite::magma()` 等生成完整色带），以及 `rwv_palettes_read()` 对该规格的校验；`analyses/040`、`110`、`130`、`140`、`230`、`320` 的任务代码按 Codex A1–A5 与设计增补修订。均为本项目新写，没有复制第三方源码；`viridisLite` 仅通过命名空间调用，已登记为 `DESCRIPTION` 的直接依赖。

2026-10-07 配色修订（方案 A 修订 2）：`R/figures.R` 新增 `rwv_label_ink()`（按 WCAG 相对亮度公式选择条内标签的黑/白字，公式为公开标准，代码为本项目新写）；七个图 QMD 只改颜色参数。`config/palettes.yml` 的颜色取自 Paul Tol 官方色板（sronpersonalpages.nl/~pault）与 ColorBrewer（经 RColorBrewer 1.1.3 取值），逐色来源与是否调整见 `outputs/figure-colour-2026-10-07/colour-dictionary.tsv`；未复制第三方源码。

2026-10-07 图形表达与文字层级专项（预览阶段，正式运行待授权）：`R/figures.R` 新增 `rwv_tag()`（显示字母大小写开关，内部面板 ID 不变）并给 `rwv_write_legend()` 加 `notes` 参数（详细图注说明单列一节）；`R/style.R` 校验 `panel_tag$case`；九个图 QMD 去掉描述性面板标题、补轴名、拆分投稿图注与 figure notes；`analyses/900` 的图注解析在新节标题处截止。Figure 1a 的地图—采样瓶—三组学示意为本项目新写的 ggplot2 代码：采样瓶、衣壳六边形、杆状与有核细胞图标均为手写几何路径（`geom_rect`、`geom_polygon`、`ggforce::geom_ellipse`），未用任何图标库或生成式图片；版式只参考本地旧图 `p0061-RecWaterVirome/tmp/main/analyses/figs/910-report/G1_graphical_abstract.jpg` 中间栏的“地图→样本卡片→三组学”组织方式（只读；作者归属与是否即用户所指图均未确认），未复用其图形、文字或工艺/结论断言。底图数据：Natural Earth 1:50m admin-0 国家边界，经 `rnaturalearthdata::countries50` 读取（包许可 CC0；Natural Earth 数据本身为公有领域），用 `sf`（1.1-0；许可 GPL-2 | MIT + file LICENSE）裁剪与投影；两包均为本机已有，未安装或下载，按项目规则登记为 `DESCRIPTION` 直接依赖。城市代表坐标见 `config/site-locations.tsv`（逐行记公开来源与访问日期，性质为城市/市镇代表点，不是采水点）。

2026-10-07 用户选色：`config/palettes.yml` 五处颜色改动，来源分别是 Paul Tol 色板（#6699CC、#CC6677）、ColorBrewer BrBG（#01665E、#5AB4AC、#D8B365）、本项目按原 Tol 色调去饱和得到的区域底色（#E7C6CC、#CFE2E8），以及 viridisLite 的 rocket 色带。未改动代码。

2026-10-07 balance-v1 合并：颜色来自 Codex 的候选配置（新主色多为自定义，稀有类群色仍来自 Paul Tol）。热图色带是 `grDevices::hcl.colors("Reds")`，为 R 自带的 HCL 近似 ColorBrewer Reds。`R/figures.R` 中新增的 `hcl:` 分支为本项目新写的代码。

2026-10-08 V1 收尾：230 的检出格细灰框、240 的引线加深，均为本项目新写的 ggplot2 参数；ADF 墨色 #7A520A 为本项目自定义，在 V1 金色基础上加深。

2026-10-14 补图 S2 重排：`analyses/220` 的新版代码（c 热图、b 分区与加框、质量简写、e/f 行名）、`analyses/030` 新增的两张表（NARP 携带者逐样本丰度、防御类型清单）及 `analyses/130`、`320` 的配套改动，均为本项目新写。类型清单的原始输入由本项目审核阶段的 `outputs/defense-case-comparison-2026-10-14/extract_comparison.py` 只读查询本地 SQLite 快照生成，来源登记在 `metadata/raw-inputs.tsv`；未复制第三方源码。

## 2026-10-14 Figure 4／S3布局迁移（Codex）

140的B复用既有230携带者热图；140的C复用旧D森林图；230的E/F复用旧140位置图及条件计数。保留已有作者顺序、共享样式、所有数值与坐标；只变图位和资格／范围说明。310/320与definitions/field-notes同步引用，无新科学计算。源码及图像修改前基线：`baselines/pre-figure4-restructure-2026-10-14/`。

本批正式入口确实重新执行既有012/014/020计算；上句“无新科学计算”只指没有新增分析方法、VF/全球模型拟合或注释。系统拒绝Quarto架构查询／空缓存清理时，本批在outputs中复制已安装Quarto1.8.27入口并作两个明确的显示运行适配（空generated目录保留、Sass新鲜编译）；没有改全局安装。900生成目录改名连续返回EPERM后，`R/workflow.R`加入本项目新写的有限复制发布兼容：仅900的review-candidate合法暂存／备份／恢复路径，逐文件SHA核对后才移除源文件，恢复原件保留至清理，并用持久计划保护中断重入；原journal、记录提交点及所有QA不变。来源、失败日志、独立沙盒故障测试及实际源码哈希见`outputs/figure4-restructure-2026-10-14/`。未复制第三方发布代码。

2026-10-14 补图 S2 方案 A 正式采用（Claude）：`analyses/220` 的 a 轴/图例措辞、c 单矩阵热图与 d 一维结构域轨道移植自 Codex 的独立候选脚本 `outputs/s2-decision-review-2026-10-14/layouts/render-layouts.R`（同一项目内代码，非外部来源），保留生产 step 守卫与输入核验；Supplementary Note 1 生成代码与 900 的 Note 复制/链接为本批新写。


2026-10-14 Codex：用户明确授权合并完成 Claude 中断的 S2 正式采用与 S3 重整。S2 四面板＋Note1；S3 从两页六面板改为天然定位 a＋受控端点 b（180×172 mm），细项生成 Note3。仅复用保存结果，不改模型、阈值、分母；更新 figures/workflow 冻结哈希。S3 绘制逻辑改编自本项目独立候选 build-layout-candidates.R，S2 实现保留 Claude 已完成源码。运行适配使用已存的批次内 Quarto 适配器（原生 shell 无法读取受限 sysctl 架构），不修改全局安装。

## 2026-10-15 — S4 to Supplementary Note 4

Codex implementation under explicit user authorization. Step 240 retains its UUID and guards; saved results only, no global fitting. Steps 150 (caption only), 330 (navigation only), 900 and workflow/figure/definition registers updated. Modification script and pre-edit SHA256 baseline: `outputs/s4-note-adoption-2026-10-15/`. New writing v25; independent review pending.

2026-10-15 全球来源状态与机会诊断（Claude，任务书 r2 §4）：`analyses/050` 新增把源项目 `dev/380-global-repair-preflight-2026-09-26`（repair_aggregation.R，script SHA256 4f9892c3…；2026-09-26 已完成）保存的 6 张结果表与完成/独立核验记录逐字节登记并原样传递，另生成状态索引 `global_result_status.tsv`；G01 按 feature 键追加源项目 `dev/280-publication-stage-a/global_primary.R:21–45` 已保存的 13 个机会诊断字段。均为本项目新写的读取/核对代码，不执行、不改写也不复制源项目的修复或拟合代码；330/240 的表规格与 Note 4 文字为本批新写。

2026-10-15 接续（Codex，用户明确授权）：复核并保留上述Claude实现。330字段说明根据只读repair_aggregation.R中的场景单元计数和纳入规则更正；保存数据不变。写作v26与学习页同步，隔离F3/S2候选复用本项目130／220绘图块，不覆盖生产图。执行／复核脚本、实际失败记录与数值合同在 `outputs/story-action-impl-2026-10-15/`；不将实现者的检查冒充独立全文终审。

## 2026-10-15 — author-approved v29 ecology summaries (Codex)

040 reuses the saved-object detection, fixed-carrier and normalization definitions from `outputs/process-ecology-2026-10-15/candidate/scripts/calculate.R`, originally created for the independent candidate. The symmetric six-row community and 24-row VF partitions, explicit input-field diagnostics and Note5 are added here; no new mapping, threshold, model or significance test. Upstream data are read through the declared workflow. 320/900 packaging and writing/Word/learning builders adapt the existing v28 implementation with attribution.

## 2026-10-15 v30 literature integration

Jinlong Ru → Cunli Pan display order retained. Seven-sample descriptive membership in R/community.R and020 is adapted from the independently checked outputs/seven-sample-overlap-review-2026-10-15/data-audit/aggregate-overlap.py;210 continuation layout adapts outputs/seven-sample-overlap-refinement-2026-10-15/draw-refinement.R. New R/literature-summary.R and030/040 joins adapt the independently audited Niu/Yu descriptive set logic, using declared formal020/030/raw inputs instead of exploration caches. Root support changes add Data1 dictionaries, continuation packaging, explicit saved-model labels and generated Note1/3 context. No protein annotation, classifier, statistical model or test is rerun as a new method. The existing full entry reexecutes permitted community calculations. Literary/graphic inspiration from papers36–38 is documented in outputs/literature-integration-2026-10-15; their data and conclusions are not relabelled as this study.


## 2026-10-16 — v32 upstream Methods and Note5 display (Codex)

Author-supplied p0057-manuscript-25.09.2026.docx is a wording/citation source, not a substitute runtime log. The local upstream import and CoverM logs govern actual rules; VITAP/CoverM references are independently checked. Sources, source Word SHA and reuse decisions: outputs/upstream-methods-v32-2026-10-16/. No source-project files modified. In analyses/040, only ec_rows() maps the existing machine position values to six human-readable Note5 labels. Its saved-table display block is independently executed in an isolated directory and matches writing/v2026.09.28.32/supplementary-notes/Supplementary_Note_5_Process_ecology.md; all production outputs remain the prior run. No full analytical rerun, method, numeric field or scientific threshold changed. Word export adapts outputs/word-v29-2026-10-15/build-docx.py; learning export adapts the v31 builder with the same formal figures.


### 2026-10-16 v34 editorial implementation — Jinlong Ru → Cunli Pan

- Existing120/140 plottingQMDs: author-approved label/caption edits, no new scientific computation. Isolated rendering reuses outputs/literature-integration-2026-10-15/harness/preview-step.R and the existing story-action mock harness; source/saved-input hashes retained.
- Word and guide builders adapted from v33; strict editorial_assets.py validates both original sealed files and every replacement. Exact validation retained; no silent override or new analysis-run claim.
- Global classifier text/dictionary transcribed read-only from original dev/220-scaling-cargo/scripts/j42-run.py, source hash and exact keyword/precedence/fallback recorded in v34 supplement. No reclassification.
- Figure2 optional layout reads six sealedData1S54 rows only; original ordinations kept. Candidate code and export QA are separate from production, not an adopted figure.


## 2026-10-16 v35 NARP-focused S2

- `outputs/s2-narp-v35-2026-10-16/build_s2.py`: new full-figure composition, using saved 030 NARP flags/abundance, original SQLite coordinates and shared style/palette. The PDF/font helper pattern is adapted from this project's earlier `outputs/orf102-s2-compact-2026-10-16/build_candidate.py`; previous source and formal QMDs are preserved.
- `render_local_overlay.py`: adapted from the Science ORF102 PyMOL rendering example in `candidates/structure-v2026.10.15.1/continuation-2026-10-16/code/render_orf102.py`, now isolates one experimental I-TevI reference and exports the exact CE pairs, transform, coordinate-recomputed RMSD and `.pse` session. No new structure prediction.
- `prepare_v35.py`, `prepare_learning.py`, `finalize_assets.py`: version-local adoption and provenance code. Manuscript evidence/reference/assembly and learning-page builders are inherited from v34 with explicit structural-supplement extensions; inherited code is not claimed as newly authored.
- Only v35 uses these output overrides. Base analytical run, frozen inputs, 900 workflow and old reviewer log are not relabelled as having produced or reviewed the new structure supplement.

## 2026-10-17 Figure 2 and supplementary figure adoption (implementer: Claude; authors in code: Jinlong Ru, Cunli Pan)

Author-approved adoption, docs/figure2-supplement-adoption-2026-10-17/00-给Claude的采用执行prompt.md. Candidate folders were read, not called by the workflow.

- `analyses/120-fig2-community-links.qmd`, panels c and d: compact Mantel strip and top-10-plus-ties host bubbles adapted from `outputs/figure2-ecology-panel-2026-10-17/draw-layouts.R` (candidate A); the bubble table is recomputed in the step from the 020 tables `host_iphop.tsv`, `votu_sharing_members.tsv` and `host_codetection_by_sample.tsv`, following `outputs/chen2021-final-candidates-2026-10-17/analyze.py` (top N with ties, per-sample qualifying vOTUs, same-sample 16S detection). c/d frames use `free()` and `coord_cartesian()` so they span the page width (layout only).
- `R/sfig-sharing-hosts.R` and `analyses/210-sfig1-qc-community.qmd` (Supplementary Figure 2): page layout transcribed from `outputs/pooled-host-network-2026-10-17/draw-network.R` and `draw-split-candidate.R` into one grid grob; shared-host inset after `outputs/chen2021-final-candidates-2026-10-17/draw-S1.R`. Colours registered in `config/palettes.yml` (`sample_codetection`, `sharing`). GTDB placeholder genus names with a hyphen between digits are drawn with a zero-width non-joiner after the hyphen (`rwv_taxon_display`) so the house range rule stays enforced. The pooled-network concept was motivated by Chow et al. 2014; no topology, coordinates or values were copied.
- `analyses/220-sfig2-function-context.qmd` (Supplementary Figure 3): the adopted v35 NARP figure built by `outputs/s2-narp-v35-2026-10-16/build_s2.py` and `render_local_overlay.py` (PyMuPDF/PyMOL; stored ESMFold2 model, no prediction re-run) is a registered raw input of the step (`analyses/data/00-raw/d220-sfig2-function-context/`, metadata/raw-inputs.tsv), output byte for byte and cross-checked against the 030 tables; its 600-dpi TIFF was rendered with PyMuPDF at registration because pdftools/poppler stops at a dash operator in that PDF. The retired four-panel drawing code was removed; its data checks remain.
- `analyses/230-sfig3-vf-calibration.qmd`: outputs renamed `sfig4.*` (Supplementary Figure 4); drawing unchanged.
