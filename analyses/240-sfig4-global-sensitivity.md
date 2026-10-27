# Supplementary Note 4 (not Figure S4)

Jinlong Ru; Cunli Pan.

[Editable QMD](240-sfig4-global-sensitivity.qmd) · [Analysis index](README.md)

Source reading companion with accepted figure previews; not a new scientific execution report.

## Purpose

Supplementary Note 4 replaces the former six-panel S4. The technical step identifier is retained for provenance. This step reads saved global results; it does not fit models.

```r
manifest <- rwv_read_tsv(rwv_step_input(step, path_source, "010-input-manifest", "input-manifest.tsv"))
defs <- rwv_definitions_read(rwv_project_input(step, "analyses/R/definitions.tsv", manifest))
up5 <- function(f) as.data.frame(readr::type_convert(rwv_read_tsv(rwv_step_input(step, path_source, "050-global-inputs", f)), col_types = readr::cols()))
fits <- up5("global_feature_fits.tsv")
support <- up5("global_profile_support.tsv")
firth <- up5("global_firth.tsv")
adjusted <- up5("global_adjusted.tsv")
resampling <- up5("global_resampling.tsv")
strata <- up5("global_strata.tsv")
leave <- up5("global_nad_leaveout.tsv")
gaps <- up5("global-gaps.tsv")
ff <- up5("global_firth_feature_fits.tsv")
rc <- up5("global_resample_contrasts.tsv")
rf <- up5("global_resample_features.tsv")
status_ix <- up5("global_result_status.tsv")
rep_sc <- up5("global_repair_scenario_summary.tsv")
rep_ff <- up5("global_repair_feature_fits.tsv")
checks <- rwv_checks_new()
rwv_check_def(checks, defs, "global_metab", sum(fits$group == "285 metabolic-related Pfam domains"), "global_feature_fits.tsv")
rwv_check_def(checks, defs, "global_adf", sum(fits$group == "38 non-NARP anti-defense profiles"), "global_feature_fits.tsv")
rwv_check(checks, "every feature has >= 30 carriers", TRUE, all(fits$carriers >= 30))
rwv_check_def(checks, defs, "global_single_cluster", sum(support$carrier_clusters == 1), "global_profile_support.tsv")
rwv_check(checks, "ordinary separate adjusted full comparisons not estimable", rep(FALSE, 4), adjusted$valid)
f <- firth[firth$definition == "all38", ]
f <- f[match(c("unadjusted", "ecosystem", "host"), f$covariate), ]
rwv_check(checks, "three separate Firth settings", 3, nrow(f))
rwv_check(checks, "Firth anti-defense medians match saved regression anchors", c(1.360913, 1.208445, 1.446066), round(f$adf_median, 6))
for (i in seq_len(nrow(f))) {
  z <- ff[ff$mode == f$covariate[i], ]
  rwv_check(checks, paste("Firth fixed sets", f$covariate[i]), c(285,38), c(sum(z$group == "METAB"), sum(z$group == "ADF_profile")))
  rwv_check(checks, paste("Firth valid feature fits", f$covariate[i]), TRUE, all(z$valid))
  med <- c(median(z$slope[z$group == "METAB"]), median(z$slope[z$group == "ADF_profile"]))
  rwv_check(checks, paste("Firth medians and difference from features", f$covariate[i]),
            c(f$metab_median[i], f$adf_median[i], f$difference[i]), c(med, med[1]-med[2]), tol=1e-12)
}
rs <- resampling[resampling$definition == "all38", ]
rs <- rs[match(c("representative", "cluster_bootstrap"), rs$mode), ]
rwv_check(checks, "complete-comparison estimability counts", c(10,50,76,200), as.vector(t(as.matrix(rs[, c("valid_replicates", "replicates")]))))
for (i in seq_len(nrow(rs))) {
  x <- rc[rc$mode == rs$mode[i] & rc$definition == "all38", ]
  y <- rf[rf$mode == rs$mode[i], ]
  counts <- table(y$rep)
  valid <- tapply(y$valid, y$rep, all)
  rwv_check(checks, paste("all fixed features in every replicate", rs$mode[i]), TRUE, all(counts == nrow(fits)))
  rwv_check(checks, paste("feature validity reconstructs each full comparison", rs$mode[i]),
            x$valid, unname(valid[as.character(x$rep)]))
  rwv_check(checks, paste("replicate summary from full records", rs$mode[i]),
            c(rs$valid_replicates[i], rs$replicates[i]), c(sum(x$valid), nrow(x)))
}
all285 <- leave$value[leave$key == "all_285"]
excl <- leave$value[leave$key == "excl_NAD6_279"]
delta <- leave$value[leave$key == "delta"]
six <- leave[leave$row_type == "left-out domain", ]
rwv_check(checks, "six NAD domains simultaneously excluded", 6, nrow(six))
rwv_check(checks, "NAD exclusion medians", c(4.048350,3.982495), c(all285,excl), tol=1e-6)
rwv_check(checks, "NAD shift equals difference", delta, excl-all285, tol=1e-9)
rwv_check(checks, "all six domains above original median", TRUE, all(six$value > all285))
met <- fits[fits$group == "285 metabolic-related Pfam domains", ]
rwv_check(checks, "simultaneous NAD exclusion reconstructed from all feature coefficients", c(all285,excl),
          c(median(met$slope),median(met$slope[!met$feature %in% six$key])), tol=1e-6)
eco <- strata[strata$covariate == "ecosystem", ]
host <- strata[strata$covariate == "host", ]
rwv_check(checks, "two classifications of same reference set", c(77951,77951), c(sum(eco$n),sum(host$n)))
rwv_check_def(checks, defs, "global_references", sum(eco$n), "global_strata.tsv")
rwv_check(checks, "host Unknown count", 38815, host$n[host$stratum == "Unknown"])
# 2026-10-15 (task r2 sections 4.4, 4.2, 5.5): opportunity diagnostics, aggregation status, failure reasons.
gv <- tapply(fits$gamma_valid, fits$group, sum)
rwv_check(checks, "opportunity: null valid 323; gamma valid 285 METAB and 35 ADF", c(323, 285, 35),
          c(sum(fits$null_valid), gv[["285 metabolic-related Pfam domains"]], gv[["38 non-NARP anti-defense profiles"]]))
g_bad <- sort(fits$feature[!fits$gamma_valid])
rwv_check(checks, "gamma not accepted: gp4.5, ocr, samase", c("gp4.5", "ocr", "samase"), g_bad)
aca1 <- fits[fits$feature == "aca1", ]
rwv_check(checks, "aca1 slope, projection, residual, gamma", c(0.631208439542248, 2.3034134327236, -1.67220499318136, 0.274024027211473),
          c(aca1$slope, aca1$null_logit_equivalent, aca1$residual_slope, aca1$gamma), tol = 1e-13)
res_med <- tapply(fits$residual_slope, fits$group, median)
rwv_check(checks, "per-set medians of the saved residual differences (summary.json values)", c(1.7443563398004578, -0.97354405044350412),
          unname(res_med[c("285 metabolic-related Pfam domains", "38 non-NARP anti-defense profiles")]), tol = 1e-12)
corr <- rep_ff[startsWith(rep_ff$scenario, "corrected_"), ]
rwv_check(checks, "corrected: 19 fits, null valid 19, gamma valid 18, projection valid 0", c(19, 19, 18, 0),
          c(nrow(corr), sum(corr$null_valid), sum(corr$gamma_valid), sum(corr$null_equivalent_valid)))
sc <- setNames(rep_sc$median_slope, rep_sc$scenario); scd <- setNames(rep_sc$class_difference, rep_sc$scenario)
nu <- setNames(rep_sc$n_units, rep_sc$scenario)
rwv_check(checks, "corrected category scenarios have 9 and 10 units", c(9, 10),
          unname(nu[c("corrected_fixed38_category", "corrected_all_profiles_category")]))
rwv_check(checks, "status index labels the old join withdrawn and the corrected units post hoc", c(TRUE, TRUE),
          c(any(status_ix$status == "WITHDRAWN_BUG_AFFECTED_AUDIT_ONLY"), any(status_ix$status == "POST_HOC_CORRECTED_DEFINITION")))
fail_why <- lapply(c("representative", "cluster_bootstrap"), function(m) {
  bad <- rf[rf$mode == m & !rf$valid, ]
  zero_rep <- unique(bad$rep[bad$carriers == 0]); all_rep <- unique(bad$rep)
  c(failed = length(all_rep), with_zero = length(zero_rep), warning_only = length(setdiff(all_rep, zero_rep)))
})
names(fail_why) <- c("representative", "cluster_bootstrap")
rwv_check(checks, "failed replicates: representative 40 (all with a zero-carrier feature)", c(40, 40, 0), unname(fail_why$representative))
rwv_check(checks, "failed replicates: cluster bootstrap 124 (123 with a zero-carrier feature, 1 warning only)", c(124, 123, 1), unname(fail_why$cluster_bootstrap))
```

```r
labels <- c(unadjusted="Unadjusted Firth", ecosystem="Firth, ecosystem adjusted separately", host="Firth, host phylum adjusted separately")
summary <- data.frame(model=unname(labels[f$covariate]), metabolic_domains=285L, anti_defense_profiles=38L,
                      metabolic_median=f$metab_median, anti_defense_median=f$adf_median, difference=f$difference,
                      unit="log-odds per tenfold increase in CDS count")
rwv_write_tsv(summary, path_target("supplementary-note-4-firth-summary.tsv"))
nav <- data.frame(sheet=c("G01_feature_fits; G02_group_medians", "G03_profile_support", "G05_adjusted; G11_adjusted_fits",
  "G06_firth; G12_firth_feature_fits; G16_firth_run", "G07_resampling; G17_resample_contrasts; G18_resample_features",
  "G08_strata", "G09_nad_leaveout", "G10_gaps", "G13_stratum_fits",
  "G19_result_status", "G14_aggregation_fits; G15_aggregation_members",
  "G20_repair_scenarios; G21_repair_feature_fits; G22_repair_members; G23_repair_scenario_members; G24_repair_mapping; G25_repair_eligibility"),
  purpose=c("Unadjusted per-feature carriers, slope, se and cluster_se, with the saved opportunity diagnostics of the same fits; fixed-set summaries (Figure 5b)",
  "Per-profile carrier genomes, carrier_clusters and single_carrier_cluster flag (Figure 5c)",
  "Ordinary separate adjustments: summary validity, invalid-feature counts and all per-feature fits/warnings",
  "Firth summary, all penalized per-feature coefficients and saved fitting parameters",
  "Complete-comparison summaries, every replicate including failures, and per-feature carrier counts/validity/warnings",
  "Ecosystem and host-phylum counts for the same reference genomes",
  "Six NAD-domain identities, simultaneous exclusion and saved medians",
  "Unfinished or unestablished analyses and interpretation limits; preserved source-era S4 wording now refers to Note 4",
  "Within-stratum results",
  "Status of every historical, withdrawn and post hoc corrected aggregation result and of the current fixed baseline",
  "Historical old-join aggregation fits and membership, withdrawn and kept for audit only",
  "Saved post hoc repair of the category join: scenario summary, all fits with validity and warnings, corrected memberships, census mapping and eligibility changes"))
rwv_write_tsv(nav, path_target("supplementary-note-4-data-navigation.tsv"))
display <- data.frame(Model=summary$model, `Metabolic median (285 domains)`=sprintf("%.6f",summary$metabolic_median),
 `Anti-defense median (38 profiles)`=sprintf("%.6f",summary$anti_defense_median),
 `Median difference (metabolic minus anti-defense)`=sprintf("%.6f",summary$difference), check.names=FALSE)
p1 <- sprintf("The fixed reference set comprises %s genomes, with separate per-feature models for 285 metabolic-related Pfam domains and 38 non-NARP anti-defense profiles, each present in at least 30 genomes (Methods; Data 2). Coefficients describe log-odds of carriage per tenfold increase in CDS count. The feature-specific relationships provide extended context for the local functional observations. The two sets were constructed differently; their median difference does not establish a general mechanism, and this analysis is not an independent validation of the local results. Shared sequence membership was not assessed.", format(sum(eco$n),big.mark=",",scientific=FALSE,trim=TRUE))
p2 <- "Table A summarizes saved Firth-penalized coefficients (Data 2 G06_firth), checked against all per-feature fits in G12_firth_feature_fits. Ecosystem and host phylum are adjusted in separate models, never jointly. These are Firth results, not ordinary logistic-regression estimates. The difference is descriptive for the fixed feature sets."
p3 <- sprintf("Ordinary separately adjusted models did not yield an estimable complete fixed comparison: %d metabolic and %d anti-defense features failed under ecosystem adjustment, and %d and %d under host-phylum adjustment (G05_adjusted; G11_adjusted_fits). The complete comparison, requiring every fixed feature to satisfy the fitting conditions, was estimable in %d/%d one-representative-per-cluster draws and %d/%d cluster bootstrap replicates (G07_resampling; G17_resample_contrasts; G18_resample_features). These are complete-comparison estimability counts, not positive, effect-replication, significance or detection rates. An inestimable complete comparison does not mean that every feature failed. Results among valid replicates describe only that subset; these checks did not all pass without qualification.",
 adjusted$n_invalid_metab[adjusted$covariate=="ecosystem" & adjusted$definition=="all38"], adjusted$n_invalid_adf[adjusted$covariate=="ecosystem" & adjusted$definition=="all38"],
 adjusted$n_invalid_metab[adjusted$covariate=="host" & adjusted$definition=="all38"], adjusted$n_invalid_adf[adjusted$covariate=="host" & adjusted$definition=="all38"],
 rs$valid_replicates[1],rs$replicates[1],rs$valid_replicates[2],rs$replicates[2])
p4 <- sprintf("Simultaneously excluding the six NAD-related domains changed the ordinary unadjusted metabolic median from %.2f to %.2f (G09_nad_leaveout); this was not a one-at-a-time leave-one-out analysis and does not validate all metabolic annotations.",all285,excl)
p5 <- sprintf("The ecosystem and host-phylum classifications describe the same reference set and must not be added. Host phylum was Unknown for %s/%s reference genomes (G08_strata); these are reference annotation labels, not measured host ranges. Carrier counts provide the scale of support for each feature (G01_feature_fits). For %d profiles, all carriers belong to one gene-sharing cluster (G03_profile_support; Figure 5c); a single cluster is neither a single genome nor a single host and does not establish phylogenetic independence.",
 format(host$n[host$stratum=="Unknown"],big.mark=",",trim=TRUE),format(sum(host$n),big.mark=",",trim=TRUE),sum(support$carrier_clusters==1))
p3b <- sprintf("Why complete comparisons failed: in the one-representative-per-cluster draws every cluster is kept but the drawn representative need not carry a feature, and in the cluster bootstrap carrier clusters can be left out; a feature with zero carriers in a replicate has a constant response and cannot be fitted. In %d of %d failed one-representative draws and %d of %d failed bootstrap replicates at least one fixed feature had zero carriers; the remaining failed bootstrap replicate%s failed only through a fitted-probability warning (G18_resample_features). A single such warning is not taken as proof of complete separation.",
  fail_why$representative[["with_zero"]], fail_why$representative[["failed"]], fail_why$cluster_bootstrap[["with_zero"]], fail_why$cluster_bootstrap[["failed"]],
  if (fail_why$cluster_bootstrap[["warning_only"]] == 1) "" else sprintf(" (%d)", fail_why$cluster_bootstrap[["warning_only"]]))
po1 <- "Each feature's saved fits also include an explicit opportunity diagnostic (G01_feature_fits). With N the CDS count of a reference genome, the main model is logit(p) = a + beta log10(N), and beta (slope) is the change in log-odds per tenfold increase in N. A fixed-opportunity reference model, cloglog(p) = a0 + offset(ln N), i.e. p = 1 - exp(-lambda N) with a feature-specific lambda, assumes a constant per-CDS chance of carriage; it is a simplified reference, not a measured detection model. A free-exponent model, cloglog(p) = a1 + gamma ln N, gives a dimensionless exponent gamma, with gamma = 1 under the fixed-opportunity reference; gamma is neither beta nor residual_slope. null_logit_equivalent projects the expected carrier counts of the fixed-opportunity model, on the original CDS bins, onto the same logit scale as beta; it depends on the CDS distribution and on the feature's frequency and is not a universal constant. residual_slope = beta - null_logit_equivalent is a saved descriptive difference of two slopes, not a residualised refit, a significance test or an index of selection; gamma_se is an ordinary model standard error, and cluster_se belongs to beta only."
po2 <- sprintf("Saved status: the fixed-opportunity model was valid for all %d features; the free-exponent fit was accepted for %d/%d metabolic domains and %d/%d anti-defense profiles, and not for %s, whose gamma and gamma_se are left empty with the saved warnings and an unaccepted estimate kept for audit only. The validity, warnings and convergence of the projection fit itself were not saved, so the projection and residual_slope are reported as saved descriptive values without a validity claim. For example, aca1 has beta = %.4f, a fixed-opportunity projection of %.4f and residual_slope = %.4f, with a separately fitted gamma = %.4f: its positive point estimate lies below this simplified reference, which is not evidence of significance, selection, suppression or lower investment. The medians of the per-feature differences are %.4f for the metabolic domains and %.4f for the anti-defense profiles. Full-precision values are in G01; no new model or test was fitted for this Note.",
  sum(fits$null_valid), gv[["285 metabolic-related Pfam domains"]], 285L, gv[["38 non-NARP anti-defense profiles"]], 38L,
  paste(g_bad, collapse = ", "), aca1$slope, aca1$null_logit_equivalent, aca1$residual_slope, aca1$gamma,
  res_med[["285 metabolic-related Pfam domains"]], res_med[["38 non-NARP anti-defense profiles"]])
pa1 <- sprintf("An earlier aggregation of anti-defense profiles into categories used a direct string join that mis-assigned profiles; its results (G14_aggregation_fits, G15_aggregation_members, the named25 rows of G05, G06, G07 and G17, and the named column of G12) are withdrawn and kept for audit only (status of each object: G19_result_status), and the former legacy contrast and the range built on it are not current results. Figure 5 uses the 38 individual profiles, which do not pass through that join. A saved post hoc repair (G20-G25) mapped profiles through census subtypes to %d categories when the fixed 38 profiles are pooled and %d when all observed profiles are pooled before the carrier threshold; median category slopes were %.4f and %.4f, giving metabolic-minus-category differences of %.4f and %.4f. These corrected definitions change the statistical units and their weights; they are post hoc comparisons of different objects, not replicates of the 38-profile estimate, and no resampling, permutation or significance result is carried over to them. All 19 corrected logit fits and fixed-opportunity fits were valid and %d of 19 free-exponent fits were accepted; the projection was recorded invalid for all 19, so no corrected residual difference is reported.",
  as.integer(nu[["corrected_fixed38_category"]]), as.integer(nu[["corrected_all_profiles_category"]]),
  sc[["corrected_fixed38_category"]], sc[["corrected_all_profiles_category"]], scd[["corrected_fixed38_category"]], scd[["corrected_all_profiles_category"]],
  sum(corr$gamma_valid))
md <- c("# Supplementary Note 4. Global reference analysis: summary and limits", "", p1,"",p2,"", "## Table A. Firth sensitivity summary", "",
        as.character(knitr::kable(display,format="pipe")),"", "All coefficients and differences: log-odds per tenfold increase in CDS count. Values rounded to six decimal places only for display; full precision is retained in the source tables.","",p3,"",p3b,"",p4,"",p5,"",
        "## Saved opportunity diagnostic", "", po1, "", po2, "", "## Category aggregation status", "", pa1, "", "## Data 2 navigation", "", as.character(knitr::kable(nav,format="pipe")),"",
        "The full workbook is [Data 2](Data2_global.xlsx), with a [sheet index](Data2_sheet_index.tsv) and [field dictionary](Data2_field_dictionary.tsv). Every scientific sheet listed in the index remains available, including G04_local_carriage_bins (the local Figure 5a table). No feature, failed fit or unfinished-analysis record was removed.")
writeLines(md,path_target("supplementary-note-4-global.md"),useBytes=TRUE)
html <- c('<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Supplementary Note 4 — Global reference analysis</title><style>body{font:16px/1.65 Arial,sans-serif;color:#23384a;max-width:1080px;margin:auto;padding:40px}h1{font-size:27px}h2{font-size:21px}table{border-collapse:collapse;width:100%;font-size:14px}td,th{border:1px solid #cad5de;padding:10px;text-align:left}th{background:#edf3f6}a{color:#17618b}@media(max-width:650px){body{padding:18px}table{font-size:12px}}@media print{body{padding:0;font-size:10pt}}</style></head><body>',
 '<h1>Supplementary Note 4. Global reference analysis: summary and limits</h1>', paste0('<p>',p1,'</p><p>',p2,'</p><h2>Table A. Firth sensitivity summary</h2>'),
 as.character(knitr::kable(display,format="html")), '<p>Unit: log-odds per tenfold increase in CDS count. Six decimal places are shown; full precision remains in Data 2.</p>',
 paste0('<p>',c(p3,p3b,p4,p5),'</p>'),'<h2>Saved opportunity diagnostic</h2>',paste0('<p>',c(po1,po2),'</p>'),
 '<h2>Category aggregation status</h2>',paste0('<p>',pa1,'</p>'),'<h2>Data 2 navigation</h2>',as.character(knitr::kable(nav,format="html")),
 '<p><a href="Data2_global.xlsx">Data 2 workbook</a> · <a href="Data2_sheet_index.tsv">Sheet index</a> · <a href="Data2_field_dictionary.tsv">Field dictionary</a></p><p>Every scientific sheet listed in the index remains available, including G04_local_carriage_bins (Figure 5a). No feature, failed fit or unfinished-analysis record was removed.</p></body></html>')
writeLines(html,path_target("supplementary-note-4-global.html"),useBytes=TRUE)
rwv_write_tsv(gaps,path_target("global-note-gaps.tsv"))
# F7: the note links to Data 2 files that sit beside it in the publication bundle; in this step report show
# their names as text with that location instead of links that cannot resolve here.
cat(gsub("\\[([^]]+)\\]\\((Data2_[^)]+)\\)", "\\1 (`\\2`, in the publication bundle)", paste(md, collapse = "\n")))
```

```r
check_table <- rwv_checks_finish(checks, path_target("global-note-checks.tsv"))
knitr::kable(check_table[, c("check", "expected", "observed", "pass")])
rwv_write_session_info(path_target("session-info.txt"),c(step=params$name,run_id=step$run_id,mode=step$mode,quarto=rwv_quarto_version()))
```
