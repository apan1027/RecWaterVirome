# Figure 4／Supplementary Figure 3 版式与源码验收

2026-10-14；Codex。用户本轮明确授权“就你来执行吧，你直接修改吧”。本报告在正式全量运行前冻结，审核范围是源码及隔离重绘；正式交付核验另记在 outputs/figure4-restructure-2026-10-14/。

**结论：通过所述范围。** 原`figure-final-review`已通过的范围继续以`docs/figure3a-label-design-2026-10-13/08-Codex正式交付终审.md`为依据保留，未在本轮重新审查。本报告扩展的是F4/S3的源码、隔离版式与文字预检，不升级整个S2新批次或后续正式run的审核状态。 Figure 4采用三面板而非仅追求减少面板：a总体份额、b携带者组成、c目录生活史敏感性。完整定位证据进入S3续页e/f；S3第一页a–d保留。科学问题与数值、阈值、分母不变。

| 原位置 | 新位置 | 独立核验 |
|---|---|---|
| Figure 4a | Figure 4a | 28个占比值及四个零值不变 |
| Supplementary Figure 3e | Figure 4b | 126个格值、18行数值排序、检出状态及S/R两资格全部不变 |
| Figure 4d | Figure 4c | 四个IRR、n及八个区间端点与保存模型一致；仍全部Filtered |
| Figure 4b | Supplementary Figure 3e | 17段区域与20个命中坐标，共37行，全部保留 |
| Figure 4c | Supplementary Figure 3f | 18/1/1计数不变；轴明确20 of 143条件范围 |
| Supplementary Figure 3a–d | 原位 | 45行绘图值及PNG/SVG逐字节一致 |

主图及S3续页由Codex实际查看；所有字母、坐标轴、标记和标签清晰，未裁切。主图工作尺寸180×225 mm，S3续页180×145 mm；Arial最低8 pt。隔离导出QA按文件实际计数：F4 121项、S3第一页 49项、S3续页 71项，全部通过；绘图检查F4 22项、S3 33项通过。未更改任何检查阈值以通过。

范围说明：全目录143→124与模型142→123有不同纳入对象；全目录123个无区域预测不是模型123个保留命中。图注明确未定位不证明病毒归属，零值不是生物学不存在，区域规则改变carrier membership而不重映射。热图显示18/114，不把18行列和当样本总份额。四个模型依赖同一CheckV信息，不说明宿主污染解释全部或真实生物效应为零。c/d不是处理前后。

同步源码包括140、230、310/320的图位指针、definitions与field-notes；旧正式产物与v20保存在不可覆盖的baseline／原版本。v21只做图号、18/114范围与vOTU2169单GroEL差额的有限文字同步。图注Sources经读取实际输入核对；Supplementary Fig. 3e原引用有效，只因本次迁移而改位，不沿用会诊的误判。

**不覆盖**：本报告之后的全量交付run、既有统计模型独立重拟合、整个S2新批次终审、全稿全部引用重审、采样／真实水型／湿实验／accession／作者信息、投稿可用性、期刊或新颖性。机器检查成功不能替代这些确认。正式运行需核十页PNG（仅F4和S3续页应改变）、科学小表、Data1数据单元、证据锁及文字证据，实际结果另列记录。

原始对照：baselines/pre-figure4-restructure-2026-10-14/；预览与独立检查：outputs/figure4-restructure-2026-10-14/。没有commit或push，没有重跑生信注释。
