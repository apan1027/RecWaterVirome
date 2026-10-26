# 040-vf-inputs
Jinlong Ru, Cunli Pan
2026-10-20

**Updated: 2026-10-20 00:22:29 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 24 output files.
</p>

<p>

Saved assertions: 127 passed, 0 failed, 0 unclassified.
</p>

<p>

Key files:
<a href="data/040-vf-inputs/supplementary-note-5-process-ecology.md">supplementary-note-5-process-ecology.md</a>
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

Read, validate and prepare archived VF-hit coordinates/localizations,
region boundaries for 19 CheckV-flagged records, four fixed models and
controlled-construct endpoints for Figure 4, Supplementary Figure 4 and
Data 1. Models, confidence intervals, CheckV calls and constructs are
not regenerated.

### Task 1: Inputs

### Task 2: Twenty VF hits with unique-key localization

Eight of the 19 flagged records carry the 20 hits. Saved mutually
exclusive localizations comprise 18 predicted-host hits, one
boundary-crossing hit and one viral hit. These are hit counts, not 18
contigs; the crossing hit is counted once.

| localization      | Freq |
|:------------------|-----:|
| boundary-crossing |    1 |
| predicted-host    |   18 |
| viral             |    1 |

### Task 3: Region boundaries for the 19 CheckV-flagged records

### Task 4: Four fixed models using the same 3,013 members

IRRs and 95% Wald confidence intervals are read directly from S34.
Models and intervals are not refitted; whether an interval crosses one
is not used as a vote.

| model | label_definition | region_definition | irr | lo | hi | p |
|---:|:---|:---|---:|---:|---:|---:|
| 1 | including the CheckV provirus call | all hits; full contig length offset | 2.521 | 1.507 | 4.217 | 0.000 |
| 2 | including the CheckV provirus call | hits retained after regional exclusion; retained-viral-length offset | 1.050 | 0.568 | 1.941 | 0.877 |
| 3 | excluding the CheckV provirus call | all hits; full contig length offset | 0.951 | 0.492 | 1.839 | 0.881 |
| 4 | excluding the CheckV provirus call | hits retained after regional exclusion; retained-viral-length offset | 1.003 | 0.532 | 1.893 | 0.992 |

### Task 5: Controlled-construct endpoints with separate denominators

| endpoint                                                   |   k |   n |
|:-----------------------------------------------------------|----:|----:|
| Constructs without an added flank that were flagged        |   0 | 512 |
| Primary flanked constructs without a provirus flag         | 315 | 720 |
| Primary flanked constructs retaining \< 95% of viral bases |  33 | 720 |

### Task 6: Candidate VF-carrier abundance

Join saved catalogue abundance with saved VFDB-A annotations to describe
candidate-carrier shares and their sensitivity to annotation strictness
and host-region assignment. No remapping, reannotation or model fitting
is performed. Region rules change carrier eligibility only; saved
whole-contig abundance and denominators are retained.

|  | sample_id | record_label | catalogue_detected | F0_percent_of_catalogue | F1_percent_of_catalogue | S0_percent_of_catalogue | S1_percent_of_catalogue |
|:---|:---|:---|---:|---:|---:|---:|---:|
| bc1 | bc1 | clean | 991 | 9.679 | 6.803 | 6.513 | 4.011 |
| bd1 | bd1 | dirty | 793 | 1.851 | 1.789 | 1.042 | 0.980 |
| bc2 | bc2 | clean | 602 | 3.905 | 3.646 | 2.524 | 2.524 |
| gc1 | gc1 | clean | 60 | 9.949 | 6.687 | 0.543 | 0.543 |
| gd1 | gd1 | dirty | 533 | 2.015 | 1.974 | 0.182 | 0.182 |
| oc1 | oc1 | clean | 124 | 1.077 | 1.077 | 0.000 | 0.000 |
| od1 | od1 | dirty | 274 | 2.651 | 2.403 | 0.000 | 0.000 |

### Task 7: Symmetric ecological contributions for process-associated positions

Construct descriptive decompositions from saved depth, breadth and
prespecified comparisons, without changing detection rules or adding
tests/models.

| sample_id | qualifying_vOTUs | shared_vOTUs | shared_catalogue_percent | position_only_catalogue_percent |
|:---|---:|---:|---:|---:|
| bd1 | 793 | 70 | 1.310 | 98.690 |
| bc1 | 991 | 70 | 44.775 | 55.225 |
| gd1 | 533 | 59 | 12.900 | 87.100 |
| gc1 | 60 | 59 | 99.590 | 0.410 |
| od1 | 274 | 60 | 38.793 | 61.207 |
| oc1 | 124 | 60 | 70.698 | 29.302 |

### Task 7b: Unadjusted candidate carriage under two lifestyle rules

Summarize binary candidate carriage for the complete 3,060-member
catalogue under two existing lifestyle rules and six existing candidate
sets. Denominators are all catalogue members in each lifestyle group,
not the 3,013-member completeness-assessable model set. Unadjusted
proportions are not the VF-hit-per-kb model IRRs. Length/completeness
backgrounds are supplied without fitting new models.

| lifestyle_rule | lifestyle | function_set | carrier_n | group_n | carrier_percent |
|:---|:---|:---|---:|---:|---:|
| including_CheckV | temperate | AMG_export | 63 | 262 | 24.05 |
| including_CheckV | temperate | anti_defense_union | 107 | 262 | 40.84 |
| including_CheckV | temperate | F0 | 19 | 262 | 7.25 |
| including_CheckV | temperate | F1 | 12 | 262 | 4.58 |
| including_CheckV | temperate | S0 | 5 | 262 | 1.91 |
| including_CheckV | temperate | S1 | 4 | 262 | 1.53 |
| including_CheckV | virulent | AMG_export | 481 | 2798 | 17.19 |
| including_CheckV | virulent | anti_defense_union | 615 | 2798 | 21.98 |
| including_CheckV | virulent | F0 | 95 | 2798 | 3.40 |
| including_CheckV | virulent | F1 | 95 | 2798 | 3.40 |
| including_CheckV | virulent | S0 | 26 | 2798 | 0.93 |
| including_CheckV | virulent | S1 | 26 | 2798 | 0.93 |
| without_CheckV | temperate | AMG_export | 49 | 246 | 19.92 |
| without_CheckV | temperate | anti_defense_union | 103 | 246 | 41.87 |
| without_CheckV | temperate | F0 | 12 | 246 | 4.88 |
| without_CheckV | temperate | F1 | 11 | 246 | 4.47 |
| without_CheckV | temperate | S0 | 3 | 246 | 1.22 |
| without_CheckV | temperate | S1 | 3 | 246 | 1.22 |
| without_CheckV | virulent | AMG_export | 495 | 2814 | 17.59 |
| without_CheckV | virulent | anti_defense_union | 619 | 2814 | 22.00 |
| without_CheckV | virulent | F0 | 102 | 2814 | 3.62 |
| without_CheckV | virulent | F1 | 96 | 2814 | 3.41 |
| without_CheckV | virulent | S0 | 28 | 2814 | 1.00 |
| without_CheckV | virulent | S1 | 27 | 2814 | 0.96 |

### Task 8: Record checks and the run

| check | expected | observed | pass |
|:---|:---|:---|:---|
| stage-A artifact manifest hash of vf20_coordinates.tsv | 38a21cdea4790e23bab5228c0cc33c43d222a325fd8cdbb87871c77bf49c0fdb | 38a21cdea4790e23bab5228c0cc33c43d222a325fd8cdbb87871c77bf49c0fdb | TRUE |
| stage-A artifact manifest hash of checkv19.tsv | 1c77e6b4e40f38f251843d46e817bb8c074be7d8a1c5d3f2fef21fd88c786fd4 | 1c77e6b4e40f38f251843d46e817bb8c074be7d8a1c5d3f2fef21fd88c786fd4 | TRUE |
| stage-A artifact manifest hash of regions.tsv | 33e6cf72a3b0ef3317b56b9877b9dec45b6d8f7feb93263d93b8b7e426b929ef | 33e6cf72a3b0ef3317b56b9877b9dec45b6d8f7feb93263d93b8b7e426b929ef | TRUE |
| stage-A artifact manifest hash of votu_input.tsv | ebaa1b914e7cd6cd4171da22022f2c091757db54298142cc1a2faab79f276035 | ebaa1b914e7cd6cd4171da22022f2c091757db54298142cc1a2faab79f276035 | TRUE |
| definitions.tsv:vf_hits | 20 | 20 | TRUE |
| unique vOTU / protein_id / (query,target) | 8, 20, 20 | 8, 20, 20 | TRUE |
| definitions.tsv:vf_hits_host | 18 | 18 | TRUE |
| definitions.tsv:vf_hits_crossing | 1 | 1 | TRUE |
| definitions.tsv:vf_hits_viral | 1 | 1 | TRUE |
| protein coordinates are ordered start \< end | TRUE | TRUE | TRUE |
| definitions.tsv:vf_flagged_records | 19 | 19 | TRUE |
| all 8 hit-carrying vOTUs are among the flagged records | TRUE | TRUE | TRUE |
| definitions.tsv:vf_hit_records | 8 | 8 | TRUE |
| region lengths equal end - start + 1 | 9074, 3001, 7853, 5663, 4913, … (39 values) | 9074, 3001, 7853, 5663, 4913, … (39 values) | TRUE |
| regions cover the full flagged record length | 50407, 72425, 62172, 46175, 44087, … (19 values) | 50407, 72425, 62172, 46175, 44087, … (19 values) | TRUE |
| hits distributed over the flagged records sum to 20 | 20 | 20 | TRUE |
| four models | 4 | 4 | TRUE |
| definitions.tsv:vf_model_n | 3013 | 3013 | TRUE |
| saved IRR values (3 dp) | 2.521, 1.050, 0.951, 1.003 | 2.521, 1.050, 0.951, 1.003 | TRUE |
| all four models converged | TRUE | TRUE | TRUE |
| lo \< irr \< hi in every model | TRUE | TRUE | TRUE |
| 3,060 - completeness NA = 3,013 | 3013 | 3013 | TRUE |
| CheckV completeness: every value is numeric or the literal NA (47 NA) | 0, 47 | 0, 47 | TRUE |
| model input covers the catalogue | vOTU0001, vOTU0002, vOTU0003, vOTU0004, vOTU0005, … (3060 values) | vOTU0001, vOTU0002, vOTU0003, vOTU0004, vOTU0005, … (3060 values) | TRUE |
| vOTUs in the saved model set | 3013 | 3013 | TRUE |
| definitions.tsv:vf_model_excluded | 47 | 47 | TRUE |
| excluded IDs are exactly the CheckV Undetermined IDs | vOTU0662, vOTU0847, vOTU0947, vOTU1122, vOTU1129, … (47 values) | vOTU0662, vOTU0847, vOTU0947, vOTU1122, vOTU1129, … (47 values) | TRUE |
| temperate vOTUs in the model set (CheckV-based labels) | 260 | 260 | TRUE |
| definitions.tsv:vf_model_hits_all | 142 | 142 | TRUE |
| S34 hits (all regions) equal the model-input sum | 142 | 142 | TRUE |
| definitions.tsv:vf_model_hits_viral | 123 | 123 | TRUE |
| S34 region-corrected hits = all - predicted-host - boundary-crossing | 123 | 123 | TRUE |
| host and crossing hits in the model set equal the 20-hit localization | 18, 1 | 18, 1 | TRUE |
| localization of the 142 model hits (no host region, host, crossing, viral) | 122, 18, 1, 1 | 122, 18, 1, 1 | TRUE |
| retained hits are the no-host-region and viral hits | 123 | 123 | TRUE |
| records whose length offset changes under the region definition | 19 | 19 | TRUE |
| those records are the CheckV-flagged records of panels A-B | 19 | 19 | TRUE |
| the saved lifestyle label is the four-way disjunction | temperate, virulent, virulent, virulent, virulent, … (3013 values) | temperate, virulent, virulent, virulent, virulent, … (3013 values) | TRUE |
| dropping the CheckV branch: 260 -\> 244 temperate, 16 labels change | 260, 244, 16 | 260, 244, 16 | TRUE |
| definitions.tsv:construct_noflank | 0 | 0 | TRUE |
| zero-flank denominator (270 + 242) | 512 | 512 | TRUE |
| primary flanked constructs | 720 | 720 | TRUE |
| flagged primary flanked constructs | 405 | 405 | TRUE |
| zero-flank constructs per panel | 270, 242 | 270, 242 | TRUE |
| definitions.tsv:construct_unflagged | 315 | 315 | TRUE |
| unflagged primary constructs have no host bases removed (max) | 0 | 0 | TRUE |
| definitions.tsv:construct_below95 | 33 | 33 | TRUE |
| flag rate (fraction) rises with window length at 10% flanks | TRUE | TRUE | TRUE |
| minimum viral retention (4 dp) | 0.6402 | 0.6402 | TRUE |
| sequence strata rows | 896 | 896 | TRUE |
| sample display order from config | TRUE | TRUE | TRUE |
| breadth threshold read from config/community.yml | 0.75 | 0.75 | TRUE |
| catalogue representatives in the TSE | 3060 | 3060 | TRUE |
| masked depth equals the saved masked assay | TRUE | TRUE | TRUE |
| catalogue percentage matches the saved closed-sum assay (1e-12 criterion) | TRUE | TRUE | TRUE |
| every sample percentage sums to 100 (1e-9) | TRUE | TRUE | TRUE |
| filtered and strict hit keys are unique | TRUE, TRUE | TRUE, TRUE | TRUE |
| strict hits are a subset of filtered | 0 | 0 | TRUE |
| all localized hits join the filtered table on (vOTU_id, query, target) | 20 | 20 | TRUE |
| hits excluded by the region rule | 19 | 19 | TRUE |
| hits per set (F0, F1, S0, S1) | 143, 124, 37, 34 | 143, 124, 37, 34 | TRUE |
| carriers per set (F0, F1, S0, S1) | 114, 107, 31, 30 | 114, 107, 31, 30 | TRUE |
| definitions.tsv:vf_cat_hits_F0 | 143 | 143 | TRUE |
| definitions.tsv:vf_cat_carriers_F0 | 114 | 114 | TRUE |
| definitions.tsv:vf_cat_hits_F1 | 124 | 124 | TRUE |
| definitions.tsv:vf_cat_carriers_F1 | 107 | 107 | TRUE |
| definitions.tsv:vf_cat_hits_S0 | 37 | 37 | TRUE |
| definitions.tsv:vf_cat_carriers_S0 | 31 | 31 | TRUE |
| definitions.tsv:vf_cat_hits_S1 | 34 | 34 | TRUE |
| definitions.tsv:vf_cat_carriers_S1 | 30 | 30 | TRUE |
| definitions.tsv:vf_detection_breadth | 0.75 | 0.75 | TRUE |
| set nesting F1\<=F0, S0\<=F0, S1\<=S0, S1\<=F1 | TRUE, TRUE, TRUE, TRUE | TRUE, TRUE, TRUE, TRUE | TRUE |
| per-vOTU filtered and strict counts agree with votu_model_input.tsv | TRUE, TRUE | TRUE, TRUE | TRUE |
| per-vOTU F1 and S1 counts agree with votu_model_input.tsv | TRUE, TRUE | TRUE, TRUE | TRUE |
| sample summary rows | 7 | 7 | TRUE |
| carrier x sample cells | 798 | 798 | TRUE |
| unique carrier x sample keys | 798 | 798 | TRUE |
| heatmap rows selected | 18 | 18 | TRUE |
| definitions.tsv:vf_heatmap_top | 18 | 18 | TRUE |
| no cell passes breadth with a non-positive depth | 0 | 0 | TRUE |
| no missing abundance cells | 0 | 0 | TRUE |
| normalization audit rows | 7 | 7 | TRUE |
| hit catalogue rows | 143 | 143 | TRUE |
| localization classes (no_region_prediction, host, boundary_crossing, viral) | 123, 18, 1, 1 | 123, 18, 1, 1 | TRUE |
| ecology: three designated comparisons, bc2 unpaired | TRUE | TRUE | TRUE |
| ecology: input diagnostics reproduce existing qualifying counts | TRUE | TRUE | TRUE |
| ecology: positive-count zero-depth field is a subset, not all mapped members | TRUE | TRUE | TRUE |
| ecology: complete unique comparison by vOTU register | TRUE | TRUE | TRUE |
| ecology: catalogue partition conserves members and shares bd1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total bd1 F0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total bd1 F1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total bd1 S0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total bd1 S1 | TRUE | TRUE | TRUE |
| ecology: catalogue partition conserves members and shares bc1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total bc1 F0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total bc1 F1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total bc1 S0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total bc1 S1 | TRUE | TRUE | TRUE |
| ecology: catalogue partition conserves members and shares gd1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total gd1 F0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total gd1 F1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total gd1 S0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total gd1 S1 | TRUE | TRUE | TRUE |
| ecology: catalogue partition conserves members and shares gc1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total gc1 F0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total gc1 F1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total gc1 S0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total gc1 S1 | TRUE | TRUE | TRUE |
| ecology: catalogue partition conserves members and shares od1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total od1 F0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total od1 F1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total od1 S0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total od1 S1 | TRUE | TRUE | TRUE |
| ecology: catalogue partition conserves members and shares oc1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total oc1 F0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total oc1 F1 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total oc1 S0 | TRUE | TRUE | TRUE |
| ecology: VF partition reproduces saved total oc1 S1 | TRUE | TRUE | TRUE |
| ecology: symmetric community and VF table shapes | 6, 24 | 6, 24 | TRUE |
| ecology: diagnostic categories partition position-only members | TRUE | TRUE | TRUE |
| ecology: zero VF denominator has NA conditional share | TRUE | TRUE | TRUE |
| raw lifestyle carriage: two rules x two groups x six candidate sets | 24 | 24 | TRUE |
| lifestyle carriage keeps full catalogue denominators | TRUE | TRUE | TRUE |
| raw lifestyles: original and no-CheckV temperate / virulent counts | 262, 2798, 246, 2814 | 262, 2798, 246, 2814 | TRUE |
| raw candidate-set counts conserved within both lifestyle rules | TRUE | TRUE | TRUE |
| available completeness totals reproduce model set without discarding catalogue members | TRUE | TRUE | TRUE |
| original virulent records retain Replidec lytic predictions | TRUE | TRUE | TRUE |

| file                                    |   bytes | sha256           |
|:----------------------------------------|--------:|:-----------------|
| process_community_contribution.tsv      |    1259 | ef7eb9a196f54166 |
| process_vf_contribution.tsv             |    3424 | 382c575af974b1a5 |
| process_comparison_members.tsv          | 1165858 | 2dea900eb9140ccf |
| process_input_diagnostics.tsv           |     608 | 7d6789a8f67f0e87 |
| supplementary-note-5-process-ecology.md |    3823 | b5d302ba258da730 |
| vf_hits.tsv                             |    4158 | 3bee7dbda69f9a87 |
| checkv_regions.tsv                      |    1425 | 65a4ed1e8cfa4e3c |
| checkv_flagged_records.tsv              |    1089 | 96b245c1aaf3a43a |
| vf_models.tsv                           |    1927 | 5441aa6c13c6328c |
| vf_model_bridge.tsv                     |     232 | 8f9d670f4dba966e |
| construct_detection.tsv                 |     500 | 23aabd78e71bcddd |
| construct_endpoints.tsv                 |    1165 | 254ca10d2aa1003e |
| construct_below95.tsv                   |    3322 | 56524cc3dd998ed7 |
| input-checks.tsv                        |   10820 | 0c10591e0bec8415 |
| session-info.txt                        |   13692 | e1425fb685c43eb6 |
| vf_model_excluded.tsv                   |    7999 | dee68183c6f1dae1 |
| construct_strata.tsv                    |   87189 | ca093e269e36b31f |
| vf_hit_localization.tsv                 |     425 | 3f2811ab3c273f7b |
| vf_sample_summary.tsv                   |    1810 | fbccbd21c019e0f2 |
| vf_carrier_abundance.tsv                |  145018 | ef71342a782202c3 |
| vf_normalization_audit.tsv              |    2903 | d160369e897db6e4 |
| vf_hit_catalogue.tsv                    |   38590 | 3c3bb32ff6de6b75 |
| vf_heatmap_selection.tsv                |    3425 | 7ab5293a70b4dfc3 |
| lifestyle_function_carriage.tsv         |    2540 | b4f1cc8be9094a59 |

Outputs recorded in step-record.json

</details>

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/040-vf-inputs/process_community_contribution.tsv">process_community_contribution.tsv</a> (1.2 KB)</li>
<li><a href="data/040-vf-inputs/process_vf_contribution.tsv">process_vf_contribution.tsv</a> (3.3 KB)</li>
<li><a href="data/040-vf-inputs/process_comparison_members.tsv">process_comparison_members.tsv</a> (1138.5 KB)</li>
<li><a href="data/040-vf-inputs/process_input_diagnostics.tsv">process_input_diagnostics.tsv</a> (0.6 KB)</li>
<li><a href="data/040-vf-inputs/supplementary-note-5-process-ecology.md">supplementary-note-5-process-ecology.md</a> (3.7 KB)</li>
<li><a href="data/040-vf-inputs/vf_hits.tsv">vf_hits.tsv</a> (4.1 KB)</li>
<li><a href="data/040-vf-inputs/checkv_regions.tsv">checkv_regions.tsv</a> (1.4 KB)</li>
<li><a href="data/040-vf-inputs/checkv_flagged_records.tsv">checkv_flagged_records.tsv</a> (1.1 KB)</li>
<li><a href="data/040-vf-inputs/vf_models.tsv">vf_models.tsv</a> (1.9 KB)</li>
<li><a href="data/040-vf-inputs/vf_model_bridge.tsv">vf_model_bridge.tsv</a> (0.2 KB)</li>
<li><a href="data/040-vf-inputs/construct_detection.tsv">construct_detection.tsv</a> (0.5 KB)</li>
<li><a href="data/040-vf-inputs/construct_endpoints.tsv">construct_endpoints.tsv</a> (1.1 KB)</li>
<li><a href="data/040-vf-inputs/construct_below95.tsv">construct_below95.tsv</a> (3.2 KB)</li>
<li><a href="data/040-vf-inputs/input-checks.tsv">input-checks.tsv</a> (10.6 KB)</li>
<li><a href="data/040-vf-inputs/session-info.txt">session-info.txt</a> (13.4 KB)</li>
<li><a href="data/040-vf-inputs/vf_model_excluded.tsv">vf_model_excluded.tsv</a> (7.8 KB)</li>
<li><a href="data/040-vf-inputs/construct_strata.tsv">construct_strata.tsv</a> (85.1 KB)</li>
<li><a href="data/040-vf-inputs/vf_hit_localization.tsv">vf_hit_localization.tsv</a> (0.4 KB)</li>
<li><a href="data/040-vf-inputs/vf_sample_summary.tsv">vf_sample_summary.tsv</a> (1.8 KB)</li>
<li><a href="data/040-vf-inputs/vf_carrier_abundance.tsv">vf_carrier_abundance.tsv</a> (141.6 KB)</li>
<li><a href="data/040-vf-inputs/vf_normalization_audit.tsv">vf_normalization_audit.tsv</a> (2.8 KB)</li>
<li><a href="data/040-vf-inputs/vf_hit_catalogue.tsv">vf_hit_catalogue.tsv</a> (37.7 KB)</li>
<li><a href="data/040-vf-inputs/vf_heatmap_selection.tsv">vf_heatmap_selection.tsv</a> (3.3 KB)</li>
<li><a href="data/040-vf-inputs/lifestyle_function_carriage.tsv">lifestyle_function_carriage.tsv</a> (2.5 KB)</li>
</ul>

</details>
