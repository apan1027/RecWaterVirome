# 320-data1-local
Jinlong Ru, Cunli Pan
2026-10-20

**Updated: 2026-10-20 00:24:30 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 68 output files.
</p>

<p>

Saved assertions: 35 passed, 0 failed, 0 unclassified.
</p>

<p>

Key files:
<a href="data/320-data1-local/Data1_local.xlsx">Data1_local.xlsx</a>
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

Data 1 collects local sample, composition, diversity, ordination,
cross-assay, host, catalogue-quality, QC, functional, carrier, VF and
controlled-construct tables, including all 138 KOs and 68 pathways.
Every worksheet has units, provenance and figure references in its
dictionary; machine-readable TSVs are also exported. Tables with
different units are not combined without a dictionary.

### Task 1: Inputs

### Task 2: Worksheet register

|  | sheet | field | type | unit_or_code | meaning |
|:---|:---|:---|:---|:---|:---|
| 171 | S19_amg_carriers | feature_id | text | identifier | Feature identifier at this sheet’s feature level (KO, curated pathway or database entry) |
| 172 | S19_amg_carriers | feature_name | text | text | Human-readable name of that feature |
| 173 | S19_amg_carriers | vOTU_id | text | identifier | Identifier of a viral operational taxonomic unit in this catalogue |
| 174 | S19_amg_carriers | bc1 | numeric | see sheet units | Value for sample bc1; the quantity and its unit are given by this sheet’s units_and_limits |
| 175 | S19_amg_carriers | bd1 | numeric | see sheet units | Value for sample bd1; the quantity and its unit are given by this sheet’s units_and_limits |
| 176 | S19_amg_carriers | bc2 | numeric | see sheet units | Value for sample bc2; the quantity and its unit are given by this sheet’s units_and_limits |
| 177 | S19_amg_carriers | gc1 | numeric | see sheet units | Value for sample gc1; the quantity and its unit are given by this sheet’s units_and_limits |
| 178 | S19_amg_carriers | gd1 | numeric | see sheet units | Value for sample gd1; the quantity and its unit are given by this sheet’s units_and_limits |

|  | sheet | rows | figures | content |
|:---|:---|---:|:---|:---|
| S01_samples | S01_samples | 7 | F1, F2, S1, S2 | Seven water samples: fixed order, site, record label, assay IDs and read counts |
| S02_composition_full | S02_composition_full | 413 | F1 | Full composition of all 59 taxa x 7 samples in three assays, with the display category of each taxon |
| S03_composition_display | S03_composition_display | 196 | F1 | Composition after the frozen display aggregation (top 8 named taxa per amplicon assay, all viral classes) |
| S04_taxon_display_map | S04_taxon_display_map | 59 | F1 | Which taxon was mapped to which display category, with the rule and the 7-sample mean used to rank |
| S05_alpha | S05_alpha | 21 | F2 | Shannon and observed richness per assay and sample, each with its own definition |
| S06_virome_alpha_detail | S06_virome_alpha_detail | 7 | F2, S1 | Masked viral alpha diversity with rarefied and unrarefied values and the rarefaction spread |
| S07_label_pairs | S07_label_pairs | 9 | F2 | Same-site c/d record-label contrasts as saved (difference = dirty minus clean) |
| S08_pcoa | S08_pcoa | 21 | F2 | Saved Aitchison PCoA coordinates per assay and sample |
| S09_crossomics | S09_crossomics | 3 | F2c (Mantel); table formerly drawn as S1E | All three cross-assay statistics for the three assay pairs: Mantel r, Procrustes correlation and RV coefficient; the ranking of the two virome pairs depends on the statistic |
| S10_permanova | S10_permanova | 36 | table formerly drawn as S1D | Marginal PERMANOVA for every distance of each assay, location and c/d label terms retained; the virome location term depends on the distance (Aitchison p = 0.725; Bray-Curtis 0.001; Jaccard 0.002) |
| S11_betadisper | S11_betadisper | 36 | table formerly drawn as S1D | Dispersion checks for every distance and grouping, with the saved status (flagged / method-dependent / not flagged) |
| S12_host_iphop | S12_host_iphop | 200 | F2d, S2c; Note 1 Table C | All 200 iPHoP records at score \>= 90 with the corrected genus and the visibility status |
| S13_host_crispr | S13_host_crispr | 29 | F2 | The 29 strict CRISPR edges (25 vOTUs, 22 genera) with co-detection and mismatch fields |
| S14_checkv_catalogue | S14_checkv_catalogue | 3060 | F1, F4, F5, S1, S4 | All 3,060 vOTUs with CheckV class, estimated completeness, length and predicted gene count |
| S15_depth | S15_depth | 7 | S1 | Masked richness and sequencing depth per sample |
| S16_saturation | S16_saturation | 21 | table formerly drawn as S1C | Historical saturation diagnostics at full depth from the source project, with the definition of each layer; kept for reference, not evidence of sampling sufficiency |
| S17_amg_ko_matrix | S17_amg_ko_matrix | 138 | F3 | All 138 AMG candidate KOs x 7 samples |
| S18_amg_pathway_matrix | S18_amg_pathway_matrix | 68 | Data 1 only | All 68 curated metabolism pathways x 7 samples |
| S19_amg_carriers | S19_amg_carriers | 731 | F3; Note 1 Table C | Every KO-carrier pair with its per-sample TPM, contribution fraction and rank (KO feature level) |
| S20_f3_display | S20_f3_display | 11 | F3 | The frozen 11-row display list with the selection rule and the saved totals |
| S21_f3_carrier_ranks | S21_f3_carrier_ranks | 44 | F3 | Top 1/2/3 and remaining carrier shares for each displayed KO |
| S22_f3_carrier_hosts | S22_f3_carrier_hosts | 276 | Note 1 Table C | Carriers of the displayed KOs joined to the checked iPHoP \>= 90 members |
| S23_defense_sets | S23_defense_sets | 6 | F3 | Each defense and anti-defense set with its tool, rule and denominator |
| S24_defense_membership | S24_defense_membership | 3060 | F3, F5 | Per-vOTU membership of each tool set and of the anti-defense union, with the predicted gene count |
| S25_narp_definitions | S25_narp_definitions | 19 | F3, S3a | Membership of every NARP-related vOTU under four operational definitions, with its CheckV class |
| S26_votu0052_locus | S26_votu0052_locus | 3 | F3, S3c | Coordinates and annotations of ORF101-103 of vOTU0052 |
| S27_votu0052_defensefinder | S27_votu0052_defensefinder | 3 | S3 | DefenseFinder gene rows for vOTU0052, including the separate atd1 call |
| S28_narp_case_evidence | S28_narp_case_evidence | 29 | S3d and Supplementary Note 1 | Case values reported in project documents (coverage, HE targeting, ORF102 domains, global NARP), with file and line; the coverage and HE-targeting rows are Tables A and B of Supplementary Note 1 (formerly drawn as S2e, S2f) |
| S29_vf_hits | S29_vf_hits | 20 | S4b, S4c; Supplementary Note 3 | The 20 VF hits with protein coordinates, HSP extent and saved localization |
| S30_checkv_regions | S30_checkv_regions | 39 | S4b, S4c | CheckV viral and host region boundaries of the flagged records |
| S31_checkv_flagged_records | S31_checkv_flagged_records | 19 | S4b; Supplementary Note 3 | The 19 flagged records with gene counts, contamination and the number of VF hits |
| S32_vf_models | S32_vf_models | 4 | F4C | The four saved negative-binomial models with their two definition axes |
| S33_vf_model_bridge | S33_vf_model_bridge | 3 | F4, S4 | How 3,060 vOTUs relate to the 3,013 used by the models |
| S34_construct_endpoints | S34_construct_endpoints | 3 | Supplementary Note 3 | The three controlled-construct endpoints with their own denominators |
| S35_construct_detection | S35_construct_detection | 6 | Supplementary Note 3 | Provirus flag rate per viral window and flank proportion |
| S36_construct_below95 | S36_construct_below95 | 33 | Supplementary Note 3 | The 33 individual constructs retaining less than 95% of viral bases |
| S37_gaps | S37_gaps | 2 | Data 1 only | Community-side gaps: what was not exported or not done in the source project |
| S38_function_gaps | S38_function_gaps | 4 | S3 | Function-side gaps: analyses done in the source project whose per-item tables were not exported |
| S39_feature_taxonomy | S39_feature_taxonomy | 6998 | F1 | Taxonomy of every feature of the three assays, the table behind the composition sheets |
| S40_vf_model_excluded | S40_vf_model_excluded | 47 | F4, S4 | The 47 vOTU IDs excluded from the four models, with the reason |
| S41_construct_strata | S41_construct_strata | 896 | Supplementary Note 3 | Per-stratum construct results behind the endpoints of Supplementary Figure 4 |
| S42_narp_gene_pairs | S42_narp_gene_pairs | 12 | F3, S3c | The gene rows behind the KO co-occurrence rule (K03462 + K13522) with coordinates and hits |
| S43_amg_pathway_carriers | S43_amg_pathway_carriers | 934 | Data 1 only | Carrier contributions at the curated-pathway feature level: the rows behind the pathway matrix S18 |
| S44_amg_dbid_carriers | S44_amg_dbid_carriers | 772 | Table 1 | Carrier contributions at the dbID feature level: the widest AMG carrier definition |
| S45_amg_dbid_only_carriers | S45_amg_dbid_only_carriers | 16 | Table 1 | The 16 vOTUs that carry an AMG dbID entry but none of the 138 KOs, i.e. the difference between the 560 and the 544 |
| S46_vf_sample_abundance | S46_vf_sample_abundance | 7 | F4A | Per-sample abundance of candidate VF carriers under the four annotation definitions, with the technical normalization denominators |
| S47_vf_carrier_abundance | S47_vf_carrier_abundance | 798 | F4B | All 114 filtered-annotation carriers in all seven samples: depth, breadth, detection, catalogue share, eligibility under each definition and the heatmap selection |
| S48_vf_match_evidence | S48_vf_match_evidence | 143 | F4A, F4B, S4A | All 143 filtered VFDB-A matches with identity, coverage, strict status, region localization and inclusion under each definition |
| S49_host_codetection_by_sample | S49_host_codetection_by_sample | 1603 | F2d, S2c | Per-sample detail behind the co-detection counts of Figure 2d: each of the 200 iPHoP records and 29 strict CRISPR edges in each of the seven samples |
| S50_rarefaction_curves | S50_rarefaction_curves | 2230 | S1C | Read-subsampling curves within the retained count tables: expected features observed when n reads are drawn from a sample’s own reads, for unmasked and breadth-masked virome counts, filtered 16S ASVs and microeukaryote 18S ASVs |
| S51_f3_ko_labels | S51_f3_ko_labels | 11 | F3A | Short display names of the 11 KO rows of Figure 3a, one row per KO, with the full KO annotation and the basis for each name |
| S52_narp_sample_abundance | S52_narp_sample_abundance | 49 | S3b | Abundance of the five DefenseFinder NARP2-carrying vOTUs and the two other nadM (K13522) carriers in each of the seven samples |
| S53_defense_type_inventory | S53_defense_type_inventory | 26 | F3C | DefenseFinder subtypes and PADLOC system types called on the local catalogue, with carrier counts, CheckV classes and notes on selected candidates |
| S54_process_community | S54_process_community | 6 | Supplementary Note 5; F2 context | Both positions of the three designated comparisons: contribution of the fixed shared qualifying set and of position-only qualifying members |
| S55_process_VF_contribution | S55_process_VF_contribution | 24 | Supplementary Note 5; F4 context | Both positions of the three designated comparisons under all four existing VF definitions, with shared and position-only carrier contributions and mapping diagnostics |
| S56_sharing_patterns | S56_sharing_patterns | 26 | S2a | All observed exact seven-sample qualification patterns, intersection counts and their sample-specific abundance contributions |
| S57_sharing_samples | S57_sharing_samples | 7 | S2a,b | Seven sample totals and the member counts and abundance contributions of sample-only versus other-sample-shared members |
| S58_sharing_members | S58_sharing_members | 3060 | F2d, S2a,b | Complete catalogue register of exact membership, seven qualification flags and full-catalogue abundance contributions |
| S59_AMG_host_register | S59_AMG_host_register | 544 | F3; Note 1 | All AMG-export KO carriers with the retained primary host prediction and same-sample co-detection status, including unresolved carriers |
| S60_KO_host_paths | S60_KO_host_paths | 22 | Note 1; learning-page exploration | Every KO-carrier association among carriers with a retained primary predicted host genus co-detected in the same sample |
| S61_lifestyle_carriage | S61_lifestyle_carriage | 24 | Note 3; learning-page exploration | Complete descriptive carrier proportions for six candidate sets under both operational lifestyle rules, with sequence-length and recovery context |

### Task 3: Write the workbook and TSVs

| item | status | note |
|:---|:---|:---|
| Data1_local.xlsx | written | 61 data sheets plus INDEX and FIELDS (63 worksheets), written with writexl 1.5.4 |

### Task 4: Record checks and the run

| check | expected | observed | pass |
|:---|:---|:---|:---|
| S56_sharing_patterns keeps seven-bit membership identifiers | TRUE | TRUE | TRUE |
| S58_sharing_members keeps seven-bit membership identifiers | TRUE | TRUE | TRUE |
| six literature-integration tables have complete intended row counts | 26, 7, 3060, 544, 22, 24 | 26, 7, 3060, 544, 22, 24 | TRUE |
| S46: normalization audit covers exactly the same samples | TRUE | TRUE | TRUE |
| S46: one normalization row per sample | 7 | 7 | TRUE |
| S46: no sample lost or duplicated by the join | 7 | 7 | TRUE |
| S46 now carries the PMCR diagnostic the table note claims | TRUE | TRUE | TRUE |
| S47: every heatmap member exists in the carrier table | TRUE | TRUE | TRUE |
| S47: the join adds no row | 798 | 798 | TRUE |
| S47 now carries the max value and selection rule the note claims | TRUE | TRUE | TRUE |
| S47: max value is filled for exactly the 18 heatmap members | 18 | 18 | TRUE |
| S17_amg_ko_matrix: all seven samples present | TRUE | TRUE | TRUE |
| S18_amg_pathway_matrix: all seven samples present | TRUE | TRUE | TRUE |
| wide matrices follow the configured sample order | bc1,bd1,bc2,gc1,gd1,oc1,od1, bc1,bd1,bc2,gc1,gd1,oc1,od1 | bc1,bd1,bc2,gc1,gd1,oc1,od1, bc1,bd1,bc2,gc1,gd1,oc1,od1 | TRUE |
| numeric columns are numeric after conversion (catalogue length, KO matrix) | TRUE, TRUE | TRUE, TRUE | TRUE |
| no empty sheet | TRUE | TRUE | TRUE |
| sheet names are unique and \<= 31 characters (Excel limit) | TRUE, TRUE | TRUE, TRUE | TRUE |
| catalogue sheet has 3,060 rows | 3060 | 3060 | TRUE |
| full KO matrix has 138 rows | 138 | 138 | TRUE |
| pathway matrix has 68 rows | 68 | 68 | TRUE |
| composition sheet has 413 rows | 413 | 413 | TRUE |
| VF hits sheet has 20 rows | 20 | 20 | TRUE |
| definitions.tsv:vf_model_excluded | 47 | 47 | TRUE |
| three AMG feature levels delivered (KO, pathway, dbID rows) | 731, 934, 772 | 731, 934, 772 | TRUE |
| definitions.tsv:amg_carriers_ko | 544 | 544 | TRUE |
| definitions.tsv:amg_carriers_dbid | 560 | 560 | TRUE |
| the dbID-only sheet is exactly the difference between the two carrier definitions | vOTU0001, vOTU0031, vOTU0182, vOTU0220, vOTU0532, … (16 values) | vOTU0001, vOTU0031, vOTU0182, vOTU0220, vOTU0532, … (16 values) | TRUE |
| pathway carriers cover exactly the 68 pathways of S18 | map00010, map00020, map00030, map00040, map00051, … (68 values) | map00010, map00020, map00030, map00040, map00051, … (68 values) | TRUE |
| field dictionary agrees with the delivered values (missing rules, ranges, code sets) |  |  | TRUE |
| every delivered field has exactly one dictionary row | 647 | 647 | TRUE |
| no duplicated sheet/field pair in the dictionary | FALSE | FALSE | TRUE |
| every field of the model, resampling and construct sheets is curated | 0 | 0 | TRUE |
| every numeric field is curated and states a unit or code | 0 | 0 | TRUE |
| workbook sheets read back equal INDEX, FIELDS plus every sheet | INDEX, FIELDS, S01_samples, S02_composition_full, S03_composition_display, … (63 values) | INDEX, FIELDS, S01_samples, S02_composition_full, S03_composition_display, … (63 values) | TRUE |
| catalogue sheet read back: rows and numeric length column | 3060, TRUE | 3060, TRUE | TRUE |

| file                               |   bytes | sha256           |
|:-----------------------------------|--------:|:-----------------|
| S54_process_community.tsv          |    1245 | b5a2d89f44d00e10 |
| S55_process_VF_contribution.tsv    |    3417 | 894450801c234d63 |
| Data1_local.xlsx                   | 1380977 | 35a913ec580ec9c2 |
| data1-index.tsv                    |   18167 | 8549239b799450c4 |
| data1-README.md                    |    9584 | c4180b42e13b2862 |
| data1-workbook-status.tsv          |     123 | 6314db0b26befd35 |
| data1-checks.tsv                   |    3212 | fb058873d686c32c |
| session-info.txt                   |   13694 | 8b069de524db1cb7 |
| S01_samples.tsv                    |    2291 | b24cea2679ddd05c |
| S02_composition_full.tsv           |   37852 | 25440c390bf55406 |
| S03_composition_display.tsv        |    8979 | 554402eec51f8bb7 |
| S04_taxon_display_map.tsv          |    9364 | dc664765f6b26646 |
| S05_alpha.tsv                      |    4004 | da2ac1214a391ada |
| S06_virome_alpha_detail.tsv        |     703 | b23b3c762d0e955c |
| S07_label_pairs.tsv                |     877 | 9218fd9a4ce22e46 |
| S08_pcoa.tsv                       |    2267 | 9efa4f8a4a352461 |
| S09_crossomics.tsv                 |     881 | d6d1ea10a35d6afa |
| S10_permanova.tsv                  |    2986 | 9ac1b8ddb13af95c |
| S11_betadisper.tsv                 |    5432 | 47c5deffeb3f62c5 |
| S12_host_iphop.tsv                 |   88225 | d51631785bcada5b |
| S13_host_crispr.tsv                |    3712 | e4bdf9caac71977e |
| S14_checkv_catalogue.tsv           |  273709 | 892da3acdfb61f6c |
| S15_depth.tsv                      |     302 | 3595700ea2e67d54 |
| S16_saturation.tsv                 |    3857 | 2961cd641b5584c4 |
| S17_amg_ko_matrix.tsv              |   19856 | d85c5e408ad00e2b |
| S18_amg_pathway_matrix.tsv         |    9909 | 4acc9440365db375 |
| S19_amg_carriers.tsv               |  124598 | f5f20d47e3f91799 |
| S20_f3_display.tsv                 |    2599 | bedac122ef8f4b3a |
| S21_f3_carrier_ranks.tsv           |    1829 | f4aab222d32ce02a |
| S22_f3_carrier_hosts.tsv           |   18152 | 67e0655e56c80a44 |
| S23_defense_sets.tsv               |     452 | 3c6ccbedc53e8ddb |
| S24_defense_membership.tsv         |   67373 | 6a01ecc31017f1d2 |
| S25_narp_definitions.tsv           |     875 | 39842e01520a9d5a |
| S26_votu0052_locus.tsv             |     719 | d767275b1847550a |
| S27_votu0052_defensefinder.tsv     |     650 | 31b6715396ef7ab1 |
| S28_narp_case_evidence.tsv         |   12445 | bfefff2de548ae5e |
| S29_vf_hits.tsv                    |    4159 | 95cd3eda0a1705f7 |
| S30_checkv_regions.tsv             |    1425 | 65a4ed1e8cfa4e3c |
| S31_checkv_flagged_records.tsv     |    1089 | 96b245c1aaf3a43a |
| S32_vf_models.tsv                  |    1927 | 5441aa6c13c6328c |
| S33_vf_model_bridge.tsv            |     232 | 8f9d670f4dba966e |
| S34_construct_endpoints.tsv        |    1165 | 254ca10d2aa1003e |
| S35_construct_detection.tsv        |     500 | 23aabd78e71bcddd |
| S36_construct_below95.tsv          |    3322 | 56524cc3dd998ed7 |
| S37_gaps.tsv                       |     459 | 624dc7d5066ae68d |
| S38_function_gaps.tsv              |     827 | 8518c1d918a07627 |
| S39_feature_taxonomy.tsv           |  504123 | f491d04eb433d048 |
| S40_vf_model_excluded.tsv          |    7999 | dee68183c6f1dae1 |
| S41_construct_strata.tsv           |   83525 | 58000afa63394e74 |
| S42_narp_gene_pairs.tsv            |    4051 | 16e841fed68df77f |
| S43_amg_pathway_carriers.tsv       |  136287 | 3516219c1de5265f |
| S44_amg_dbid_carriers.tsv          |  144503 | 3d358bb8b3d10531 |
| S45_amg_dbid_only_carriers.tsv     |    1709 | a818d2ccf6f8e274 |
| S46_vf_sample_abundance.tsv        |    4652 | 7972600b1d3822f1 |
| S47_vf_carrier_abundance.tsv       |  168025 | 03b18ae7edd11d35 |
| S48_vf_match_evidence.tsv          |   38590 | 3c3bb32ff6de6b75 |
| S49_host_codetection_by_sample.tsv |  164681 | ec72956a5fcc66f5 |
| S50_rarefaction_curves.tsv         |  141962 | b99bf0a8d2f70ec1 |
| S51_f3_ko_labels.tsv               |    2792 | 9d5a718e72e8bc64 |
| S52_narp_sample_abundance.tsv      |   11160 | cce0007bfec92d32 |
| S53_defense_type_inventory.tsv     |    5746 | 0938ab551e249f6b |
| data1-field-dictionary.tsv         |  182035 | 92f4ba2e4452b193 |
| S56_sharing_patterns.tsv           |    2189 | 92ac3b04e12b5385 |
| S57_sharing_samples.tsv            |     822 | 2dbf922bd1532717 |
| S58_sharing_members.tsv            |  203777 | 036a4da9b520d042 |
| S59_AMG_host_register.tsv          |  108725 | 9dcfe16f2ee1e596 |
| S60_KO_host_paths.tsv              |    3011 | 51becb24c2deb28a |
| S61_lifestyle_carriage.tsv         |    2527 | 94207b3a55ba4357 |

Outputs recorded in step-record.json

</details>

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/320-data1-local/S54_process_community.tsv">S54_process_community.tsv</a> (1.2 KB)</li>
<li><a href="data/320-data1-local/S55_process_VF_contribution.tsv">S55_process_VF_contribution.tsv</a> (3.3 KB)</li>
<li><a href="data/320-data1-local/Data1_local.xlsx">Data1_local.xlsx</a> (1348.6 KB)</li>
<li><a href="data/320-data1-local/data1-index.tsv">data1-index.tsv</a> (17.7 KB)</li>
<li><a href="data/320-data1-local/data1-README.md">data1-README.md</a> (9.4 KB)</li>
<li><a href="data/320-data1-local/data1-workbook-status.tsv">data1-workbook-status.tsv</a> (0.1 KB)</li>
<li><a href="data/320-data1-local/data1-checks.tsv">data1-checks.tsv</a> (3.1 KB)</li>
<li><a href="data/320-data1-local/session-info.txt">session-info.txt</a> (13.4 KB)</li>
<li><a href="data/320-data1-local/S01_samples.tsv">S01_samples.tsv</a> (2.2 KB)</li>
<li><a href="data/320-data1-local/S02_composition_full.tsv">S02_composition_full.tsv</a> (37 KB)</li>
<li><a href="data/320-data1-local/S03_composition_display.tsv">S03_composition_display.tsv</a> (8.8 KB)</li>
<li><a href="data/320-data1-local/S04_taxon_display_map.tsv">S04_taxon_display_map.tsv</a> (9.1 KB)</li>
<li><a href="data/320-data1-local/S05_alpha.tsv">S05_alpha.tsv</a> (3.9 KB)</li>
<li><a href="data/320-data1-local/S06_virome_alpha_detail.tsv">S06_virome_alpha_detail.tsv</a> (0.7 KB)</li>
<li><a href="data/320-data1-local/S07_label_pairs.tsv">S07_label_pairs.tsv</a> (0.9 KB)</li>
<li><a href="data/320-data1-local/S08_pcoa.tsv">S08_pcoa.tsv</a> (2.2 KB)</li>
<li><a href="data/320-data1-local/S09_crossomics.tsv">S09_crossomics.tsv</a> (0.9 KB)</li>
<li><a href="data/320-data1-local/S10_permanova.tsv">S10_permanova.tsv</a> (2.9 KB)</li>
<li><a href="data/320-data1-local/S11_betadisper.tsv">S11_betadisper.tsv</a> (5.3 KB)</li>
<li><a href="data/320-data1-local/S12_host_iphop.tsv">S12_host_iphop.tsv</a> (86.2 KB)</li>
<li><a href="data/320-data1-local/S13_host_crispr.tsv">S13_host_crispr.tsv</a> (3.6 KB)</li>
<li><a href="data/320-data1-local/S14_checkv_catalogue.tsv">S14_checkv_catalogue.tsv</a> (267.3 KB)</li>
<li><a href="data/320-data1-local/S15_depth.tsv">S15_depth.tsv</a> (0.3 KB)</li>
<li><a href="data/320-data1-local/S16_saturation.tsv">S16_saturation.tsv</a> (3.8 KB)</li>
<li><a href="data/320-data1-local/S17_amg_ko_matrix.tsv">S17_amg_ko_matrix.tsv</a> (19.4 KB)</li>
<li><a href="data/320-data1-local/S18_amg_pathway_matrix.tsv">S18_amg_pathway_matrix.tsv</a> (9.7 KB)</li>
<li><a href="data/320-data1-local/S19_amg_carriers.tsv">S19_amg_carriers.tsv</a> (121.7 KB)</li>
<li><a href="data/320-data1-local/S20_f3_display.tsv">S20_f3_display.tsv</a> (2.5 KB)</li>
<li><a href="data/320-data1-local/S21_f3_carrier_ranks.tsv">S21_f3_carrier_ranks.tsv</a> (1.8 KB)</li>
<li><a href="data/320-data1-local/S22_f3_carrier_hosts.tsv">S22_f3_carrier_hosts.tsv</a> (17.7 KB)</li>
<li><a href="data/320-data1-local/S23_defense_sets.tsv">S23_defense_sets.tsv</a> (0.4 KB)</li>
<li><a href="data/320-data1-local/S24_defense_membership.tsv">S24_defense_membership.tsv</a> (65.8 KB)</li>
<li><a href="data/320-data1-local/S25_narp_definitions.tsv">S25_narp_definitions.tsv</a> (0.9 KB)</li>
<li><a href="data/320-data1-local/S26_votu0052_locus.tsv">S26_votu0052_locus.tsv</a> (0.7 KB)</li>
<li><a href="data/320-data1-local/S27_votu0052_defensefinder.tsv">S27_votu0052_defensefinder.tsv</a> (0.6 KB)</li>
<li><a href="data/320-data1-local/S28_narp_case_evidence.tsv">S28_narp_case_evidence.tsv</a> (12.2 KB)</li>
<li><a href="data/320-data1-local/S29_vf_hits.tsv">S29_vf_hits.tsv</a> (4.1 KB)</li>
<li><a href="data/320-data1-local/S30_checkv_regions.tsv">S30_checkv_regions.tsv</a> (1.4 KB)</li>
<li><a href="data/320-data1-local/S31_checkv_flagged_records.tsv">S31_checkv_flagged_records.tsv</a> (1.1 KB)</li>
<li><a href="data/320-data1-local/S32_vf_models.tsv">S32_vf_models.tsv</a> (1.9 KB)</li>
<li><a href="data/320-data1-local/S33_vf_model_bridge.tsv">S33_vf_model_bridge.tsv</a> (0.2 KB)</li>
<li><a href="data/320-data1-local/S34_construct_endpoints.tsv">S34_construct_endpoints.tsv</a> (1.1 KB)</li>
<li><a href="data/320-data1-local/S35_construct_detection.tsv">S35_construct_detection.tsv</a> (0.5 KB)</li>
<li><a href="data/320-data1-local/S36_construct_below95.tsv">S36_construct_below95.tsv</a> (3.2 KB)</li>
<li><a href="data/320-data1-local/S37_gaps.tsv">S37_gaps.tsv</a> (0.4 KB)</li>
<li><a href="data/320-data1-local/S38_function_gaps.tsv">S38_function_gaps.tsv</a> (0.8 KB)</li>
<li><a href="data/320-data1-local/S39_feature_taxonomy.tsv">S39_feature_taxonomy.tsv</a> (492.3 KB)</li>
<li><a href="data/320-data1-local/S40_vf_model_excluded.tsv">S40_vf_model_excluded.tsv</a> (7.8 KB)</li>
<li><a href="data/320-data1-local/S41_construct_strata.tsv">S41_construct_strata.tsv</a> (81.6 KB)</li>
<li><a href="data/320-data1-local/S42_narp_gene_pairs.tsv">S42_narp_gene_pairs.tsv</a> (4 KB)</li>
<li><a href="data/320-data1-local/S43_amg_pathway_carriers.tsv">S43_amg_pathway_carriers.tsv</a> (133.1 KB)</li>
<li><a href="data/320-data1-local/S44_amg_dbid_carriers.tsv">S44_amg_dbid_carriers.tsv</a> (141.1 KB)</li>
<li><a href="data/320-data1-local/S45_amg_dbid_only_carriers.tsv">S45_amg_dbid_only_carriers.tsv</a> (1.7 KB)</li>
<li><a href="data/320-data1-local/S46_vf_sample_abundance.tsv">S46_vf_sample_abundance.tsv</a> (4.5 KB)</li>
<li><a href="data/320-data1-local/S47_vf_carrier_abundance.tsv">S47_vf_carrier_abundance.tsv</a> (164.1 KB)</li>
<li><a href="data/320-data1-local/S48_vf_match_evidence.tsv">S48_vf_match_evidence.tsv</a> (37.7 KB)</li>
<li><a href="data/320-data1-local/S49_host_codetection_by_sample.tsv">S49_host_codetection_by_sample.tsv</a> (160.8 KB)</li>
<li><a href="data/320-data1-local/S50_rarefaction_curves.tsv">S50_rarefaction_curves.tsv</a> (138.6 KB)</li>
<li><a href="data/320-data1-local/S51_f3_ko_labels.tsv">S51_f3_ko_labels.tsv</a> (2.7 KB)</li>
<li><a href="data/320-data1-local/S52_narp_sample_abundance.tsv">S52_narp_sample_abundance.tsv</a> (10.9 KB)</li>
<li><a href="data/320-data1-local/S53_defense_type_inventory.tsv">S53_defense_type_inventory.tsv</a> (5.6 KB)</li>
<li><a href="data/320-data1-local/data1-field-dictionary.tsv">data1-field-dictionary.tsv</a> (177.8 KB)</li>
<li><a href="data/320-data1-local/S56_sharing_patterns.tsv">S56_sharing_patterns.tsv</a> (2.1 KB)</li>
<li><a href="data/320-data1-local/S57_sharing_samples.tsv">S57_sharing_samples.tsv</a> (0.8 KB)</li>
<li><a href="data/320-data1-local/S58_sharing_members.tsv">S58_sharing_members.tsv</a> (199 KB)</li>
<li><a href="data/320-data1-local/S59_AMG_host_register.tsv">S59_AMG_host_register.tsv</a> (106.2 KB)</li>
<li><a href="data/320-data1-local/S60_KO_host_paths.tsv">S60_KO_host_paths.tsv</a> (2.9 KB)</li>
<li><a href="data/320-data1-local/S61_lifestyle_carriage.tsv">S61_lifestyle_carriage.tsv</a> (2.5 KB)</li>
</ul>

</details>
