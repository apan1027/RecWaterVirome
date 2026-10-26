# 240-sfig4-global-sensitivity
Jinlong Ru, Cunli Pan
2026-10-20

**Updated: 2026-10-20 00:24:15 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 7 output files.
</p>

<p>

Saved assertions: 40 passed, 0 failed, 0 unclassified.
</p>

<p>

Key files:
<a href="data/240-sfig4-global-sensitivity/supplementary-note-4-global.md">supplementary-note-4-global.md</a>
</p>

<p>

No runtime warnings were captured after report initialization.
</p>

</section>

<!-- RWV_REPORT_SUMMARY_END -->

<details class="rwv-analysis-details">

<summary>

Analysis steps, methods and full verification
</summary>

## Purpose

Supplementary Note 4 replaces the former six-panel S4. The technical
step identifier is retained for provenance. This step reads saved global
results; it does not fit models.

# Supplementary Note 4. Global reference analysis: summary and limits

The fixed reference set comprises 77,951 genomes, with separate
per-feature models for 285 metabolic-related Pfam domains and 38
non-NARP anti-defense profiles, each present in at least 30 genomes
(Methods; Data 2). Coefficients describe log-odds of carriage per
tenfold increase in CDS count. The feature-specific relationships
provide extended context for the local functional observations. The two
sets were constructed differently; their median difference does not
establish a general mechanism, and this analysis is not an independent
validation of the local results. Shared sequence membership was not
assessed.

Table A summarizes saved Firth-penalized coefficients (Data 2
G06_firth), checked against all per-feature fits in
G12_firth_feature_fits. Ecosystem and host phylum are adjusted in
separate models, never jointly. These are Firth results, not ordinary
logistic-regression estimates. The difference is descriptive for the
fixed feature sets.

## Table A. Firth sensitivity summary

| Model | Metabolic median (285 domains) | Anti-defense median (38 profiles) | Median difference (metabolic minus anti-defense) |
|:---|:---|:---|:---|
| Unadjusted Firth | 4.056505 | 1.360913 | 2.695592 |
| Firth, ecosystem adjusted separately | 4.111189 | 1.208445 | 2.902745 |
| Firth, host phylum adjusted separately | 3.970157 | 1.446066 | 2.524090 |

All coefficients and differences: log-odds per tenfold increase in CDS
count. Values rounded to six decimal places only for display; full
precision is retained in the source tables.

Ordinary separately adjusted models did not yield an estimable complete
fixed comparison: 106 metabolic and 11 anti-defense features failed
under ecosystem adjustment, and 58 and 18 under host-phylum adjustment
(G05_adjusted; G11_adjusted_fits). The complete comparison, requiring
every fixed feature to satisfy the fitting conditions, was estimable in
10/50 one-representative-per-cluster draws and 76/200 cluster bootstrap
replicates (G07_resampling; G17_resample_contrasts;
G18_resample_features). These are complete-comparison estimability
counts, not positive, effect-replication, significance or detection
rates. An inestimable complete comparison does not mean that every
feature failed. Results among valid replicates describe only that
subset; these checks did not all pass without qualification.

Why complete comparisons failed: in the one-representative-per-cluster
draws every cluster is kept but the drawn representative need not carry
a feature, and in the cluster bootstrap carrier clusters can be left
out; a feature with zero carriers in a replicate has a constant response
and cannot be fitted. In 40 of 40 failed one-representative draws and
123 of 124 failed bootstrap replicates at least one fixed feature had
zero carriers; the remaining failed bootstrap replicate failed only
through a fitted-probability warning (G18_resample_features). A single
such warning is not taken as proof of complete separation.

Simultaneously excluding the six NAD-related domains changed the
ordinary unadjusted metabolic median from 4.05 to 3.98
(G09_nad_leaveout); this was not a one-at-a-time leave-one-out analysis
and does not validate all metabolic annotations.

The ecosystem and host-phylum classifications describe the same
reference set and must not be added. Host phylum was Unknown for
38,815/77,951 reference genomes (G08_strata); these are reference
annotation labels, not measured host ranges. Carrier counts provide the
scale of support for each feature (G01_feature_fits). For 4 profiles,
all carriers belong to one gene-sharing cluster (G03_profile_support;
Figure 5c); a single cluster is neither a single genome nor a single
host and does not establish phylogenetic independence.

## Saved opportunity diagnostic

Each feature’s saved fits also include an explicit opportunity
diagnostic (G01_feature_fits). With N the CDS count of a reference
genome, the main model is logit(p) = a + beta log10(N), and beta (slope)
is the change in log-odds per tenfold increase in N. A fixed-opportunity
reference model, cloglog(p) = a0 + offset(ln N), i.e. p = 1 -
exp(-lambda N) with a feature-specific lambda, assumes a constant
per-CDS chance of carriage; it is a simplified reference, not a measured
detection model. A free-exponent model, cloglog(p) = a1 + gamma ln N,
gives a dimensionless exponent gamma, with gamma = 1 under the
fixed-opportunity reference; gamma is neither beta nor residual_slope.
null_logit_equivalent projects the expected carrier counts of the
fixed-opportunity model, on the original CDS bins, onto the same logit
scale as beta; it depends on the CDS distribution and on the feature’s
frequency and is not a universal constant. residual_slope = beta -
null_logit_equivalent is a saved descriptive difference of two slopes,
not a residualised refit, a significance test or an index of selection;
gamma_se is an ordinary model standard error, and cluster_se belongs to
beta only.

Saved status: the fixed-opportunity model was valid for all 323
features; the free-exponent fit was accepted for 285/285 metabolic
domains and 35/38 anti-defense profiles, and not for gp4.5, ocr, samase,
whose gamma and gamma_se are left empty with the saved warnings and an
unaccepted estimate kept for audit only. The validity, warnings and
convergence of the projection fit itself were not saved, so the
projection and residual_slope are reported as saved descriptive values
without a validity claim. For example, aca1 has beta = 0.6312, a
fixed-opportunity projection of 2.3034 and residual_slope = -1.6722,
with a separately fitted gamma = 0.2740: its positive point estimate
lies below this simplified reference, which is not evidence of
significance, selection, suppression or lower investment. The medians of
the per-feature differences are 1.7444 for the metabolic domains and
-0.9735 for the anti-defense profiles. Full-precision values are in G01;
no new model or test was fitted for this Note.

## Category aggregation status

An earlier aggregation of anti-defense profiles into categories used a
direct string join that mis-assigned profiles; its results
(G14_aggregation_fits, G15_aggregation_members, the named25 rows of G05,
G06, G07 and G17, and the named column of G12) are withdrawn and kept
for audit only (status of each object: G19_result_status), and the
former legacy contrast and the range built on it are not current
results. Figure 5 uses the 38 individual profiles, which do not pass
through that join. A saved post hoc repair (G20-G25) mapped profiles
through census subtypes to 9 categories when the fixed 38 profiles are
pooled and 10 when all observed profiles are pooled before the carrier
threshold; median category slopes were 2.0865 and 2.0481, giving
metabolic-minus-category differences of 1.9619 and 2.0002. These
corrected definitions change the statistical units and their weights;
they are post hoc comparisons of different objects, not replicates of
the 38-profile estimate, and no resampling, permutation or significance
result is carried over to them. All 19 corrected logit fits and
fixed-opportunity fits were valid and 18 of 19 free-exponent fits were
accepted; the projection was recorded invalid for all 19, so no
corrected residual difference is reported.

## Data 2 navigation

| sheet | purpose |
|:---|:---|
| G01_feature_fits; G02_group_medians | Unadjusted per-feature carriers, slope, se and cluster_se, with the saved opportunity diagnostics of the same fits; fixed-set summaries (Figure 5b) |
| G03_profile_support | Per-profile carrier genomes, carrier_clusters and single_carrier_cluster flag (Figure 5c) |
| G05_adjusted; G11_adjusted_fits | Ordinary separate adjustments: summary validity, invalid-feature counts and all per-feature fits/warnings |
| G06_firth; G12_firth_feature_fits; G16_firth_run | Firth summary, all penalized per-feature coefficients and saved fitting parameters |
| G07_resampling; G17_resample_contrasts; G18_resample_features | Complete-comparison summaries, every replicate including failures, and per-feature carrier counts/validity/warnings |
| G08_strata | Ecosystem and host-phylum counts for the same reference genomes |
| G09_nad_leaveout | Six NAD-domain identities, simultaneous exclusion and saved medians |
| G10_gaps | Unfinished or unestablished analyses and interpretation limits; preserved source-era S4 wording now refers to Note 4 |
| G13_stratum_fits | Within-stratum results |
| G19_result_status | Status of every historical, withdrawn and post hoc corrected aggregation result and of the current fixed baseline |
| G14_aggregation_fits; G15_aggregation_members | Historical old-join aggregation fits and membership, withdrawn and kept for audit only |
| G20_repair_scenarios; G21_repair_feature_fits; G22_repair_members; G23_repair_scenario_members; G24_repair_mapping; G25_repair_eligibility | Saved post hoc repair of the category join: scenario summary, all fits with validity and warnings, corrected memberships, census mapping and eligibility changes |

The full workbook is Data 2 (`Data2_global.xlsx`, in the publication
bundle), with a sheet index (`Data2_sheet_index.tsv`, in the publication
bundle) and field dictionary (`Data2_field_dictionary.tsv`, in the
publication bundle). Every scientific sheet listed in the index remains
available, including G04_local_carriage_bins (the local Figure 5a
table). No feature, failed fit or unfinished-analysis record was
removed.

| check | expected | observed | pass |
|:---|:---|:---|:---|
| definitions.tsv:global_metab | 285 | 285 | TRUE |
| definitions.tsv:global_adf | 38 | 38 | TRUE |
| every feature has \>= 30 carriers | TRUE | TRUE | TRUE |
| definitions.tsv:global_single_cluster | 4 | 4 | TRUE |
| ordinary separate adjusted full comparisons not estimable | FALSE, FALSE, FALSE, FALSE | FALSE, FALSE, FALSE, FALSE | TRUE |
| three separate Firth settings | 3 | 3 | TRUE |
| Firth anti-defense medians match saved regression anchors | 1.360913, 1.208445, 1.446066 | 1.360913, 1.208445, 1.446066 | TRUE |
| Firth fixed sets unadjusted | 285, 38 | 285, 38 | TRUE |
| Firth valid feature fits unadjusted | TRUE | TRUE | TRUE |
| Firth medians and difference from features unadjusted | 4.056505459, 1.360913113, 2.695592346 | 4.056505459, 1.360913113, 2.695592346 | TRUE |
| Firth fixed sets ecosystem | 285, 38 | 285, 38 | TRUE |
| Firth valid feature fits ecosystem | TRUE | TRUE | TRUE |
| Firth medians and difference from features ecosystem | 4.111189093, 1.208444546, 2.902744547 | 4.111189093, 1.208444546, 2.902744547 | TRUE |
| Firth fixed sets host | 285, 38 | 285, 38 | TRUE |
| Firth valid feature fits host | TRUE | TRUE | TRUE |
| Firth medians and difference from features host | 3.970156912, 1.446066451, 2.524090461 | 3.970156912, 1.446066451, 2.524090461 | TRUE |
| complete-comparison estimability counts | 10, 50, 76, 200 | 10, 50, 76, 200 | TRUE |
| all fixed features in every replicate representative | TRUE | TRUE | TRUE |
| feature validity reconstructs each full comparison representative | FALSE, FALSE, FALSE, FALSE, FALSE, … (50 values) | FALSE, FALSE, FALSE, FALSE, FALSE, … (50 values) | TRUE |
| replicate summary from full records representative | 10, 50 | 10, 50 | TRUE |
| all fixed features in every replicate cluster_bootstrap | TRUE | TRUE | TRUE |
| feature validity reconstructs each full comparison cluster_bootstrap | FALSE, TRUE, FALSE, FALSE, FALSE, … (200 values) | FALSE, TRUE, FALSE, FALSE, FALSE, … (200 values) | TRUE |
| replicate summary from full records cluster_bootstrap | 76, 200 | 76, 200 | TRUE |
| six NAD domains simultaneously excluded | 6 | 6 | TRUE |
| NAD exclusion medians | 4.048350, 3.982495 | 4.048350, 3.982495 | TRUE |
| NAD shift equals difference | -0.065855 | -0.065855 | TRUE |
| all six domains above original median | TRUE | TRUE | TRUE |
| simultaneous NAD exclusion reconstructed from all feature coefficients | 4.048350, 3.982495 | 4.048349798, 3.982494694 | TRUE |
| two classifications of same reference set | 77951, 77951 | 77951, 77951 | TRUE |
| definitions.tsv:global_references | 77951 | 77951 | TRUE |
| host Unknown count | 38815 | 38815 | TRUE |
| opportunity: null valid 323; gamma valid 285 METAB and 35 ADF | 323, 285, 35 | 323, 285, 35 | TRUE |
| gamma not accepted: gp4.5, ocr, samase | gp4.5, ocr, samase | gp4.5, ocr, samase | TRUE |
| aca1 slope, projection, residual, gamma | 0.6312084395, 2.3034134327, -1.6722049932, 0.2740240272 | 0.6312084395, 2.3034134327, -1.6722049932, 0.2740240272 | TRUE |
| per-set medians of the saved residual differences (summary.json values) | 1.7443563398, -0.9735440504 | 1.7443563398, -0.9735440504 | TRUE |
| corrected: 19 fits, null valid 19, gamma valid 18, projection valid 0 | 19, 19, 18, 0 | 19, 19, 18, 0 | TRUE |
| corrected category scenarios have 9 and 10 units | 9, 10 | 9, 10 | TRUE |
| status index labels the old join withdrawn and the corrected units post hoc | TRUE, TRUE | TRUE, TRUE | TRUE |
| failed replicates: representative 40 (all with a zero-carrier feature) | 40, 40, 0 | 40, 40, 0 | TRUE |
| failed replicates: cluster bootstrap 124 (123 with a zero-carrier feature, 1 warning only) | 124, 123, 1 | 124, 123, 1 | TRUE |

| file                                     | bytes | sha256           |
|:-----------------------------------------|------:|:-----------------|
| supplementary-note-4-global.md           | 12394 | e23da02042c5ad2e |
| supplementary-note-4-global.html         | 11934 | 13e4036d730fd110 |
| supplementary-note-4-firth-summary.tsv   |   494 | 3b90725217dd43a4 |
| supplementary-note-4-data-navigation.tsv |  1647 | fe131e41fafc935c |
| global-note-gaps.tsv                     |  1136 | cba6c590b7f7cda5 |
| global-note-checks.tsv                   |  3617 | 13d7590a1c757dda |
| session-info.txt                         | 13707 | 2f13978141cfe92d |

Outputs recorded in step-record.json

</details>

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/240-sfig4-global-sensitivity/supplementary-note-4-global.md">supplementary-note-4-global.md</a> (12.1 KB)</li>
<li><a href="data/240-sfig4-global-sensitivity/supplementary-note-4-global.html">supplementary-note-4-global.html</a> (11.7 KB)</li>
<li><a href="data/240-sfig4-global-sensitivity/supplementary-note-4-firth-summary.tsv">supplementary-note-4-firth-summary.tsv</a> (0.5 KB)</li>
<li><a href="data/240-sfig4-global-sensitivity/supplementary-note-4-data-navigation.tsv">supplementary-note-4-data-navigation.tsv</a> (1.6 KB)</li>
<li><a href="data/240-sfig4-global-sensitivity/global-note-gaps.tsv">global-note-gaps.tsv</a> (1.1 KB)</li>
<li><a href="data/240-sfig4-global-sensitivity/global-note-checks.tsv">global-note-checks.tsv</a> (3.5 KB)</li>
<li><a href="data/240-sfig4-global-sensitivity/session-info.txt">session-info.txt</a> (13.4 KB)</li>
</ul>

</details>
