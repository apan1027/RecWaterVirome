#!/usr/bin/env python3
"""A2 覆盖度尖峰检验 — 汇总.

判据: 若 ORF102 驱动了 NARP2 位点的原位串联扩增, 短读长组装会把重复塌缩,
但塌缩的重复必然在 read depth 上留下尖峰。故检验 NARP2 区间相对 contig 的深度比。

三重对照:
  · 位置特异性 — 滑窗百分位, 排除 contig 天然深度起伏
  · 跨 contig  — 带 HE / 有非 HE 插入 / 无插入 三级
  · 跨物种误 map — Q0 vs Q20 两档 MAPQ（nadM/NAMPT 高度保守, 易招募他源 reads）
内部阳性对照: 报告全 contig 最高窗口, 证明方法对真实深度起伏有分辨力。
"""
import bisect, csv, os, statistics as st
from collections import OrderedDict

ROOT = "/home/allen/github/rujinlong/p0061-RecWaterVirome/analyses/data/140-coverage-spike"
W, S = 500, 100

# contig -> (NARP2 区间, 插入 ORF 区间 or None, 插入类型, 主样本, 次样本)
LOCI = OrderedDict([
    ("vctg2997", ((42702, 45891), (43790, 44425), "GIY-YIG HE (ORF102)",      "gd1v", "gc1v")),
    ("vctg3454", ((10691, 15450), (12064, 14426), "HNH+NUMOD3 等 4 ORF",       "od1v", "oc1v")),
    ("vctg2633", ((23869, 26988), (25049, 25459), "非 HE 插入 (ORF36)",        "gc1v", "gd1v")),
    ("vctg2728", ((28,     2536), None,           "无插入（贴 contig 起点）",  "gd1v", "gc1v")),
    ("vctg2892", ((7823,  10302), None,           "无插入",                    "gd1v", "oc1v")),
])

def load(path):
    return [int(l.split("\t")[2]) for l in open(path)]

def windows(d):
    return [(i + 1, i + W, st.median(d[i:i + W])) for i in range(0, len(d) - W + 1, S)]

def region_stats(d, beg, end):
    seg = d[beg - 1:end]
    return st.median(seg), st.mean(seg)

rows = []
for c, (narp, ins, ins_type, main, second) in LOCI.items():
    for s in (main, second):
        for q in (0, 20):
            f = f"{ROOT}/depth/{c}.{s}.Q{q}.tsv"
            if not os.path.exists(f):
                continue
            d = load(f)
            med = st.median(d) or 0.5          # 防除零
            wins = windows(d)
            wm = sorted(w[2] for w in wins)
            pct = lambda v: 100 * bisect.bisect_left(wm, v) / len(wm)
            nmed, nmean = region_stats(d, *narp)
            nwin = [w[2] for w in wins if not (w[1] < narp[0] or w[0] > narp[1])]
            top = max(wins, key=lambda w: w[2])
            imed = region_stats(d, *ins)[0] if ins else None
            rows.append(dict(
                contig=c, sample=s, role="main" if s == main else "second", mapq=f"Q{q}",
                ins_type=ins_type,
                contig_med=med, contig_mean=round(st.mean(d), 2),
                zero_frac=round(sum(1 for x in d if x == 0) / len(d), 4),
                narp_med=nmed, narp_ratio=round(nmed / med, 2),
                narp_win_pct_lo=round(min(pct(v) for v in nwin), 1),
                narp_win_pct_hi=round(max(pct(v) for v in nwin), 1),
                ins_ratio=round(imed / med, 2) if imed is not None else "",
                top_win=f"{top[0]}-{top[1]}", top_ratio=round(top[2] / med, 2),
                top_in_narp=int(not (top[1] < narp[0] or top[0] > narp[1])),
            ))

os.makedirs(f"{ROOT}/summary", exist_ok=True)
with open(f"{ROOT}/summary/coverage_spike.tsv", "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0]), delimiter="\t")
    w.writeheader(); w.writerows(rows)

hdr = f"{'contig':<9} {'sample':<6} {'Q':<4} {'插入':<22} {'contig中位':>9} {'NARP2':>7} {'ratio':>6} {'窗口%位':>12} {'插入ORF':>8} {'最高窗ratio':>11}"
print(hdr); print("-" * len(hdr))
for r in rows:
    print(f"{r['contig']:<9} {r['sample']:<6} {r['mapq']:<4} {r['ins_type'][:22]:<22} "
          f"{r['contig_med']:>9} {r['narp_med']:>7} {r['narp_ratio']:>6} "
          f"{str(r['narp_win_pct_lo'])+'-'+str(r['narp_win_pct_hi']):>12} "
          f"{str(r['ins_ratio']):>8} {r['top_ratio']:>11}")
print(f"\n写出 {ROOT}/summary/coverage_spike.tsv ({len(rows)} 行)")
