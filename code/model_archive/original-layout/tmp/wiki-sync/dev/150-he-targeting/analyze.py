#!/usr/bin/env python3
"""B: HE 是否靶向 nadM-NAMPT 连接 —— 统计检验.

零假设: 每个基因组的 k 个 HE 随机分布在 n 个 ORF 位置上。
统计量: 目标窗口内含 >=1 个 HE 的基因组数; 期望 = sum_g [1-(1-m_g/n_g)^k_g]。
以每基因组自身的 HE 总数 k_g 为条件 => HANDOFF 要求的对照 2「是不是这个基因组本来 HE 就多」
被自动吸收(vctg3454 全基因组 >=4 个 HE 已证明必须有此对照)。
对照 1「是不是哪儿都插」= 期望值本身(全基因组 HE 密度)。
对照 3 谱系 = genus 折叠后重算。
"""
import csv, json, math, os
from collections import defaultdict, Counter

P = "/home/allen/github/rujinlong/pc051e1-PhageNAMPT/analyses/data"
O = "/home/allen/github/rujinlong/p0061-RecWaterVirome/analyses/data/150-he-targeting"

def poisson_p(obs, lam):
    if obs == 0: return 1.0
    return 1 - sum(math.exp(-lam) * lam**i / math.factorial(i) for i in range(obs))

def fam(x):
    if x.startswith(("GIY-YIG", "GIY_YIG")): return "GIY-YIG"
    if x.startswith(("HNH", "AHH", "WHH")):  return "HNH"
    if x.startswith("LAGLIDADG"):            return "LAGLIDADG"
    if x.startswith("NUMOD"):                return "NUMOD"

def main():
    n_orf = defaultdict(int)
    for line in open(f"{P}/06-extract-accession-proteomes/nampt_positive_phages.gff"):
        if not line.startswith("#"): n_orf[line.split("\t", 1)[0]] += 1

    he = defaultdict(set)
    for line in open(f"{O}/hmmsearch/he_domains.domtbl"):
        if line.startswith("#"): continue
        pid = line.split()[0]
        he[pid.rsplit("_", 1)[0]].add(int(pid.rsplit("_", 1)[1]))

    meta = {r["accession"]: r for r in csv.DictReader(
        open(f"{P}/05-call-local-narp2-modules/local_narp2_window10_summary.tsv"), delimiter="\t")}

    idx = lambda p: int(p.rsplit("_", 1)[1])
    narp = {}
    for r in csv.DictReader(open(f"{P}/05-call-local-narp2-modules/local_narp2_window10_detail.tsv"),
                            delimiter="\t"):
        if "NMNAT" not in r["neighbor_role"]: continue
        if r["neighbor_protein_id"] == r["nampt_protein_id"]: continue
        a = r["accession"]; ni, mi = idx(r["nampt_protein_id"]), idx(r["neighbor_protein_id"])
        if a not in narp or abs(ni - mi) < narp[a]["dist"]:
            narp[a] = dict(dist=abs(ni - mi), nampt=ni, nmnat=mi)

    def test(accs, ext):
        obs = exp = n_eval = 0
        for a in accs:
            n, k = n_orf.get(a, 0), len(he.get(a, ()))
            if not n: continue
            lo, hi = sorted((narp[a]["nampt"], narp[a]["nmnat"]))
            win = set(range(lo + 1, hi)) if ext == 0 else \
                  set(range(max(1, lo + 1 - ext), min(n, hi - 1 + ext) + 1))
            if not win: continue
            n_eval += 1
            if he.get(a, set()) & win: obs += 1
            if k: exp += 1 - (1 - len(win) / n)**k
        return n_eval, obs, exp, poisson_p(obs, exp)

    # 谱系折叠：同一 genus 只取 1 个代表；Unclassified 视为各自独立
    seen, units = set(), []
    for a in narp:
        g = meta.get(a, {}).get("genus", "")
        key = a if g in ("Unclassified", "", "?") else g
        if key not in seen:
            seen.add(key); units.append(a)

    rows = []
    for label, accs in [("全部基因组", list(narp)), ("谱系去重", units)]:
        for wname, ext in [("严格（两基因之间）", 0), ("±2 ORF", 2), ("±5 ORF", 5), ("±10 ORF", 10)]:
            n_eval, obs, exp, p = test(accs, ext)
            rows.append(dict(set=label, window=wname, n_genomes=n_eval,
                             observed=obs, expected=round(exp, 2), poisson_p=round(p, 4)))

    os.makedirs(f"{O}/summary", exist_ok=True)
    with open(f"{O}/summary/he_targeting_test.tsv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]), delimiter="\t")
        w.writeheader(); w.writerows(rows)

    # 功效：以 80% 功效检出 OR=3 需要多大数据量
    pw = []
    base = next(r["expected"] for r in rows if r["set"] == "全部基因组" and r["window"].startswith("严格"))
    n_base = next(r["n_genomes"] for r in rows if r["set"] == "全部基因组" and r["window"].startswith("严格"))
    for f in (1, 2, 4, 6, 8, 10, 12):
        lam0 = base * f; lam1 = lam0 * 3
        crit = next(c for c in range(1, 80) if poisson_p(c, lam0) < 0.05)
        pw.append(dict(fold=f, n_genomes=int(n_base * f), expected_null=round(lam0, 2),
                       crit=crit, power_OR3=round(poisson_p(crit, lam1), 3)))
    with open(f"{O}/summary/power_analysis.tsv", "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(pw[0]), delimiter="\t")
        w.writeheader(); w.writerows(pw)

    for r in rows: print(r)
    print(f"\n写出 {O}/summary/{{he_targeting_test,power_analysis}}.tsv")

if __name__ == "__main__":
    main()
