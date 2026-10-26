# 机会模型投影的实际复跑核查

2026-10-25。作者明确要求实际验证，有限授权覆盖本项既有模型及投影的复跑。当前固定投稿入口指向 v56.1。所有输出独立保存在本目录；原研究项目、归档输入、正式稿、SI、数据工作簿、冻结工作流均未改。

## 执行范围

使用 v56.1 model_archive 的原始 77,951 基因组 CDS 表、原始代谢域/抗防御携带记录与原有固定 285/38 特征集合。复用 global_primary.R 原始 fit 函数和原来 CDS 分箱/权重，逐特征重算 ordinary logit、fixed-opportunity cloglog 和 logit projection。没有运行整份历史脚本，未运行其已撤回聚合分支、gamma、协变量调整、重采样、注释或生信。此为从归档携带记录复跑，不是从原始测序重新注释。

执行命令：

```sh
Rscript outputs/opportunity-projection-validation-2026-10-25/validate.R submission/RecWaterVirome_v56.1_2026-10-25 outputs/opportunity-projection-validation-2026-10-25
```

此外使用 quasibinomial 系数拟合及从独立初值开始、手写 Newton 迭代的加权 Bernoulli 交叉熵最小化核验投影系数。两者均仅验证确定性投影数值，不作显著性、标准误、AIC 或生物学推断。

## 结果

- 285 个代谢域的 beta 中位数为 4.04834979821829，逐特征 beta 减投影的中位数为 +1.74435633980046。
- 38 个抗防御 profile 的 beta 中位数为 1.35694834072366，逐特征差值中位数为 −0.973544050443506。
- 323 个固定机会模型均通过原始 valid 检查。323 个投影均收敛、未到边界、设计秩为 2；全部仅记录 `non-integer counts in a binomial glm!`。原来的 valid 将任何 warning 判作 FALSE，故严格原规则下投影 0/323 valid，不能伪写原规则全通过。
- 该警告源于将模型预测的期望携带数量（小数）作为二项成功次数。它不是本次观察到的不收敛错误，也不是原始观测携带数被弄成小数。
- 与保存结果最大绝对差：beta 4.27e−14、投影 5.33e−15、residual 3.20e−14；浮点误差水平。
- quasibinomial 投影均收敛、未到边界、无警告，系数与原投影一致（最大差 0）。独立交叉熵解均收敛，最大系数差 4.70e−9。
- 归档输入的 MD5 前后完全一致；另检查 859 个投稿包文稿源/Word/工作簿文件 SHA256，未改变。机器记录见 verification.json、publication-unchanged.json、feature-validation.tsv。

## 判断与后续文字处理

缺少历史投影状态记录并不等于历史值错误。本次已补上重现与数值诊断证据，未发现上述两个中位数存在数值错误。若作者之后采用本次核查，应将 SI 的“投影状态未保存”限定更新为历史记录缺口已由本次独立核查补充，并准确描述期望概率投影及非整数计数提示；不得只删除警告或伪写原 strict-valid 通过。

该核查不能证明固定每-CDS机会假设符合生物现实，不能排除其他混杂、谱系依赖或注释差异。residual_slope 仍是描述性斜率差，不是重新拟合的“校正后携带效应”、选择指数或显著性结果。不要将它当成可直接画出实际携带概率的斜率，不对其应用 exp() 来解释为校正后实际 odds ratio。

本轮未改正式稿、SI、图或 Data 2；文字同步是后续明确采用本次核查时的工作。

## 给作者的解释

beta=1 指 CDS 数量增加十倍时，模型 log-odds 增加 1（odds 乘 e）；不是概率增加 1，也不规定图上 45°。图形角度依赖坐标单位、比例与所画尺度。

residual=beta−投影。+1.7444/−0.9735 是两组逐特征差值的中位数，不能用“beta 中位数减投影中位数”代替。负差值表示实际斜率低于机会模型参照，不能解释为不相关或实际负斜率。实际例 aca1：beta=+0.6312、投影=+2.3034、差=−1.6722，实际方向仍正。

技术依据：R 官方 family/glm 文档说明 binomial/quasibinomial 响应、链接与加权拟合；本次独立系数一致性以实际计算为准。

- https://stat.ethz.ch/R-manual/R-devel/library/stats/html/family.html
- https://stat.ethz.ch/R-manual/R-devel/library/stats/html/glm.html
