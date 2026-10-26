# Data 2 (global reference arm): sheet dictionary

One sheet per table. Local tables live in Data 1; the only local table here is the
six-bin summary plotted in Figure 5A. Global summaries and limitations are in Supplementary Note 4.

In the review bundle this file sits next to `Data2_global.xlsx`, the sheet overview
`Data2_sheet_index.tsv`, the field-level dictionary `Data2_field_dictionary.tsv`
(one row per sheet and field, with units and missing-value rules) and one TSV per
sheet under `Data2_tables/<sheet>.tsv`. The workbook carries the same two
dictionaries as its INDEX and FIELDS sheets.

| Sheet | Rows | Figures | Content |
|---|---:|---|---|
| G01_feature_fits | 323 | F5B, Supplementary Note 4 | Coefficient of every feature in the two fixed sets (285 metabolic Pfam domains, 38 non-NARP anti-defense profiles), with the saved opportunity diagnostics of the same fits (fixed-opportunity cloglog model, free exponent gamma, logit projection and their validity/warnings) |
| G02_group_medians | 2 | F5B | Median coefficient and sign counts of each fixed set |
| G03_profile_support | 38 | F5C, Supplementary Note 4 | Carrier genomes and gene-sharing clusters behind each of the 38 profiles |
| G04_local_carriage_bins | 6 | F5A | The six saved local bins of predicted genes per recovered vOTU (kept here because they are plotted in Figure 5A) |
| G05_adjusted | 4 | Supplementary Note 4 | Validity of the separate ecosystem and host-phylum adjustments for the fixed comparison |
| G06_firth | 6 | Supplementary Note 4 | Firth sensitivity fits, unadjusted and under each separate adjustment |
| G07_resampling | 4 | Supplementary Note 4 | How often the full fixed comparison was estimable in each resampling scheme (summary of G17) |
| G08_strata | 14 | Supplementary Note 4 | Stratum sizes of the ecosystem and host-phylum labels |
| G09_nad_leaveout | 9 | Supplementary Note 4 | The six NAD-pathway domains and the metabolic median with and without them |
| G10_gaps | 4 | Supplementary Note 4 | Global-side analyses that were not done, are incomplete, or were not established in the source project; original S4 wording in the saved records now refers to Supplementary Note 4 |
| G11_adjusted_fits | 646 | Supplementary Note 4 | Every per-feature fit of the two separate adjustments, including the ones that were not estimable |
| G12_firth_feature_fits | 969 | Supplementary Note 4 | Every per-feature Firth-penalised fit behind the medians of Supplementary Note 4 |
| G13_stratum_fits | 3230 | Supplementary Note 4 | Per-feature fits within each ecosystem and host-phylum stratum |
| G14_aggregation_fits | 43 | Supplementary Note 4 | HISTORICAL, withdrawn, audit only: fits of aggregation units formed by the old direct category join (21 fixed38 units; 22 all-profile units = legacy_mixed). Corrected post hoc categories are in G21; status in G19 |
| G15_aggregation_members | 104 | Supplementary Note 4 | HISTORICAL, withdrawn, audit only: profile-to-unit membership under the old direct join (equals G22 old_unit). Corrected mapping in G22 and G24 |
| G16_firth_run | 6 | Supplementary Note 4 | Run parameters of the Firth sensitivity fits |
| G17_resample_contrasts | 500 | Supplementary Note 4 | Every resampling replicate: whether the full fixed comparison was estimable and, when it was, the METAB-minus-ADF median difference |
| G18_resample_features | 80750 | Supplementary Note 4 | Per-replicate, per-feature diagnostics behind G17: which feature failed in which replicate, with its carrier count and warning text |
| G19_result_status | 13 | Supplementary Note 4 | Status of the historical, withdrawn and post hoc corrected global aggregation results and of the current fixed baseline, by sheet and rows |
| G20_repair_scenarios | 5 | Supplementary Note 4 | Saved scenario summary of the post hoc repair of the category join: fixed 285 and 38 baselines, two corrected category definitions (9 and 10 units), and the withdrawn legacy_mixed (22) |
| G21_repair_feature_fits | 364 | Supplementary Note 4 | All 364 saved fits of the repair run, with logit, fixed-opportunity, free-exponent and projection fields, validity flags and warnings as saved |
| G22_repair_members | 104 | Supplementary Note 4 | The 104 observed anti-defense profiles: corrected category, historical old-join unit and whether the mapping changed |
| G23_repair_scenario_members | 284 | Supplementary Note 4 | Profile-to-unit membership in profile38, legacy_mixed and the two corrected category scenarios |
| G24_repair_mapping | 356 | Supplementary Note 4 | Census expansion of 356 profiles to subtypes and categories used by the repair |
| G25_repair_eligibility | 12 | Supplementary Note 4 | All categories compared between the two corrected scenarios, including unchanged membership and eligibility |
