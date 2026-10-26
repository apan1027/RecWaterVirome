# 050-global-inputs
Jinlong Ru, Cunli Pan
2026-10-20

**Updated: 2026-10-20 00:22:38 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 27 output files.
</p>

<p>

Saved assertions: 89 passed, 0 failed, 0 unclassified.
</p>

<p>

Key files:
<a href="data/050-global-inputs/global_feature_fits.tsv">global_feature_fits.tsv</a>
·
<a href="data/050-global-inputs/global_group_medians.tsv">global_group_medians.tsv</a>
·
<a href="data/050-global-inputs/global_profile_support.tsv">global_profile_support.tsv</a>
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

Read, validate and prepare archived per-feature coefficients for the
fixed 285 metabolic Pfam domains and 38 non-NARP anti-defense profiles,
lineage support, adjustment/resampling/Firth sensitivity and the six
local carriage bins. Outputs support Figure 5, Supplementary Note 4 and
Data 2; coefficients and tests are not recalculated.

### Task 1: Inputs

### Task 2: Fixed feature sets and per-feature coefficients

Each coefficient is the log-odds change per tenfold increase in CDS
count (binary presence ~ log10(CDS), logit link, one model per feature).
Retain all points, negative values and the zero reference without
selection by direction or p value.

| group | n_features | median_slope | n_positive | n_negative | note |
|:---|---:|---:|---:|---:|:---|
| 38 non-NARP anti-defense profiles | 38 | 1.3569 | 26 | 12 | median describes the fixed set only; it is not a test between the sets |
| 285 metabolic-related Pfam domains | 285 | 4.0483 | 269 | 16 | median describes the fixed set only; it is not a test between the sets |

### Task 3: Lineage support for 38 profiles

### Task 4: Six local carriage bins

The horizontal axis is predicted gene count on recovered sequences. The
numerator is the DefenseFinder anti-defense OR filtered dbAPIS union.
Historical confidence intervals and fits are not used.

| label   |    n |   k | percent |
|:--------|-----:|----:|--------:|
| 3-19    | 1077 |  76 |    7.06 |
| 20-39   | 1232 | 277 |   22.48 |
| 40-59   |  411 | 180 |   43.80 |
| 60-79   |  237 | 117 |   49.37 |
| 80-119  |   85 |  55 |   64.71 |
| 120-299 |   18 |  17 |   94.44 |

### Task 5: Supplementary Note 4 sensitivity, failures and non-estimable records

| mode              | definition | valid_replicates | replicates | median |
|:------------------|:-----------|-----------------:|-----------:|-------:|
| cluster_bootstrap | all38      |               76 |        200 |  2.530 |
| representative    | all38      |               10 |         50 |  2.715 |
| cluster_bootstrap | named25    |               76 |        200 |  1.247 |
| representative    | named25    |               10 |         50 |  1.262 |

### Task 5b: Historical joins, withdrawal status and completed repair records

Historical G14/G15 and the named25 subset used direct string joins in
source-project j42-run.py:110 and j44-run.py:133. The completed
2026-09-26 repair record under
dev/380-global-repair-preflight-2026-09-26 is registered and passed
through unchanged. Repair/verification scripts are not executed and
models are not refitted. Historical tables are retained with separate
status records. The Figure 5 per-feature 285/38 models do not use that
join.

| sheet | rows_covered | n_rows | status |
|:---|:---|---:|:---|
| G01_feature_fits | all 323 rows: 285 METAB + 38 ADF_profile | 323 | DESCRIPTIVE_FIXED_BASELINE |
| G01_feature_fits | opportunity diagnostic columns (null_valid … gamma_warnings) | 323 | SAVED_DESCRIPTIVE_DIAGNOSTIC |
| G05_adjusted | definition == named25 | 2 | WITHDRAWN_HISTORICAL_JOIN_AUDIT_ONLY |
| G06_firth | definition == named25 | 3 | WITHDRAWN_HISTORICAL_JOIN_AUDIT_ONLY |
| G07_resampling | definition == named25 | 2 | WITHDRAWN_HISTORICAL_JOIN_AUDIT_ONLY |
| G17_resample_contrasts | definition == named25 | 250 | WITHDRAWN_HISTORICAL_JOIN_AUDIT_ONLY |
| G12_firth_feature_fits | column named (TRUE marks the 25 old-join-named profiles) | 969 | WITHDRAWN_HISTORICAL_JOIN_AUDIT_ONLY |
| G14_aggregation_fits | mode == fixed38 (21 old-join units) | 21 | WITHDRAWN_HISTORICAL_JOIN_AUDIT_ONLY |
| G14_aggregation_fits | mode == all_profiles_then_threshold (22 units = legacy_mixed) | 22 | WITHDRAWN_BUG_AFFECTED_AUDIT_ONLY |
| G15_aggregation_members | all 104 profiles (old direct-join unit) | 104 | WITHDRAWN_HISTORICAL_JOIN_AUDIT_ONLY |
| G21_repair_feature_fits | scenario starts with corrected\_ (19 fits) | 19 | POST_HOC_CORRECTED_DEFINITION |
| G21_repair_feature_fits | scenario == legacy_mixed (22 fits) | 22 | WITHDRAWN_BUG_AFFECTED_AUDIT_ONLY |
| G21_repair_feature_fits | scenario in METAB285, profile38 (323 fits) | 323 | DESCRIPTIVE_FIXED_BASELINE |

### Task 6: Record checks and the run

| check | expected | observed | pass |
|:---|:---|:---|:---|
| global artifact manifest hash of full_feature_fits.tsv | 5f20bfec6711245be1a7c4456e8d872b9af2c43442bfe0ed7ce1745d000b9fab | 5f20bfec6711245be1a7c4456e8d872b9af2c43442bfe0ed7ce1745d000b9fab | TRUE |
| global artifact manifest hash of fixed_universe.tsv | 773f76326254026e80fd0ce3b9e99ec434945fa2f3ecb50591aa1c5882ad2085 | 773f76326254026e80fd0ce3b9e99ec434945fa2f3ecb50591aa1c5882ad2085 | TRUE |
| global artifact manifest hash of profile_cluster_support.tsv | b2a1fee98990f61e2ad29491c3ad2239d421415b5c0c11ebcd7fc535a2d3c3e1 | b2a1fee98990f61e2ad29491c3ad2239d421415b5c0c11ebcd7fc535a2d3c3e1 | TRUE |
| global artifact manifest hash of summary.json | db2a473cac05b482f17d32758432b9da058d83c641d6ea3cdaf313000356185e | db2a473cac05b482f17d32758432b9da058d83c641d6ea3cdaf313000356185e | TRUE |
| global artifact manifest hash of adjusted_fits.tsv | 8eca827a565c0ba489bdbb18ba500d22fddcef6d767d98d66c997063fc6fc180 | 8eca827a565c0ba489bdbb18ba500d22fddcef6d767d98d66c997063fc6fc180 | TRUE |
| global artifact manifest hash of adjusted_contrasts.tsv | 65fee6b741237594407e3b64911ee3de2de5710c94c25a556e9ddd832b176d9d | 65fee6b741237594407e3b64911ee3de2de5710c94c25a556e9ddd832b176d9d | TRUE |
| global artifact manifest hash of firth_contrasts.tsv | 514db13fdefd72a6f196261609d29564c3e0f4809d930c331aa03c5968ef16d3 | 514db13fdefd72a6f196261609d29564c3e0f4809d930c331aa03c5968ef16d3 | TRUE |
| global artifact manifest hash of firth_feature_fits.tsv | 47002e493add33055884d7853dcc3bd211bd656e1d63d910ee99044879791e14 | 47002e493add33055884d7853dcc3bd211bd656e1d63d910ee99044879791e14 | TRUE |
| global artifact manifest hash of firth_run.json | eb411fa0e23957b1eabcfedf93018b66c5218439f65d946e16149a18957fc75b | eb411fa0e23957b1eabcfedf93018b66c5218439f65d946e16149a18957fc75b | TRUE |
| global artifact manifest hash of resample_contrasts.tsv | d0ef627940e0a0a54f4b9bca4a2e3a8215bfe614229f39b5ce533e7a56444eda | d0ef627940e0a0a54f4b9bca4a2e3a8215bfe614229f39b5ce533e7a56444eda | TRUE |
| global artifact manifest hash of resample_features.tsv | 5620f6ddb051b1d6ee90831af3c2e02d222158b67899bdd7b3cbc3cb5a36e1e0 | 5620f6ddb051b1d6ee90831af3c2e02d222158b67899bdd7b3cbc3cb5a36e1e0 | TRUE |
| global artifact manifest hash of stratum_population.tsv | 015f496639fcd5637ea5d1ebcd212c4e140ed15df6409435d4332f694b003a23 | 015f496639fcd5637ea5d1ebcd212c4e140ed15df6409435d4332f694b003a23 | TRUE |
| global artifact manifest hash of stratum_fits.tsv | 826c6e52c9ad8f6f264e8442ac5322e225699dedaa809a2f9a2738a05b73c15c | 826c6e52c9ad8f6f264e8442ac5322e225699dedaa809a2f9a2738a05b73c15c | TRUE |
| global artifact manifest hash of aggregation_fits.tsv | bbb46c66295c4cf2842fec6cb55875e82d492a5c236cce7c3b2580b186da1935 | bbb46c66295c4cf2842fec6cb55875e82d492a5c236cce7c3b2580b186da1935 | TRUE |
| global artifact manifest hash of aggregation_members.tsv | f068fc35817941592f302e71d9024ce0e53b5950f84e698d9f39f327f5fb4479 | f068fc35817941592f302e71d9024ce0e53b5950f84e698d9f39f327f5fb4479 | TRUE |
| fixed universe equals the fitted features | aca1, aca10, aca11, aca13, acb1, … (323 values) | aca1, aca10, aca11, aca13, acb1, … (323 values) | TRUE |
| definitions.tsv:global_metab | 285 | 285 | TRUE |
| definitions.tsv:global_adf | 38 | 38 | TRUE |
| every feature has \>= 30 carriers | TRUE | TRUE | TRUE |
| all models converged, none at a boundary | TRUE, TRUE | TRUE, TRUE | TRUE |
| carriers match the frozen universe | 30, 118, 35, 77, 300, … (323 values) | 30, 118, 35, 77, 300, … (323 values) | TRUE |
| ADF profiles: 26 positive, 12 negative | 26, 12 | 26, 12 | TRUE |
| group medians equal global summary.json (6 dp) | 4.048350, 1.356948 | 4.048350, 1.356948 | TRUE |
| group sizes equal global summary.json | 285, 38 | 285, 38 | TRUE |
| saved genome and cluster counts | 77951, 30079 | 77951, 30079 | TRUE |
| opportunity fields present in the saved fits | TRUE | TRUE | TRUE |
| one saved row per feature (323 unique keys) | 323, 323 | 323, 323 | TRUE |
| every G01 feature has exactly one saved opportunity row | FALSE | FALSE | TRUE |
| opportunity fields equal the source strings by key | TRUE | TRUE | TRUE |
| fixed-opportunity null model valid for all 323 | 323 | 323 | TRUE |
| free-exponent gamma valid: METAB 285/285, ADF 35/38 | 285, 35 | 285, 35 | TRUE |
| gamma not accepted for exactly gp4.5, ocr, samase | gp4.5, ocr, samase | gp4.5, ocr, samase | TRUE |
| no accepted gamma or gamma_se where gamma was not accepted | TRUE, TRUE | TRUE, TRUE | TRUE |
| unaccepted gamma estimates kept for audit (non-empty) where gamma was not accepted | TRUE | TRUE | TRUE |
| saved warnings of the three gamma failures | glm.fit: fitted probabilities numerically 0 or 1 occurred, glm.fit: algorithm did not converge, glm.fit: fitted probabilities numerically 0 or 1 occurred | glm.fit: fitted probabilities numerically 0 or 1 occurred, glm.fit: algorithm did not converge, glm.fit: fitted probabilities numerically 0 or 1 occurred | TRUE |
| residual_slope = slope - null_logit_equivalent (saved values, \|diff\| \<= 1e-12) | TRUE | TRUE | TRUE |
| aca1 example: saved projection, residual and gamma (text) | 2.3034134327236, -1.67220499318136, 0.274024027211473 | 2.3034134327236, -1.67220499318136, 0.274024027211473 | TRUE |
| aca1 example: slope | 0.6312084395 | 0.6312084395 | TRUE |
| positives per group (ADF 26, METAB 269) | 26, 269 | 26, 269 | TRUE |
| definitions.tsv:global_adf | 38 | 38 | TRUE |
| display profiles equal the fitted ADF set | aca1, aca10, aca11, aca13, acb1, … (38 values) | aca1, aca10, aca11, aca13, acb1, … (38 values) | TRUE |
| display slopes equal the fitted slopes | 0.6312084395, 0.4141639850, -5.4428556756, -2.9143624896, 5.7192704320, … (38 values) | 0.6312084395, 0.4141639850, -5.4428556756, -2.9143624896, 5.7192704320, … (38 values) | TRUE |
| display carriers equal the fitted carriers | 30, 118, 35, 77, 300, … (38 values) | 30, 118, 35, 77, 300, … (38 values) | TRUE |
| definitions.tsv:global_single_cluster | 4 | 4 | TRUE |
| the four single-cluster profiles | darb, ddra, gp4.5, samase | darb, ddra, gp4.5, samase | TRUE |
| single-cluster flag equals carrier_clusters == 1 | FALSE, FALSE, FALSE, FALSE, FALSE, … (38 values) | FALSE, FALSE, FALSE, FALSE, FALSE, … (38 values) | TRUE |
| the 104-row support table is filtered to the fixed 38 | 38 | 38 | TRUE |
| carriers and clusters equal the support table | TRUE, TRUE | TRUE, TRUE | TRUE |
| six ordered bins | 6 | 6 | TRUE |
| definitions.tsv:catalogue_votu | 3060 | 3060 | TRUE |
| definitions.tsv:antidefense_union | 722 | 722 | TRUE |
| bin rates equal k / n | 0.07056638812, 0.22483766234, 0.43795620438, 0.49367088608, 0.64705882353, 0.94444444444 | 0.07056638812, 0.22483766234, 0.43795620438, 0.49367088608, 0.64705882353, 0.94444444444 | TRUE |
| highest bin is 17 of 18 | 17, 18 | 17, 18 | TRUE |
| bins equal the archived local_bridge_bins.json (lo, hi, n, k) | 3, 20, 1077, 76, 20, … (24 values) | 3, 20, 1077, 76, 20, … (24 values) | TRUE |
| bins are contiguous and left-closed | 20, 40, 60, 80, 120 | 20, 40, 60, 80, 120 | TRUE |
| separate adjustments are recorded as invalid for the fixed 38 | FALSE, FALSE, FALSE, FALSE | FALSE, FALSE, FALSE, FALSE | TRUE |
| Firth sensitivity contrasts are valid | TRUE, TRUE, TRUE, TRUE, TRUE, TRUE | TRUE, TRUE, TRUE, TRUE, TRUE, TRUE | TRUE |
| valid replicates: representative / all38 | 10 | 10 | TRUE |
| replicates requested: representative / all38 | 50 | 50 | TRUE |
| valid replicates: representative / named25 | 10 | 10 | TRUE |
| replicates requested: representative / named25 | 50 | 50 | TRUE |
| valid replicates: cluster_bootstrap / all38 | 76 | 76 | TRUE |
| replicates requested: cluster_bootstrap / all38 | 200 | 200 | TRUE |
| valid replicates: cluster_bootstrap / named25 | 76 | 76 | TRUE |
| replicates requested: cluster_bootstrap / named25 | 200 | 200 | TRUE |
| per-replicate contrast rows (2 modes x 2 definitions x replicates) | 500 | 500 | TRUE |
| valid replicates in the detail equal the summary | 76, 10, 76, 10 | 76, 10, 76, 10 | TRUE |
| per-feature resampling diagnostics rows | 80750 | 80750 | TRUE |
| per-feature diagnostics cover the same modes as the contrasts | cluster_bootstrap, representative | cluster_bootstrap, representative | TRUE |
| per-feature diagnostics cover the fixed feature set | aca1, aca10, aca11, aca13, acb1, … (323 values) | aca1, aca10, aca11, aca13, acb1, … (323 values) | TRUE |
| a replicate is invalid in all38 exactly when some fixed feature is not estimable | FALSE, FALSE, FALSE, FALSE, FALSE, … (250 values) | FALSE, FALSE, FALSE, FALSE, FALSE, … (250 values) | TRUE |
| NAD leave-out: median 4.048350 -\> 3.982495 | 4.048350, 3.982495 | 4.048350, 3.982495 | TRUE |
| six NAD domains: saved slopes equal the fixed-set fits (4 dp) | 8.2217, 8.2176, 6.7754, 6.4807, 6.1230, 4.7963 | 8.2217, 8.2176, 6.7754, 6.4807, 6.1230, 4.7963 | TRUE |
| repair run completed with the recorded script | COMPLETE, 4f9892c39ed89ca7ef9d9b8218a7104dff5ced4abcc27ee0b5e97d158650175b | COMPLETE, 4f9892c39ed89ca7ef9d9b8218a7104dff5ced4abcc27ee0b5e97d158650175b | TRUE |
| repair scenarios and their saved status labels | DESCRIPTIVE_FIXED_BASELINE, POST_HOC_CORRECTED_DEFINITION, POST_HOC_CORRECTED_DEFINITION, WITHDRAWN_BUG_AFFECTED_AUDIT_ONLY, DESCRIPTIVE_FIXED_BASELINE | DESCRIPTIVE_FIXED_BASELINE, POST_HOC_CORRECTED_DEFINITION, POST_HOC_CORRECTED_DEFINITION, WITHDRAWN_BUG_AFFECTED_AUDIT_ONLY, DESCRIPTIVE_FIXED_BASELINE | TRUE |
| repair units: 285, 38, 22 legacy, 9 and 10 corrected categories | 285, 38, 22, 9, 10 | 285, 38, 22, 9, 10 | TRUE |
| repair fits: 364 rows, one per scenario unit | 364, 364 | 364, 364 | TRUE |
| corrected fits: 19 logit valid, 19 null valid, 18 gamma valid | 19, 19, 19, 18 | 19, 19, 19, 18 | TRUE |
| the corrected gamma failure is corrected_fixed38_category / Anti_TA (0/1 warning; not boundary) | corrected_fixed38_category, Anti_TA, glm.fit: fitted probabilities numerically 0 or 1 occurred, TRUE, FALSE | corrected_fixed38_category, Anti_TA, glm.fit: fitted probabilities numerically 0 or 1 occurred, TRUE, FALSE | TRUE |
| corrected null logit projection recorded invalid for all 19, residual NA, warning as saved | 19, 19, 19 | 19, 19, 19 | TRUE |
| independent verification of the 19 corrected logit slopes | PASS, 19 | PASS, 19 | TRUE |
| independent verification maximum slope difference below 1e-9 | TRUE | TRUE | TRUE |
| G15 historical units equal the repair record’s old_unit (104 profiles) | 104, 104 | 104, 104 | TRUE |
| G14 all_profiles_then_threshold (22) equals legacy_mixed slopes | 22, 0 | 22, 0 | TRUE |
| G14 fixed38 has 21 historical units (old join of the fixed 38) | 21, 21 | 21, 21 | TRUE |
| repair run reproduces the fixed 285/38 slopes of G01 (\|diff\| \< 1e-6) | TRUE | TRUE | TRUE |
| named25 = the 25 fixed profiles named by the old join | 25 | 25 | TRUE |
| observed profiles, census mapping rows and corrected memberships | 104, 356, 284, 12 | 104, 356, 284, 12 | TRUE |
| status index covers every historical or corrected object once | 13 | 13 | TRUE |

| file                                  |   bytes | sha256           |
|:--------------------------------------|--------:|:-----------------|
| global_feature_fits.tsv               |  107237 | 1c910aa14ca29018 |
| global_group_medians.tsv              |     322 | f8c64348d4520b64 |
| global_profile_support.tsv            |    4456 | c60d8ad40c1713c5 |
| local_carriage_bins.tsv               |     724 | e873fd65413a8687 |
| global_adjusted.tsv                   |     666 | 02b9f1d279aa9da2 |
| global_firth.tsv                      |    1150 | 7077b81bc16a2f7f |
| global_resampling.tsv                 |    1171 | c359b8e5970eae9d |
| global_strata.tsv                     |     356 | 015f496639fcd563 |
| global_nad_leaveout.tsv               |    2124 | cd39bc9048349c13 |
| global-gaps.tsv                       |    1136 | cba6c590b7f7cda5 |
| input-checks.tsv                      |   12019 | 5f3521a5dd8ff53d |
| session-info.txt                      |   13696 | 6cb566f2ce39bc66 |
| global_adjusted_fits.tsv              |   42393 | ef3053d9431a52ee |
| global_firth_feature_fits.tsv         |  106510 | 0bdab56c3f36471d |
| global_stratum_fits.tsv               |  218537 | 48e19385f4977958 |
| global_aggregation_fits.tsv           |    2490 | 05c30ee1aadf0a17 |
| global_aggregation_members.tsv        |    3160 | f068fc3581794159 |
| global_firth_run.tsv                  |     225 | eced2afd5b78f081 |
| global_resample_contrasts.tsv         |   21993 | d0ef627940e0a0a5 |
| global_resample_features.tsv          | 4605408 | 1ca5e861d95762b5 |
| global_result_status.tsv              |    3842 | de0e7b225c4eb343 |
| global_repair_scenario_summary.tsv    |    1618 | 5b61f3ed0d1d6982 |
| global_repair_feature_fits.tsv        |   68213 | 9773e5b402f7af99 |
| global_repair_members.tsv             |    7160 | 9cbe503f396c8478 |
| global_repair_scenario_members.tsv    |   13325 | d77965fcad4fb30c |
| global_repair_mapping.tsv             |   58382 | 0e1b4905cbfb7393 |
| global_repair_eligibility_changes.tsv |    2036 | f5371862a06419ab |

Outputs recorded in step-record.json

</details>

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/050-global-inputs/global_feature_fits.tsv">global_feature_fits.tsv</a> (104.7 KB)</li>
<li><a href="data/050-global-inputs/global_group_medians.tsv">global_group_medians.tsv</a> (0.3 KB)</li>
<li><a href="data/050-global-inputs/global_profile_support.tsv">global_profile_support.tsv</a> (4.4 KB)</li>
<li><a href="data/050-global-inputs/local_carriage_bins.tsv">local_carriage_bins.tsv</a> (0.7 KB)</li>
<li><a href="data/050-global-inputs/global_adjusted.tsv">global_adjusted.tsv</a> (0.7 KB)</li>
<li><a href="data/050-global-inputs/global_firth.tsv">global_firth.tsv</a> (1.1 KB)</li>
<li><a href="data/050-global-inputs/global_resampling.tsv">global_resampling.tsv</a> (1.1 KB)</li>
<li><a href="data/050-global-inputs/global_strata.tsv">global_strata.tsv</a> (0.3 KB)</li>
<li><a href="data/050-global-inputs/global_nad_leaveout.tsv">global_nad_leaveout.tsv</a> (2.1 KB)</li>
<li><a href="data/050-global-inputs/global-gaps.tsv">global-gaps.tsv</a> (1.1 KB)</li>
<li><a href="data/050-global-inputs/input-checks.tsv">input-checks.tsv</a> (11.7 KB)</li>
<li><a href="data/050-global-inputs/session-info.txt">session-info.txt</a> (13.4 KB)</li>
<li><a href="data/050-global-inputs/global_adjusted_fits.tsv">global_adjusted_fits.tsv</a> (41.4 KB)</li>
<li><a href="data/050-global-inputs/global_firth_feature_fits.tsv">global_firth_feature_fits.tsv</a> (104 KB)</li>
<li><a href="data/050-global-inputs/global_stratum_fits.tsv">global_stratum_fits.tsv</a> (213.4 KB)</li>
<li><a href="data/050-global-inputs/global_aggregation_fits.tsv">global_aggregation_fits.tsv</a> (2.4 KB)</li>
<li><a href="data/050-global-inputs/global_aggregation_members.tsv">global_aggregation_members.tsv</a> (3.1 KB)</li>
<li><a href="data/050-global-inputs/global_firth_run.tsv">global_firth_run.tsv</a> (0.2 KB)</li>
<li><a href="data/050-global-inputs/global_resample_contrasts.tsv">global_resample_contrasts.tsv</a> (21.5 KB)</li>
<li><a href="data/050-global-inputs/global_resample_features.tsv">global_resample_features.tsv</a> (4497.5 KB)</li>
<li><a href="data/050-global-inputs/global_result_status.tsv">global_result_status.tsv</a> (3.8 KB)</li>
<li><a href="data/050-global-inputs/global_repair_scenario_summary.tsv">global_repair_scenario_summary.tsv</a> (1.6 KB)</li>
<li><a href="data/050-global-inputs/global_repair_feature_fits.tsv">global_repair_feature_fits.tsv</a> (66.6 KB)</li>
<li><a href="data/050-global-inputs/global_repair_members.tsv">global_repair_members.tsv</a> (7 KB)</li>
<li><a href="data/050-global-inputs/global_repair_scenario_members.tsv">global_repair_scenario_members.tsv</a> (13 KB)</li>
<li><a href="data/050-global-inputs/global_repair_mapping.tsv">global_repair_mapping.tsv</a> (57 KB)</li>
<li><a href="data/050-global-inputs/global_repair_eligibility_changes.tsv">global_repair_eligibility_changes.tsv</a> (2 KB)</li>
</ul>

</details>
