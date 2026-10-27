# Shared helpers of the community analysis (analysis-v2026.09.28.1).
# Authors (display order): Jinlong Ru, Cunli Pan

# Dispersion status of one betadisper comparison from its two permutation p
# values (plain and bias-adjusted median). A test that did not return a
# finite p value is "undetermined", never read as a negative result; the
# reason says which test failed and why.
rwv_dispersion_status <- function(p_perm, p_perm_adj, err_perm = NULL, err_adj = NULL, alpha = 0.05) {
  bad <- c(permutation = !isTRUE(is.finite(p_perm)), bias_adjusted = !isTRUE(is.finite(p_perm_adj)))
  if (any(bad)) {
    why <- c(permutation = if (is.null(err_perm)) "no finite p value" else err_perm,
             bias_adjusted = if (is.null(err_adj)) "no finite p value" else err_adj)
    return(list(status = "undetermined",
                reason = paste(sprintf("%s test: %s", names(bad)[bad], why[bad]), collapse = "; ")))
  }
  status <- if (p_perm < alpha && p_perm_adj < alpha) "flagged_both" else
    if (p_perm < alpha || p_perm_adj < alpha) "method_dependent" else "not_flagged"
  list(status = status, reason = "")
}

# The community rebuild implements one frozen method. Each value of
# analyses/R/community.yml that selects a method must be a supported value;
# anything else stops the step instead of being silently ignored.
rwv_community_config_check <- function(cfg) {
  bad <- character(0)
  need <- function(ok, what) if (!isTRUE(ok)) bad <<- c(bad, what)
  int1 <- function(x) is.numeric(x) && length(x) == 1L && is.finite(x) && x == round(x)
  known <- list(top = c("calculation_sample_order", "virome", "amplicon", "diversity", "crossomics", "hosts"),
                virome = c("detect_covered_fraction", "tpm_scale", "clr_pseudocount", "alpha_seed", "alpha_iterations", "alpha_depth"),
                amplicon = c("filter_min_reads", "filter_min_samples", "rarefy_seed", "rarefy_replace", "rarefy_depth",
                             "rarefy_row_order", "clr_pseudocount", "metazoa_subdivision"),
                diversity = c("alpha_indices", "pcoa_k", "permanova_formula", "permanova_by", "permanova_permutations",
                              "permanova_seed", "betadisper_groups", "betadisper_permutations", "betadisper_seed"),
                crossomics = c("assays", "seed", "permutations", "mantel_method", "pcoa_k"),
                hosts = c("iphop_min_confidence"))
  need(setequal(names(cfg), known$top), "top-level sections")
  for (sec in setdiff(names(known), "top")) {
    extra <- setdiff(names(cfg[[sec]]), known[[sec]]); miss <- setdiff(known[[sec]], names(cfg[[sec]]))
    need(!length(extra), paste0(sec, ": unknown key(s) ", paste(extra, collapse = ", ")))
    need(!length(miss), paste0(sec, ": missing key(s) ", paste(miss, collapse = ", ")))
  }
  so <- unlist(cfg$calculation_sample_order)
  need(length(so) == 7L && !anyDuplicated(so) && setequal(so, c("bc1", "bc2", "bd1", "gc1", "gd1", "oc1", "od1")),
       "calculation_sample_order: the seven samples, each once")
  v <- cfg$virome; a <- cfg$amplicon; d <- cfg$diversity; x <- cfg$crossomics
  need(is.numeric(v$detect_covered_fraction) && v$detect_covered_fraction > 0 && v$detect_covered_fraction <= 1, "virome.detect_covered_fraction in (0, 1]")
  need(identical(as.numeric(v$tpm_scale), 1e6), "virome.tpm_scale: 1000000")
  need(is.numeric(v$clr_pseudocount) && v$clr_pseudocount > 0, "virome.clr_pseudocount > 0")
  need(int1(v$alpha_seed) && int1(v$alpha_iterations) && v$alpha_iterations >= 1, "virome.alpha_seed / alpha_iterations: integers")
  need(identical(v$alpha_depth, "minimum"), "virome.alpha_depth: only 'minimum' (the smallest masked read total) is implemented")
  need(int1(a$filter_min_reads) && int1(a$filter_min_samples) && a$filter_min_reads >= 1 && a$filter_min_samples >= 1, "amplicon.filter_*: positive integers")
  need(int1(a$rarefy_seed) && is.logical(a$rarefy_replace) && length(a$rarefy_replace) == 1L, "amplicon.rarefy_seed / rarefy_replace")
  need(identical(a$rarefy_depth, "minimum"), "amplicon.rarefy_depth: only 'minimum' (the smallest filtered sample total) is implemented")
  need(isTRUE(a$rarefy_row_order %in% c("legacy", "input_table")), "amplicon.rarefy_row_order: legacy or input_table")
  need(is.numeric(a$clr_pseudocount) && a$clr_pseudocount > 0, "amplicon.clr_pseudocount > 0")
  need(identical(a$metazoa_subdivision, "Metazoa"), "amplicon.metazoa_subdivision: Metazoa")
  need(length(unlist(d$alpha_indices)) >= 1 && all(unlist(d$alpha_indices) %in% c("observed", "shannon", "pielou", "faith")),
       "diversity.alpha_indices: observed, shannon, pielou, faith")
  need(int1(d$pcoa_k) && d$pcoa_k >= 2, "diversity.pcoa_k: integer >= 2")
  need(identical(d$permanova_formula, "~ location + water_condition"), "diversity.permanova_formula: only '~ location + water_condition' is implemented")
  need(identical(d$permanova_by, "margin"), "diversity.permanova_by: margin")
  need(int1(d$permanova_permutations) && int1(d$betadisper_permutations) && int1(d$permanova_seed) && int1(d$betadisper_seed),
       "diversity permutations and seeds: integers")
  need(identical(unlist(d$betadisper_groups), c("water_condition", "location")),
       "diversity.betadisper_groups: only [water_condition, location] is implemented (in this order)")
  need(identical(unlist(x$assays), c("virome", "bact_16s", "euk_18s_microeuk")), "crossomics.assays: virome, bact_16s, euk_18s_microeuk")
  need(int1(x$seed) && int1(x$permutations), "crossomics.seed / permutations: integers")
  need(identical(x$mantel_method, "spearman"), "crossomics.mantel_method: spearman")
  need(identical(x$pcoa_k, "full_rank"), "crossomics.pcoa_k: only 'full_rank' (n - 1) is implemented")
  need(identical(as.numeric(cfg$hosts$iphop_min_confidence), 90), "hosts.iphop_min_confidence: 90 (the archived records were selected at 90)")
  bad
}

# Compare the name sets of a legacy and a rebuilt object part (assays, fields,
# distances). A legacy name missing from the rebuilt set, or an empty common
# set, is a difference; rebuilt-only names are additions.
rwv_name_sets <- function(old, new) {
  miss <- setdiff(old, new); add <- setdiff(new, old); common <- intersect(old, new)
  list(missing = miss, added = add, common = common,
       status = if (length(miss) || !length(common)) "different" else "identical")
}

# ---------------------------------------------------------------------------
# Community calculation from the TSEs of 012 (analysis-v2026.09.28.1).
# One function per scientific task; 020-community-analysis calls them in this
# order and 014-legacy-comparison calls the same functions to recompute
# independently. Each reproduces the historical specification listed in
# docs/ANALYSIS-REBUILD-PLAN.md section 3 with the values of
# analyses/R/community.yml; every random step sets its seed where the source did,
# so calling order and results are the same as in the source project.

rwv_comm_cd <- function(x) as.data.frame(SummarizedExperiment::colData(x), stringsAsFactors = FALSE)
rwv_comm_prov <- function(file, content, method) data.frame(file = file, content = content, method = method)

# Composition: per-assay taxon sums and within-sample shares (virome
# trimmed_tpm by tax_class, 16S relabundance by gtdb_phylum without p__,
# microeukaryote relabundance by Division; empty labels -> Unclassified).
rwv_comm_composition <- function(tse, calc_order, checks) {
  spec <- data.frame(omic = c("virome", "bact_16s", "euk_18s_microeuk"), rank = c("tax_class", "gtdb_phylum", "Division"),
                     assay = c("trimmed_tpm", "relabundance", "relabundance"))
  composition <- list(); taxonomy <- list(); comp_checks <- list()
  for (i in seq_len(nrow(spec))) {
    nm <- spec$omic[i]; x <- tse[[nm]]
    mat <- as.matrix(SummarizedExperiment::assay(x, spec$assay[i]))
    rd <- as.data.frame(SummarizedExperiment::rowData(x), stringsAsFactors = FALSE)
    raw_lab <- as.character(rd[[spec$rank[i]]])
    clean <- raw_lab
    if (nm == "bact_16s") clean <- sub("^p__", "", clean)
    clean[is.na(clean) | clean == ""] <- "Unclassified"
    taxonomy[[nm]] <- data.frame(omic = nm, feature_id = rownames(rd), source_field = spec$rank[i], raw_label = raw_lab, display_taxon = clean)
    agg <- rowsum(mat[, calc_order, drop = FALSE], group = clean, reorder = TRUE)
    rel <- sweep(agg, 2, colSums(agg), "/")
    composition[[nm]] <- do.call(rbind, lapply(calc_order, function(s) {
      data.frame(omic = nm, sample_id = s, taxonomic_rank = spec$rank[i], taxon = rownames(agg),
                 source_assay = spec$assay[i], abundance_sum = unname(agg[, s]), relative_abundance = unname(rel[, s]))
    }))
    comp_checks[[nm]] <- data.frame(omic = nm, source_features = nrow(mat), samples = ncol(mat), taxonomy_groups = nrow(agg),
                                    max_composition_sum_error = max(abs(colSums(rel) - 1)))
  }
  rwv_check(checks, "composition: every sample sums to 1 within each assay", TRUE,
            all(vapply(comp_checks, function(z) z$max_composition_sum_error < 1e-12, logical(1))))
  list(composition_full = do.call(rbind, composition), feature_taxonomy = do.call(rbind, taxonomy), comp_checks = comp_checks,
       prov = rwv_comm_prov("composition_full / feature_taxonomy", "per-assay taxon sums and within-sample shares",
                            "virome trimmed_tpm by tax_class; 16S relabundance by gtdb_phylum (p__ removed); microeukaryote relabundance by Division; empty -> Unclassified"))
}

# Alpha diversity: amplicons by mia::addAlpha on the rarefied assay; the
# virome by 100 draws of vegan::rrarefy of round(count_masked) at the minimum
# depth (seed from config), mean and SD; depth diagnostics and the same-site
# c/d record-label contrasts (bc2 has no counterpart).
rwv_comm_alpha <- function(tse, cfg, calc_order, checks) {
  amp <- c("bact_16s", "euk_18s_all", "euk_18s_microeuk")
  for (nm in amp) for (ix in unlist(cfg$diversity$alpha_indices)) tse[[nm]] <- mia::addAlpha(tse[[nm]], assay.type = "rarefied", index = ix, name = ix)
  alpha_summary <- do.call(rbind, lapply(amp, function(nm) {
    cd <- rwv_comm_cd(tse[[nm]])
    data.frame(experiment = nm, sample_id = cd$sample_id, desc = cd$desc, location = cd$location, water_condition = cd$water_condition,
               observed = cd$observed, shannon = cd$shannon, pielou = cd$pielou, faith = cd$faith)
  }))
  vc <- cfg$virome
  cdv <- rwv_comm_cd(tse$virome)
  m <- t(round(as.matrix(SummarizedExperiment::assay(tse$virome, "count_masked"))))
  rwv_check(checks, "virome alpha matrix: samples in calculation order, non-negative", c(TRUE, TRUE), c(identical(rownames(m), calc_order), all(m >= 0)))
  alpha_fun <- function(x) {
    s <- vegan::specnumber(x); h <- vegan::diversity(x, "shannon")
    data.frame(observed = s, shannon = h, pielou = ifelse(s > 1, h / log(s), NA))
  }
  raw_alpha <- alpha_fun(m)
  depth <- rowSums(m); rdepth <- min(depth)
  set.seed(vc$alpha_seed)
  it <- replicate(vc$alpha_iterations, as.matrix(alpha_fun(vegan::rrarefy(m, rdepth))), simplify = "array")
  rar <- apply(it, c(1, 2), mean); rar_sd <- apply(it, c(1, 2), stats::sd)
  virome_alpha <- data.frame(experiment = "virome", sample_id = cdv$sample_id, desc = cdv$desc, location = cdv$location,
                             water_condition = cdv$water_condition, masked_reads = depth, rarefy_depth = rdepth,
                             observed = rar[, "observed"], shannon = rar[, "shannon"], pielou = rar[, "pielou"],
                             observed_sd = rar_sd[, "observed"], shannon_sd = rar_sd[, "shannon"],
                             observed_unrarefied = raw_alpha$observed, shannon_unrarefied = raw_alpha$shannon,
                             pielou_unrarefied = raw_alpha$pielou, row.names = NULL)
  viral_load <- data.frame(sample_id = cdv$sample_id, mapped_viral_reads = colSums(SummarizedExperiment::assay(tse$virome, "count_masked")),
                           clean_reads = cdv$clean_reads_virome, row.names = NULL)
  viral_load$viral_fraction <- viral_load$mapped_viral_reads / viral_load$clean_reads
  viral_load <- cbind(viral_load, cdv[, c("desc", "location", "water_condition")])
  rownames(viral_load) <- NULL
  depth_check <- data.frame(
    metric = c("observed_unrarefied~mapped_viral_reads", "observed_unrarefied~clean_reads", "observed_rarefied~mapped_viral_reads"),
    spearman_rho = c(stats::cor(virome_alpha$observed_unrarefied, viral_load$mapped_viral_reads, method = "spearman"),
                     stats::cor(virome_alpha$observed_unrarefied, viral_load$clean_reads, method = "spearman"),
                     stats::cor(virome_alpha$observed, viral_load$mapped_viral_reads, method = "spearman")))
  all_a <- rbind(alpha_summary[alpha_summary$experiment %in% c("bact_16s", "euk_18s_microeuk"), c("experiment", "sample_id", "observed", "shannon", "pielou")],
                 virome_alpha[, c("experiment", "sample_id", "observed", "shannon", "pielou")])
  pair_def <- list(Tsinghua = c("bc1", "bd1"), Garching = c("gc1", "gd1"), Oberschleissheim = c("oc1", "od1"))
  label_pairs <- do.call(rbind, lapply(split(all_a, all_a$experiment), function(d) do.call(rbind, lapply(names(pair_def), function(p) {
    cl <- d[d$sample_id == pair_def[[p]][1], ]; di <- d[d$sample_id == pair_def[[p]][2], ]
    data.frame(experiment = d$experiment[1], pair = p, observed_clean = cl$observed, observed_dirty = di$observed,
               shannon_clean = cl$shannon, shannon_dirty = di$shannon, shannon_diff_dirty_minus_clean = di$shannon - cl$shannon)
  }))))
  rownames(label_pairs) <- NULL
  list(tse = tse, alpha_summary = alpha_summary, virome_alpha = virome_alpha, viral_load_per_sample = viral_load,
       virome_depth_check = depth_check, label_pairs = label_pairs,
       prov = rbind(rwv_comm_prov("alpha_summary", "amplicon alpha on the rarefied assay", "mia::addAlpha observed, shannon, pielou, faith"),
                    rwv_comm_prov("virome_alpha / viral_load_per_sample / virome_depth_check / label_pairs", "virome alpha, load and depth diagnostics",
                                  sprintf("round(count_masked); vegan::rrarefy x %d at depth %d, seed %d; Spearman rho (n = 7)", vc$alpha_iterations, rdepth, vc$alpha_seed))))
}

# Distances, PCoA, marginal PERMANOVA and betadisper for the four assays.
# Aitchison = Euclidean on clr; Bray and binary Jaccard on relabundance
# (virome trimmed_tpm / 1e6); UniFrac on rarefied; seeds as in the source
# (once per assay before its PERMANOVAs; before every permutest).
rwv_comm_diversity <- function(tse, cfg, calc_order, comp_checks) {
  dv <- cfg$diversity
  perm_log <- list()
  curate <- function(x, has_tree) {
    diss <- list()
    diss$aitchison <- as.matrix(stats::dist(t(SummarizedExperiment::assay(x, "clr")), method = "euclidean"))
    bc_input <- if ("relabundance" %in% SummarizedExperiment::assayNames(x)) t(SummarizedExperiment::assay(x, "relabundance")) else
      t(SummarizedExperiment::assay(x, "trimmed_tpm") / 1e6)
    diss$bray <- as.matrix(vegan::vegdist(bc_input, method = "bray"))
    diss$jaccard <- as.matrix(vegan::vegdist(bc_input, method = "jaccard", binary = TRUE))
    if (has_tree) {
      diss$unifrac_weighted <- as.matrix(mia::getDissimilarity(x, method = "unifrac", weighted = TRUE, assay.type = "rarefied"))
      diss$unifrac_unweighted <- as.matrix(mia::getDissimilarity(x, method = "unifrac", weighted = FALSE, assay.type = "rarefied"))
    }
    pcoa <- lapply(diss, function(d) {
      p <- stats::cmdscale(stats::as.dist(d), k = dv$pcoa_k, eig = TRUE)
      list(points = p$points, eig = p$eig, pct = 100 * p$eig[1:2] / sum(abs(p$eig)))
    })
    cd <- as.data.frame(SummarizedExperiment::colData(x), stringsAsFactors = FALSE)
    perm <- list(); bd <- list()
    set.seed(dv$permanova_seed)
    for (nm in names(diss)) {
      f <- stats::update(stats::as.formula(dv$permanova_formula), stats::as.dist(diss[[nm]]) ~ .)
      res <- vegan::adonis2(f, data = cd, by = dv$permanova_by, permutations = dv$permanova_permutations)
      perm[[nm]] <- as.data.frame(res)
      # The permuted statistics actually used; the printed heading can report
      # the size of the complete permutation set (5039) instead.
      perm_log[[length(perm_log) + 1L]] <<- data.frame(component = "adonis2", object = nm, permutations_used = nrow(as.matrix(attr(res, "F.perm"))))
      for (g in unlist(dv$betadisper_groups)) bd[[paste0(nm, if (g == "water_condition") "_water" else "_location")]] <- vegan::betadisper(stats::as.dist(diss[[nm]]), cd[[g]])
    }
    list(diss = diss, pcoa = pcoa, perm = perm, bd = bd, cd = cd)
  }
  div <- list(virome = curate(tse$virome, FALSE), bact_16s = curate(tse$bact_16s, TRUE),
              euk_18s_all = curate(tse$euk_18s_all, TRUE), euk_18s_microeuk = curate(tse$euk_18s_microeuk, TRUE))
  perm_rows <- do.call(rbind, lapply(names(div), function(e) do.call(rbind, lapply(names(div[[e]]$perm), function(d) {
    x <- div[[e]]$perm[[d]]; x$term <- rownames(x)
    x <- x[x$term %in% c("location", "water_condition"), ]
    data.frame(experiment = e, dissimilarity = d, term = x$term, df = x$Df, R2 = x$R2, F_stat = x$F, p = x$`Pr(>F)`)
  }))))
  perm_rows <- perm_rows[order(perm_rows$experiment, perm_rows$dissimilarity, perm_rows$term, method = "radix"), ]
  rownames(perm_rows) <- NULL
  bd_rows <- do.call(rbind, lapply(names(div), function(e) do.call(rbind, lapply(names(div[[e]]$bd), function(rk) {
    b <- div[[e]]$bd[[rk]]
    grp <- if (grepl("_water$", rk)) "water_condition" else "location"
    dname <- sub("_(water|location)$", "", rk)
    b_adj <- vegan::betadisper(stats::as.dist(div[[e]]$diss[[dname]]), div[[e]]$cd[[grp]], type = "median", bias.adjust = TRUE)
    p_par <- tryCatch(stats::anova(b)[1, "Pr(>F)"], error = function(err) NA_real_)
    err_perm <- NULL; err_adj <- NULL
    set.seed(dv$betadisper_seed)
    pt <- tryCatch(vegan::permutest(b, permutations = dv$betadisper_permutations), error = function(err) { err_perm <<- conditionMessage(err); NULL })
    p_par_adj <- tryCatch(stats::anova(b_adj)[1, "Pr(>F)"], error = function(err) NA_real_)
    set.seed(dv$betadisper_seed)
    pt_adj <- tryCatch(vegan::permutest(b_adj, permutations = dv$betadisper_permutations), error = function(err) { err_adj <<- conditionMessage(err); NULL })
    p_perm <- if (is.null(pt)) NA_real_ else pt$tab[1, "Pr(>F)"]
    p_perm_adj <- if (is.null(pt_adj)) NA_real_ else pt_adj$tab[1, "Pr(>F)"]
    perm_log[[length(perm_log) + 1L]] <<- data.frame(component = "permutest", object = paste(e, rk),
                                                     permutations_used = if (is.null(pt)) NA_integer_ else nrow(as.matrix(pt$perm)))
    # A failed or incomplete test is "undetermined" with its reason, never "not_flagged".
    ds <- rwv_dispersion_status(p_perm, p_perm_adj, err_perm, err_adj)
    data.frame(experiment = e, diss_x_group = rk, p_betadisper = p_par, p_betadisper_parametric = p_par,
               p_betadisper_permutation = p_perm, p_betadisper_parametric_bias_adjusted = p_par_adj,
               p_betadisper_permutation_bias_adjusted = p_perm_adj, dispersion_status = ds$status, dispersion_status_reason = ds$reason)
  }))))
  rownames(bd_rows) <- NULL
  shown <- c("virome", "bact_16s", "euk_18s_microeuk")
  pcoa_out <- do.call(rbind, lapply(shown, function(nm) {
    p <- div[[nm]]$pcoa$aitchison
    data.frame(omic = nm, sample_id = calc_order, PCoA1 = p$points[calc_order, 1], PCoA2 = p$points[calc_order, 2],
               axis1_percent = p$pct[1], axis2_percent = p$pct[2], source_reducedDim = "aitchison_PCoA", row.names = NULL)
  }))
  export_checks <- do.call(rbind, comp_checks)
  export_checks$axis1_percent <- vapply(export_checks$omic, function(o) div[[o]]$pcoa$aitchison$pct[1], 0)
  export_checks$axis2_percent <- vapply(export_checks$omic, function(o) div[[o]]$pcoa$aitchison$pct[2], 0)
  rownames(export_checks) <- NULL
  eigen_out <- do.call(rbind, lapply(names(div), function(e) do.call(rbind, lapply(names(div[[e]]$pcoa), function(d) {
    data.frame(experiment = e, dissimilarity = d, axis = seq_along(div[[e]]$pcoa[[d]]$eig), eigenvalue = div[[e]]$pcoa[[d]]$eig)
  }))))
  list(div = div, permanova_marginal = perm_rows, betadisper_summary = bd_rows, pcoa_aitchison = pcoa_out, export_checks = export_checks,
       pcoa_eigen = eigen_out, distances = lapply(div, function(z) z$diss), perm_log = do.call(rbind, perm_log),
       prov = rbind(rwv_comm_prov("permanova_marginal", "marginal PERMANOVA for every distance",
                                  sprintf("adonis2(%s, by = margin, %d permutations); set.seed(%d) once per assay before its distances",
                                          dv$permanova_formula, dv$permanova_permutations, dv$permanova_seed)),
                    rwv_comm_prov("betadisper_summary", "dispersion checks (parametric, permutation, bias-adjusted median)",
                                  sprintf("vegan::betadisper; permutest %d permutations requested, set.seed(%d) before every call; failed tests are undetermined",
                                          dv$betadisper_permutations, dv$betadisper_seed)),
                    rwv_comm_prov("pcoa_aitchison / pcoa-eigen / distances", "Aitchison and other distances, PCoA",
                                  "Aitchison = Euclidean on clr; Bray and binary Jaccard on relabundance (virome trimmed_tpm/1e6); UniFrac on rarefied; cmdscale k = 2, % = eig / sum(|eig|)")))
}

# Cross-assay covariation of the Aitchison distances: full-rank PCoA,
# Procrustes (protest) then Mantel for each pair, one seed for all pairs,
# and the RV coefficient.
rwv_comm_crossomics <- function(div, cfg, calc_order) {
  xc <- cfg$crossomics
  omics <- unlist(xc$assays)
  diss_a <- lapply(omics, function(o) div[[o]]$diss$aitchison); names(diss_a) <- omics
  rv_coef <- function(X, Y) {
    Sx <- tcrossprod(scale(X, scale = FALSE)); Sy <- tcrossprod(scale(Y, scale = FALSE))
    sum(Sx * Sy) / sqrt(sum(Sx * Sx) * sum(Sy * Sy))
  }
  k_full <- length(calc_order) - 1L
  perm_log <- list()
  set.seed(xc$seed)
  cross <- do.call(rbind, lapply(utils::combn(omics, 2, simplify = FALSE), function(pr) {
    d1 <- stats::as.dist(diss_a[[pr[1]]]); d2 <- stats::as.dist(diss_a[[pr[2]]])
    p1 <- stats::cmdscale(d1, k = k_full, eig = TRUE)$points; p2 <- stats::cmdscale(d2, k = k_full, eig = TRUE)$points
    prot <- vegan::protest(p1, p2, permutations = xc$permutations)
    mant <- vegan::mantel(d1, d2, method = xc$mantel_method, permutations = xc$permutations)
    perm_log[[length(perm_log) + 1L]] <<- data.frame(component = c("protest", "mantel"), object = paste(pr, collapse = " x "),
                                                     permutations_used = c(prot$permutations, mant$permutations))
    data.frame(pair = paste(pr[1], "x", pr[2]), omic_1 = pr[1], omic_2 = pr[2], proc_m2 = prot$ss, proc_corr = prot$t0,
               proc_p = prot$signif, mantel_r = mant$statistic, mantel_p = mant$signif, rv_coef = rv_coef(p1, p2))
  }))
  list(crossomics_pairwise = cross, perm_log = do.call(rbind, perm_log),
       prov = rwv_comm_prov("crossomics_pairwise", "Procrustes, Mantel and RV for the three assay pairs",
                            sprintf("full-rank PCoA (k = %d); set.seed(%d) once; per pair protest then Mantel (%s), %d permutations each",
                                    k_full, xc$seed, xc$mantel_method, xc$permutations)))
}

# Host visibility and co-detection on the archived host evidence. iPHoP: the
# 200 archived best records are kept; visibility, prevalence and co-detection
# use the final 16S TSE (genera without an empty or bare g__ name) and the
# masked virome. CRISPR: the 29 archived strict edges are kept; visibility
# uses the filtered 16S table before rarefaction (genus "g__" + Genus, empty
# genus kept); co-detection with masked and raw vOTU presence.
rwv_comm_hosts <- function(tse, tse_16s_filtered, hm, cr, cfg, calc_order, checks) {
  rwv_check(checks, "archived iPHoP records: 200 unique vOTUs at confidence >= 90", c(200L, TRUE),
            c(length(unique(hm$vOTU_id)), all(as.numeric(hm$iphop_confidence) >= cfg$hosts$iphop_min_confidence)))
  rd16 <- as.data.frame(SummarizedExperiment::rowData(tse$bact_16s), stringsAsFactors = FALSE)
  cnt16 <- SummarizedExperiment::assay(tse$bact_16s, "counts")[, calc_order, drop = FALSE]
  keep_g <- !is.na(rd16$gtdb_genus) & rd16$gtdb_genus != "" & rd16$gtdb_genus != "g__"
  host_present <- rowsum(cnt16[keep_g, , drop = FALSE], group = rd16$gtdb_genus[keep_g], reorder = FALSE) > 0
  votu_masked <- SummarizedExperiment::assay(tse$virome, "count_masked")[, calc_order, drop = FALSE] > 0
  genus <- ifelse(hm$host_genus_clean %in% c("", "NA"), NA_character_, hm$host_genus_clean)
  visible <- !is.na(genus) & genus %in% rownames(host_present)
  hm$host_in_16s_clean <- ifelse(is.na(genus), "NA", ifelse(visible, "1", "0"))
  hm$visibility_status <- ifelse(is.na(genus), "genus_unresolved", ifelse(visible, "named_genus_detected_in_16s", "named_genus_not_detected_in_16s"))
  hm$in_127_named_visible_set <- ifelse(visible, "1", "0")
  hm$host_prevalence_saved <- ifelse(visible, vapply(seq_len(nrow(hm)), function(i) if (visible[i]) sum(host_present[genus[i], ]) else NA_real_, 0), NA)
  hm$n_codetected_saved <- ifelse(visible, vapply(seq_len(nrow(hm)), function(i) if (visible[i]) sum(votu_masked[hm$vOTU_id[i], ] & host_present[genus[i], ]) else NA_real_, 0), NA)
  rdf <- as.data.frame(SummarizedExperiment::rowData(tse_16s_filtered), stringsAsFactors = FALSE)
  cntf <- SummarizedExperiment::assay(tse_16s_filtered, "counts")[, calc_order, drop = FALSE]
  gpres <- rowsum(cntf, group = paste0("g__", rdf$Genus), reorder = FALSE) > 0
  votu_raw <- SummarizedExperiment::assay(tse$virome, "count")[, calc_order, drop = FALSE] > 0
  gg <- paste0("g__", cr$host_genus)
  cr$host_visible_in_16s <- ifelse(vapply(gg, function(g) g %in% rownames(gpres) && any(gpres[g, ]), logical(1)), "True", "False")
  codet <- function(pres) vapply(seq_len(nrow(cr)), function(i) {
    if (!cr$vOTU_id[i] %in% rownames(pres) || !gg[i] %in% rownames(gpres)) return(0L)
    as.integer(sum(pres[cr$vOTU_id[i], ] & gpres[gg[i], ]))
  }, 0L)
  cr$n_codetected_masked <- codet(votu_masked)
  cr$n_codetected_raw <- codet(votu_raw)
  cr$votu_prevalence <- as.integer(rowSums(votu_masked)[cr$vOTU_id])
  list(corrected_host_members = hm, crispr_host_edges_primary = cr,
       prov = rbind(rwv_comm_prov("corrected_host_members", "200 archived iPHoP records with recomputed host_in_16s_clean, visibility_status, in_127_named_visible_set, host_prevalence_saved, n_codetected_saved",
                                  "final 16S TSE counts summed by gtdb_genus (empty and bare g__ excluded); present = count > 0; co-detection with count_masked > 0"),
                    rwv_comm_prov("crispr_host_edges_primary", "29 archived strict edges with recomputed host_visible_in_16s, n_codetected_masked, n_codetected_raw, votu_prevalence",
                                  "filtered 16S table before rarefaction by g__ + Genus; masked = count > 0 and covered_fraction >= 0.75; raw = count > 0")))
}

# Per-sample detail behind the Figure 2d co-detection counts (Data 1 S49): one row
# per iPHoP record or strict CRISPR edge and sample, built from the 012 TSEs with
# the same presence rules as rwv_comm_hosts(): vOTU count_masked > 0; iPHoP genus
# from the final 16S object (gtdb_genus), CRISPR genus from the filtered table
# before rarefaction (g__ + Genus); 16S count > 0. Unresolved genera stay NA.
# Works with either analysis version; 020 checks every per-record sum against the
# saved counts, so the table cannot drift from the figure.
rwv_comm_host_codetection <- function(tse_virome, tse_16s, tse_16s_filtered, hm, cr, sample_order) {
  votu_masked <- SummarizedExperiment::assay(tse_virome, "count_masked")[, sample_order, drop = FALSE] > 0
  rd16 <- as.data.frame(SummarizedExperiment::rowData(tse_16s), stringsAsFactors = FALSE)
  cnt16 <- SummarizedExperiment::assay(tse_16s, "counts")[, sample_order, drop = FALSE]
  keep_g <- !is.na(rd16$gtdb_genus) & rd16$gtdb_genus != "" & rd16$gtdb_genus != "g__"
  host_present <- rowsum(cnt16[keep_g, , drop = FALSE], group = rd16$gtdb_genus[keep_g], reorder = FALSE) > 0
  rdf <- as.data.frame(SummarizedExperiment::rowData(tse_16s_filtered), stringsAsFactors = FALSE)
  cntf <- SummarizedExperiment::assay(tse_16s_filtered, "counts")[, sample_order, drop = FALSE]
  gpres <- rowsum(cntf, group = paste0("g__", rdf$Genus), reorder = FALSE) > 0
  per_sample <- function(endpoint, votu, genus, pres, table_note) {
    do.call(rbind, lapply(seq_along(votu), function(i) {
      g <- genus[i]
      gd <- if (is.na(g)) rep(NA, length(sample_order)) else if (g %in% rownames(pres)) pres[g, ] else rep(FALSE, length(sample_order))
      vd <- if (votu[i] %in% rownames(votu_masked)) votu_masked[votu[i], ] else rep(FALSE, length(sample_order))
      data.frame(endpoint = endpoint, vOTU_id = votu[i], host_genus = ifelse(is.na(g), "", g), sample_id = sample_order,
                 vOTU_detected_masked = unname(vd), genus_detected_16s = unname(gd), codetected = unname(vd & gd),
                 genus_table = table_note, stringsAsFactors = FALSE)
    }))
  }
  genus_h <- ifelse(hm$host_genus_clean %in% c("", "NA"), NA_character_, hm$host_genus_clean)
  rbind(per_sample("iPHoP record (score >= 90)", hm$vOTU_id, genus_h, host_present, "final 16S object, gtdb_genus"),
        per_sample("strict CRISPR edge", cr$vOTU_id, paste0("g__", cr$host_genus), gpres, "filtered 16S counts before rarefaction, Genus"))
}

# Read-subsampling curves within the retained count tables (Supplementary Fig. 1c).
# Analytical expectation of the number of features observed in a random subsample
# of n reads drawn without replacement from a sample's own reads (Hurlbert; the
# quantity vegan::rarefy computes): E[S_n] = sum_i 1 - C(N - x_i, n) / C(N, n).
# Deterministic, so no seed. Depths are interpolated within each sample's observed
# total only, never extrapolated. Layers:
#   virome_unmasked  - mapped counts before the breadth mask (count)
#   virome_masked    - breadth-masked counts as in the alpha analysis (count_masked;
#                      the mask was fixed at full depth and is not re-evaluated)
#   bact_16s         - filtered 16S ASV counts before rarefaction (3,093 ASVs)
#   euk_18s_microeuk - reads drawn from the filtered full 18S table (892 ASVs) and
#                      only non-metazoan ASVs counted, the order used for the
#                      microeukaryote alpha diversity (rarefy full 18S, then drop Metazoa)
# Counts are rounded as for the virome alpha analysis; amplicon counts are integers.
rwv_comm_rarefaction_curves <- function(tse_virome, tse_16s_filtered, tse_18s_all, micro_ids, sample_order,
                                        common_depth, n_points = 40L) {
  layer_tables <- list(
    virome_unmasked = list(m = round(SummarizedExperiment::assay(tse_virome, "count")), keep = NULL),
    virome_masked = list(m = round(SummarizedExperiment::assay(tse_virome, "count_masked")), keep = NULL),
    bact_16s = list(m = SummarizedExperiment::assay(tse_16s_filtered, "counts"), keep = NULL),
    euk_18s_microeuk = list(m = SummarizedExperiment::assay(tse_18s_all, "counts"), keep = micro_ids))
  expected <- function(x, n, keep_rows) {
    N <- sum(x)
    if (n >= N) return(sum(x[keep_rows] > 0))
    xi <- x[keep_rows]; xi <- xi[xi > 0]
    sum(1 - exp(lchoose(N - xi, n) - lchoose(N, n)))
  }
  out <- list()
  for (layer in names(layer_tables)) {
    m <- as.matrix(layer_tables[[layer]]$m)[, sample_order, drop = FALSE]
    keep <- layer_tables[[layer]]$keep
    keep_rows <- if (is.null(keep)) rep(TRUE, nrow(m)) else rownames(m) %in% keep
    cd <- common_depth[[layer]]
    for (s in sample_order) {
      x <- as.numeric(m[, s]); N <- sum(x)
      # Quadratic spacing (dense near the plateau, for linear axes) plus log spacing from
      # 100 reads (dense near the origin, for log axes); interpolation only.
      grid <- unique(round(c(N * ((seq_len(n_points) / n_points)^2), 10^seq(2, log10(N), length.out = n_points),
                             if (!is.null(cd) && cd <= N) cd, N)))
      grid <- sort(grid[grid >= 1 & grid <= N])
      out[[length(out) + 1L]] <- data.frame(
        layer = layer, sample_id = s, depth_reads = grid,
        expected_features = vapply(grid, function(n) expected(x, n, keep_rows), numeric(1)),
        sample_total_reads = N, observed_features = sum(x[keep_rows] > 0),
        common_depth = if (is.null(cd)) NA_real_ else cd,
        is_common_depth = if (is.null(cd)) FALSE else grid == cd, stringsAsFactors = FALSE)
    }
  }
  do.call(rbind, out)
}

# Record of seeds, RNG and the permutations actually used.
rwv_comm_rng_record <- function(cfg, perm_log) {
  rng <- rbind(data.frame(component = c("rng_kind", "virome_rrarefy", "adonis2", "permutest", "protest/mantel"),
                          object = c(paste(RNGkind(), collapse = "/"), sprintf("seed %d, %d draws", cfg$virome$alpha_seed, cfg$virome$alpha_iterations),
                                     sprintf("seed %d once per assay", cfg$diversity$permanova_seed),
                                     sprintf("seed %d before every call", cfg$diversity$betadisper_seed),
                                     sprintf("seed %d once for all pairs", cfg$crossomics$seed)),
                          permutations_used = NA_integer_),
               perm_log)
  rng$vegan <- as.character(utils::packageVersion("vegan")); rng$mia <- as.character(utils::packageVersion("mia"))
  rng
}

# All community tables in the order of the tasks above (the archived table
# names, so that 020 and 014 treat both sources alike).
rwv_comm_compute <- function(tse, tse_16s_filtered, hm, cr, cfg, checks) {
  calc_order <- unlist(cfg$calculation_sample_order)
  rwv_check(checks, "all four TSEs in calculation sample order", TRUE, all(vapply(tse, function(x) identical(colnames(x), calc_order), logical(1))))
  comp <- rwv_comm_composition(tse, calc_order, checks)
  alpha <- rwv_comm_alpha(tse, cfg, calc_order, checks)
  divr <- rwv_comm_diversity(alpha$tse, cfg, calc_order, comp$comp_checks)
  cross <- rwv_comm_crossomics(divr$div, cfg, calc_order)
  hosts <- rwv_comm_hosts(alpha$tse, tse_16s_filtered, hm, cr, cfg, calc_order, checks)
  list(tables = list(composition_full = comp$composition_full, export_checks = divr$export_checks, feature_taxonomy = comp$feature_taxonomy,
                     virome_alpha = alpha$virome_alpha, alpha_summary = alpha$alpha_summary, label_pairs = alpha$label_pairs,
                     pcoa_aitchison = divr$pcoa_aitchison, crossomics_pairwise = cross$crossomics_pairwise,
                     permanova_marginal = divr$permanova_marginal, betadisper_summary = divr$betadisper_summary,
                     viral_load_per_sample = alpha$viral_load_per_sample, virome_depth_check = alpha$virome_depth_check,
                     corrected_host_members = hosts$corrected_host_members, crispr_host_edges_primary = hosts$crispr_host_edges_primary),
       distances = divr$distances, pcoa_eigen = divr$pcoa_eigen,
       rng_record = rwv_comm_rng_record(cfg, rbind(divr$perm_log, cross$perm_log)),
       provenance = rbind(comp$prov, alpha$prov, divr$prov, cross$prov, hosts$prov))
}

# Seven-sample exact-pattern sharing from the existing breadth-masked virome.
# Author-approved descriptive extension, 2026-10-15 (papers 36-38 integration).
# No reads are subsampled and no threshold, seed, model or test is introduced.
# A pattern is exclusive: each catalogue member belongs to exactly one bit string.
rwv_comm_votu_sharing <- function(tse_virome, sample_order, cfg, checks) {
  if (length(sample_order) != 7L || anyDuplicated(sample_order))
    rwv_fail("Seven-sample sharing requires seven unique configured samples.")
  if (!setequal(colnames(tse_virome), sample_order))
    rwv_fail("Sharing samples do not match the saved virome TSE.")
  rd <- as.data.frame(SummarizedExperiment::rowData(tse_virome), stringsAsFactors = FALSE)
  ids <- if ("vOTU_id" %in% names(rd)) as.character(rd$vOTU_id) else rownames(tse_virome)
  if (length(ids) != nrow(tse_virome) || anyNA(ids) || any(!nzchar(ids)) || anyDuplicated(ids))
    rwv_fail("Sharing requires one unique vOTU ID for every catalogue member.")
  get_assay <- function(nm) as.matrix(SummarizedExperiment::assay(tse_virome, nm))[, sample_order, drop = FALSE]
  depth <- get_assay("trimmed_mean")
  breadth <- get_assay("covered_fraction")
  saved_mask <- get_assay("trimmed_mean_masked")
  saved_tpm <- get_assay("trimmed_tpm")
  for (nm in c("depth", "breadth", "saved_mask", "saved_tpm")) {
    z <- get(nm)
    if (any(!is.finite(z)) || any(z < 0)) rwv_fail("Sharing input is nonfinite or negative: ", nm)
  }
  if (any(breadth > 1)) rwv_fail("Sharing covered fractions exceed one.")
  threshold <- as.numeric(cfg$virome$detect_covered_fraction)
  if (length(threshold) != 1L || !is.finite(threshold) || threshold <= 0 || threshold > 1)
    rwv_fail("Invalid registered breadth threshold for sharing.")
  masked <- depth * (breadth >= threshold)
  close <- function(x, y) all(abs(x - y) <= 1e-12 * pmax(1, abs(y)))
  rwv_check(checks, "sharing mask reproduces every saved masked depth", TRUE,
            close(masked, saved_mask), source = "012 TSE: trimmed_mean, covered_fraction, trimmed_mean_masked")
  denominator <- colSums(masked)
  if (any(denominator <= 0)) rwv_fail("A sample has no positive masked catalogue depth.")
  percent <- sweep(masked, 2L, denominator, "/") * 100
  rwv_check(checks, "sharing percentages reproduce saved trimmed TPM / 10000", TRUE,
            close(percent, saved_tpm / 10000), source = "012 TSE: trimmed_tpm; sample whole-catalogue depth denominator")
  qualified <- masked > 0
  degree <- rowSums(qualified)
  bit <- apply(qualified, 1L, function(x) paste0(as.integer(x), collapse = ""))
  all_patterns <- unique(bit)
  nonempty_patterns <- all_patterns[all_patterns != paste0(rep("0", length(sample_order)), collapse = "")]
  counts <- vapply(nonempty_patterns, function(x) sum(bit == x), integer(1))
  o <- order(-counts, nonempty_patterns)
  nonempty_patterns <- nonempty_patterns[o]; counts <- counts[o]
  patt <- data.frame(pattern_id = sprintf("P%02d", seq_along(nonempty_patterns)), pattern = nonempty_patterns,
                     display_order = seq_along(nonempty_patterns),
                     n_qualifying_samples = vapply(strsplit(nonempty_patterns, ""), function(x) sum(x == "1"), integer(1)),
                     samples = vapply(nonempty_patterns, function(x) paste(sample_order[strsplit(x, "")[[1]] == "1"], collapse = ";"), ""),
                     n_vOTUs = counts, stringsAsFactors = FALSE)
  for (s in sample_order) patt[[paste0(s, "_percent")]] <- vapply(nonempty_patterns, function(x) sum(percent[bit == x, s]), numeric(1))
  member <- data.frame(vOTU_id = ids, pattern = bit, n_qualifying_samples = degree, stringsAsFactors = FALSE)
  for (s in sample_order) member[[paste0(s, "_qualified")]] <- as.integer(qualified[, s])
  for (s in sample_order) member[[paste0(s, "_percent")]] <- percent[, s]
  summaries <- lapply(seq_along(sample_order), function(j) {
    s <- sample_order[j]
    only <- qualified[, s] & degree == 1L
    shared <- qualified[, s] & degree > 1L
    data.frame(sample_id = s, qualifying_vOTUs = sum(qualified[, s]), sample_only_vOTUs = sum(only),
               shared_vOTUs = sum(shared), sample_only_catalogue_percent = sum(percent[only, s]),
               shared_catalogue_percent = sum(percent[shared, s]), masked_depth_denominator = denominator[s],
               catalogue_vOTUs = length(ids), union_qualifying_vOTUs = sum(degree > 0),
               no_qualifying_vOTUs = sum(degree == 0), all_samples_shared_vOTUs = sum(degree == length(sample_order)),
               breadth_threshold = threshold, row.names = NULL, stringsAsFactors = FALSE)
  })
  samples <- do.call(rbind, summaries)
  rwv_check(checks, "sharing member register preserves every catalogue ID once", TRUE,
            nrow(member) == length(ids) && !anyDuplicated(member$vOTU_id), source = "012 TSE rowData")
  rwv_check(checks, "sharing nonempty union plus zero-qualified members equals catalogue", length(ids),
            sum(patt$n_vOTUs) + sum(degree == 0), source = "exact bit-pattern partition of every catalogue member")
  rwv_check(checks, "sharing degree agrees with every seven-bit pattern", TRUE,
            identical(as.integer(degree), as.integer(vapply(strsplit(bit, ""), function(x) sum(x == "1"), integer(1)))),
            source = "member register and seven qualification flags")
  rwv_check(checks, "sharing unique and shared counts sum to each sample total", TRUE,
            all(samples$sample_only_vOTUs + samples$shared_vOTUs == samples$qualifying_vOTUs), source = "member register")
  rwv_check(checks, "sharing unique and shared abundance sum to 100 percent", TRUE,
            close(samples$sample_only_catalogue_percent + samples$shared_catalogue_percent, rep(100, length(sample_order))),
            source = "sample whole-catalogue masked-depth denominators")
  for (s in sample_order) {
    active <- vapply(strsplit(patt$pattern, ""), function(x) x[match(s, sample_order)] == "1", logical(1))
    rwv_check(checks, paste("sharing pattern count marginal", s), sum(qualified[, s]), sum(patt$n_vOTUs[active]),
              source = "012 positive masked depth and exact-pattern counts")
    rwv_check(checks, paste("sharing pattern abundance marginal", s), 100, sum(patt[[paste0(s, "_percent")]]),
              tol = 1e-10, source = "012 sample whole-catalogue masked depth")
    rwv_check(checks, paste("sharing nonmember patterns contribute zero abundance", s), TRUE,
              all(patt[[paste0(s, "_percent")]][!active] == 0), source = "breadth mask fixes nonmember depth to zero")
  }
  list(patterns = patt, samples = samples, members = member)
}
