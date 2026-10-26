# VF位置与末端重复：实际复跑报告
日期：2026-10-25（Europe/Berlin作者日期）。本轮已按作者明确指令实际执行两项检查，不再只是阅读旧结果。正式基线v54.2未改。

## 结论
**数值复现成功；“污染不可能”的解释不成立。**
1. 师兄原位置诊断已用同一统计逻辑、seed=1、2,000次bootstrap在本机实际运行。VF、AMG和KO结果全部复现。
2. 三份保存结果表与师兄版本逐字节一致：position_ratio.tsv、vf_on_complete_genomes.tsv、vf_by_provirus_flag.tsv。
3. 末端重复部分独立逐条核对确认29个命中、18条载体；但其中8个命中仍是预测host区，涉及两条不满100%完整度的载体。
4. 所有受保护输入/正式Word/SI/Data1及冻结登记哈希在运行前后相同。新结果仅位于本审计目录，不纳入正式投稿包。

## 第一道检查：实际跑了什么
输入是3,060条vOTU代表序列及保存注释。R实际从数据库读取并完成坐标连接、距离计算、长度×基因密度分层和2,000次bootstrap。排除220条DTR/ITR标记序列后，背景为2,840条contig上的82,064个基因位点。

| 注释集合 | n | 末端距离中位数bp | 比值 | bootstrap 95%区间 | 与原保存表 |
| --- | ---: | ---: | ---: | --- | --- |
| VFDB-A filtered | 114 | 4226 | 0.984 | 0.644–1.261 | 完全一致 |
| DRAM-v AMG | 133 | 4843 | 0.863 | 0.655–1.432 | 完全一致 |
| KO annotated | 2991 | 4139 | 0.906 | 0.863–0.961 | 完全一致 |

R进程返回0，stderr为空；本次执行约2.37秒，完整stdout和session-info保留。此运行速度不影响是否真正执行：执行命令、源适配差异、输出哈希与运行记录均已保存。

可支持：在本诊断的整体中位数尺度上，VF注释没有显示明确的端部距离偏移证据。
不能支持：证明完全等效、排除全部污染/内部嵌合/少数端部异常、验证病毒来源或毒力功能。KO区间未跨1，不能称所有对照均严格无偏。

图：review-plot.png仅从复跑结果表重绘，未改变统计值；去掉了原图未经验证的等效灰带，并使用中性标题。原脚本原图保留于rerun/fig210a-vf-position-ratio.png供忠实复现留档，其标题和等效灰带不是本审计认可的结论。

## 第二道检查：末端重复逐条核查
原R脚本计数与独立Python/只读SQLite交叉检查一致：
- 220条DTR/ITR标记contig。
- 29个VF命中位于18条载体上，占143命中的约20%。
- 命中数：DTR 27、ITR 2；载体数：DTR 17、ITR 1。
- 18条载体的CheckV完整度中位数100%，其中14条估计为100%，最低26.64%；中位100不表示全部100。
- 29个命中中，8个预测host、21个无区域预测；这29个均未进入上面的114基因位置诊断。
- 末端重复集合命中identity中位36.1%；全143命中identity中位37.3%，98条低于40%。

| 载体 | 拓扑标记 | CheckV完整度 | CheckV宿主污染估计 | 预测host命中 | CheckV provirus |
| --- | --- | ---: | ---: | ---: | --- |
| vOTU0016 | DTR | 65% | 32.8% | 5 | Yes |
| vOTU0446 | DTR | 26.64% | 27.92% | 3 | Yes |

这不是把8个预测host命中认作已经实验确认污染，而是说明“有末端重复”与“存在预测宿主区”可以同时出现。因此不能使用评论建议句中的 **where host-region contamination is structurally implausible**。vOTU0016也正是bc1区域排除降幅的主要贡献者，两个检查并不互相推翻。

## 已核实解释与建议口径
师兄原有数值有可复现依据；可考虑增加“非DTR/ITR标记序列中的VF相关注释未显示明确的整体末端富集”的补充诊断。
现有20/143可定位、123未定位以及候选功能边界仍应保留。不能用这一诊断宣称VF全部是病毒基因、宿主成分已排除，或把命中直接改叫尾纤维/解聚酶。那些功能解释需要各自证据。
本轮按原方法复现，未执行按contig聚类的替代bootstrap或正式等效检验；原方法的基因位点相关性、单次背景抽样点估计及等效灰带解释限制见上一轮说明报告，不因成功复现而消失。

## 输入、代码与保护措施
- 输入库：/Users/pan/Documents/GitHub/p0061-RecWaterVirome/analyses/p0061.sqlite，SHA256见checks/before.json，R和Python均强制只读。
- 师兄代码源：Wiki /project/p0061-RecWaterVirome/dev/210-vf-position-qc/vf_position_qc.R，已保存版本32388c380e5c。151行代码由上一轮完整分段快照恢复。
- 原脚本留档：source/vf_position_qc.server.R.txt。
- 实际执行适配：source/vf_position_qc.audit.R。仅把路径变成命令参数、数据库连接增加SQLITE_RO；统计逻辑和随机种子未改。完整差异source/path-and-readonly-only.patch。
- 执行入口：run_audit.py；命令、耗时与退出状态checks/execution.json。
- 第二项逐条核查：check_terminal_repeats.py，保存29行命中和18行载体元数据。与正式冻结143条命中的key、identity及function全部一致。
- 结果比较：checks/comparison.json给出三份表的原始/复跑SHA256，均逐字节一致。
- 原库、正式主文Word、SI Word、Data1、两份冻结VF表及metadata/frozen-files.tsv哈希保持不变。仅问题本/本轮授权和代码来源记录新增，不改变正式科学结果。

## 文件入口
- rerun/position_ratio.tsv：实际复跑位置结果。
- rerun/repeat_vf_hits.tsv：29个末端重复集合命中的逐条表。
- rerun/repeat_carriers.tsv：18条载体的逐条拓扑、完整度和host定位统计。
- rerun/repeat_summary.json：第二项汇总。
- rerun/stdout.log、stderr.log、session-info.txt：执行证据。
- index.html：可读结果页；review-plot.png：中性标题的审计预览。
- source/expected-*.tsv：对照用师兄保存结果。
- AUTHORIZATION.md：本轮有限执行范围。

本轮没有重跑CheckV、装配、比对、VF/全球模型或pc028e3分析，没有修改正式稿、图、数据、代码交付包、Wiki或Nextcloud。

