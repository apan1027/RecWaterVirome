# 010-input-manifest
Jinlong Ru, Cunli Pan
2026-10-23

**Updated: 2026-10-23 13:58:07 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 4 output files.
</p>

<p>

Key files:
<a href="data/010-input-manifest/input-manifest.tsv">input-manifest.tsv</a>
·
<a href="data/010-input-manifest/raw-input-manifest.tsv">raw-input-manifest.tsv</a>
·
<a href="data/010-input-manifest/science-input-status.tsv">science-input-status.tsv</a>
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

This step verifies registered design/configuration files against
metadata/frozen-files.tsv and staged scientific inputs against
metadata/raw-inputs.tsv. Inputs were copied or extracted read-only from
the source project with source paths and SHA256 provenance. Missing,
changed or unregistered raw files stop the step. The source project is
not accessed at runtime.

### Task 1: Verify the frozen-file register

The frozen-file register supplies the expected SHA256 of each registered
file. Every hash is recomputed and compared. The register itself is the
trust anchor; its own hash is recorded rather than compared with itself.

| path | role | bytes | status | sha256 |
|:---|:---|---:|:---|:---|
| metadata/frozen-files.tsv | register | 7487 | root of trust (no expected hash) | cb190f61f161a047 |
| archive/original-records/paper-framework/v2026.09.27.1.md | frozen-story | 7415 | match | 678a15fcf547bdfb |
| archive/original-records/figure-production-design-2026-09-27/01.md | frozen-design | 16869 | match | 6265097bc88158ac |
| archive/original-records/figure-production-design-2026-09-27/02-qproj.md | frozen-design | 8728 | match | d6e82e10c90f702b |
| archive/original-records/figure-production-design-2026-09-27/03-Claude.md | frozen-design | 4380 | match | 9bb08c9a482167f4 |
| config/style.yml | config | 4248 | match | 07c316c563f2f4ae |
| config/samples.tsv | config | 146 | match | d78164d7c020f6f5 |
| config/workflow.yml | config | 42809 | match | bf86d81b7afcabb3 |
| metadata/raw-inputs.tsv | raw-input-register | 67866 | match | c696a8a668d5ff46 |
| config/palettes.yml | config | 10535 | match | 4e26369292abab1d |
| config/figures.yml | config | 1827 | match | 54186035b7061c72 |
| config/definitions.tsv | config | 17667 | match | bc592e0d61475b88 |
| metadata/visual-review.tsv | metadata | 52245 | match | 1ca7934e64bfa303 |
| config/field-notes.tsv | config | 80193 | match | f190356ddff945b1 |
| config/community.yml | config | 1978 | match | 7afd3cc3a10d8ff8 |
| config/analysis-version.yml | config | 844 | match | 2935cff8fe2f9623 |
| DESCRIPTION | project | 1835 | match | 542f81044f872f6a |
| metadata/review-log.tsv | metadata | 7860 | match | dcca63671ef0cea7 |
| archive/original-records/codex-workflow-acceptance-2026-09-28/00.md | review-report | 9972 | match | 15c44465dd5fd035 |
| config/site-locations.tsv | config | 551 | match | 204ccb103c7a5f03 |
| config/f3-ko-labels.tsv | config | 1732 | match | bac4e14d2ab162a4 |
| archive/original-records/final-review-2026-10-12/01-Codex.md | review-report | 14645 | match | f68073acdaeb5114 |
| archive/original-records/final-review-2026-10-12/03-Codex.md | review-report | 7966 | match | a3d71d5ec7ae89ab |
| archive/original-records/figure3a-label-design-2026-10-13/08-Codex.md | review-report | 7493 | match | ebc41f32357adbd6 |
| archive/original-records/figure4-restructure-2026-10-14/00-Codex.md | review-report | 3288 | match | 8d568ede20e70f14 |
| docs/s4-note-adoption-2026-10-15/implementation-scope.md | implementation-scope | 1489 | match | 2e6bd60a0e4f5f69 |
| R/literature-summary.R | shared-source | 12414 | match | 9b225ec26f45adaf |
| archive/original-records/literature-integration-2026-10-15/implementation-scope.md | implementation-scope | 2052 | match | 692b14e74e830c60 |
| archive/original-records/figure-cleanup-v49-2026-10-19/04-Codex-v50.md | review-report | 6306 | match | c5e4fdab1e951ad1 |

input-manifest.tsv (sha256 shortened here; full values are in the file)

### Task 2: Verify staged scientific inputs

The raw-input register is itself hash-verified in Task 1. This task
recomputes each staged input hash; downstream steps access these
verified files through rwv_raw_input().

| consumer_step | files | bytes | status |
|:---|---:|---:|:---|
| all | 124 | 54461123 | migrated: every file in analyses/data/00-raw/ is registered and matches |
| 012-tse-construction | 12 | 29719037 | staged and hash-verified; reconstruction scope is defined by the consumer step |
| 014-legacy-comparison | 18 | 6053267 | staged and hash-verified; reconstruction scope is defined by the consumer step |
| 020-community-analysis | 21 | 1134047 | staged and hash-verified; reconstruction scope is defined by the consumer step |
| 030-function-inputs | 19 | 1606730 | staged and hash-verified; reconstruction scope is defined by the consumer step |
| 040-vf-inputs | 14 | 2954180 | staged and hash-verified; reconstruction scope is defined by the consumer step |
| 050-global-inputs | 29 | 5432429 | staged and hash-verified; reconstruction scope is defined by the consumer step |
| 220-sfig2-function-context | 11 | 7561433 | staged and hash-verified; reconstruction scope is defined by the consumer step |

science-input-status.tsv

| path | bytes | status | origin_path | sha256 |
|:---|---:|:---|:---|:---|
| analyses/data/00-raw/d020-community-analysis/composition_full.tsv | 33433 | match | outputs/version-selection-panel-2026-09-27/production-inputs/composition_full.tsv | 685e096b3742 |
| analyses/data/00-raw/d020-community-analysis/feature_taxonomy.tsv | 503815 | match | outputs/version-selection-panel-2026-09-27/production-inputs/feature_taxonomy.tsv | 696aae1bb259 |
| analyses/data/00-raw/d020-community-analysis/pcoa_aitchison.tsv | 2123 | match | outputs/version-selection-panel-2026-09-27/production-inputs/pcoa_aitchison.tsv | fdeaebaed847 |
| analyses/data/00-raw/d020-community-analysis/export_checks.tsv | 321 | match | outputs/version-selection-panel-2026-09-27/production-inputs/export_checks.tsv | 7bbc4f7fa046 |
| analyses/data/00-raw/d020-community-analysis/production_input_manifest.json | 1685 | match | outputs/version-selection-panel-2026-09-27/production-inputs/input-manifest.json | 3efd0fc535b5 |
| analyses/data/00-raw/d020-community-analysis/virome_alpha.tsv | 1355 | match | dev/390-virome-alpha-2026-09-27/virome_alpha.tsv | 954ff7764f8a |
| analyses/data/00-raw/d020-community-analysis/virome_depth_check.tsv | 182 | match | dev/390-virome-alpha-2026-09-27/depth_check.tsv | 13e9f8ff7c5f |
| analyses/data/00-raw/d020-community-analysis/label_pairs.tsv | 850 | match | dev/390-virome-alpha-2026-09-27/clean_dirty_pairs.tsv | 77acad47653f |
| analyses/data/00-raw/d020-community-analysis/alpha_summary.tsv | 2611 | match | analyses/data/060-diversity/alpha_summary.tsv | 70e4b2a63549 |
| analyses/data/00-raw/d020-community-analysis/permanova_marginal.tsv | 2987 | match | analyses/data/060-diversity/permanova_marginal.tsv | d37b962bec66 |
| analyses/data/00-raw/d020-community-analysis/betadisper_summary.tsv | 5357 | match | analyses/data/060-diversity/betadisper_summary.tsv | 0eb7e5947b27 |
| analyses/data/00-raw/d020-community-analysis/crossomics_pairwise.tsv | 474 | match | analyses/data/080-procrustes/crossomics_pairwise.tsv | 6746ae0c677f |
| analyses/data/00-raw/d020-community-analysis/corrected_host_members.tsv | 88225 | match | outputs/version-selection-panel-2026-09-27/corrected-host-members.tsv | d51631785bca |
| analyses/data/00-raw/d020-community-analysis/crispr_host_edges_primary.tsv | 12244 | match | analyses/data/071-crispr_host_network/crispr_host_edges_primary.tsv | 9e8485520655 |
| analyses/data/00-raw/d020-community-analysis/sample_metadata.tsv | 832 | match | analyses/manuscript/tables/S1_sample_metadata.tsv | 2f9cf360a256 |
| analyses/data/00-raw/d020-community-analysis/saturation_diagnostics.tsv | 2580 | match | analyses/data/115-supp-qc/saturation_diagnostics_all_omics.tsv | 7e555b0575ce |
| analyses/data/00-raw/d020-community-analysis/viral_load_per_sample.tsv | 681 | match | analyses/data/020-tse_virome/viral_load_per_sample.tsv | 25a14421302e |
| analyses/data/00-raw/d020-community-analysis/checkv_quality_summary.tsv | 361577 | match | analyses/data/00-raw/hpc/virome/05-vanno/out_checkv/quality_summary.tsv | 6fbd10bdca45 |
| analyses/data/00-raw/d020-community-analysis/votu_contig_map.tsv | 105994 | match | analyses/p0061.sqlite | 5bc4e6b722d4 |
| analyses/data/00-raw/d020-community-analysis/denominator_funnel.tsv | 3148 | match | analyses/manuscript/tables/F1_denominator_funnel_inputs.tsv | 9b261e5ee00d |
| analyses/data/00-raw/d020-community-analysis/virome_alpha_script.R | 3573 | match | dev/390-virome-alpha-2026-09-27/virome_alpha.R | db3833db9c20 |
| analyses/data/00-raw/d030-function-inputs/amg_ko_matrix_tpm.tsv | 19882 | match | workspace/codex_work/results/amg_pathway_current/amg_ko_matrix_tpm.tsv | b19100e40f49 |
| analyses/data/00-raw/d030-function-inputs/amg_pathway_matrix_tpm.tsv | 9920 | match | workspace/codex_work/results/amg_pathway_current/amg_pathway_curated_metabolism_matrix_tpm.tsv | 988061073f64 |
| analyses/data/00-raw/d030-function-inputs/amg_feature_driver_summary.tsv | 120450 | match | workspace/codex_work/results/amg_votu_host_drivers/amg_feature_driver_summary.tsv | 23bc0d7d1620 |
| analyses/data/00-raw/d030-function-inputs/amg_carrier_contributions.tsv | 1074739 | match | workspace/codex_work/results/amg_votu_host_drivers/amg_driver_votu_feature_contributions.tsv | a4e9f8ca867a |
| analyses/data/00-raw/d030-function-inputs/f3_display_selection.tsv | 1837 | match | outputs/figure-production-design-2026-09-27/F3-display-selection.tsv | 9b3c610f1429 |
| analyses/data/00-raw/d030-function-inputs/f3_display_selection_provenance.json | 709 | match | outputs/figure-production-design-2026-09-27/F3-display-selection-provenance.json | 1a7d384ec64a |
| analyses/data/00-raw/d030-function-inputs/cargo_library_tiers.tsv | 2721 | match | analyses/data/102-cargo_evidence_tiers/cargo_library_tiers.tsv | 161cc0fb7fcb |
| analyses/data/00-raw/d030-function-inputs/local_votu_table.tsv | 226582 | match | outputs/manuscript-package-2026-08-28/02-figures/source/local_votu_table.tsv | bb4d50b1077b |
| analyses/data/00-raw/d030-function-inputs/narp_votu_detail.tsv | 1336 | match | workspace/codex_work/results/final_gap_closure_2026-08-04/narp_votu_detail.tsv | 47ec5bfc4c36 |
| analyses/data/00-raw/d030-function-inputs/narp_ko_cooccurrence.tsv | 1482 | match | workspace/codex_work/results/narp2_module_cooccurrence_2026-08-11/cooccurring_NAMPT_K03462_nadM_K13522_vOTUs.tsv | 859fa81aa020 |
| analyses/data/00-raw/d030-function-inputs/narp_gene_annotation_pairs.tsv | 3973 | match | workspace/codex_work/results/narp2_module_cooccurrence_2026-08-11/NAMPT_nadM_gene_annotation_pairs.tsv | b1cd74757775 |
| analyses/data/00-raw/d030-function-inputs/narp_thoeris_context.tsv | 1805 | match | workspace/codex_work/results/narp2_module_cooccurrence_2026-08-11/global_NARP_Thoeris_context.tsv | a9ea2c9f4421 |
| analyses/data/00-raw/d030-function-inputs/votu0052_context.tsv | 9054 | match | workspace/codex_work/results/amg_case_studies/votu0052_amg_focused_context_pm5.tsv | ede0222e16e8 |
| analyses/data/00-raw/d030-function-inputs/votu0052_defensefinder_genes.tsv | 635 | match | analyses/p0061.sqlite | 1e91dcf88761 |
| analyses/data/00-raw/d030-function-inputs/doc_votu0052_coverage_spike.md | 10167 | match | docs/votu0052-coverage-spike.md | 514971765150 |
| analyses/data/00-raw/d030-function-inputs/doc_votu0052_he_targeting.md | 11346 | match | docs/votu0052-he-targeting.md | 311c9c9f5e4f |
| analyses/data/00-raw/d030-function-inputs/doc_votu0052_orf102.md | 25407 | match | docs/votu0052-orf102-characterization.md | dd197a11358b |
| analyses/data/00-raw/d030-function-inputs/supplementary_information.qmd | 83161 | match | analyses/manuscript/supplementary-information.qmd | 95d3d6efdc1d |
| analyses/data/00-raw/d040-vf-inputs/vf20_coordinates.tsv | 10765 | match | dev/280-publication-stage-a/local/vf20_coordinates.tsv | 38a21cdea479 |
| analyses/data/00-raw/d040-vf-inputs/checkv19.tsv | 2762 | match | dev/280-publication-stage-a/local/checkv19.tsv | 1c77e6b4e40f |
| analyses/data/00-raw/d040-vf-inputs/checkv_regions.tsv | 1174 | match | dev/280-publication-stage-a/local/regions.tsv | 33e6cf72a3b0 |
| analyses/data/00-raw/d040-vf-inputs/votu_model_input.tsv | 2757842 | match | dev/280-publication-stage-a/local/votu_input.tsv | ebaa1b914e7c |
| analyses/data/00-raw/d040-vf-inputs/local_artifact_manifest.tsv | 2352 | match | dev/280-publication-stage-a/local/artifact_manifest.tsv | 98c5b0061d9f |
| analyses/data/00-raw/d040-vf-inputs/s34_local_factorial.tsv | 629 | match | analyses/manuscript/tables/S34_local_factorial.tsv | bd1cd62cd65a |
| analyses/data/00-raw/d040-vf-inputs/construct_detection_by_stratum.tsv | 1226 | match | dev/370-audit-integration-2026-09-26/results/detection_by_stratum.tsv | 047d7996be8c |
| analyses/data/00-raw/d040-vf-inputs/construct_zero_flank_flags.tsv | 41 | match | dev/370-audit-integration-2026-09-26/results/zero_flank_flags.tsv | 4b6e2d3f18b4 |
| analyses/data/00-raw/d040-vf-inputs/construct_host_removal.tsv | 732 | match | dev/370-audit-integration-2026-09-26/results/host_removal_by_detection.tsv | 4a80ec144133 |
| analyses/data/00-raw/d040-vf-inputs/construct_summary.json | 1303 | match | dev/370-audit-integration-2026-09-26/results/summary.json | 777b1cd55bd2 |
| analyses/data/00-raw/d040-vf-inputs/construct_below95.tsv | 12015 | match | analyses/manuscript/tables/S47_C_individual_below95.tsv | 42e31a5014e2 |
| analyses/data/00-raw/d040-vf-inputs/construct_sequence_strata.tsv | 87189 | match | analyses/manuscript/tables/S39_C_sequence_strata.tsv | ca093e269e36 |
| analyses/data/00-raw/d050-global-inputs/global_full_feature_fits.tsv | 74972 | match | dev/280-publication-stage-a/global_primary/full_feature_fits.tsv | 5f20bfec6711 |
| analyses/data/00-raw/d050-global-inputs/global_fixed_universe.tsv | 8404 | match | dev/280-publication-stage-a/global_primary/fixed_universe.tsv | 773f76326254 |
| analyses/data/00-raw/d050-global-inputs/global_profile_cluster_support.tsv | 1249 | match | dev/280-publication-stage-a/global_primary/profile_cluster_support.tsv | b2a1fee98990 |
| analyses/data/00-raw/d050-global-inputs/global_summary.json | 2501 | match | dev/280-publication-stage-a/global_primary/summary.json | db2a473cac05 |
| analyses/data/00-raw/d050-global-inputs/global_adjusted_fits.tsv | 43299 | match | dev/280-publication-stage-a/global_primary/adjusted_fits.tsv | 8eca827a565c |
| analyses/data/00-raw/d050-global-inputs/global_adjusted_contrasts.tsv | 186 | match | dev/280-publication-stage-a/global_primary/adjusted_contrasts.tsv | 65fee6b74123 |
| analyses/data/00-raw/d050-global-inputs/global_firth_contrasts.tsv | 523 | match | dev/280-publication-stage-a/global_primary/firth_contrasts.tsv | 514db13fdefd |
| analyses/data/00-raw/d050-global-inputs/global_firth_feature_fits.tsv | 108448 | match | dev/280-publication-stage-a/global_primary/firth_feature_fits.tsv | 47002e493add |
| analyses/data/00-raw/d050-global-inputs/global_firth_run.json | 260 | match | dev/280-publication-stage-a/global_primary/firth_run.json | eb411fa0e239 |
| analyses/data/00-raw/d050-global-inputs/global_resample_contrasts.tsv | 21993 | match | dev/280-publication-stage-a/global_primary/resample_contrasts.tsv | d0ef627940e0 |
| analyses/data/00-raw/d050-global-inputs/global_resample_features.tsv | 4766118 | match | dev/280-publication-stage-a/global_primary/resample_features.tsv | 5620f6ddb051 |
| analyses/data/00-raw/d050-global-inputs/global_stratum_population.tsv | 356 | match | dev/280-publication-stage-a/global_primary/stratum_population.tsv | 015f496639fc |
| analyses/data/00-raw/d050-global-inputs/global_stratum_fits.tsv | 222777 | match | dev/280-publication-stage-a/global_primary/stratum_fits.tsv | 826c6e52c9ad |
| analyses/data/00-raw/d050-global-inputs/global_aggregation_fits.tsv | 2576 | match | dev/280-publication-stage-a/global_primary/aggregation_fits.tsv | bbb46c66295c |
| analyses/data/00-raw/d050-global-inputs/global_aggregation_members.tsv | 3160 | match | dev/280-publication-stage-a/global_primary/aggregation_members.tsv | f068fc358179 |
| analyses/data/00-raw/d050-global-inputs/global_artifact_manifest.tsv | 2164 | match | dev/280-publication-stage-a/global_primary/artifact_manifest.tsv | 4030535dd47e |
| analyses/data/00-raw/d050-global-inputs/global_fixed38_display.tsv | 1334 | match | outputs/version-selection-panel-2026-09-27/production-inputs/global_fixed38_display.tsv | 73758adfe8cd |
| analyses/data/00-raw/d050-global-inputs/local_carriage_bins.tsv | 242 | match | outputs/version-selection-panel-2026-09-27/production-inputs/local_carriage_bins_display.tsv | 815352291f50 |
| analyses/data/00-raw/d050-global-inputs/local_bridge_bins.json | 885 | match | outputs/manuscript-package-2026-08-28/02-figures/source/local_bridge_bins.json | 2907acbb4881 |
| analyses/data/00-raw/d050-global-inputs/nad_domain_leaveout.tsv | 2124 | match | analyses/manuscript/tables/S11_nad_domain_leaveout.tsv | cd39bc904834 |
| analyses/data/00-raw/d012-tse-construction/p0061_snapshot.sqlite | 27095040 | match | analyses/p0061.sqlite | 44a3a8e3bfbd |
| analyses/data/00-raw/d012-tse-construction/16s_ASV_table_filt.tsv | 188128 | match | analyses/data/00-raw/hpc/16s/ASV_table_filt.tsv | 3a43a59712a3 |
| analyses/data/00-raw/d012-tse-construction/16s_ASV_tax.tsv | 1455632 | match | analyses/data/00-raw/hpc/16s/ASV_tax.tsv | b8aaab02fe0b |
| analyses/data/00-raw/d012-tse-construction/16s_metadata.tsv | 251 | match | analyses/data/00-raw/hpc/16s/metadata.tsv | 14e4df3d2c49 |
| analyses/data/00-raw/d012-tse-construction/16s_tree.nwk | 240007 | match | analyses/data/00-raw/hpc/16s/tree.nwk | b4548b6d96bb |
| analyses/data/00-raw/d012-tse-construction/16s_legacy_row_order.tsv | 147227 | match | analyses/data/00-raw/hpc/16s/tse.rds | 4f016a25a975 |
| analyses/data/00-raw/d012-tse-construction/18s_ASV_table_filt.tsv | 50656 | match | analyses/data/00-raw/hpc/18s/ASV_table_filt.tsv | 9648e377ad1d |
| analyses/data/00-raw/d012-tse-construction/18s_ASV_tax.tsv | 438446 | match | analyses/data/00-raw/hpc/18s/ASV_tax.tsv | 20047dae6564 |
| analyses/data/00-raw/d012-tse-construction/18s_metadata.tsv | 251 | match | analyses/data/00-raw/hpc/18s/metadata.tsv | 14e4df3d2c49 |
| analyses/data/00-raw/d012-tse-construction/18s_tree.nwk | 64431 | match | analyses/data/00-raw/hpc/18s/tree.nwk | b5bca5b508d5 |
| analyses/data/00-raw/d012-tse-construction/18s_legacy_row_order.tsv | 38775 | match | analyses/data/00-raw/hpc/18s/tse.rds | 5791951aa4ca |
| analyses/data/00-raw/d012-tse-construction/nreads_virome.tsv | 193 | match | analyses/data/00-raw/hpc/virome/nreads_virome.tsv | 22072dbe1158 |
| analyses/data/00-raw/d014-legacy-comparison/legacy_composition_full.tsv | 33433 | match | outputs/version-selection-panel-2026-09-27/production-inputs/composition_full.tsv | 685e096b3742 |
| analyses/data/00-raw/d014-legacy-comparison/legacy_feature_taxonomy.tsv | 503815 | match | outputs/version-selection-panel-2026-09-27/production-inputs/feature_taxonomy.tsv | 696aae1bb259 |
| analyses/data/00-raw/d014-legacy-comparison/legacy_pcoa_aitchison.tsv | 2123 | match | outputs/version-selection-panel-2026-09-27/production-inputs/pcoa_aitchison.tsv | fdeaebaed847 |
| analyses/data/00-raw/d014-legacy-comparison/legacy_virome_alpha.tsv | 1355 | match | dev/390-virome-alpha-2026-09-27/virome_alpha.tsv | 954ff7764f8a |
| analyses/data/00-raw/d014-legacy-comparison/legacy_virome_depth_check.tsv | 182 | match | dev/390-virome-alpha-2026-09-27/depth_check.tsv | 13e9f8ff7c5f |
| analyses/data/00-raw/d014-legacy-comparison/legacy_label_pairs.tsv | 850 | match | dev/390-virome-alpha-2026-09-27/clean_dirty_pairs.tsv | 77acad47653f |
| analyses/data/00-raw/d014-legacy-comparison/legacy_alpha_summary.tsv | 2611 | match | analyses/data/060-diversity/alpha_summary.tsv | 70e4b2a63549 |
| analyses/data/00-raw/d014-legacy-comparison/legacy_permanova_marginal.tsv | 2987 | match | analyses/data/060-diversity/permanova_marginal.tsv | d37b962bec66 |
| analyses/data/00-raw/d014-legacy-comparison/legacy_betadisper_summary.tsv | 5357 | match | analyses/data/060-diversity/betadisper_summary.tsv | 0eb7e5947b27 |
| analyses/data/00-raw/d014-legacy-comparison/legacy_crossomics_pairwise.tsv | 474 | match | analyses/data/080-procrustes/crossomics_pairwise.tsv | 6746ae0c677f |
| analyses/data/00-raw/d014-legacy-comparison/legacy_viral_load_per_sample.tsv | 681 | match | analyses/data/020-tse_virome/viral_load_per_sample.tsv | 25a14421302e |
| analyses/data/00-raw/d014-legacy-comparison/legacy_corrected_host_members.tsv | 88225 | match | outputs/version-selection-panel-2026-09-27/corrected-host-members.tsv | d51631785bca |
| analyses/data/00-raw/d014-legacy-comparison/legacy_crispr_host_edges_primary.tsv | 12244 | match | analyses/data/071-crispr_host_network/crispr_host_edges_primary.tsv | 9e8485520655 |
| analyses/data/00-raw/d014-legacy-comparison/legacy_tse_virome.rds | 759097 | match | analyses/data/020-tse_virome/tse_virome.rds | d142acbb1f8c |
| analyses/data/00-raw/d014-legacy-comparison/legacy_tse_16s.rds | 1094886 | match | analyses/data/030-tse_16s/tse_16s.rds | 3061bbebcf92 |
| analyses/data/00-raw/d014-legacy-comparison/legacy_tse_18s_all.rds | 306372 | match | analyses/data/040-tse_18s/tse_18s_all.rds | 842a34467eca |
| analyses/data/00-raw/d014-legacy-comparison/legacy_tse_18s_microeuk.rds | 292920 | match | analyses/data/040-tse_18s/tse_18s_microeuk.rds | a33df7f56999 |
| analyses/data/00-raw/d014-legacy-comparison/legacy_mae_diversity.rds | 2945655 | match | analyses/data/060-diversity/mae_diversity.rds | 9a66c39756cb |
| analyses/data/00-raw/d040-vf-inputs/vfdbA_filtered_catalogue.tsv | 60031 | match | table virus_vfdbA_filtered of p0061_snapshot.sqlite | 341c834282e1 |
| analyses/data/00-raw/d040-vf-inputs/vfdbA_strict_catalogue.tsv | 16119 | match | table virus_vfdbA_strict of p0061_snapshot.sqlite | 156d6c918333 |
| analyses/data/00-raw/d030-function-inputs/defense_type_inventory.tsv | 1524 | match | outputs/defense-case-comparison-2026-10-14/system-inventory.tsv | 41da17766e19 |
| analyses/data/00-raw/d050-global-inputs/repair_scenario_summary.tsv | 1648 | match | dev/380-global-repair-preflight-2026-09-26/results/scenario_summary.tsv | baa95a1f49f2 |
| analyses/data/00-raw/d050-global-inputs/repair_feature_fits.tsv | 70549 | match | dev/380-global-repair-preflight-2026-09-26/results/feature_fits.tsv | f155daf77f03 |
| analyses/data/00-raw/d050-global-inputs/repair_members.tsv | 8146 | match | dev/380-global-repair-preflight-2026-09-26/results/members.tsv | 87b272dbc641 |
| analyses/data/00-raw/d050-global-inputs/repair_scenario_members.tsv | 13325 | match | dev/380-global-repair-preflight-2026-09-26/results/scenario_members.tsv | d77965fcad4f |
| analyses/data/00-raw/d050-global-inputs/repair_mapping.tsv | 62642 | match | dev/380-global-repair-preflight-2026-09-26/results/mapping.tsv | c35f82dbbeed |
| analyses/data/00-raw/d050-global-inputs/repair_eligibility_changes.tsv | 2052 | match | dev/380-global-repair-preflight-2026-09-26/results/eligibility_changes.tsv | 9b8efbcdd624 |
| analyses/data/00-raw/d050-global-inputs/repair_input_manifest.tsv | 1495 | match | dev/380-global-repair-preflight-2026-09-26/results/input_manifest.tsv | b247e2924fb8 |
| analyses/data/00-raw/d050-global-inputs/repair_COMPLETE.json | 4452 | match | dev/380-global-repair-preflight-2026-09-26/results/COMPLETE.json | 700689960323 |
| analyses/data/00-raw/d050-global-inputs/repair_independent_verification.json | 4549 | match | dev/380-global-repair-preflight-2026-09-26/independent_verification.json | b6e63524f6e1 |
| analyses/data/00-raw/d220-sfig2-function-context/narp-v35-figure.pdf | 1900348 | match | outputs/s2-narp-v35-2026-10-16/figures/FigureS2.pdf | 38905bff11a2 |
| analyses/data/00-raw/d220-sfig2-function-context/narp-v35-figure.svg | 1388784 | match | outputs/s2-narp-v35-2026-10-16/figures/FigureS2.svg | 799923b543eb |
| analyses/data/00-raw/d220-sfig2-function-context/narp-v35-figure.png | 628269 | match | outputs/s2-narp-v35-2026-10-16/figures/FigureS2.png | 08aa4b671787 |
| analyses/data/00-raw/d220-sfig2-function-context/narp-v35-plot-values.tsv | 14983 | match | outputs/s2-narp-v35-2026-10-16/figures/FigureS2-plot-values.tsv | 99b38269785d |
| analyses/data/00-raw/d220-sfig2-function-context/narp-v35-legend.md | 2114 | match | outputs/s2-narp-v35-2026-10-16/figures/FigureS2-legend.md | 50838f0259a2 |
| analyses/data/00-raw/d220-sfig2-function-context/narp-v35-export.json | 32975 | match | outputs/s2-narp-v35-2026-10-16/figures/FigureS2-export.json | 2415bb8254cd |
| analyses/data/00-raw/d220-sfig2-function-context/narp-v35-figure.tiff | 2796176 | match | analyses/data/00-raw/d220-sfig2-function-context/narp-v35-figure.pdf | 45c96d5f5114 |
| analyses/data/00-raw/d220-sfig2-function-context/narp-v35-neighbourhood-source.tsv | 6360 | match | outputs/s2-narp-v35-2026-10-16/data/narp2-neighbourhood-source.tsv | 081a146b14a0 |
| analyses/data/00-raw/d220-sfig2-function-context/narp-v35-structure-full.png | 475511 | match | outputs/s2-narp-v35-2026-10-16/figures/ORF102-full-trim.png | e13c4658db3f |
| analyses/data/00-raw/d220-sfig2-function-context/narp-v35-structure-overlay.png | 310258 | match | outputs/s2-narp-v35-2026-10-16/figures/ORF102-overlay-trim.png | 8bf2b56996f9 |
| analyses/data/00-raw/d220-sfig2-function-context/narp-v35-colour-ramps.json | 5655 | match | outputs/s2-narp-v35-2026-10-16/data/colour-ramps.json | 9eaa94454e82 |

raw-input-manifest.tsv (sha256 shortened)

Staged inputs include a viral SQLite snapshot, amplicon
counts/taxonomy/trees, archived analysis tables and saved figure
materials. Steps 012 and 020 rebuild community objects and calculations;
the function, VF and global modules read archived results. This is not a
workflow from raw sequencing reads.

### Task 3: Record the run

| file                     | bytes | sha256           |
|:-------------------------|------:|:-----------------|
| input-manifest.tsv       |  6725 | 70ee8c390a17b829 |
| raw-input-manifest.tsv   | 45979 | 28fbe92253ba4d14 |
| science-input-status.tsv |   898 | 789bad80a8c70821 |
| session-info.txt         | 13710 | e61979c5ad1bcae3 |

Outputs recorded in step-record.json

</details>

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/010-input-manifest/input-manifest.tsv">input-manifest.tsv</a> (6.6 KB)</li>
<li><a href="data/010-input-manifest/raw-input-manifest.tsv">raw-input-manifest.tsv</a> (44.9 KB)</li>
<li><a href="data/010-input-manifest/science-input-status.tsv">science-input-status.tsv</a> (0.9 KB)</li>
<li><a href="data/010-input-manifest/session-info.txt">session-info.txt</a> (13.4 KB)</li>
</ul>

</details>
