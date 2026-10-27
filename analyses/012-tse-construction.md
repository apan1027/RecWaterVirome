# Construct community objects from the registered SQLite/amplicon inputs

Jinlong Ru; Cunli Pan.

[Editable QMD](012-tse-construction.qmd) · [Analysis index](README.md)

Source reading companion with accepted figure previews; not a new scientific execution report.

## Tasks

This step builds viral, 16S and 18S community objects for analysis-v2026.09.28.1 from the staged SQLite snapshot and ampliseq counts, taxonomy, sample metadata and trees. Prebuilt source-project TSEs are used only in optional comparison step 014. Parameters are read from analyses/R/community.yml; the computational specification is implemented in R/community.R and documented in docs/WORKFLOW-GUIDE.md. Reads are not remapped, DADA2/CheckV are not rerun and new trees are not inferred.

### Task 1: Inputs and parameters

```r
manifest <- rwv_read_tsv(rwv_step_input(step, path_source, "010-input-manifest", "input-manifest.tsv"))
raw_manifest <- rwv_read_tsv(rwv_step_input(step, path_source, "010-input-manifest", "raw-input-manifest.tsv"))
cfg <- yaml::read_yaml(rwv_project_input(step, "analyses/R/community.yml", manifest))
cfg_problems <- rwv_community_config_check(cfg)
if (length(cfg_problems)) rwv_fail("analyses/R/community.yml selects values that are not implemented: ", paste(cfg_problems, collapse = "; "))
raw_path <- function(f) rwv_raw_input(step, path_data, f, raw_manifest)
read_tab <- function(f) utils::read.delim(raw_path(f), check.names = FALSE, colClasses = "character", na.strings = character(0))
checks <- rwv_checks_new()
calc_order <- unlist(cfg$calculation_sample_order)
rwv_check(checks, "calculation sample order has the seven samples", 7L, length(unique(calc_order)))
```

### Task 2: Validate structure, keys, aliases, ASVs, taxonomy and trees

```r
db <- raw_path("p0061_snapshot.sqlite")
con <- DBI::dbConnect(RSQLite::SQLite(), db, flags = RSQLite::SQLITE_RO)
tables <- DBI::dbListTables(con)
schema <- do.call(rbind, lapply(tables, function(t) {
  cols <- DBI::dbListFields(con, t)
  data.frame(table = t, rows = DBI::dbGetQuery(con, paste0("SELECT COUNT(*) AS n FROM \"", t, "\""))$n,
             columns = length(cols), column_names = paste(cols, collapse = ", "))
}))
rwv_check(checks, "SQLite integrity check", "ok", DBI::dbGetQuery(con, "PRAGMA integrity_check")[[1]])
rwv_check(checks, "SQLite has no 16S/18S ASV or tree table (amplicons come from the ampliseq files)", FALSE,
          any(grepl("asv|16s|18s|tree", tables, ignore.case = TRUE)))
# Explicit sample alias dictionary from the source's own sample table: the
# virome abundance columns and nreads use id_virome_hpc (bc1v ...), the
# amplicon tables use id_16s_hpc / id_18s_hpc.
smd <- DBI::dbGetQuery(con, "SELECT * FROM sample_metadata")
alias <- data.frame(sample_id = smd$sample_id, virome = smd$id_virome_hpc, amp16s = smd$id_16s_hpc, amp18s = smd$id_18s_hpc)
alias <- alias[match(calc_order, alias$sample_id), ]
rwv_check(checks, "sample aliases are one-to-one for all seven samples", TRUE,
          !anyNA(alias) && all(vapply(alias, function(x) !anyDuplicated(x), logical(1))))
# Virome abundance tables, read in SQLite rowid order (the historical row
# order; the random draws of the virome alpha depend on it).
abun_tables <- c(count = "virus_abundance_count", trimmed_mean = "virus_abundance_trimmed_mean",
                 tpm = "virus_abundance_tpm", covered_fraction = "virus_abundance_covered_fraction")
load_abun <- function(t) {
  df <- DBI::dbGetQuery(con, paste0("SELECT * FROM \"", t, "\" ORDER BY rowid"))
  m <- as.matrix(df[, setdiff(colnames(df), "vOTU_id"), drop = FALSE])
  storage.mode(m) <- "double"
  rownames(m) <- df$vOTU_id
  colnames(m) <- alias$sample_id[match(colnames(m), alias$virome)]
  m[, calc_order, drop = FALSE]
}
ab <- lapply(abun_tables, load_abun)
rwv_check(checks, "virome abundance tables: 3,060 rows each, identical row and column order", TRUE,
          all(vapply(ab, nrow, 0L) == 3060L) && all(vapply(ab, function(m) identical(dimnames(m), dimnames(ab$count)), logical(1))))
rwv_check(checks, "virome abundance: no missing value, no negative value", c(FALSE, FALSE),
          c(any(vapply(ab, anyNA, logical(1))), any(vapply(ab, function(m) any(m < 0), logical(1)))))
contig_anno <- DBI::dbGetQuery(con, "SELECT * FROM virus_contig_annotation ORDER BY rowid")
cargo <- DBI::dbGetQuery(con, "SELECT * FROM virus_cargo_summary ORDER BY rowid")
taxf <- DBI::dbGetQuery(con, "SELECT * FROM virus_taxonomy_formatted ORDER BY rowid")
DBI::dbDisconnect(con)
rwv_check(checks, "catalogue tables keyed on vOTU_id without duplicates (3,060)", c(3060L, 3060L, 0L, 0L),
          c(nrow(contig_anno), nrow(cargo), anyDuplicated(contig_anno$vOTU_id), anyDuplicated(cargo$vOTU_id)))
rwv_check(checks, "abundance vOTU set equals the catalogue", TRUE, setequal(rownames(ab$count), contig_anno$vOTU_id))
# The formatted taxonomy has 3,533 rows keyed on the representative contig;
# it is joined by vcontig_id, never by row position.
tax_hit <- match(contig_anno$vcontig_id, taxf$vcontig_id)
join_report <- data.frame(
  join = c("virus_taxonomy_formatted by vcontig_id", "virus_cargo_summary by vOTU_id"),
  source_rows = c(nrow(taxf), nrow(cargo)), source_key_duplicates = c(anyDuplicated(taxf$vcontig_id) > 0, anyDuplicated(cargo$vOTU_id) > 0),
  catalogue_rows = nrow(contig_anno), matched = c(sum(!is.na(tax_hit)), sum(contig_anno$vOTU_id %in% cargo$vOTU_id)),
  unmatched = c(sum(is.na(tax_hit)), sum(!contig_anno$vOTU_id %in% cargo$vOTU_id)))
# Catalogue vOTUs without a formatted-taxonomy row keep empty taxonomy (as the
# source's left join did); they are listed rather than dropped.
join_report$unmatched_ids <- c(paste(contig_anno$vOTU_id[is.na(tax_hit)], collapse = ", "), "")
rwv_check(checks, "taxonomy join key is unique (no row duplicated by the join)", FALSE, join_report$source_key_duplicates[1])
rwv_check(checks, "cargo join: every catalogue vOTU matched", 0L, join_report$unmatched[2])
nreads <- read_tab("nreads_virome.tsv")
rwv_check(checks, "nreads aliases map one-to-one onto the seven samples", TRUE, setequal(nreads$sample_id, alias$virome))

# Amplicons: counts, taxonomy, sample table, tree and the registered row order.
amp <- list()
for (a in c("16s", "18s")) {
  tab <- read_tab(paste0(a, "_ASV_table_filt.tsv"))
  tax <- read_tab(paste0(a, "_ASV_tax.tsv"))
  meta <- read_tab(paste0(a, "_metadata.tsv"))
  tree <- ape::read.tree(raw_path(paste0(a, "_tree.nwk")))
  ord <- read_tab(paste0(a, "_legacy_row_order.tsv"))
  al <- alias[[paste0("amp", a)]]
  rwv_check(checks, paste(a, "ASV IDs unique; taxonomy, tree tips and registered order cover exactly the same ASVs"), rep(TRUE, 4),
            c(!anyDuplicated(tab$ASV_ID), setequal(tab$ASV_ID, tax$ASV_ID), setequal(tab$ASV_ID, tree$tip.label), setequal(tab$ASV_ID, ord$feature_id)))
  rwv_check(checks, paste(a, "tree: one tip per ASV, branch lengths present"), c(TRUE, TRUE),
            c(ape::Ntip(tree) == nrow(tab) && !anyDuplicated(tree$tip.label), !is.null(tree$edge.length) && !anyNA(tree$edge.length)))
  rwv_check(checks, paste(a, "sample columns and metadata IDs are the seven aliased samples"), c(TRUE, TRUE),
            c(setequal(setdiff(colnames(tab), "ASV_ID"), al), setequal(meta$ID, al)))
  amp[[a]] <- list(tab = tab, tax = tax, meta = meta, tree = tree, ord = ord$feature_id, alias = al)
}
rwv_check(checks, "18S taxonomy keeps the PR2 Subdivision needed to remove Metazoa", TRUE, "Subdivision" %in% colnames(amp[["18s"]]$tax))
knitr::kable(schema[, c("table", "rows", "columns")])
```

### Task 3: Construct the viral TSE: detection mask, normalization and CLR

```r
vc <- cfg$virome
mask <- ab$covered_fraction >= vc$detect_covered_fraction
apply_mask <- function(m) { m[!mask] <- 0; m }
count_masked <- apply_mask(ab$count)
trimmed_mean_masked <- apply_mask(ab$trimmed_mean)
tpm_masked <- apply_mask(ab$tpm)
trimmed_tpm <- sweep(trimmed_mean_masked, 2, colSums(trimmed_mean_masked), `/`) * vc$tpm_scale
trimmed_tpm[is.nan(trimmed_tpm)] <- 0
rwv_check(checks, "trimmed_tpm sums to one million per sample", TRUE, all(abs(colSums(trimmed_tpm) - vc$tpm_scale) < 1e-3))
clean_reads <- as.numeric(nreads$clean_reads[match(alias$virome, nreads$sample_id)])
trimmed_pmcr <- sweep(trimmed_mean_masked, 2, clean_reads, `/`) * 1e6
# rowData: the catalogue joined to cargo flags by vOTU_id and to the
# formatted taxonomy by the representative contig (first match; the key is
# unique, see Task 2).
rd <- cbind(contig_anno,
            cargo[match(contig_anno$vOTU_id, cargo$vOTU_id), setdiff(colnames(cargo), c("vOTU_id", "VC_id")), drop = FALSE],
            stats::setNames(taxf[tax_hit, c("realm", "kingdom", "phylum", "class", "order", "family", "genus", "species")],
                            paste0("tax_", c("realm", "kingdom", "phylum", "class", "order", "family", "genus", "species"))))
rd <- rd[match(rownames(ab$count), rd$vOTU_id), ]
rownames(rd) <- rd$vOTU_id
cd_v <- smd[match(calc_order, smd$sample_id), ]
cd_v$clean_reads_virome <- clean_reads
cd_v$raw_reads_virome <- as.numeric(nreads$raw_reads[match(alias$virome, nreads$sample_id)])
rownames(cd_v) <- cd_v$sample_id
tse_vir <- TreeSummarizedExperiment::TreeSummarizedExperiment(
  assays = list(count = ab$count, count_masked = count_masked, trimmed_mean = ab$trimmed_mean,
                trimmed_mean_masked = trimmed_mean_masked, trimmed_tpm = trimmed_tpm, trimmed_pmcr = trimmed_pmcr,
                tpm = ab$tpm, tpm_masked = tpm_masked, covered_fraction = ab$covered_fraction),
  rowData = S4Vectors::DataFrame(rd, check.names = FALSE), colData = S4Vectors::DataFrame(cd_v, check.names = FALSE))
tse_vir <- mia::transformAssay(tse_vir, assay.type = "trimmed_tpm", method = "clr", pseudocount = vc$clr_pseudocount, name = "clr")
S4Vectors::metadata(tse_vir) <- list(analysis_version = "analysis-v2026.09.28.1", source = "p0061_snapshot.sqlite",
                                     detect_threshold = vc$detect_covered_fraction, tree = "none (no viral tree is built)")
rwv_check(checks, "virome TSE: 3,060 x 7 in calculation order", c(3060L, 7L, TRUE),
          c(nrow(tse_vir), ncol(tse_vir), identical(colnames(tse_vir), calc_order)))
rwv_check(checks, "breadth mask removes positive counts (cells with reads but covered_fraction < 0.75)", TRUE, sum(ab$count > 0 & !mask) > 0)
```

### Task 4: Construct 16S and 18S TSEs: filtering, rarefaction and transformations

```r
ac <- cfg$amplicon
build_amplicon <- function(a, prefix_gtdb) {
  x <- amp[[a]]
  row_ids <- switch(ac$rarefy_row_order, legacy = x$ord, input_table = x$tab$ASV_ID,
                    rwv_fail("amplicon.rarefy_row_order must be legacy or input_table"))
  cnt <- as.matrix(x$tab[match(row_ids, x$tab$ASV_ID), x$alias])
  storage.mode(cnt) <- "double"
  rownames(cnt) <- row_ids
  colnames(cnt) <- alias$sample_id[match(colnames(cnt), x$alias)]
  cnt <- cnt[, calc_order, drop = FALSE]
  tax <- x$tax[match(row_ids, x$tax$ASV_ID), setdiff(colnames(x$tax), c("ASV_ID", "sequence")), drop = FALSE]
  tax$confidence <- as.numeric(tax$confidence)
  rownames(tax) <- row_ids
  meta <- x$meta[match(x$alias[match(calc_order, alias$sample_id)], x$meta$ID), c("location", "water_type", "country", "replicate")]
  meta$replicate <- as.integer(meta$replicate)
  rownames(meta) <- calc_order
  tse <- TreeSummarizedExperiment::TreeSummarizedExperiment(
    assays = list(counts = cnt), rowData = S4Vectors::DataFrame(tax, check.names = FALSE),
    colData = S4Vectors::DataFrame(meta, check.names = FALSE), rowTree = x$tree)
  if (!identical(rownames(tse), row_ids)) rwv_fail(a, ": the TSE constructor changed the row order")
  rdx <- as.data.frame(SummarizedExperiment::rowData(tse), stringsAsFactors = FALSE)
  if (prefix_gtdb) {
    ranks <- c(Kingdom = "d__", Phylum = "p__", Class = "c__", Order = "o__", Family = "f__", Genus = "g__", Species = "s__")
    rdx$gtdb_lineage <- do.call(paste, c(Map(function(col, p) paste0(p, col), rdx[names(ranks)], ranks), sep = ";"))
    for (rk in names(ranks)) rdx[[paste0("gtdb_", tolower(rk))]] <- paste0(ranks[[rk]], rdx[[rk]])
  } else {
    pr2 <- c("Domain", "Supergroup", "Division", "Subdivision", "Class", "Order", "Family", "Genus", "Species")
    rdx$pr2_lineage <- do.call(paste, c(rdx[pr2], sep = ";"))
    rdx$pr2_lineage[rdx$pr2_lineage == strrep(";", length(pr2) - 1)] <- NA_character_
  }
  keep <- rowSums(cnt >= ac$filter_min_reads) >= ac$filter_min_samples
  tse <- tse[keep, ]
  SummarizedExperiment::rowData(tse) <- S4Vectors::DataFrame(rdx[keep, ], check.names = FALSE)
  # Project sample table joined by sample_id (location from the curated table;
  # water_type of the sequencing sheet must equal water_condition).
  cdx <- as.data.frame(SummarizedExperiment::colData(tse), stringsAsFactors = FALSE)
  cdx$sample_id <- rownames(cdx)
  s <- smd[match(cdx$sample_id, smd$sample_id), ]
  cdx$desc <- s$desc; cdx$water_condition <- s$water_condition
  cdx$id_virome_hpc <- s$id_virome_hpc; cdx$id_16s_hpc <- s$id_16s_hpc; cdx$id_18s_hpc <- s$id_18s_hpc
  cdx$location <- ifelse(is.na(s$location), cdx$location, s$location)
  if (!identical(cdx$water_type, cdx$water_condition)) rwv_fail(a, ": water_type differs from water_condition")
  SummarizedExperiment::colData(tse) <- S4Vectors::DataFrame(cdx, check.names = FALSE)
  filtered <- tse
  depth <- min(colSums(SummarizedExperiment::assay(tse, "counts")))
  set.seed(ac$rarefy_seed)
  tse <- mia::rarefyAssay(tse, assay.type = "counts", sample = depth, name = "rarefied",
                          replace = isTRUE(ac$rarefy_replace), verbose = FALSE)
  tse <- mia::transformAssay(tse, assay.type = "counts", method = "relabundance", name = "relabundance")
  tse <- mia::transformAssay(tse, assay.type = "counts", method = "clr", pseudocount = ac$clr_pseudocount, name = "clr")
  tse <- TreeSummarizedExperiment::changeTree(tse, rowTree = ape::keep.tip(TreeSummarizedExperiment::rowTree(tse), rownames(tse)))
  list(tse = tse, filtered = filtered, depth = depth,
       record = data.frame(omic = a, input_rows = nrow(cnt), row_order = ac$rarefy_row_order, kept_after_filter = sum(keep),
                           rarefy_depth = depth, rows_after_rarefy = nrow(tse), rarefy_seed = ac$rarefy_seed,
                           replace = isTRUE(ac$rarefy_replace), tree_tips = ape::Ntip(TreeSummarizedExperiment::rowTree(tse))))
}
b16 <- build_amplicon("16s", prefix_gtdb = TRUE)
b18 <- build_amplicon("18s", prefix_gtdb = FALSE)
tse_16s <- b16$tse; tse_18s_all <- b18$tse
rwv_check(checks, "16S/18S trees pruned to the surviving rows", c(TRUE, TRUE),
          c(ape::Ntip(TreeSummarizedExperiment::rowTree(tse_16s)) == nrow(tse_16s),
            ape::Ntip(TreeSummarizedExperiment::rowTree(tse_18s_all)) == nrow(tse_18s_all)))
for (x in list(list("16S", tse_16s, b16$depth), list("18S", tse_18s_all, b18$depth))) {
  rs <- colSums(SummarizedExperiment::assay(x[[2]], "rarefied"))
  rwv_check(checks, paste(x[[1]], "rarefied totals equal the depth"), TRUE, all(rs == x[[3]]))
}
# Microeukaryote view: Metazoa removed after rarefaction (NA Subdivision kept),
# tree pruned, relabundance and CLR rebuilt from counts; the rarefied assay is
# the subset of the full-18S draw and is not redrawn.
is_metazoa <- as.data.frame(SummarizedExperiment::rowData(tse_18s_all))$Subdivision == ac$metazoa_subdivision
is_metazoa[is.na(is_metazoa)] <- FALSE
tse_18s_micro <- tse_18s_all[!is_metazoa, ]
tse_18s_micro <- TreeSummarizedExperiment::changeTree(tse_18s_micro,
  rowTree = ape::keep.tip(TreeSummarizedExperiment::rowTree(tse_18s_micro), rownames(tse_18s_micro)))
tse_18s_micro <- mia::transformAssay(tse_18s_micro, assay.type = "counts", method = "relabundance", name = "relabundance")
tse_18s_micro <- mia::transformAssay(tse_18s_micro, assay.type = "counts", method = "clr", pseudocount = ac$clr_pseudocount, name = "clr")
micro_totals <- colSums(SummarizedExperiment::assay(tse_18s_micro, "rarefied"))
rwv_check(checks, "microeukaryote rarefied totals are not equal among samples (Metazoa removed after rarefaction)", TRUE,
          length(unique(micro_totals)) > 1)
for (nm in c("tse_16s", "tse_18s_all", "tse_18s_micro")) {
  obj <- get(nm)
  S4Vectors::metadata(obj) <- list(analysis_version = "analysis-v2026.09.28.1",
                                   source = "ampliseq ASV_table_filt / ASV_tax / metadata / tree.nwk (migrated)",
                                   filter_rule = sprintf(">= %d reads in >= %d sample", ac$filter_min_reads, ac$filter_min_samples),
                                   rarefy_seed = ac$rarefy_seed, row_order = ac$rarefy_row_order)
  assign(nm, obj)
}
```

### Task 5: Save objects and provenance

```r
saveRDS(tse_vir, path_target("tse_virome.rds"))
saveRDS(tse_16s, path_target("tse_16s.rds"))
saveRDS(b16$filtered, path_target("tse_16s_filtered.rds"))
saveRDS(tse_18s_all, path_target("tse_18s_all.rds"))
saveRDS(tse_18s_micro, path_target("tse_18s_microeuk.rds"))
objects <- data.frame(
  object = c("tse_virome", "tse_16s", "tse_16s_filtered", "tse_18s_all", "tse_18s_microeuk"),
  rows = c(nrow(tse_vir), nrow(tse_16s), nrow(b16$filtered), nrow(tse_18s_all), nrow(tse_18s_micro)),
  columns = 7L,
  assays = c(paste(SummarizedExperiment::assayNames(tse_vir), collapse = ", "),
             paste(SummarizedExperiment::assayNames(tse_16s), collapse = ", "),
             paste(SummarizedExperiment::assayNames(b16$filtered), collapse = ", "),
             paste(SummarizedExperiment::assayNames(tse_18s_all), collapse = ", "),
             paste(SummarizedExperiment::assayNames(tse_18s_micro), collapse = ", ")),
  tree = c("none", rep("pruned ASV tree", 4)),
  note = c("SQLite snapshot; mask covered_fraction >= 0.75; trimmed_tpm and trimmed_pmcr; clr on trimmed_tpm",
           "filtered, rarefied (drops rows that become all-zero), relabundance and clr from counts",
           "filtered counts before rarefaction (the 16S genus set used for CRISPR visibility)",
           "as 16S, PR2 taxonomy", "Metazoa removed after rarefaction; relabundance and clr rebuilt from counts"))
rng <- RNGkind()
record <- rbind(b16$record, b18$record)
record$rng_kind <- paste(rng, collapse = "/")
record$mia <- as.character(utils::packageVersion("mia"))
rwv_write_tsv(objects, path_target("tse-objects.tsv"))
rwv_write_tsv(record, path_target("rarefy-record.tsv"))
rwv_write_tsv(schema, path_target("sqlite-schema.tsv"))
rwv_write_tsv(join_report, path_target("join-report.tsv"))
rwv_write_tsv(alias, path_target("sample-aliases.tsv"))
knitr::kable(record)
check_table <- rwv_checks_finish(checks, path_target("tse-checks.tsv"))
knitr::kable(check_table[, c("check", "expected", "observed", "pass")])
rwv_write_session_info(path_target("session-info.txt"),
                       c(step = params$name, run_id = step$run_id, mode = step$mode, quarto = rwv_quarto_version()))
```
