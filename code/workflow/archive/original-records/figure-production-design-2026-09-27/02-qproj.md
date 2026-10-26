# qproj工程结构与来源规范

对应design-v2026.09.27.1。以下是未来工程规格，尚未初始化项目、创建QMD或上传GitHub。它修正上一版code-repository-plan.md中的通用目录示意：`00-inputs`不用，图不直接写公共`figures/main`。

## 1. 一个图一个入口，准备步骤共享

拟用有效R包名`RecWaterVirome`；实际GitHub owner、仓库名和可见性在建库时核定。qproj::proj_create检查R包名，不能直接把带连字符的旧仓库名当包名，也不在现有非空研究区重新初始化。

```text
RecWaterVirome/
  DESCRIPTION                     # 包依赖与作者；R包名独立核定
  README.md / PAPER-PLAN.md
  LICENSE.md / CITATION.cff / CONTRIBUTORS.md
  R/                              # 纯读取/检查/样式/组装/导出函数
  config/                         # 样本顺序、配色、图尺寸、列定义与显示名单
  metadata/                       # 来源、hash、图—代码—数据映射
  docs/                           # 固定设计、方法与审阅记录
  environment/                    # R及外部工具版本/恢复说明
  analyses/
    _quarto.yml
    010-input-manifest.qmd
    020-community-inputs.qmd
    030-function-inputs.qmd
    040-vf-inputs.qmd
    050-global-inputs.qmd
    110-fig1-design-composition.qmd
    120-fig2-community-links.qmd
    130-fig3-functions.qmd
    140-fig4-vf-context.qmd
    150-fig5-global-reference.qmd
    210-sfig1-qc-community.qmd
    220-sfig2-function-context.qmd
    230-sfig3-vf-calibration.qmd
    240-sfig4-global-sensitivity.qmd
    310-table1-definitions.qmd
    320-data1-local.qmd
    330-data2-global.qmd
    900-publication-bundle.qmd
    data/
      00-raw/d00-resource/         # 受清单管理的共享输入
      00-raw/d020-community-inputs/ # 示例：该步骤私有输入
      020-community-inputs/       # 本步骤产出
      110-fig1-design-composition/ # Figure1主文件、面板与绘图值
      ...
      900-publication-bundle/     # 最终交付副本及manifest
```

数字间隔为了可插入步骤；统一三位零填充，不混01/1/001。qproj保留精确`00-`开头；010等用户步骤不占`00-raw`。计算依赖由清单决定，不仅凭论文阅读顺序猜。

SwDG被审阅的模板实际上调用`projthis`。迁移时借鉴其组织约定，按本轮查明的`qproj`模板/API实现，不能直接复制旧包名或假定两套函数完全兼容。无需修改qproj包本身，也无需创建新的通用工作流引擎；显式步骤清单和小型输入/路径检查足够。

每张QMD可以包含多个A/B/C子面板，必须最后组装并导出完整图；通用函数只写一次。S1–S4各自有单一入口，若有明确批准的续页，同一入口导出其所有页，页码/面板号不重复。

## 2. 读写与运行约定

- 写计算/图/表产物只经`path_target()`到当前步骤目录。QMD自身的标准GFM/HTML报告由Quarto渲染位置管理，属于明确例外，不混为科学图产物。
- 私有原始输入用`path_data`，共享输入用`path_resource`；下游只经`path_source("较早步骤", "产物")`读准备结果。禁止绕过绑定读取兄弟步骤的私有raw。
- 不写死`/Users/pan`、`/home/allen`或Spark个人路径。外部源由配置和manifest指向，发布时提供可移植获取/暂存方式。
- `clean=FALSE`，不通过模板清空目录。已安装函数`clean=TRUE`会递归删除target；不要把“模板约定只删输出”误当底层保证。
- 显式render清单，声明每个步骤的输入、依赖、输出；执行前检查来源step存在、编号更早、输入hash匹配以及target归属。本项目的越序/错路径检查要主动失败，不能依靠qproj仅发warning。
- 每文件新R进程，先运行params/setup，再运行任务；首次验证关闭cache/freeze。共享`R/`在load_all时不得执行下载、统计、安装或写文件。
- 依赖图只辅助理解。已装sort_files未兑现所有下划线跳过/排序指南，故不依赖隐藏文件名约定或扩展名匹配的first/last重排来保障正确性。

这些是运行规则，不构成进程级权限隔离。Claude任务边界、已有文件保护和Codex差异审核另行执行。

## 3. 与论文材料的对应链

| 准备步骤 | 本轮已确认的主要来源 | 供应对象 |
|---|---|---|
| 010 | 新工程输入manifest、来源hash、样本/单位字典 | 所有后续步骤；只核对与登记 |
| 020 | 已导出组成/排序；390 alpha；060 alpha/多样性；080协变；已清理200宿主成员；严格CRISPR与QC来源 | F1、F2、S1、Data1 |
| 030 | amg_pathway_current矩阵；amg_votu_host_drivers贡献表；F3-display-selection；NARP位点及相关背景 | F3、S2、Data1 |
| 040 | S34固定3013模型；vf20_coordinates及完整预测边界；受控构建与分层表 | F4、S3、Data1 |
| 050 | global_primary固定285/38模型及支持/敏感性；本地已保存六档比例 | F5、S4、Data2；本地/全球字段分开 |

原文件详细路径在01、local-panel-design及此前来源记录。实现前产生逐文件迁移清单，不能凭此表假装每个上游已能从原始reads重跑。准备步骤只读取、核验、导出已有结果；遇到必须重拟合或补新数据库扫描才有的数据，返回缺口，不能偷偷运算。

图旁源表保存实际显示值、类别映射、排序和单位；全量表进入Data1/2，图中top-N不删掉全量。F3名单的hash和来源表一致；旧宿主置信度/空属匹配字段不未经核验复活。

单位/定义的唯一来源放在早期config/metadata中，各图读取同一份；310步骤只是将它排成Table1。不能让前面的图依赖后面的Table1产物，造成反向依赖。

## 4. 署名与贡献记录

每个新QMD显式写ordered `author`：**Jinlong Ru → Cunli Pan**；工作流默认配置、README贡献说明、DESCRIPTION中的作者列表及新代码文件头保持这一展示顺序。具体贡献角色按实际记录，原有其他贡献者不得删除；维护者可另标Cunli Pan。

qproj当前模板没有以`contributors`替代`author`的机制。GitHub自动Contributors列表按提交记录生成，不受YAML/README排序控制；不能为改变排序伪造提交者。代码文档顺序也不替作者擅定论文最终byline。

复制/改写代码逐项记录原路径、commit或本地hash、贡献者（不明确则待核）、改动说明。保留原代码许可；不把参考项目的脚本换名后当成全新原创。

## 5. 环境、数据与发布

初版锁定实际使用的qproj commit和R依赖；DESCRIPTION是依赖声明，不是完整版本锁。记录R/session、Quarto、系统字体、Python/外部工具与数据库版本，未确认项标缺口。不要把“固定qproj0.1.5”写成远端最新版本认证。

qproj默认忽略`analyses/data/*`。新仓库必须另有**明确选择的输入交付规则**：小型可分享绘图源表可列白名单或进入数据release；用文件清单/hash和暂存步骤放入qproj raw区，不能全目录force-add。大型原始reads/数据库走数据来源说明。未取得输入时明确失败，不能从个人机器隐形补读。

900步骤只复制已验收图表；逐项记录生产step、接受记录、源hash、复制后hash，并断言相等。不得混入上次残留图，不在打包中缩放、重拟合或换标签。图的名字如Figure1.pdf、FigureS1.pdf可便于投稿；manifest保留到110等生产入口的映射，不要求把步骤前缀强加到期刊图名。

分别声明：①从冻结小表重绘；②从保存中间对象重建；③从原始序列完整重跑。只做了①，不能宣传③已验收。

## 6. 实施批次与交付状态

0. **工程与样式小样**：明确新工作目录，复制已批准规则，核模板/API，确认字体/页面/导出同一对象；不混入科学结论。按qproj-helper的初始化要求处理脚手架，本轮无需执行Console或创建项目。
1. **F1、F2与S1一起**：冻结020输入、组成映射和host集合；主图、QC/协变补充和Data1相应sheet一起审核。
2. **F3、F4与S2、S3一起**：使用已选KO/贡献数据，核位点/命中单位与四模型；候选与阴性证据同步展示。
3. **F5与S4一起**：本地/全球分面和固定集合/谱系限制同步审核。
4. **全套打包**：Table1、Data1/2、图注、版本与来源核对；主补图一起查看，之后才准备自己的GitHub远端。

每批允许保存草稿，但只有数据与视觉均通过才标accepted。阶段1不要求尚未实施的F3/F4通过；全套投稿验收才要求九个入口、各补充页与工作簿齐全。
