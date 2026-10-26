# 330-data2-global
Jinlong Ru, Cunli Pan
2026-10-20

**Updated: 2026-10-20 00:24:39 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 32 output files.
</p>

<p>

Saved assertions: 25 passed, 0 failed, 0 unclassified.
</p>

<p>

Key files:
<a href="data/330-data2-global/Data2_global.xlsx">Data2_global.xlsx</a>
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

## Tasks

Data 2 collects global per-feature models, fixed feature-set mappings,
lineage support, separate adjustment, Firth and resampling
sensitivity/estimability, stratified scales, NAD leave-one-out and
incomplete items. Worksheets record units, provenance and figure
references; TSVs are also exported. Local and global results remain in
separate Data 1 and Data 2 workbooks.

### Task 1: Inputs

### Task 2: Worksheet register

| sheet | field | type | unit_or_code | meaning |
|:---|:---|:---|:---|:---|
| G01_feature_fits | feature | text | identifier | Feature identifier (Pfam domain or anti-defense profile) |
| G01_feature_fits | group | text | codes: 285 metabolic-related Pfam domains, 38 non-NARP anti-defense profiles | Which fixed feature set the row belongs to, by its display name (the metabolic Pfam domains or the non-NARP anti-defense profiles) |
| G01_feature_fits | carriers | numeric | genomes | Reference genomes carrying the feature |
| G01_feature_fits | slope | numeric | log-odds per 10-fold CDS | Coefficient on the log-odds scale per 10-fold increase in CDS count |
| G01_feature_fits | se | numeric | log-odds per 10-fold CDS | Standard error of slope on the same scale |
| G01_feature_fits | cluster_se | numeric | log-odds per 10-fold CDS | Sandwich standard error of slope clustered on the gene-sharing cluster of the carrier genome |
| G01_feature_fits | unit | text | text | Unit of the value in the same row |
| G01_feature_fits | model | text | text | Model formula the coefficient comes from |

|  | sheet | rows | figures | content |
|:---|:---|---:|:---|:---|
| G01_feature_fits | G01_feature_fits | 323 | F5B, Supplementary Note 4 | Coefficient of every feature in the two fixed sets (285 metabolic Pfam domains, 38 non-NARP anti-defense profiles), with the saved opportunity diagnostics of the same fits (fixed-opportunity cloglog model, free exponent gamma, logit projection and their validity/warnings) |
| G02_group_medians | G02_group_medians | 2 | F5B | Median coefficient and sign counts of each fixed set |
| G03_profile_support | G03_profile_support | 38 | F5C, Supplementary Note 4 | Carrier genomes and gene-sharing clusters behind each of the 38 profiles |
| G04_local_carriage_bins | G04_local_carriage_bins | 6 | F5A | The six saved local bins of predicted genes per recovered vOTU (kept here because they are plotted in Figure 5A) |
| G05_adjusted | G05_adjusted | 4 | Supplementary Note 4 | Validity of the separate ecosystem and host-phylum adjustments for the fixed comparison |
| G06_firth | G06_firth | 6 | Supplementary Note 4 | Firth sensitivity fits, unadjusted and under each separate adjustment |
| G07_resampling | G07_resampling | 4 | Supplementary Note 4 | How often the full fixed comparison was estimable in each resampling scheme (summary of G17) |
| G08_strata | G08_strata | 14 | Supplementary Note 4 | Stratum sizes of the ecosystem and host-phylum labels |
| G09_nad_leaveout | G09_nad_leaveout | 9 | Supplementary Note 4 | The six NAD-pathway domains and the metabolic median with and without them |
| G10_gaps | G10_gaps | 4 | Supplementary Note 4 | Global-side analyses that were not done, are incomplete, or were not established in the source project; original S4 wording in the saved records now refers to Supplementary Note 4 |
| G11_adjusted_fits | G11_adjusted_fits | 646 | Supplementary Note 4 | Every per-feature fit of the two separate adjustments, including the ones that were not estimable |
| G12_firth_feature_fits | G12_firth_feature_fits | 969 | Supplementary Note 4 | Every per-feature Firth-penalised fit behind the medians of Supplementary Note 4 |
| G13_stratum_fits | G13_stratum_fits | 3230 | Supplementary Note 4 | Per-feature fits within each ecosystem and host-phylum stratum |
| G14_aggregation_fits | G14_aggregation_fits | 43 | Supplementary Note 4 | HISTORICAL, withdrawn, audit only: fits of aggregation units formed by the old direct category join (21 fixed38 units; 22 all-profile units = legacy_mixed). Corrected post hoc categories are in G21; status in G19 |
| G15_aggregation_members | G15_aggregation_members | 104 | Supplementary Note 4 | HISTORICAL, withdrawn, audit only: profile-to-unit membership under the old direct join (equals G22 old_unit). Corrected mapping in G22 and G24 |
| G16_firth_run | G16_firth_run | 6 | Supplementary Note 4 | Run parameters of the Firth sensitivity fits |
| G17_resample_contrasts | G17_resample_contrasts | 500 | Supplementary Note 4 | Every resampling replicate: whether the full fixed comparison was estimable and, when it was, the METAB-minus-ADF median difference |
| G18_resample_features | G18_resample_features | 80750 | Supplementary Note 4 | Per-replicate, per-feature diagnostics behind G17: which feature failed in which replicate, with its carrier count and warning text |
| G19_result_status | G19_result_status | 13 | Supplementary Note 4 | Status of the historical, withdrawn and post hoc corrected global aggregation results and of the current fixed baseline, by sheet and rows |
| G20_repair_scenarios | G20_repair_scenarios | 5 | Supplementary Note 4 | Saved scenario summary of the post hoc repair of the category join: fixed 285 and 38 baselines, two corrected category definitions (9 and 10 units), and the withdrawn legacy_mixed (22) |
| G21_repair_feature_fits | G21_repair_feature_fits | 364 | Supplementary Note 4 | All 364 saved fits of the repair run, with logit, fixed-opportunity, free-exponent and projection fields, validity flags and warnings as saved |
| G22_repair_members | G22_repair_members | 104 | Supplementary Note 4 | The 104 observed anti-defense profiles: corrected category, historical old-join unit and whether the mapping changed |
| G23_repair_scenario_members | G23_repair_scenario_members | 284 | Supplementary Note 4 | Profile-to-unit membership in profile38, legacy_mixed and the two corrected category scenarios |
| G24_repair_mapping | G24_repair_mapping | 356 | Supplementary Note 4 | Census expansion of 356 profiles to subtypes and categories used by the repair |
| G25_repair_eligibility | G25_repair_eligibility | 12 | Supplementary Note 4 | All categories compared between the two corrected scenarios, including unchanged membership and eligibility |

### Task 3: Write the workbook and TSVs

| item | status | note |
|:---|:---|:---|
| Data2_global.xlsx | written | 25 scientific sheets plus INDEX and FIELDS, written with writexl 1.5.4 |

### Task 4: Record checks and the run

| check | expected | observed | pass |
|:---|:---|:---|:---|
| no empty sheet | TRUE | TRUE | TRUE |
| sheet names unique and \<= 31 characters | TRUE, TRUE | TRUE, TRUE | TRUE |
| definitions.tsv:global_metab | 285 | 285 | TRUE |
| definitions.tsv:global_adf | 38 | 38 | TRUE |
| definitions.tsv:global_adf | 38 | 38 | TRUE |
| six local bins retained | 6 | 6 | TRUE |
| numeric columns are numeric after conversion (feature slopes) | TRUE | TRUE | TRUE |
| per-feature fits of the two separate adjustments cover both sets twice | 646 | 646 | TRUE |
| aggregation members cover the fixed 38 | 38 | 38 | TRUE |
| resampling detail sheets: 500 replicate rows and 80,750 feature rows | 500, 80750 | 500, 80750 | TRUE |
| valid replicates rebuilt from the detail equal the G07 summary | 76, 10, 76, 10 | 76, 10, 76, 10 | TRUE |
| Firth slope and raw_slope are the same coefficient wherever the fit is valid | 0 | 0 | TRUE |
| G01 keeps the 8 original columns first and adds the 13 opportunity fields | 8, 21 | 8, 21 | TRUE |
| G01 gamma valid 320/323 and null_valid 323/323 | 320, 323 | 320, 323 | TRUE |
| G01 residual identity on the delivered values (\|diff\| \<= 1e-12) | TRUE | TRUE | TRUE |
| repair fits: 364 rows, 19 corrected | 364, 19 | 364, 19 | TRUE |
| status index refers only to sheets of this workbook | TRUE | TRUE | TRUE |
| field dictionary agrees with the delivered values (missing rules, ranges, code sets) |  |  | TRUE |
| every delivered field has exactly one dictionary row | 215 | 215 | TRUE |
| no duplicated sheet/field pair in the dictionary | FALSE | FALSE | TRUE |
| every field of the model, resampling and construct sheets is curated | 0 | 0 | TRUE |
| every numeric field is curated and states a unit or code | 0 | 0 | TRUE |
| workbook written | written | written | TRUE |
| workbook sheets read back equal INDEX, FIELDS plus every sheet | INDEX, FIELDS, G01_feature_fits, G02_group_medians, G03_profile_support, … (27 values) | INDEX, FIELDS, G01_feature_fits, G02_group_medians, G03_profile_support, … (27 values) | TRUE |
| feature-fit sheet read back: rows and numeric slope column | 323, TRUE | 323, TRUE | TRUE |

| file                            |   bytes | sha256           |
|:--------------------------------|--------:|:-----------------|
| Data2_global.xlsx               | 3429594 | d62b137015ba1b01 |
| data2-index.tsv                 |    8048 | ba39909372d6f986 |
| data2-README.md                 |    4803 | b83788e0548964a3 |
| data2-workbook-status.tsv       |     114 | 6144426261f4ba8b |
| data2-checks.tsv                |    2163 | 4851700fd82d2bbb |
| session-info.txt                |   13695 | d5a00bd487a7c380 |
| G01_feature_fits.tsv            |  109191 | 446890b70b4fc6fa |
| G02_group_medians.tsv           |     322 | f8c64348d4520b64 |
| G03_profile_support.tsv         |    4456 | c60d8ad40c1713c5 |
| G04_local_carriage_bins.tsv     |     724 | e873fd65413a8687 |
| G05_adjusted.tsv                |     666 | 02b9f1d279aa9da2 |
| G06_firth.tsv                   |    1150 | 7077b81bc16a2f7f |
| G07_resampling.tsv              |    1171 | c359b8e5970eae9d |
| G08_strata.tsv                  |     356 | 015f496639fcd563 |
| G09_nad_leaveout.tsv            |    2124 | cd39bc9048349c13 |
| G10_gaps.tsv                    |    1136 | cba6c590b7f7cda5 |
| G11_adjusted_fits.tsv           |   44075 | 9bc1415d0efc2723 |
| G12_firth_feature_fits.tsv      |  107510 | d60409f08b3d5f2e |
| G13_stratum_fits.tsv            |  225001 | 115cab9a96fd461f |
| G14_aggregation_fits.tsv        |    2576 | 39843747667add53 |
| G15_aggregation_members.tsv     |    3214 | 723580a50d201493 |
| G16_firth_run.tsv               |     225 | eced2afd5b78f081 |
| G17_resample_contrasts.tsv      |   22649 | ea99869b971a3363 |
| G18_resample_features.tsv       | 4767454 | db512a034f3e5eef |
| G19_result_status.tsv           |    3842 | de0e7b225c4eb343 |
| G20_repair_scenarios.tsv        |    1618 | 5b61f3ed0d1d6982 |
| G21_repair_feature_fits.tsv     |   69043 | b427b284ff6e20e4 |
| G22_repair_members.tsv          |    7160 | 9cbe503f396c8478 |
| G23_repair_scenario_members.tsv |   13325 | d77965fcad4fb30c |
| G24_repair_mapping.tsv          |   58382 | 0e1b4905cbfb7393 |
| G25_repair_eligibility.tsv      |    2052 | d702b2fca0c84382 |
| data2-field-dictionary.tsv      |   68722 | 724fab78bb51ca49 |

Outputs recorded in step-record.json

</details>

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/330-data2-global/Data2_global.xlsx">Data2_global.xlsx</a> (3349.2 KB)</li>
<li><a href="data/330-data2-global/data2-index.tsv">data2-index.tsv</a> (7.9 KB)</li>
<li><a href="data/330-data2-global/data2-README.md">data2-README.md</a> (4.7 KB)</li>
<li><a href="data/330-data2-global/data2-workbook-status.tsv">data2-workbook-status.tsv</a> (0.1 KB)</li>
<li><a href="data/330-data2-global/data2-checks.tsv">data2-checks.tsv</a> (2.1 KB)</li>
<li><a href="data/330-data2-global/session-info.txt">session-info.txt</a> (13.4 KB)</li>
<li><a href="data/330-data2-global/G01_feature_fits.tsv">G01_feature_fits.tsv</a> (106.6 KB)</li>
<li><a href="data/330-data2-global/G02_group_medians.tsv">G02_group_medians.tsv</a> (0.3 KB)</li>
<li><a href="data/330-data2-global/G03_profile_support.tsv">G03_profile_support.tsv</a> (4.4 KB)</li>
<li><a href="data/330-data2-global/G04_local_carriage_bins.tsv">G04_local_carriage_bins.tsv</a> (0.7 KB)</li>
<li><a href="data/330-data2-global/G05_adjusted.tsv">G05_adjusted.tsv</a> (0.7 KB)</li>
<li><a href="data/330-data2-global/G06_firth.tsv">G06_firth.tsv</a> (1.1 KB)</li>
<li><a href="data/330-data2-global/G07_resampling.tsv">G07_resampling.tsv</a> (1.1 KB)</li>
<li><a href="data/330-data2-global/G08_strata.tsv">G08_strata.tsv</a> (0.3 KB)</li>
<li><a href="data/330-data2-global/G09_nad_leaveout.tsv">G09_nad_leaveout.tsv</a> (2.1 KB)</li>
<li><a href="data/330-data2-global/G10_gaps.tsv">G10_gaps.tsv</a> (1.1 KB)</li>
<li><a href="data/330-data2-global/G11_adjusted_fits.tsv">G11_adjusted_fits.tsv</a> (43 KB)</li>
<li><a href="data/330-data2-global/G12_firth_feature_fits.tsv">G12_firth_feature_fits.tsv</a> (105 KB)</li>
<li><a href="data/330-data2-global/G13_stratum_fits.tsv">G13_stratum_fits.tsv</a> (219.7 KB)</li>
<li><a href="data/330-data2-global/G14_aggregation_fits.tsv">G14_aggregation_fits.tsv</a> (2.5 KB)</li>
<li><a href="data/330-data2-global/G15_aggregation_members.tsv">G15_aggregation_members.tsv</a> (3.1 KB)</li>
<li><a href="data/330-data2-global/G16_firth_run.tsv">G16_firth_run.tsv</a> (0.2 KB)</li>
<li><a href="data/330-data2-global/G17_resample_contrasts.tsv">G17_resample_contrasts.tsv</a> (22.1 KB)</li>
<li><a href="data/330-data2-global/G18_resample_features.tsv">G18_resample_features.tsv</a> (4655.7 KB)</li>
<li><a href="data/330-data2-global/G19_result_status.tsv">G19_result_status.tsv</a> (3.8 KB)</li>
<li><a href="data/330-data2-global/G20_repair_scenarios.tsv">G20_repair_scenarios.tsv</a> (1.6 KB)</li>
<li><a href="data/330-data2-global/G21_repair_feature_fits.tsv">G21_repair_feature_fits.tsv</a> (67.4 KB)</li>
<li><a href="data/330-data2-global/G22_repair_members.tsv">G22_repair_members.tsv</a> (7 KB)</li>
<li><a href="data/330-data2-global/G23_repair_scenario_members.tsv">G23_repair_scenario_members.tsv</a> (13 KB)</li>
<li><a href="data/330-data2-global/G24_repair_mapping.tsv">G24_repair_mapping.tsv</a> (57 KB)</li>
<li><a href="data/330-data2-global/G25_repair_eligibility.tsv">G25_repair_eligibility.tsv</a> (2 KB)</li>
<li><a href="data/330-data2-global/data2-field-dictionary.tsv">data2-field-dictionary.tsv</a> (67.1 KB)</li>
</ul>

</details>
