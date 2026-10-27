# Descriptive integrations of retained function, host and lifestyle records.
# Authors (display order): Jinlong Ru, Cunli Pan.
# No fitting, threshold selection, annotation or sample reclassification.

.rwv_lit_require <- function(ok, message) {
  if (!isTRUE(ok)) stop(message, call. = FALSE)
}

.rwv_lit_columns <- function(x, columns, name) {
  .rwv_lit_require(is.data.frame(x) && all(columns %in% names(x)),
                   paste0(name, " is missing required fields: ", paste(setdiff(columns, names(x)), collapse = ", ")))
}

.rwv_lit_bool <- function(x, name, allow_missing = FALSE) {
  text <- tolower(trimws(as.character(x)))
  missing <- is.na(text) | text %in% c("", "na")
  .rwv_lit_require(all((!missing & text %in% c("true", "false", "1", "0")) | (allow_missing & missing)),
                   paste0(name, " contains missing or unrecognized logical values"))
  value <- text %in% c("true", "1")
  if (allow_missing) value[missing] <- NA
  value
}

.rwv_lit_numeric <- function(x, name, allow_missing = FALSE) {
  value <- suppressWarnings(as.numeric(x))
  missing <- is.na(x) | trimws(as.character(x)) %in% c("", "NA", "NaN")
  .rwv_lit_require(all(is.finite(value) | (allow_missing & missing)),
                   paste0(name, " contains invalid numeric values"))
  value
}

.rwv_lit_genus <- function(x) sub("^g__", "", trimws(as.character(x)))
.rwv_lit_median <- function(x) if (any(is.finite(x))) stats::median(x[is.finite(x)]) else NA_real_

# Each carrier remains in the complete register. Paths are a deliberately
# selected subset with a retained primary host prediction and saved same-
# sample co-detection; no infection or host metabolic function is inferred.
rwv_literature_host_links <- function(ko_carriers, hosts, codetection, crispr, samples) {
  .rwv_lit_columns(ko_carriers, c("feature_id", "feature_name", "vOTU_id"), "KO carriers")
  .rwv_lit_columns(hosts, c("vOTU_id", "iphop_confidence", "host_genus_clean", "host_genus_full",
                           "host_methods", "has_resolved_genus", "host_in_16s_clean"), "iPHoP records")
  .rwv_lit_columns(codetection, c("endpoint", "vOTU_id", "host_genus", "sample_id",
                                 "vOTU_detected_masked", "genus_detected_16s", "codetected"), "co-detection records")
  .rwv_lit_columns(crispr, c("vOTU_id", "host_genus"), "strict CRISPR records")
  .rwv_lit_columns(samples, c("sample_id", "site", "sample_order"), "sample configuration")
  sample_order <- as.character(samples$sample_id[order(as.numeric(samples$sample_order))])
  .rwv_lit_require(length(sample_order) > 0L && !anyDuplicated(sample_order), "Sample configuration must have unique IDs")
  .rwv_lit_require(!anyNA(ko_carriers$vOTU_id) && !anyNA(ko_carriers$feature_id) &&
                     !anyDuplicated(ko_carriers[, c("feature_id", "vOTU_id")]), "KO-carrier identities must be unique and present")
  .rwv_lit_require(all(grepl("^K[0-9]{5}$", ko_carriers$feature_id)), "KO identities must be original KEGG identifiers")
  .rwv_lit_require(!anyDuplicated(hosts$vOTU_id), "Primary iPHoP records must be unique by vOTU")
  score <- .rwv_lit_numeric(hosts$iphop_confidence, "iPHoP confidence")
  .rwv_lit_require(all(score >= 90), "Only the retained iPHoP >=90 records may be connected")
  resolved <- .rwv_lit_bool(hosts$has_resolved_genus, "iPHoP resolved genus")
  visible <- .rwv_lit_bool(hosts$host_in_16s_clean, "iPHoP genus detected in 16S", allow_missing = TRUE)
  .rwv_lit_require(all(!visible | resolved, na.rm = TRUE), "A visible primary host genus must be resolved")
  ko_annotation <- split(as.character(ko_carriers$feature_name), ko_carriers$feature_id)
  .rwv_lit_require(all(vapply(ko_annotation, function(x) length(unique(x)) == 1L, logical(1))),
                   "Each KO must retain one unambiguous full annotation")

  primary <- codetection[codetection$endpoint == "iPHoP record (score >= 90)", , drop = FALSE]
  .rwv_lit_require(!anyDuplicated(primary[, c("vOTU_id", "sample_id")]), "Primary co-detection keys must be unique")
  .rwv_lit_require(nrow(primary) == nrow(hosts) * length(sample_order) &&
                     all(primary$vOTU_id %in% hosts$vOTU_id) && all(primary$sample_id %in% sample_order),
                   "Co-detection must cover every retained primary record in every configured sample")
  for (id in hosts$vOTU_id) {
    .rwv_lit_require(setequal(primary$sample_id[primary$vOTU_id == id], sample_order),
                     paste0("Primary sample coverage incomplete for ", id))
  }
  hm <- match(primary$vOTU_id, hosts$vOTU_id)
  # The retained table spells unresolved genus as NA, while the per-sample
  # table leaves it blank. Normalize only that missing-value representation;
  # resolved genus strings still have to match exactly.
  primary_genus <- as.character(primary$host_genus)
  retained_genus <- as.character(hosts$host_genus_clean[hm])
  primary_genus[is.na(primary_genus) | primary_genus %in% c("", "NA")] <- ""
  retained_genus[is.na(retained_genus) | retained_genus %in% c("", "NA")] <- ""
  .rwv_lit_require(identical(primary_genus, retained_genus),
                   "Co-detection genus strings must match the retained primary host record")
  co <- .rwv_lit_bool(primary$codetected, "primary co-detection", allow_missing = TRUE)
  virus <- .rwv_lit_bool(primary$vOTU_detected_masked, "masked vOTU detection")
  genus <- .rwv_lit_bool(primary$genus_detected_16s, "16S genus detection", allow_missing = TRUE)
  .rwv_lit_require(identical(co, virus & genus), "Saved primary co-detection must equal both detection flags")
  co_samples <- split(as.character(primary$sample_id[which(co)]), primary$vOTU_id[which(co)])
  cr_keys <- paste(crispr$vOTU_id, .rwv_lit_genus(crispr$host_genus), sep = "|")
  carrier_ids <- sort(unique(as.character(ko_carriers$vOTU_id)))
  register <- do.call(rbind, lapply(carrier_ids, function(id) {
    k <- ko_carriers[ko_carriers$vOTU_id == id, c("feature_id", "feature_name"), drop = FALSE]
    k <- k[order(k$feature_id), , drop = FALSE]
    h <- match(id, hosts$vOTU_id); has <- !is.na(h)
    sample_ids <- sample_order[sample_order %in% co_samples[[id]]]
    resolved_here <- has && resolved[h]; visible_here <- has && isTRUE(visible[h])
    .rwv_lit_require(!length(sample_ids) || (resolved_here && visible_here), "Co-detection must have a resolved visible host")
    cr_n <- if (resolved_here) sum(cr_keys == paste(id, .rwv_lit_genus(hosts$host_genus_clean[h]), sep = "|")) else 0L
    data.frame(vOTU_id = id, KO_count = nrow(k), KO_list = paste(k$feature_id, collapse = ";"),
      KO_annotation_list = paste(paste(k$feature_id, k$feature_name, sep = " = "), collapse = " | "),
      has_iphop90_record = has, iphop_confidence = if (has) score[h] else NA_real_,
      host_genus_clean = if (has) as.character(hosts$host_genus_clean[h]) else NA_character_,
      host_genus_full = if (has) as.character(hosts$host_genus_full[h]) else NA_character_,
      host_methods = if (has) as.character(hosts$host_methods[h]) else NA_character_,
      host_genus_resolved = resolved_here, host_in_16s = if (has) visible[h] else NA, codetected = length(sample_ids) > 0L,
      n_codetected_samples = length(sample_ids), codetected_samples = paste(sample_ids, collapse = ";"),
      strict_crispr_same_genus = cr_n > 0L, strict_crispr_record_count = cr_n,
      status = if (!has) "no_highscore_host_record" else if (!resolved_here) "unresolved_host_genus" else
        if (!visible_here) "host_genus_not_detected" else if (!length(sample_ids)) "host_visible_without_codetection" else "codetected_primary_host",
      stringsAsFactors = FALSE)
  }))
  .rwv_lit_require(all(register$n_codetected_samples[register$codetected] == 1L),
                   "This fixed path summary expects one saved co-detection sample per selected AMG carrier")
  selected <- ko_carriers[ko_carriers$vOTU_id %in% register$vOTU_id[register$codetected], , drop = FALSE]
  selected <- selected[order(selected$feature_id, selected$vOTU_id), , drop = FALSE]
  rm <- match(selected$vOTU_id, register$vOTU_id)
  paths <- data.frame(KO = as.character(selected$feature_id), KO_annotation_full = as.character(selected$feature_name),
    vOTU_id = as.character(selected$vOTU_id), host_genus = .rwv_lit_genus(register$host_genus_clean[rm]),
    host_genus_clean = register$host_genus_clean[rm], sample_id = register$codetected_samples[rm],
    site = as.character(samples$site[match(register$codetected_samples[rm], samples$sample_id)]),
    iphop_confidence = register$iphop_confidence[rm], strict_crispr_same_genus = register$strict_crispr_same_genus[rm],
    association_weight = rep(1L, nrow(selected)), stringsAsFactors = FALSE)
  rownames(register) <- rownames(paths) <- NULL
  list(register = register, paths = paths)
}

# Raw, binary candidate carriage within two fixed operational label rules.
# Group context is repeated to make length/recovery opportunity visible.
# These summaries are not the adjusted VF hit-count models or new tests.
rwv_literature_lifestyle_carriage <- function(model_input, amg_carriers, defense_membership, vf_sets) {
  .rwv_lit_columns(model_input, c("vOTU_id", "lifestyle", "vibrant_type", "genomad_topology", "checkv_provirus",
                                 "replidec_lifestyle", "contig_length", "checkv_completeness"), "saved model input")
  .rwv_lit_columns(amg_carriers, c("vOTU_id"), "AMG carriers")
  .rwv_lit_columns(defense_membership, c("vOTU_id", "antidefense_union"), "defense membership")
  ids <- as.character(model_input$vOTU_id)
  .rwv_lit_require(!anyNA(ids) && !anyDuplicated(ids), "Catalogue model-input keys must be present and unique")
  .rwv_lit_require(!anyDuplicated(defense_membership$vOTU_id) && setequal(ids, defense_membership$vOTU_id),
                   "Defense membership must cover the complete catalogue once")
  .rwv_lit_require(identical(names(vf_sets), c("F0", "F1", "S0", "S1")), "All four fixed VF sets must be supplied in order")
  anti <- as.character(defense_membership$vOTU_id[.rwv_lit_bool(defense_membership$antidefense_union, "anti-defense membership")])
  sets <- c(list(AMG_export = unique(as.character(amg_carriers$vOTU_id)), anti_defense_union = anti), vf_sets)
  .rwv_lit_require(all(vapply(sets, function(x) !anyNA(x) && !anyDuplicated(x) && all(x %in% ids), logical(1))),
                   "All candidate carrier sets must use unique complete-catalogue members")
  length_bp <- .rwv_lit_numeric(model_input$contig_length, "contig length")
  .rwv_lit_require(all(length_bp > 0), "Recovered contig lengths must be positive")
  completeness <- .rwv_lit_numeric(model_input$checkv_completeness, "CheckV completeness", allow_missing = TRUE)
  .rwv_lit_require(all(!is.finite(completeness) | completeness >= 0), "Finite completeness must be nonnegative")
  without <- model_input$vibrant_type %in% "lysogenic" | model_input$genomad_topology %in% "Provirus" |
    model_input$replidec_lifestyle %in% "temperate"
  with <- without | model_input$checkv_provirus %in% "Yes"
  original <- ifelse(with, "temperate", "virulent")
  .rwv_lit_require(identical(as.character(model_input$lifestyle), original),
                   "Saved lifestyle labels must reproduce the four-branch rule for the whole catalogue")
  rules <- list(including_CheckV = original, without_CheckV = ifelse(without, "temperate", "virulent"))
  result <- list()
  for (rule in names(rules)) for (lifestyle in c("temperate", "virulent")) {
    group <- rules[[rule]] == lifestyle
    .rwv_lit_require(any(group), "Each operational lifestyle group needs a nonzero denominator")
    for (set in names(sets)) {
      carrier <- group & ids %in% sets[[set]]
      result[[length(result) + 1L]] <- data.frame(lifestyle_rule = rule, lifestyle = lifestyle, function_set = set,
        group_n = sum(group), carrier_n = sum(carrier), carrier_percent = 100 * sum(carrier) / sum(group),
        group_median_length_bp = .rwv_lit_median(length_bp[group]),
        group_completeness_available_n = sum(is.finite(completeness[group])),
        group_median_completeness_pct = .rwv_lit_median(completeness[group]),
        carrier_median_length_bp = .rwv_lit_median(length_bp[carrier]),
        carrier_completeness_available_n = sum(is.finite(completeness[carrier])),
        carrier_median_completeness_pct = .rwv_lit_median(completeness[carrier]), stringsAsFactors = FALSE)
    }
  }
  out <- do.call(rbind, result); rownames(out) <- NULL
  out
}
