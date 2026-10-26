# Stage the small, already-saved research results that the figure workflow
# redraws into the qproj raw-input areas, and write the migration register
# metadata/raw-inputs.tsv (origin path, origin SHA256, target SHA256,
# transform, fields and units).
# Authors (display order): Jinlong Ru, Cunli Pan
#
# This is a one-time migration helper, NOT a workflow step: the formal
# workflow (scripts/render.R) never reads the original research project. It
# only verifies the staged copies against metadata/raw-inputs.tsv (step 010).
#
# Usage, from the project root (the source project is only read):
#   RWV_SOURCE_ROOT=<path to p0061-RecWaterVirome> Rscript scripts/stage-inputs.R
#   Rscript scripts/stage-inputs.R <path to p0061-RecWaterVirome>
#
# Operations allowed here: byte-for-byte copy, and read-only SQLite SELECTs of
# existing columns (mode=ro). No model, statistic, ordination, rarefaction or
# annotation is computed. An already registered target is never silently
# replaced: if its source changed, the script stops.

(function() {
  fail <- function(...) stop(paste0(...), call. = FALSE)
  args <- commandArgs(trailingOnly = TRUE)
  src <- if (length(args)) args[1] else Sys.getenv("RWV_SOURCE_ROOT", unset = "")
  if (!nzchar(src) || !dir.exists(src)) fail("Give the source project root as argument or RWV_SOURCE_ROOT.")
  src <- normalizePath(src, winslash = "/")
  root <- normalizePath(getwd(), winslash = "/")
  if (!file.exists(file.path(root, "DESCRIPTION")) ||
    !identical(unname(read.dcf(file.path(root, "DESCRIPTION"), fields = "Package")[1, 1]), "RecWaterVirome")) {
    fail("Run from the RecWaterVirome project root.")
  }
  for (pkg in c("digest", "DBI", "RSQLite")) {
    if (!nzchar(system.file(package = pkg))) fail("Package ", pkg, " is needed by this migration script; it is not installed.")
  }
  sha <- function(p) digest::digest(file = p, algo = "sha256")
  # Git anchor of the source project: HEAD commit and the state of each origin
  # file (tracked-clean, tracked-modified, untracked or ignored), so that a
  # migrated copy can be traced even if the source working tree changes later.
  git <- function(...) suppressWarnings(system2("git", c("-C", shQuote(src), ...), stdout = TRUE, stderr = FALSE))
  head_commit <- tryCatch(git("rev-parse", "HEAD"), error = function(e) character())
  head_commit <- if (length(head_commit) && nzchar(head_commit[1])) head_commit[1] else "not a git repository"
  git_state <- function(rel) {
    if (identical(head_commit, "not a git repository")) return("not a git repository")
    st <- git("status", "--porcelain", "--ignored", "--", shQuote(rel))
    if (!length(st)) return("tracked-clean")
    code <- substr(st[1], 1, 2)
    if (identical(code, "??")) "untracked" else if (identical(code, "!!")) "ignored" else "tracked-modified"
  }
  raw_dir <- function(step) file.path("analyses", "data", "00-raw", paste0("d", step))

  # ---- specification -------------------------------------------------------
  # kind = "copy": origin is a file; kind = "sql": origin is the SQLite file and
  # `query` a read-only SELECT whose result is written as TSV.
  spec <- list()
  add <- function(step, target, origin, fields_units, note = "", kind = "copy", query = NA_character_) {
    spec[[length(spec) + 1L]] <<- list(step = step, target = target, origin = origin, kind = kind,
                                       query = query, fields_units = fields_units, note = note)
  }
  pi <- "outputs/version-selection-panel-2026-09-27/production-inputs"
  s020 <- "020-community-analysis"
  add(s020, "composition_full.tsv", file.path(pi, "composition_full.tsv"),
      "omic, sample_id, taxonomic_rank, taxon, source_assay, abundance_sum (assay units), relative_abundance (fraction of the sample total within one omic)",
      "59 taxa x 7 samples = 413 rows; virome trimmed_tpm by class, 16S relabundance by GTDB phylum, microeuk (Metazoa removed) relabundance by Division")
  add(s020, "feature_taxonomy.tsv", file.path(pi, "feature_taxonomy.tsv"),
      "omic, feature_id, source_field, raw_label, display_taxon", "6,998 feature-to-taxon mappings; empty labels -> Unclassified")
  add(s020, "pcoa_aitchison.tsv", file.path(pi, "pcoa_aitchison.tsv"),
      "omic, sample_id, PCoA1, PCoA2 (ordination scores), axis1_percent, axis2_percent (already %)",
      "saved aitchison_PCoA reducedDim; not re-ordinated")
  add(s020, "export_checks.tsv", file.path(pi, "export_checks.tsv"), "per-omic feature/sample/taxon counts and sum errors")
  add(s020, "production_input_manifest.json", file.path(pi, "input-manifest.json"), "SHA256 of the production-input sources and exports")
  add(s020, "virome_alpha.tsv", "dev/390-virome-alpha-2026-09-27/virome_alpha.tsv",
      "sample_id, masked_reads (reads), rarefy_depth (reads), observed (vOTUs), shannon (nats), *_sd over 100 rarefactions, *_unrarefied",
      "breadth>=75% count_masked; shannon_sd is technical rarefaction spread, not a biological interval")
  add(s020, "virome_depth_check.tsv", "dev/390-virome-alpha-2026-09-27/depth_check.tsv", "metric, spearman_rho (n = 7, descriptive)")
  add(s020, "label_pairs.tsv", "dev/390-virome-alpha-2026-09-27/clean_dirty_pairs.tsv",
      "experiment, pair (site), observed_*, shannon_*, shannon_diff_dirty_minus_clean", "within-site record-label contrasts; bc2 has no counterpart")
  add(s020, "alpha_summary.tsv", "analyses/data/060-diversity/alpha_summary.tsv",
      "experiment, sample_id, observed, shannon (nats), pielou, faith", "rarefied 16S/18S assays; euk_18s_all rows are not used")
  add(s020, "permanova_marginal.tsv", "analyses/data/060-diversity/permanova_marginal.tsv",
      "experiment, dissimilarity, term, df, R2, F_stat, p (nominal, 999 permutations, by = margin)")
  add(s020, "betadisper_summary.tsv", "analyses/data/060-diversity/betadisper_summary.tsv",
      "experiment, diss_x_group, p_betadisper* (parametric/permutation/bias-adjusted), dispersion_status")
  add(s020, "crossomics_pairwise.tsv", "analyses/data/080-procrustes/crossomics_pairwise.tsv",
      "pair, proc_m2, proc_corr, proc_p, mantel_r, mantel_p (Spearman, 999 permutations, seed 42, nominal), rv_coef")
  add(s020, "corrected_host_members.tsv", "outputs/version-selection-panel-2026-09-27/corrected-host-members.tsv",
      "200 iPHoP >=90 vOTU records; visibility_status named_genus_detected_in_16s / named_genus_not_detected_in_16s / genus_unresolved")
  add(s020, "crispr_host_edges_primary.tsv", "analyses/data/071-crispr_host_network/crispr_host_edges_primary.tsv",
      "29 strict-primary (vOTU, host genus) edges; host_visible_in_16s, n_codetected_masked (samples)")
  add(s020, "sample_metadata.tsv", "analyses/manuscript/tables/S1_sample_metadata.tsv",
      "sample_id, assay IDs, desc, water_condition (record label), location, read counts (reads)")
  add(s020, "saturation_diagnostics.tsv", "analyses/data/115-supp-qc/saturation_diagnostics_all_omics.tsv",
      "layer, sample_id, total_reads, observed_taxa, singletons, doubletons, goods_coverage, chao1, pct_of_chao1 (%), new_taxa_per_1Mr",
      "unmasked positive-count definition for the virome (not the masked alpha definition)")
  add(s020, "viral_load_per_sample.tsv", "analyses/data/020-tse_virome/viral_load_per_sample.tsv",
      "sample_id, mapped_viral_reads, clean_reads (reads), viral_fraction")
  add(s020, "checkv_quality_summary.tsv", "analyses/data/00-raw/hpc/virome/05-vanno/out_checkv/quality_summary.tsv",
      "CheckV quality_summary per contig (3,638 records before vOTU mapping); checkv_quality, completeness (%), contig_length (bp)")
  add(s020, "votu_contig_map.tsv", "analyses/p0061.sqlite",
      "vOTU_id, vcontig_id, contig_length (bp), checkv_quality_score (1-5), checkv_completeness (%), genomad_n_genes",
      "read-only SELECT of existing columns", kind = "sql",
      query = paste("SELECT vOTU_id, vcontig_id, contig_length, checkv_quality_score, checkv_completeness, genomad_n_genes",
                    "FROM virus_contig_annotation ORDER BY vOTU_id"))
  add(s020, "denominator_funnel.tsv", "analyses/manuscript/tables/F1_denominator_funnel_inputs.tsv",
      "stage, label, n, denominator, pct", "cross-check of the five CheckV classes")
  add(s020, "virome_alpha_script.R", "dev/390-virome-alpha-2026-09-27/virome_alpha.R",
      "R script that produced virome_alpha.tsv", "source of the breadth >= 75% mask and the 100 rarefactions (read to verify both parameters)")

  s030 <- "030-function-inputs"
  add(s030, "amg_ko_matrix_tpm.tsv", "workspace/codex_work/results/amg_pathway_current/amg_ko_matrix_tpm.tsv",
      "dbid (KO), db_desc, 7 sample columns = sum of carrier vOTU TPM, total_TPM, samples_detected", "138 KO")
  add(s030, "amg_pathway_matrix_tpm.tsv", "workspace/codex_work/results/amg_pathway_current/amg_pathway_curated_metabolism_matrix_tpm.tsv",
      "canonical_pathway_id/name/category, 7 sample columns (carrier TPM sum), total_TPM, samples_detected", "68 curated pathways")
  add(s030, "amg_feature_driver_summary.tsv", "workspace/codex_work/results/amg_votu_host_drivers/amg_feature_driver_summary.tsv",
      "feature_level, feature_id, total_TPM, n_contributing_vOTU, top1/3/5_fraction, dominant_vOTU", "old host fields are not used")
  add(s030, "amg_carrier_contributions.tsv", "workspace/codex_work/results/amg_votu_host_drivers/amg_driver_votu_feature_contributions.tsv",
      "feature_level, feature_id, vOTU_id, 7 sample TPM, votu_total_TPM, contribution_fraction, driver_rank", "old host fields are not used")
  add(s030, "f3_display_selection.tsv", "outputs/figure-production-design-2026-09-27/F3-display-selection.tsv",
      "KO, display_order, selection_reason, saved totals", "frozen 11-row display list (top10 by total_TPM + K13522 case)")
  add(s030, "f3_display_selection_provenance.json", "outputs/figure-production-design-2026-09-27/F3-display-selection-provenance.json",
      "rule and source SHA256 of the display list")
  add(s030, "cargo_library_tiers.tsv", "analyses/data/102-cargo_evidence_tiers/cargo_library_tiers.tsv",
      "library, n_carrier_votu, denominator (3060), what_a_hit_means")
  add(s030, "local_votu_table.tsv", "outputs/manuscript-package-2026-08-28/02-figures/source/local_votu_table.tsv",
      "vOTU_id, contig_length (bp), genomad_n_genes, checkv_completeness, df_Antidefense, df_Defense, n_dbapis, n_padloc, n_vfdbA, carries_VF",
      "3,060 vOTUs; anti-defense union = df_Antidefense > 0 OR n_dbapis > 0")
  add(s030, "narp_votu_detail.tsv", "workspace/codex_work/results/final_gap_closure_2026-08-04/narp_votu_detail.tsv",
      "DefenseFinder NARP1/NARP2 system calls per vOTU")
  add(s030, "narp_ko_cooccurrence.tsv",
      "workspace/codex_work/results/narp2_module_cooccurrence_2026-08-11/cooccurring_NAMPT_K03462_nadM_K13522_vOTUs.tsv",
      "vOTUs carrying both K03462 and K13522")
  add(s030, "narp_gene_annotation_pairs.tsv",
      "workspace/codex_work/results/narp2_module_cooccurrence_2026-08-11/NAMPT_nadM_gene_annotation_pairs.tsv",
      "NAMPT/NMNAT gene annotation pairs and reference homologues")
  add(s030, "narp_thoeris_context.tsv",
      "workspace/codex_work/results/narp2_module_cooccurrence_2026-08-11/global_NARP_Thoeris_context.tsv",
      "metric, n, vOTUs (local database-wide NARP/Thoeris annotation sets)")
  add(s030, "votu0052_context.tsv", "workspace/codex_work/results/amg_case_studies/votu0052_amg_focused_context_pm5.tsv",
      "region, protein_id, gene_position, start/end_position (bp), strandedness, ko_id, hits", "overlapping +-5 windows repeat rows")
  add(s030, "votu0052_defensefinder_genes.tsv", "analyses/p0061.sqlite",
      "DefenseFinder gene rows for vOTU0052: hit_id, gene_name, hit_pos, model_fqn, hit_i_eval, hit_profile_cov, subtype, activity",
      "read-only SELECT of existing columns", kind = "sql",
      query = paste("SELECT vOTU_id, vcontig_id, hit_id, gene_name, hit_pos, model_fqn, sys_id, hit_i_eval, hit_score,",
                    "hit_profile_cov, hit_seq_cov, type, subtype, activity FROM virus_defense_finder_genes",
                    "WHERE vOTU_id = 'vOTU0052' ORDER BY hit_pos"))

  add(s030, "doc_votu0052_coverage_spike.md", "docs/votu0052-coverage-spike.md",
      "project document with the saved NARP2-locus relative-depth table (depth / contig median depth)",
      "document-reported values; no separate result table was located in the source project")
  add(s030, "doc_votu0052_he_targeting.md", "docs/votu0052-he-targeting.md",
      "project document with the homing-endonuclease targeting table (observed vs expected genomes, Poisson p)",
      "document-reported values; no separate result table was located in the source project")
  add(s030, "doc_votu0052_orf102.md", "docs/votu0052-orf102-characterization.md",
      "project document with ORF102 domain boundaries (hmmscan) and structure-based predictions",
      "document-reported values; predictions, not activity")
  add(s030, "supplementary_information.qmd", "analyses/manuscript/supplementary-information.qmd",
      "manuscript SI source; Note 7 reports global NARP1/NARP2 module calls (566/166 of 77,951)",
      "text source only; the formal manuscript is not modified")

  s040 <- "040-vf-inputs"
  add(s040, "vf20_coordinates.tsv", "dev/280-publication-stage-a/local/vf20_coordinates.tsv",
      "20 VF hits on CheckV-flagged records: protein coordinates (bp), strand, localization, hsp_host_nt/hsp_viral_nt")
  add(s040, "checkv19.tsv", "dev/280-publication-stage-a/local/checkv19.tsv",
      "19 CheckV provirus-flagged records: region types, lengths and bp coordinates")
  add(s040, "checkv_regions.tsv", "dev/280-publication-stage-a/local/regions.tsv", "vOTU_id, kind (viral/host), start, end, length (bp)")
  add(s040, "votu_model_input.tsv", "dev/280-publication-stage-a/local/votu_input.tsv",
      "3,060-row model input (completeness, lifestyle, VF hit counts by region definition)")
  add(s040, "local_artifact_manifest.tsv", "dev/280-publication-stage-a/local/artifact_manifest.tsv", "SHA256 of the stage-A local outputs")
  add(s040, "s34_local_factorial.tsv", "analyses/manuscript/tables/S34_local_factorial.tsv",
      "label, correction, n, temperate, hits, irr, lo, hi (95% Wald), p, converged, theta", "four saved negative-binomial models, n = 3,013")
  add(s040, "construct_detection_by_stratum.tsv", "dev/370-audit-integration-2026-09-26/results/detection_by_stratum.tsv",
      "panel, window, primary_set, host_percent (flank %), constructs, flagged, flagged_fraction", "saved CheckV outputs of controlled constructs")
  add(s040, "construct_zero_flank_flags.tsv", "dev/370-audit-integration-2026-09-26/results/zero_flank_flags.tsv", "panel, constructs, flagged")
  add(s040, "construct_host_removal.tsv", "dev/370-audit-integration-2026-09-26/results/host_removal_by_detection.tsv",
      "panel, set, host_percent, flagged, constructs, host_removed_* (fraction)")
  add(s040, "construct_summary.json", "dev/370-audit-integration-2026-09-26/results/summary.json", "summary of the calibration detection counts")
  add(s040, "construct_below95.tsv", "analyses/manuscript/tables/S47_C_individual_below95.tsv",
      "33 primary flanked constructs retaining < 95% of viral bases after predicted trimming")
  add(s040, "construct_sequence_strata.tsv", "analyses/manuscript/tables/S39_C_sequence_strata.tsv",
      "mode, genus, window, flank %, treatment, metric (viral_retention/host_removed), mean, low, high (resampling interval)")

  s050 <- "050-global-inputs"
  gp <- "dev/280-publication-stage-a/global_primary"
  for (f in c("full_feature_fits.tsv", "fixed_universe.tsv", "profile_cluster_support.tsv", "summary.json",
              "adjusted_fits.tsv", "adjusted_contrasts.tsv", "firth_contrasts.tsv", "firth_feature_fits.tsv",
              "firth_run.json", "resample_contrasts.tsv", "resample_features.tsv", "stratum_population.tsv", "stratum_fits.tsv",
              "aggregation_fits.tsv", "aggregation_members.tsv", "artifact_manifest.tsv")) {
    add(s050, paste0("global_", f), file.path(gp, f),
        "saved global_primary output (77,951 source-Complete references); coefficients in log-odds per 10-fold CDS")
  }
  add(s050, "global_fixed38_display.tsv", file.path(pi, "global_fixed38_display.tsv"),
      "profile, slope, carriers (genomes), carrier_clusters, single_carrier_cluster")
  add(s050, "local_carriage_bins.tsv", file.path(pi, "local_carriage_bins_display.tsv"),
      "lo_inclusive, hi_exclusive (predicted genes per recovered vOTU), n, k (vOTUs), rate")
  add(s050, "local_bridge_bins.json", "outputs/manuscript-package-2026-08-28/02-figures/source/local_bridge_bins.json",
      "archived bins incl. unaccepted CI fields (CI not drawn)")
  add(s050, "nad_domain_leaveout.tsv", "analyses/manuscript/tables/S11_nad_domain_leaveout.tsv",
      "six NAD-pathway domains, METAB median 4.04835 and median without them 3.982495 (saved values)")

  # ---- community rebuild (analysis-v2026.09.28.1; AGENTS.md section 9) ------
  # 012 builds the TSEs from these inputs; 020 recomputes visibility and
  # co-detection on the archived host predictions (its own staged copies);
  # 014 reads the archived community results and objects for comparison only.
  s012 <- "012-tse-construction"
  add(s012, "p0061_snapshot.sqlite", "analyses/p0061.sqlite",
      "SQLite database: virus_abundance_count (reads), virus_abundance_trimmed_mean (coverage), virus_abundance_tpm, virus_abundance_covered_fraction (0-1), virus_contig_annotation, virus_cargo_summary, virus_taxonomy_formatted, sample_metadata, virus_host_genus",
      "consistent snapshot via the SQLite online backup API from a read-only connection (the source has no WAL file)", kind = "sqlite_backup")
  for (amp in c("16s", "18s")) {
    hp <- file.path("analyses/data/00-raw/hpc", amp)
    add(s012, paste0(amp, "_ASV_table_filt.tsv"), file.path(hp, "ASV_table_filt.tsv"), "ASV_ID, bc1..od1 read counts (ampliseq filtered table)")
    add(s012, paste0(amp, "_ASV_tax.tsv"), file.path(hp, "ASV_tax.tsv"),
        if (amp == "16s") "ASV_ID, GTDB Kingdom..Species, Species_exact, confidence, sequence" else "ASV_ID, PR2 Domain..Species (incl. Subdivision), Species_exact, confidence, sequence")
    add(s012, paste0(amp, "_metadata.tsv"), file.path(hp, "metadata.tsv"), "ID, location, water_type, country, replicate")
    add(s012, paste0(amp, "_tree.nwk"), file.path(hp, "tree.nwk"), "Newick tree of the ASVs (branch lengths kept)")
    add(s012, paste0(amp, "_legacy_row_order.tsv"), file.path(hp, "tse.rds"),
        "position, feature_id: row order of the HPC tse.rds",
        "only the row names are exported; they fix the row order before rarefaction so that the historical draw can be reproduced. Counts, taxonomy and tree are read from the tables above, not from this object",
        kind = "rds_rownames")
  }
  add(s012, "nreads_virome.tsv", "analyses/data/00-raw/hpc/virome/nreads_virome.tsv", "sample_id (bc1v..), raw_reads, clean_reads (reads)")
  # (2026-09-28) The archived host evidence used by the community calculation
  # is the copy already staged for 020-community-analysis; the former second
  # copy for 013 was retired with that step.
  s014 <- "014-legacy-comparison"
  legacy <- c(composition_full.tsv = file.path(pi, "composition_full.tsv"),
              feature_taxonomy.tsv = file.path(pi, "feature_taxonomy.tsv"),
              pcoa_aitchison.tsv = file.path(pi, "pcoa_aitchison.tsv"),
              virome_alpha.tsv = "dev/390-virome-alpha-2026-09-27/virome_alpha.tsv",
              virome_depth_check.tsv = "dev/390-virome-alpha-2026-09-27/depth_check.tsv",
              label_pairs.tsv = "dev/390-virome-alpha-2026-09-27/clean_dirty_pairs.tsv",
              alpha_summary.tsv = "analyses/data/060-diversity/alpha_summary.tsv",
              permanova_marginal.tsv = "analyses/data/060-diversity/permanova_marginal.tsv",
              betadisper_summary.tsv = "analyses/data/060-diversity/betadisper_summary.tsv",
              crossomics_pairwise.tsv = "analyses/data/080-procrustes/crossomics_pairwise.tsv",
              viral_load_per_sample.tsv = "analyses/data/020-tse_virome/viral_load_per_sample.tsv",
              corrected_host_members.tsv = "outputs/version-selection-panel-2026-09-27/corrected-host-members.tsv",
              crispr_host_edges_primary.tsv = "analyses/data/071-crispr_host_network/crispr_host_edges_primary.tsv",
              tse_virome.rds = "analyses/data/020-tse_virome/tse_virome.rds",
              tse_16s.rds = "analyses/data/030-tse_16s/tse_16s.rds",
              tse_18s_all.rds = "analyses/data/040-tse_18s/tse_18s_all.rds",
              tse_18s_microeuk.rds = "analyses/data/040-tse_18s/tse_18s_microeuk.rds",
              mae_diversity.rds = "analyses/data/060-diversity/mae_diversity.rds")
  for (f in names(legacy)) {
    add(s014, paste0("legacy_", f), legacy[[f]], "archived community result of the source project",
        "comparison only: never read by 012 or 013")
  }

  # ---- stage ---------------------------------------------------------------
  reg_path <- file.path(root, "metadata", "raw-inputs.tsv")
  old <- if (file.exists(reg_path)) utils::read.delim(reg_path, colClasses = "character", na.strings = character()) else NULL
  rows <- list()
  for (e in spec) {
    origin <- file.path(src, e$origin)
    if (!file.exists(origin)) fail("Missing source file: ", e$origin)
    target_rel <- file.path(raw_dir(e$step), e$target)
    target <- file.path(root, target_rel)
    dir.create(dirname(target), recursive = TRUE, showWarnings = FALSE)
    tmp <- tempfile(fileext = paste0(".", tools::file_ext(e$target)))
    if (e$kind == "copy") {
      if (!file.copy(origin, tmp, overwrite = TRUE)) fail("Copy failed: ", e$origin)
      if (!identical(sha(tmp), sha(origin))) fail("Copy is not byte-identical: ", e$origin)
      transform <- "verbatim byte copy"
    } else if (e$kind == "sqlite_backup") {
      if (file.exists(paste0(origin, "-wal"))) fail("The source database has a WAL file; stop instead of copying a database that is being written.")
      from <- DBI::dbConnect(RSQLite::SQLite(), origin, flags = RSQLite::SQLITE_RO)
      to <- DBI::dbConnect(RSQLite::SQLite(), tmp)
      RSQLite::sqliteCopyDatabase(from, to)
      DBI::dbDisconnect(from); DBI::dbDisconnect(to)
      transform <- "SQLite online backup (RSQLite::sqliteCopyDatabase) from a read-only connection"
    } else if (e$kind == "rds_rownames") {
      if (!nzchar(system.file(package = "TreeSummarizedExperiment"))) fail("TreeSummarizedExperiment is needed to read ", e$origin)
      suppressPackageStartupMessages(requireNamespace("TreeSummarizedExperiment"))
      ids <- rownames(readRDS(origin))
      utils::write.table(data.frame(position = seq_along(ids), feature_id = ids), tmp, sep = "\t", quote = FALSE, row.names = FALSE)
      transform <- "row names of the saved object, in object order (no other content exported)"
    } else {
      con <- DBI::dbConnect(RSQLite::SQLite(), origin, flags = RSQLite::SQLITE_RO)
      x <- DBI::dbGetQuery(con, e$query)
      DBI::dbDisconnect(con)
      utils::write.table(x, tmp, sep = "\t", quote = FALSE, row.names = FALSE, na = "NA")
      transform <- paste0("read-only SQLite query: ", e$query)
    }
    new_sha <- sha(tmp)
    if (!is.null(old) && e$target %in% basename(old$path)) {
      prev <- old[old$path == target_rel, , drop = FALSE]
      if (nrow(prev) == 1L && !identical(prev$sha256, new_sha)) {
        fail("Registered input ", target_rel, " would change (", prev$sha256, " -> ", new_sha,
             "). Source changed; stop and report instead of replacing it silently.")
      }
    }
    if (!file.copy(tmp, target, overwrite = TRUE)) fail("Could not write ", target_rel)
    unlink(tmp)
    rows[[length(rows) + 1L]] <- data.frame(
      path = target_rel, consumer_step = e$step, sha256 = sha(target),
      origin_project = "p0061-RecWaterVirome (read-only source)", origin_path = e$origin,
      origin_sha256 = sha(origin), origin_git_commit = head_commit, origin_git_state = git_state(e$origin),
      transform = transform, fields_units = e$fields_units, note = e$note
    )
    message("staged ", target_rel)
  }
  reg <- do.call(rbind, rows)
  utils::write.table(reg, reg_path, sep = "\t", quote = FALSE, row.names = FALSE, na = "")
  message("Wrote metadata/raw-inputs.tsv with ", nrow(reg), " inputs.")
})()
