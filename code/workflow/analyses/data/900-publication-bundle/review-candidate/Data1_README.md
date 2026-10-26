# Data 1 (local): sheet dictionary

One sheet per table; tables with different units are never merged into one sheet.

In the review bundle this file sits next to `Data1_local.xlsx`, the sheet overview
`Data1_sheet_index.tsv`, the field-level dictionary `Data1_field_dictionary.tsv`
(one row per sheet and field, with units and missing-value rules) and one TSV per
sheet under `Data1_tables/<sheet>.tsv`. The workbook carries the same two
dictionaries as its INDEX and FIELDS sheets.

| Sheet | Rows | Figures | Content |
|---|---:|---|---|
| S01_samples | 7 | F1, F2, S1, S2 | Seven water samples: fixed order, site, record label, assay IDs and read counts |
| S02_composition_full | 413 | F1 | Full composition of all 59 taxa x 7 samples in three assays, with the display category of each taxon |
| S03_composition_display | 196 | F1 | Composition after the frozen display aggregation (top 8 named taxa per amplicon assay, all viral classes) |
| S04_taxon_display_map | 59 | F1 | Which taxon was mapped to which display category, with the rule and the 7-sample mean used to rank |
| S05_alpha | 21 | F2 | Shannon and observed richness per assay and sample, each with its own definition |
| S06_virome_alpha_detail | 7 | F2, S1 | Masked viral alpha diversity with rarefied and unrarefied values and the rarefaction spread |
| S07_label_pairs | 9 | F2 | Same-site c/d record-label contrasts as saved (difference = dirty minus clean) |
| S08_pcoa | 21 | F2 | Saved Aitchison PCoA coordinates per assay and sample |
| S09_crossomics | 3 | F2c (Mantel); table formerly drawn as S1E | All three cross-assay statistics for the three assay pairs: Mantel r, Procrustes correlation and RV coefficient; the ranking of the two virome pairs depends on the statistic |
| S10_permanova | 36 | table formerly drawn as S1D | Marginal PERMANOVA for every distance of each assay, location and c/d label terms retained; the virome location term depends on the distance (Aitchison p = 0.725; Bray-Curtis 0.001; Jaccard 0.002) |
| S11_betadisper | 36 | table formerly drawn as S1D | Dispersion checks for every distance and grouping, with the saved status (flagged / method-dependent / not flagged) |
| S12_host_iphop | 200 | F2d, S2c; Note 1 Table C | All 200 iPHoP records at score >= 90 with the corrected genus and the visibility status |
| S13_host_crispr | 29 | F2 | The 29 strict CRISPR edges (25 vOTUs, 22 genera) with co-detection and mismatch fields |
| S14_checkv_catalogue | 3060 | F1, F4, F5, S1, S4 | All 3,060 vOTUs with CheckV class, estimated completeness, length and predicted gene count |
| S15_depth | 7 | S1 | Masked richness and sequencing depth per sample |
| S16_saturation | 21 | table formerly drawn as S1C | Historical saturation diagnostics at full depth from the source project, with the definition of each layer; kept for reference, not evidence of sampling sufficiency |
| S17_amg_ko_matrix | 138 | F3 | All 138 AMG candidate KOs x 7 samples |
| S18_amg_pathway_matrix | 68 | Data 1 only | All 68 curated metabolism pathways x 7 samples |
| S19_amg_carriers | 731 | F3; Note 1 Table C | Every KO-carrier pair with its per-sample TPM, contribution fraction and rank (KO feature level) |
| S20_f3_display | 11 | F3 | The frozen 11-row display list with the selection rule and the saved totals |
| S21_f3_carrier_ranks | 44 | F3 | Top 1/2/3 and remaining carrier shares for each displayed KO |
| S22_f3_carrier_hosts | 276 | Note 1 Table C | Carriers of the displayed KOs joined to the checked iPHoP >= 90 members |
| S23_defense_sets | 6 | F3 | Each defense and anti-defense set with its tool, rule and denominator |
| S24_defense_membership | 3060 | F3, F5 | Per-vOTU membership of each tool set and of the anti-defense union, with the predicted gene count |
| S25_narp_definitions | 19 | F3, S3a | Membership of every NARP-related vOTU under four operational definitions, with its CheckV class |
| S26_votu0052_locus | 3 | F3, S3c | Coordinates and annotations of ORF101-103 of vOTU0052 |
| S27_votu0052_defensefinder | 3 | S3 | DefenseFinder gene rows for vOTU0052, including the separate atd1 call |
| S28_narp_case_evidence | 29 | S3d and Supplementary Note 1 | Case values reported in project documents (coverage, HE targeting, ORF102 domains, global NARP), with file and line; the coverage and HE-targeting rows are Tables A and B of Supplementary Note 1 (formerly drawn as S2e, S2f) |
| S29_vf_hits | 20 | S4b, S4c; Supplementary Note 3 | The 20 VF hits with protein coordinates, HSP extent and saved localization |
| S30_checkv_regions | 39 | S4b, S4c | CheckV viral and host region boundaries of the flagged records |
| S31_checkv_flagged_records | 19 | S4b; Supplementary Note 3 | The 19 flagged records with gene counts, contamination and the number of VF hits |
| S32_vf_models | 4 | F4C | The four saved negative-binomial models with their two definition axes |
| S33_vf_model_bridge | 3 | F4, S4 | How 3,060 vOTUs relate to the 3,013 used by the models |
| S34_construct_endpoints | 3 | Supplementary Note 3 | The three controlled-construct endpoints with their own denominators |
| S35_construct_detection | 6 | Supplementary Note 3 | Provirus flag rate per viral window and flank proportion |
| S36_construct_below95 | 33 | Supplementary Note 3 | The 33 individual constructs retaining less than 95% of viral bases |
| S37_gaps | 2 | Data 1 only | Community-side gaps: what was not exported or not done in the source project |
| S38_function_gaps | 4 | S3 | Function-side gaps: analyses done in the source project whose per-item tables were not exported |
| S39_feature_taxonomy | 6998 | F1 | Taxonomy of every feature of the three assays, the table behind the composition sheets |
| S40_vf_model_excluded | 47 | F4, S4 | The 47 vOTU IDs excluded from the four models, with the reason |
| S41_construct_strata | 896 | Supplementary Note 3 | Per-stratum construct results behind the endpoints of Supplementary Figure 4 |
| S42_narp_gene_pairs | 12 | F3, S3c | The gene rows behind the KO co-occurrence rule (K03462 + K13522) with coordinates and hits |
| S43_amg_pathway_carriers | 934 | Data 1 only | Carrier contributions at the curated-pathway feature level: the rows behind the pathway matrix S18 |
| S44_amg_dbid_carriers | 772 | Table 1 | Carrier contributions at the dbID feature level: the widest AMG carrier definition |
| S45_amg_dbid_only_carriers | 16 | Table 1 | The 16 vOTUs that carry an AMG dbID entry but none of the 138 KOs, i.e. the difference between the 560 and the 544 |
| S46_vf_sample_abundance | 7 | F4A | Per-sample abundance of candidate VF carriers under the four annotation definitions, with the technical normalization denominators |
| S47_vf_carrier_abundance | 798 | F4B | All 114 filtered-annotation carriers in all seven samples: depth, breadth, detection, catalogue share, eligibility under each definition and the heatmap selection |
| S48_vf_match_evidence | 143 | F4A, F4B, S4A | All 143 filtered VFDB-A matches with identity, coverage, strict status, region localization and inclusion under each definition |
| S49_host_codetection_by_sample | 1603 | F2d, S2c | Per-sample detail behind the co-detection counts of Figure 2d: each of the 200 iPHoP records and 29 strict CRISPR edges in each of the seven samples |
| S50_rarefaction_curves | 2230 | S1C | Read-subsampling curves within the retained count tables: expected features observed when n reads are drawn from a sample's own reads, for unmasked and breadth-masked virome counts, filtered 16S ASVs and microeukaryote 18S ASVs |
| S51_f3_ko_labels | 11 | F3A | Short display names of the 11 KO rows of Figure 3a, one row per KO, with the full KO annotation and the basis for each name |
| S52_narp_sample_abundance | 49 | S3b | Abundance of the five DefenseFinder NARP2-carrying vOTUs and the two other nadM (K13522) carriers in each of the seven samples |
| S53_defense_type_inventory | 26 | F3C | DefenseFinder subtypes and PADLOC system types called on the local catalogue, with carrier counts, CheckV classes and notes on selected candidates |
| S54_process_community | 6 | Supplementary Note 5; F2 context | Both positions of the three designated comparisons: contribution of the fixed shared qualifying set and of position-only qualifying members |
| S55_process_VF_contribution | 24 | Supplementary Note 5; F4 context | Both positions of the three designated comparisons under all four existing VF definitions, with shared and position-only carrier contributions and mapping diagnostics |
| S56_sharing_patterns | 26 | S2a | All observed exact seven-sample qualification patterns, intersection counts and their sample-specific abundance contributions |
| S57_sharing_samples | 7 | S2a,b | Seven sample totals and the member counts and abundance contributions of sample-only versus other-sample-shared members |
| S58_sharing_members | 3060 | F2d, S2a,b | Complete catalogue register of exact membership, seven qualification flags and full-catalogue abundance contributions |
| S59_AMG_host_register | 544 | F3; Note 1 | All AMG-export KO carriers with the retained primary host prediction and same-sample co-detection status, including unresolved carriers |
| S60_KO_host_paths | 22 | Note 1; learning-page exploration | Every KO-carrier association among carriers with a retained primary predicted host genus co-detected in the same sample |
| S61_lifestyle_carriage | 24 | Note 3; learning-page exploration | Complete descriptive carrier proportions for six candidate sets under both operational lifestyle rules, with sequence-length and recovery context |
