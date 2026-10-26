#!/usr/bin/env python3
"""作业 j42 (feature-export) — 把主结论依赖的**逐特征**斜率导出来。

**为什么做**：作业 j38 / j40 / j41 都只把**中位数**写进了 summary.json，
逐条斜率只在内存里活过一次。结果是：主结论比较的是 285 个代谢域与 22 个反防御家族，
但盘上**没有那 285 条**（j38 只存了 top15，j40/j41 只存中位数）。
⇒ 手稿的主图画不出来，"coherent scaling / shared constraint"这类措辞也没法被读者核验。
j31 里那 13 个手挑的代谢标志域**不能**代替全集（会诊 2026-09-02 明确否掉）。

**本作业不产出任何新判据。** 它只做一件事：把已有口径下的逐特征结果落盘。
判据仍以 j38（主判据）/ j40（谱系）/ j41（生境）为准。

**口径**：与作业 j41 逐字一致——同一个分析集、同一套 Pfam NAME+DESC 分箱、
同一个 slope()（NL.irls，每基因组一行，k<15 或 k==n 时判为不可评估）。
**阳性对照**：合并口径必须复现 +4.05 / +0.52 / +3.53（容差 ±0.10），否则中止不产出。

**产出**：
  ~/j42_feature_export/feature_slopes.tsv   逐特征：id / 名称 / 组 / 载体数 / 斜率 / se / 95%CI
  ~/j42_feature_export/summary.json         组内中位数 + 阳性对照 + _provenance
"""
import sys, json, math, time, re, hashlib
sys.path.insert(0, "/home/cunli")
import narp_lib as NL
from pathlib import Path
from collections import Counter
from datetime import datetime, timezone

W = Path.home() / "j42_feature_export"; W.mkdir(exist_ok=True)
(W / "logs").mkdir(exist_ok=True)
t0 = time.time(); log = lambda m: print(f"[{time.time()-t0:7.1f}s] {m}", flush=True)
R = {}
MINCAR = 30
ADF = Path.home() / "narp2_antidefense_matched"
PFAM = "/home/cunli/data2/db/pfam/Pfam-A.hmm"
J38_NEW = {"METAB": 285, "REPL": 149, "STRUCT": 183, "REG": 77, "OTHER": 1134}
J38_POOLED = {"metab": 4.05, "adf": 0.52, "diff": 3.53}

def must(cond, msg):
    if not cond: sys.exit(f"[契约失败] {msg}")
for _p in (PFAM, str(ADF/"antidefense_hits.tsv"), str(ADF/"family_category.tsv")):
    must(Path(_p).exists(), f"输入不存在: {_p}")
    must(Path(_p).stat().st_size > 0, f"输入是空文件: {_p}")

# ── 分箱关键词表：逐字沿用作业 j41（只准复制，不准改）
KW = {
 "METAB": ["synthase","synthetase","transferase","reductase","dehydrogenase","kinase",
           "hydrolase","phosphatase","oxidase","lyase","isomerase","mutase","carboxylase",
           "metabol","biosynth","nucleotid","nucleosid","amino acid","sugar","lipid",
           "folate","thymidylate","nad","riboflavin","cobalamin","glycosyl","pyrophosphatase",
           "deaminase","amidase","epimerase","aldolase","thioredoxin","ferredoxin"],
 "REPL":  ["dna polymerase","helicase","primase","ligase","topoisomerase","recombinase",
           "exonuclease","endonuclease","nuclease","replicat","repair","resolvase",
           "single-stranded dna","ruva","ruvc","reca","holliday"],
 "STRUCT":["capsid","tail","portal","terminase","baseplate","sheath","fiber","fibre",
           "head","neck","collar","scaffold","major coat","minor coat","virion","tape measure",
           "spike","tegument","lysin","holin","spanin","endolysin"],
 "REG":   ["repressor","activator","transcription","sigma factor","anti-sigma","regulator",
           "two-component","response regulator","histidine kinase","dna-binding","cro ",
           "ci repressor","antiterminat"],
}
def classify(text):
    p = (text or "").lower()
    for g in ("STRUCT","REPL","REG","METAB"):
        if any(k in p for k in KW[g]): return g
    return "OTHER"

log("〇、扫 Pfam-A.hmm")
pf = {}; acc = name = desc = None
with open(PFAM, "r", errors="ignore") as fh:
    for line in fh:
        if line.startswith("NAME "): name = line[5:].strip()
        elif line.startswith("ACC "): acc = line[4:].strip().split(".")[0]
        elif line.startswith("DESC "): desc = line[5:].strip()
        elif line.startswith("//"):
            if acc: pf[re.sub(r"[^0-9]","",acc)] = {"name": name or "", "desc": desc or ""}
            acc = name = desc = None
log(f"   Pfam 家族 {len(pf):,}")
def norm(d): return re.sub(r"[^0-9]","",d)

con = NL.connect(str(W/"d.duckdb"), mem="4GB", threads=2)
con.execute("SET enable_progress_bar=false")
NA = NL.build_aset(con); NL.build_calls(con)
log(f"分析集 {NA:,}")

log("一、分箱并对作业 j38 的阳性对照")
con.execute(f"""CREATE OR REPLACE TABLE dprod AS
  SELECT dom, mode(product) prod, count(DISTINCT uvig) car FROM (
    SELECT p.uvig, unnest(p.pfam) dom, p.product FROM read_parquet('{NL.PC}') p
    SEMI JOIN aset a ON a.uvig=p.uvig WHERE p.pfam IS NOT NULL AND len(p.pfam)>0)
  GROUP BY 1""")
doms = con.execute(f"SELECT dom, prod FROM dprod WHERE car>={MINCAR}").fetchall()
log(f"   载体 ≥{MINCAR} 的域 {len(doms):,}")
hit = sum(1 for d,_ in doms if norm(d) in pf)
must(100*hit/len(doms) >= 50, f"Pfam 名称匹配率只有 {100*hit/len(doms):.1f}%（<50%）")
grp = {d: classify((pf[norm(d)]["name"]+" "+pf[norm(d)]["desc"]) if norm(d) in pf else pr)
       for d, pr in doms}
cn = Counter(grp.values())
bad = {g: cn[g]-J38_NEW[g] for g in J38_NEW if abs(cn[g]-J38_NEW[g]) > 2}
must(not bad, f"新分箱与作业 j38 对不上（容差 ±2）：{bad}")
log(f"   ✅ 阳性对照：分箱复现作业 j38（{dict(cn)}）")
R["binning"] = dict(cn)

log("二、取载体集合")
CDS = dict(con.execute("SELECT uvig, log10(cds_count) FROM aset WHERE cds_count>0").fetchall())
con.execute("""CREATE OR REPLACE TABLE pd AS SELECT DISTINCT uvig, dom FROM (
    SELECT p.uvig, unnest(p.pfam) dom FROM read_parquet('%s') p
    SEMI JOIN aset a ON a.uvig=p.uvig WHERE p.pfam IS NOT NULL AND len(p.pfam)>0)""" % NL.PC)
dom_car = {d: set(u for (u,) in con.execute("SELECT uvig FROM pd WHERE dom=?", [d]).fetchall())
           for d, _ in doms}
con.execute(f"""CREATE OR REPLACE TABLE adf_g AS
  SELECT DISTINCT split_part(h.protein_oid,'|',1) uvig, coalesce(c.category,h.profile) cat
  FROM read_csv('{ADF}/antidefense_hits.tsv', delim='\t', header=true, sample_size=-1, quote='') h
  LEFT JOIN read_csv('{ADF}/family_category.tsv', delim='\t', header=false, quote='',
       columns={{'profile':'VARCHAR','category':'VARCHAR'}}) c USING (profile)""")
cats = [c for (c,) in con.execute("""SELECT cat FROM adf_g SEMI JOIN aset USING (uvig)
  GROUP BY 1 HAVING count(DISTINCT uvig)>=30""").fetchall()]
adf_car = {c: set(u for (u,) in con.execute("SELECT DISTINCT uvig FROM adf_g WHERE cat=?",
                                            [c]).fetchall()) for c in cats}
log(f"   Pfam 域 {len(dom_car):,}，反防御类别 {len(cats)}")

# ── slope(): 与作业 j41 逐字一致，只多返回 se
def slope(carriers):
    xs=[]; ys=[]
    for u, x in CDS.items():
        xs.append(x); ys.append(1.0 if u in carriers else 0.0)
    k = sum(ys)
    if k < 15 or k == len(ys): return None
    b, se, _, _ = NL.irls([[1.0,x] for x in xs], ys)
    if not b or not math.isfinite(b[1]): return None
    s1 = None
    try:
        s1 = float(se[1]) if hasattr(se, "__len__") else float(se)
    except Exception:
        s1 = None
    if s1 is not None and not math.isfinite(s1): s1 = None
    return b[1], s1, int(k)

log("三、逐特征拟合（Pfam 域）")
rows = []
for i, (d, _) in enumerate(sorted(doms)):
    r = slope(dom_car[d])
    if r is None: continue
    s, se, k = r
    nm = pf.get(norm(d), {}).get("name", "")
    rows.append({"feature": d, "name": nm, "group": grp[d], "namespace": "Pfam",
                 "carriers": k, "slope": s, "se": se,
                 "lo": (s-1.96*se) if se else None, "hi": (s+1.96*se) if se else None})
    if (i+1) % 400 == 0: log(f"   ...{i+1:,}/{len(doms):,}")
log(f"   收敛 {len(rows):,} / {len(doms):,}")

log("四、逐特征拟合（反防御家族）")
for c in sorted(cats):
    r = slope(adf_car[c])
    if r is None: continue
    s, se, k = r
    rows.append({"feature": c, "name": c, "group": "ADF", "namespace": "antidefense_HMM",
                 "carriers": k, "slope": s, "se": se,
                 "lo": (s-1.96*se) if se else None, "hi": (s+1.96*se) if se else None})
log(f"   反防御收敛 {sum(1 for r in rows if r['group']=='ADF')} / {len(cats)}")

with open(W/"feature_slopes.tsv", "w") as fh:
    fh.write("feature\tname\tgroup\tnamespace\tcarriers\tslope\tse\tci_lo\tci_hi\n")
    for r in sorted(rows, key=lambda r: (r["group"], -r["slope"])):
        f = lambda v: "" if v is None else f"{v:.6f}"
        fh.write(f"{r['feature']}\t{r['name']}\t{r['group']}\t{r['namespace']}\t"
                 f"{r['carriers']}\t{f(r['slope'])}\t{f(r['se'])}\t{f(r['lo'])}\t{f(r['hi'])}\n")
log(f"   已写 feature_slopes.tsv（{len(rows):,} 行）")

# ── 五、阳性对照：合并口径必须复现 headline
med = {}
for g in ("METAB","REPL","STRUCT","REG","OTHER","ADF"):
    v = sorted(r["slope"] for r in rows if r["group"] == g)
    med[g] = {"n": len(v), "median": NL.quant(v, .5) if v else None}
mm, ma = med["METAB"]["median"], med["ADF"]["median"]
diff = mm - ma
print(f"\n  组             n      中位斜率")
for g in ("METAB","REPL","REG","OTHER","STRUCT","ADF"):
    print(f"  {g:<10}{med[g]['n']:>7}    {med[g]['median']:+.2f}")
print(f"\n  合并口径：METAB {mm:+.2f}（{med['METAB']['n']} 个域）vs ADF {ma:+.2f}"
      f"（{med['ADF']['n']} 个），差 {diff:+.2f}")
for k, v, exp in (("med_metab", mm, "metab"), ("med_adf", ma, "adf"), ("diff", diff, "diff")):
    must(abs(v - J38_POOLED[exp]) <= 0.10,
         f"没能复现作业 j38 的 headline：{k}={v:+.3f} vs 期望 {J38_POOLED[exp]:+.2f}")
print("  ✅ 复现作业 j38 的 headline（容差 ±0.10）⇒ 导出的逐特征结果与主结论同源")
R["group_medians"] = med
R["positive_control"] = {"med_metab": mm, "med_adf": ma, "diff": diff,
                         "expected": J38_POOLED, "tol": 0.10, "passed": True}
R["n_features_exported"] = len(rows)
R["adf_steeper_than_metab_median"] = sorted(
    [{"family": r["feature"], "slope": r["slope"]} for r in rows
     if r["group"] == "ADF" and r["slope"] > mm], key=lambda x: -x["slope"])

def _fp(p):
    try: return hashlib.sha256(open(p,"rb").read(1<<20)).hexdigest()[:16]
    except Exception as e: return f"读取失败: {e}"
R["_provenance"] = {
  "生成时间": datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds"),
  "脚本": str(Path(__file__).resolve()),
  "slurm作业号": __import__("os").environ.get("SLURM_JOB_ID", "（非 slurm 运行）"),
  "输入指纹": {p: _fp(p) for p in (PFAM, str(ADF/"antidefense_hits.tsv"),
                                   str(ADF/"family_category.tsv"))},
  "指纹口径": "sha256(文件前 1 MB) 取前 16 位",
  "口径": ("与作业 j41 逐字一致：分析集 = MetaVR Complete+Caudoviricetes+vOTU去重(取最长)"
           "+≥30kb+cds>0；分箱 = Pfam NAME+DESC 关键词；slope = NL.irls 每基因组一行，"
           "k<15 或 k==n 判为不可评估。CI 为 Wald ±1.96·se。"),
  "上游": ["作业 j38（主判据与分箱阳性对照）", "作业 j41（slope 实现与分析集）"],
  "已知边界": ("本作业**不产出新判据**，只把已有口径下的逐特征结果落盘。"
               "⚠ ADF 行与 Pfam 行**不同命名空间**：ADF 分子来自独立 HMM 搜索，"
               "两者可以并排画『斜率』（同一个 logit 模型），但**不可**放进同一个比例分母。"),
}
json.dump(R, open(W/"summary.json","w"), indent=2, ensure_ascii=False)
log("DONE")
