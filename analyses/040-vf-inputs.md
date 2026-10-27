# Read saved VF results and four sensitivity models

Jinlong Ru; Cunli Pan.

[Editable QMD](040-vf-inputs.qmd) · [Analysis index](README.md)

Source reading companion with accepted figure previews; not a new scientific execution report.

## Tasks

Read, validate and prepare archived VF-hit coordinates/localizations, region boundaries for 19 CheckV-flagged records, four fixed models and controlled-construct endpoints for Figure 4, Supplementary Figure 4 and Data 1. Models, confidence intervals, CheckV calls and constructs are not regenerated.

### Task 1: Inputs

```r
manifest <- rwv_read_tsv(rwv_step_input(step, path_source, "010-input-manifest", "input-manifest.tsv"))
raw_manifest <- rwv_read_tsv(rwv_step_input(step, path_source, "010-input-manifest", "raw-input-manifest.tsv"))
defs <- rwv_definitions_read(rwv_project_input(step, "analyses/R/definitions.tsv", manifest))
raw <- function(f) as.data.frame(rwv_read_tsv(rwv_raw_input(step, path_data, f, raw_manifest)))
catalogue <- as.data.frame(rwv_read_tsv(rwv_step_input(step, path_source, "020-community-analysis", "checkv_catalogue.tsv")))
checks <- rwv_checks_new()
num <- as.numeric
```

### Task 2: Twenty VF hits with unique-key localization

Eight of the 19 flagged records carry the 20 hits. Saved mutually exclusive localizations comprise 18 predicted-host hits, one boundary-crossing hit and one viral hit. These are hit counts, not 18 contigs; the crossing hit is counted once.

```r
vf <- raw("vf20_coordinates.tsv")
# Hash chain: the stage-A local outputs staged here must be the files its own
# artifact manifest recorded.
lam <- raw("local_artifact_manifest.tsv")
for (f in c("vf20_coordinates.tsv", "checkv19.tsv", "regions.tsv", "votu_input.tsv")) {
  staged <- c(vf20_coordinates.tsv = "vf20_coordinates.tsv", checkv19.tsv = "checkv19.tsv", regions.tsv = "checkv_regions.tsv",
              votu_input.tsv = "votu_model_input.tsv")[[f]]
  rwv_check(checks, paste("stage-A artifact manifest hash of", f),
            lam$sha256[lam$path == paste0("dev/280-publication-stage-a/local/", f)],
            raw_manifest$origin_sha256[basename(raw_manifest$path) == staged & raw_manifest$consumer_step == step$name],
            source = "dev/280-publication-stage-a/local/artifact_manifest.tsv")
}
rwv_check_def(checks, defs, "vf_hits", nrow(vf), "vf20_coordinates.tsv")
rwv_check(checks, "unique vOTU / protein_id / (query,target)", c(8, 20, 20),
          c(length(unique(vf$vOTU_id)), length(unique(vf$protein_id)), length(unique(paste(vf$query, vf$target)))))
loc <- table(factor(vf$localization, levels = c("host", "boundary_crossing", "viral")))
rwv_check_def(checks, defs, "vf_hits_host", unname(loc[["host"]]), "vf20_coordinates.tsv")
rwv_check_def(checks, defs, "vf_hits_crossing", unname(loc[["boundary_crossing"]]), "vf20_coordinates.tsv")
rwv_check_def(checks, defs, "vf_hits_viral", unname(loc[["viral"]]), "vf20_coordinates.tsv")
disp_loc <- c(host = "predicted-host", boundary_crossing = "boundary-crossing", viral = "viral")
hits <- data.frame(
  vOTU_id = vf$vOTU_id, vcontig_id = vf$vcontig_id, protein_id = vf$protein_id,
  start_bp = num(vf$start_position), end_bp = num(vf$end_position), strand = num(vf$strandedness),
  localization = unname(disp_loc[vf$localization]), localization_source = vf$localization,
  hsp_start_bp = num(vf$hsp_start), hsp_end_bp = num(vf$hsp_end),
  hsp_host_nt = num(vf$hsp_host_nt), hsp_viral_nt = num(vf$hsp_viral_nt),
  vf_function = vf$vf_function, vf_category = vf$vf_category, vf_id = vf$vf_id,
  vf_organism = vf$vf_organism, target = vf$target, evalue = num(vf$evalue), pident = num(vf$pident)
)
rwv_check(checks, "protein coordinates are ordered start < end", TRUE, all(hits$start_bp < hits$end_bp))
rwv_write_tsv(hits[order(hits$vOTU_id, hits$start_bp), ], path_target("vf_hits.tsv"))
knitr::kable(as.data.frame(table(localization = hits$localization)))
```

### Task 3: Region boundaries for the 19 CheckV-flagged records

```r
c19 <- raw("checkv19.tsv")
reg <- raw("checkv_regions.tsv")
rwv_check_def(checks, defs, "vf_flagged_records", nrow(c19), "checkv19.tsv")
rwv_check(checks, "all 8 hit-carrying vOTUs are among the flagged records", TRUE, all(unique(vf$vOTU_id) %in% c19$vOTU_id))
rwv_check_def(checks, defs, "vf_hit_records", length(unique(vf$vOTU_id)), "vf20_coordinates.tsv")
reg$start <- num(reg$start); reg$end <- num(reg$end); reg$length <- num(reg$length)
rwv_check(checks, "region lengths equal end - start + 1", reg$length, reg$end - reg$start + 1)
len <- setNames(num(c19$contig_length_checkv), c19$vOTU_id)
cov <- tapply(reg$length, reg$vOTU_id, sum)
rwv_check(checks, "regions cover the full flagged record length", unname(len[names(cov)]), unname(cov))
reg$record_length_bp <- unname(len[reg$vOTU_id])
rwv_write_tsv(reg, path_target("checkv_regions.tsv"))
records <- data.frame(vOTU_id = c19$vOTU_id, vcontig_id = c19$vcontig_id, record_length_bp = num(c19$contig_length_checkv),
                      total_genes = num(c19$total_genes), viral_genes = num(c19$viral_genes), host_genes = num(c19$host_genes),
                      proviral_length_bp = num(c19$proviral_length), host_length_bp = num(c19$host_length),
                      checkv_contamination_pct = num(c19$checkv_contamination),
                      n_vf_hits = as.integer(table(factor(vf$vOTU_id, levels = c19$vOTU_id))))
rwv_check(checks, "hits distributed over the flagged records sum to 20", 20, sum(records$n_vf_hits))
rwv_write_tsv(records, path_target("checkv_flagged_records.tsv"))
```

### Task 4: Four fixed models using the same 3,013 members

IRRs and 95% Wald confidence intervals are read directly from S34. Models and intervals are not refitted; whether an interval crosses one is not used as a vote.

```r
s34 <- raw("s34_local_factorial.tsv")
for (k in c("n", "temperate", "hits", "temperate_hits", "irr", "lo", "hi", "p", "theta")) s34[[k]] <- num(s34[[k]])
rwv_check(checks, "four models", 4, nrow(s34))
rwv_check_def(checks, defs, "vf_model_n", unique(s34$n), "S34_local_factorial.tsv")
rwv_check(checks, "saved IRR values (3 dp)", c(2.521, 1.050, 0.951, 1.003), round(s34$irr, 3))
rwv_check(checks, "all four models converged", TRUE, all(s34$converged == "TRUE"))
rwv_check(checks, "lo < irr < hi in every model", TRUE, all(s34$lo < s34$irr & s34$irr < s34$hi))
# The two axes of the saved factorial, written out as the fitted models
# actually define them (dev/310 local_factorial.R lines 6-15):
#   label    original = 4-way OR over VIBRANT, geNomad, CheckV, Replidec
#            without_checkv = the same OR without the CheckV branch
#   region   original     = every hit, offset log(contig length / 1000)
#            viral_region = hits minus predicted-host and boundary-crossing
#                           hits, offset log(viral length / 1000), where the
#                           viral length of a record without a CheckV region
#                           prediction is its full contig length.
label_def <- c(original = "including the CheckV provirus call", without_checkv = "excluding the CheckV provirus call")
corr_def <- c(original = "all hits; full contig length offset",
              viral_region = "hits retained after regional exclusion; retained-viral-length offset")
models <- data.frame(
  model = seq_len(nrow(s34)),
  label_definition = unname(label_def[s34$label]), region_definition = unname(corr_def[s34$correction]),
  hits_rule = ifelse(s34$correction == "original", "all filtered VF hits",
                     "filtered hits minus predicted-host and boundary-crossing hits"),
  offset_rule = ifelse(s34$correction == "original", "log(contig length / 1000)",
                       "log(retained viral length / 1000); full contig length where CheckV predicted no region"),
  label_rule = ifelse(s34$label == "original",
                      "temperate if VIBRANT lysogenic OR geNomad Provirus OR CheckV provirus OR Replidec temperate",
                      "the same disjunction without the CheckV branch"),
  n = s34$n, temperate = s34$temperate, hits = s34$hits, temperate_hits = s34$temperate_hits,
  irr = s34$irr, lo = s34$lo, hi = s34$hi, p = s34$p, theta = s34$theta,
  note = "negative binomial with completeness covariate and log(kb) offset; 95% Wald CI per model")
rwv_write_tsv(models, path_target("vf_models.tsv"))
# The saved table uses the literal NA token for unavailable CheckV estimates.
# Normalize that token before numeric conversion; unexpected tokens still warn.
completeness_na <- sum(is.na(num(replace(catalogue$checkv_completeness_pct,
  catalogue$checkv_completeness_pct %in% "NA", NA_character_))))
rwv_check(checks, "3,060 - completeness NA = 3,013", unique(s34$n), nrow(catalogue) - completeness_na)
cv <- catalogue$checkv_completeness_pct   # only the literal "NA" may be missing; any other text must parse
rwv_check(checks, "CheckV completeness: every value is numeric or the literal NA (47 NA)", c(0, 47),
          c(sum(!(is.na(cv) | cv %in% "NA") & is.na(suppressWarnings(as.numeric(cv)))), sum(is.na(cv) | cv %in% "NA")),
          source = "checkv_catalogue.tsv")
# ID-level bridge from the saved model input (not only counts).
mi <- raw("votu_model_input.tsv")
rwv_check(checks, "model input covers the catalogue", sort(catalogue$vOTU_id), sort(mi$vOTU_id), source = "votu_model_input.tsv")
in_model <- mi$checkv_completeness != "" & mi$lifestyle %in% c("virulent", "temperate")
rwv_check(checks, "vOTUs in the saved model set", unique(s34$n), sum(in_model), source = "S34 n")
excluded <- mi$vOTU_id[!in_model]
undetermined <- catalogue$vOTU_id[catalogue$checkv_quality == "Undetermined"]
rwv_check_def(checks, defs, "vf_model_excluded", length(excluded), "votu_model_input.tsv")
rwv_check(checks, "excluded IDs are exactly the CheckV Undetermined IDs", sort(undetermined), sort(excluded),
          source = "checkv_catalogue.tsv (CheckV quality_summary)")
rwv_check(checks, "temperate vOTUs in the model set (CheckV-based labels)", s34$temperate[1],
          sum(mi$lifestyle[in_model] == "temperate"), source = "S34 temperate")
fa <- num(mi$filtered_all[in_model]); fh <- num(mi$filtered_host[in_model]); fc <- num(mi$filtered_crossing[in_model])
rwv_check_def(checks, defs, "vf_model_hits_all", sum(fa), "votu_model_input.tsv")
rwv_check(checks, "S34 hits (all regions) equal the model-input sum", s34$hits[1], sum(fa), source = "S34_local_factorial.tsv")
rwv_check_def(checks, defs, "vf_model_hits_viral", sum(fa) - sum(fh) - sum(fc), "votu_model_input.tsv (all - host - crossing)")
rwv_check(checks, "S34 region-corrected hits = all - predicted-host - boundary-crossing", s34$hits[2], sum(fa) - sum(fh) - sum(fc),
          source = "S34_local_factorial.tsv")
rwv_check(checks, "host and crossing hits in the model set equal the 20-hit localization", c(18, 1), c(sum(fh), sum(fc)),
          source = "vf20_coordinates.tsv")
# Where the 142 hits sit, and therefore what "retained after regional
# exclusion" contains: 122 of the 123 retained hits are on records for which
# CheckV predicted no host region at all, not on a predicted viral region.
fv <- num(mi$filtered_viral[in_model])
loc <- data.frame(
  localization = c("no_host_region_detected", "host", "boundary_crossing", "viral"),
  hits = c(sum(fa) - sum(fh) - sum(fc) - sum(fv), sum(fh), sum(fc), sum(fv)),
  in_retained_set = c(TRUE, FALSE, FALSE, TRUE),
  meaning = c("the record carries no CheckV region prediction, so no host region was identified and the full contig length is used as the offset",
              "the hit lies entirely inside a CheckV-predicted host region",
              "the hit spans a predicted host/viral boundary",
              "the hit lies entirely inside a CheckV-predicted viral region"))
rwv_check(checks, "localization of the 142 model hits (no host region, host, crossing, viral)", c(122, 18, 1, 1), loc$hits,
          source = "votu_model_input.tsv filtered_* columns")
rwv_check(checks, "retained hits are the no-host-region and viral hits", sum(fa) - sum(fh) - sum(fc), sum(loc$hits[loc$in_retained_set]))
rwv_write_tsv(loc, path_target("vf_hit_localization.tsv"))
# The offset changes only for records that carry a CheckV region prediction.
vl <- num(mi$viral_length[in_model]); cl <- num(mi$contig_length[in_model])
rwv_check(checks, "records whose length offset changes under the region definition", 19, sum(vl != cl),
          source = "votu_model_input.tsv (viral_length vs contig_length)")
rwv_check(checks, "those records are the CheckV-flagged records of panels A-B", nrow(records), sum(vl != cl),
          source = "checkv_flagged_records.tsv")
# Lifestyle labels: the saved 4-way disjunction and the same rule without CheckV.
alt <- ifelse(mi$vibrant_type == "lysogenic" | mi$genomad_topology == "Provirus" | mi$replidec_lifestyle == "temperate",
              "temperate", "virulent")
four <- ifelse(mi$vibrant_type == "lysogenic" | mi$genomad_topology == "Provirus" | mi$checkv_provirus == "Yes" |
                 mi$replidec_lifestyle == "temperate", "temperate", "virulent")
rwv_check(checks, "the saved lifestyle label is the four-way disjunction", mi$lifestyle[in_model], four[in_model],
          source = "010-import_virome.qmd:284-286 rule applied to votu_model_input.tsv")
rwv_check(checks, "dropping the CheckV branch: 260 -> 244 temperate, 16 labels change",
          c(s34$temperate[1], s34$temperate[3], 16),
          c(sum(mi$lifestyle[in_model] == "temperate"), sum(alt[in_model] == "temperate"),
            sum(alt[in_model] != mi$lifestyle[in_model])), source = "S34 temperate columns")
cm <- match(excluded, catalogue$vOTU_id)
excl <- data.frame(vOTU_id = excluded, vcontig_id = catalogue$vcontig_id[cm],
                   checkv_quality_source = catalogue$checkv_quality_source[cm],
                   reason = "CheckV completeness not estimated; excluded only from models that need the completeness covariate",
                   kept_in = "Figure 1 catalogue and Figure 5A bins")
rwv_write_tsv(excl[order(excl$vOTU_id), ], path_target("vf_model_excluded.tsv"))
bridge <- data.frame(step = c("catalogue", "completeness not estimated (CheckV Not-determined)", "model set"),
                     n = c(nrow(catalogue), completeness_na, unique(s34$n)),
                     note = c("Figure 1 and Figure 5 denominator", "excluded only from models needing the completeness covariate; kept in the catalogue",
                              "four saved models"))
rwv_write_tsv(bridge, path_target("vf_model_bridge.tsv"))
knitr::kable(models[, c("model", "label_definition", "region_definition", "irr", "lo", "hi", "p")], digits = 3)
```

### Task 5: Controlled-construct endpoints with separate denominators

```r
det <- raw("construct_detection_by_stratum.tsv")
zf <- raw("construct_zero_flank_flags.tsv")
hr <- raw("construct_host_removal.tsv")
b95 <- raw("construct_below95.tsv")
for (k in c("constructs", "flagged")) { det[[k]] <- num(det[[k]]); zf[[k]] <- num(zf[[k]]) }
det$host_percent <- num(det$host_percent); det$flagged_fraction <- num(det$flagged_fraction)
rwv_check_def(checks, defs, "construct_noflank", sum(zf$flagged), "zero_flank_flags.tsv")
rwv_check(checks, "zero-flank denominator (270 + 242)", 512, sum(zf$constructs))
prim <- det[det$primary_set == "True" & det$panel == "C" & det$host_percent > 0, ]
n_flanked <- sum(prim$constructs)
csum <- jsonlite::read_json(rwv_raw_input(step, path_data, "construct_summary.json", raw_manifest))
rwv_check(checks, "primary flanked constructs", csum$flanked_detection$C$flanked_constructs, n_flanked,
          source = "dev/370 results/summary.json")
rwv_check(checks, "flagged primary flanked constructs", csum$flanked_detection$C$flagged, sum(prim$flagged),
          source = "dev/370 results/summary.json")
rwv_check(checks, "zero-flank constructs per panel", vapply(csum$zero_flank, function(z) z$constructs, numeric(1)),
          zf$constructs, source = "dev/370 results/summary.json")
hr_prim <- hr[hr$panel == "C" & hr$set == "primary flanked" & hr$host_percent == "all", ]
rwv_check_def(checks, defs, "construct_unflagged", num(hr_prim$constructs[hr_prim$flagged == "False"]), "host_removal_by_detection.tsv")
# Unflagged constructs are kept whole (no host bases removed), so they cannot be
# among the constructs retaining < 95% of viral bases: the endpoints are disjoint.
rwv_check(checks, "unflagged primary constructs have no host bases removed (max)", 0,
          num(hr_prim$host_removed_max[hr_prim$flagged == "False"]), source = "host_removal_by_detection.tsv")
rwv_check_def(checks, defs, "construct_below95", nrow(b95), "S47_C_individual_below95.tsv")
ten <- prim[prim$host_percent == 10, ]
rwv_check(checks, "flag rate (fraction) rises with window length at 10% flanks", TRUE,
          !is.unsorted(ten$flagged_fraction[order(as.numeric(sub(" bp window", "", ten$window)))]))
prim$flank_percent <- prim$host_percent
prim$viral_window_bp <- as.numeric(sub(" bp window", "", prim$window))
constructs <- prim[, c("panel", "window", "viral_window_bp", "flank_percent", "constructs", "flagged", "flagged_fraction")]
constructs$endpoint <- "provirus-flagged by CheckV"
rwv_write_tsv(constructs[order(constructs$viral_window_bp, constructs$flank_percent), ], path_target("construct_detection.tsv"))
endpoints <- data.frame(
  endpoint = c("Constructs without an added flank that were flagged", "Primary flanked constructs without a provirus flag",
               "Primary flanked constructs retaining < 95% of viral bases"),
  k = c(sum(zf$flagged), num(hr_prim$constructs[hr_prim$flagged == "False"]), nrow(b95)),
  n = c(sum(zf$constructs), n_flanked, n_flanked),
  definition = c("construct sets B and C, no flank added", "predicted trimming leaves an unflagged construct whole, so host removal is exactly 0",
                 "viral bases retained after predicted trimming"),
  boundary = "distinct endpoints from different controlled construct sets: the first pools unflanked controls from construct sets B and C, while the latter two share the same primary flanked constructs in set C; percentages must not be combined into an overall failure rate")
rwv_write_tsv(endpoints, path_target("construct_endpoints.tsv"))
retention <- data.frame(id = b95$id, mother = b95$mother, genus = b95$genus, requested_viral_length_bp = num(b95$requested_viral_length),
                        host_percent_requested = num(b95$host_percent_requested), viral_retention = num(b95$viral_retention),
                        host_removed = num(b95$host_removed), background = b95$background)
rwv_check(checks, "minimum viral retention (4 dp)", 0.6402, round(min(retention$viral_retention), 4))
rwv_write_tsv(retention, path_target("construct_below95.tsv"))
strata <- raw("construct_sequence_strata.tsv")
rwv_check(checks, "sequence strata rows", 896, nrow(strata), source = "S39_C_sequence_strata.tsv (regression constant)")
rwv_write_tsv(strata, path_target("construct_strata.tsv"))
knitr::kable(endpoints[, c("endpoint", "k", "n")])
```

### Task 6: Candidate VF-carrier abundance

Join saved catalogue abundance with saved VFDB-A annotations to describe candidate-carrier shares and their sensitivity to annotation strictness and host-region assignment. No remapping, reannotation or model fitting is performed. Region rules change carrier eligibility only; saved whole-contig abundance and denominators are retained.

```r
tse <- readRDS(rwv_step_input(step, path_source, "012-tse-construction", "tse_virome.rds"))
samples <- as.data.frame(rwv_read_tsv(rwv_step_input(step, path_source, "020-community-analysis", "samples.tsv")))
scfg <- as.data.frame(rwv_read_tsv(rwv_project_input(step, "analyses/R/samples.tsv", manifest)))
ord <- scfg$sample_id[order(num(scfg$sample_order))]
rwv_check(checks, "sample display order from config", TRUE, setequal(ord, colnames(tse)) && length(ord) == 7L)

# --- abundance: a = trimmed mean depth where covered fraction >= threshold ---
# Recomputed here from the saved depth and breadth assays rather than taken
# from the pre-normalized assay, then checked against it.
ccfg <- yaml::read_yaml(rwv_project_input(step, "analyses/R/community.yml", manifest))
thr <- num(ccfg$virome$detect_covered_fraction)
rwv_check(checks, "breadth threshold read from analyses/R/community.yml", 0.75, thr)
d_raw <- SummarizedExperiment::assay(tse, "trimmed_mean")
bred <- SummarizedExperiment::assay(tse, "covered_fraction")
a <- d_raw * (bred >= thr)
p <- sweep(a, 2L, colSums(a), "/") * 100
ids <- SummarizedExperiment::rowData(tse)$vOTU_id
rownames(a) <- rownames(p) <- rownames(bred) <- rownames(d_raw) <- ids
a <- a[, ord, drop = FALSE]; p <- p[, ord, drop = FALSE]
bred <- bred[, ord, drop = FALSE]; d_raw <- d_raw[, ord, drop = FALSE]
rwv_check(checks, "catalogue representatives in the TSE", 3060L, nrow(p), source = "012/tse_virome.rds")
rwv_check(checks, "masked depth equals the saved masked assay", TRUE,
          isTRUE(all.equal(a, SummarizedExperiment::assay(tse, "trimmed_mean_masked")[, ord, drop = FALSE], tolerance = 0)))
# Registered numeric criterion for the independent cross-check of the saved
# closed-sum assay: abs(new - old) <= 1e-12 * max(1, abs(old)).
old_p <- SummarizedExperiment::assay(tse, "trimmed_tpm")[, ord, drop = FALSE] / 10000
rwv_check(checks, "catalogue percentage matches the saved closed-sum assay (1e-12 criterion)", TRUE,
          all(abs(p - old_p) <= 1e-12 * pmax(1, abs(old_p))))
rwv_check(checks, "every sample percentage sums to 100 (1e-9)", TRUE, all(abs(colSums(p) - 100) < 1e-9))

# --- the four saved annotation sets; region exclusion changes membership only ---
fil <- raw("vfdbA_filtered_catalogue.tsv")
str <- raw("vfdbA_strict_catalogue.tsv")
hit_key <- function(x) paste(x$vOTU_id, x$query, x$target, sep = "|")
fil$hit_key <- hit_key(fil); str$hit_key <- hit_key(str)
rwv_check(checks, "filtered and strict hit keys are unique", c(TRUE, TRUE),
          c(!anyDuplicated(fil$hit_key), !anyDuplicated(str$hit_key)))
rwv_check(checks, "strict hits are a subset of filtered", 0L, sum(!str$hit_key %in% fil$hit_key))
# vf20_coordinates.tsv keeps the original query (cat_1/cat_2 form); the
# normalized protein_id of vf_hits.tsv cannot be joined to it.
vf$hit_key <- hit_key(vf)
rwv_check(checks, "all localized hits join the filtered table on (vOTU_id, query, target)", nrow(vf), sum(vf$hit_key %in% fil$hit_key))
excluded_keys <- vf$hit_key[vf$localization %in% c("host", "boundary_crossing")]
rwv_check(checks, "hits excluded by the region rule", 19L, length(excluded_keys))
fil$region_excluded <- fil$hit_key %in% excluded_keys
fil$in_strict <- fil$hit_key %in% str$hit_key
fil$localization <- vf$localization[match(fil$hit_key, vf$hit_key)]
fil$localization[is.na(fil$localization)] <- "no_region_prediction"
fil$in_F0 <- TRUE
fil$in_F1 <- !fil$region_excluded
fil$in_S0 <- fil$in_strict
fil$in_S1 <- fil$in_strict & !fil$region_excluded
set_ids <- lapply(c(F0 = "in_F0", F1 = "in_F1", S0 = "in_S0", S1 = "in_S1"),
                  function(col) sort(unique(fil$vOTU_id[fil[[col]]])))
rwv_check(checks, "hits per set (F0, F1, S0, S1)", c(143L, 124L, 37L, 34L),
          vapply(c("in_F0", "in_F1", "in_S0", "in_S1"), function(c) sum(fil[[c]]), integer(1)))
rwv_check(checks, "carriers per set (F0, F1, S0, S1)", c(114L, 107L, 31L, 30L), lengths(set_ids))
# The four whole-catalogue sets are registered in analyses/R/definitions.tsv; check the
# saved flags against that ledger so the definitions are not just recorded text.
for (nm in names(set_ids)) {
  rwv_check_def(checks, defs, paste0("vf_cat_hits_", nm), sum(fil[[paste0("in_", nm)]]), source = "040/vf_hit_catalogue.tsv")
  rwv_check_def(checks, defs, paste0("vf_cat_carriers_", nm), length(set_ids[[nm]]), source = "040/vf_hit_catalogue.tsv")
}
rwv_check_def(checks, defs, "vf_detection_breadth", thr, source = "analyses/R/community.yml")
rwv_check(checks, "set nesting F1<=F0, S0<=F0, S1<=S0, S1<=F1", rep(TRUE, 4L),
          c(all(set_ids$F1 %in% set_ids$F0), all(set_ids$S0 %in% set_ids$F0),
            all(set_ids$S1 %in% set_ids$S0), all(set_ids$S1 %in% set_ids$F1)))
# Per-vOTU counts must agree with the saved model input, which carries its own
# filtered/strict/host/crossing tallies.
vmi <- raw("votu_model_input.tsv")
agg <- function(col) { x <- table(fil$vOTU_id[fil[[col]]]); y <- setNames(integer(nrow(vmi)), vmi$vOTU_id); y[names(x)] <- as.integer(x); y }
rwv_check(checks, "per-vOTU filtered and strict counts agree with votu_model_input.tsv", c(TRUE, TRUE),
          c(identical(unname(agg("in_F0")), as.integer(num(vmi$filtered_all))),
            identical(unname(agg("in_S0")), as.integer(num(vmi$strict_all)))))
# A4 guard: F1 and S1 were only checked as totals, so two per-vOTU join errors that
# cancelled each other would have passed. The region rule removes exactly the hits
# localized to host or boundary-crossing regions, so the saved per-vOTU tallies give
# the expected F1 and S1 counts directly.
rwv_check(checks, "per-vOTU F1 and S1 counts agree with votu_model_input.tsv", c(TRUE, TRUE),
          c(identical(unname(agg("in_F1")),
                      as.integer(num(vmi$filtered_all)) - as.integer(num(vmi$filtered_host)) - as.integer(num(vmi$filtered_crossing))),
            identical(unname(agg("in_S1")),
                      as.integer(num(vmi$strict_all)) - as.integer(num(vmi$strict_host)) - as.integer(num(vmi$strict_crossing)))),
          source = "votu_model_input.tsv filtered_/strict_ host and crossing columns")

# --- per-sample summary over the four sets ---
share <- function(g, s) sum(p[rownames(p) %in% g, s])
ndet  <- function(g, s) sum(a[rownames(a) %in% g, s] > 0)
vf_abund <- data.frame(
  sample_id = ord,
  site = samples$site[match(ord, samples$sample_id)],
  record_label = samples$record_label[match(ord, samples$sample_id)],
  catalogue_detected = vapply(ord, function(s) sum(a[, s] > 0), integer(1)),
  stringsAsFactors = FALSE)
for (nm in names(set_ids)) {
  vf_abund[[paste0(nm, "_carriers_detected")]] <- vapply(ord, function(s) ndet(set_ids[[nm]], s), integer(1))
  vf_abund[[paste0(nm, "_percent_of_catalogue")]] <- vapply(ord, function(s) share(set_ids[[nm]], s), numeric(1))
}
top2 <- vapply(ord, function(s) {
  v <- sort(p[rownames(p) %in% set_ids$F0, s], decreasing = TRUE)
  if (sum(v) == 0) NA_real_ else 100 * sum(v[1:2]) / sum(v)
}, numeric(1))
vf_abund$top_carrier <- vapply(ord, function(s) { v <- p[rownames(p) %in% set_ids$F0, s]; names(sort(v, decreasing = TRUE))[1] }, character(1))
vf_abund$top_carrier_percent_of_catalogue <- vapply(ord, function(s) max(p[rownames(p) %in% set_ids$F0, s]), numeric(1))
vf_abund$top_two_share_of_F0_carrier_abundance <- top2
vf_abund$top_two_denominator <- "summed F0 carrier abundance of that sample, NOT the full catalogue"
rwv_check(checks, "sample summary rows", 7L, nrow(vf_abund))
rwv_write_tsv(vf_abund, path_target("vf_sample_summary.tsv"))

# --- long carrier x sample table (F0 carriers) ---
car <- set_ids$F0
fn <- function(ids_sel, col) vapply(ids_sel, function(i) {
  x <- unique(fil$vf_function[fil$vOTU_id == i & fil[[col]]])
  if (!length(x)) NA_character_ else paste(sort(x), collapse = "; ")
}, character(1))
long <- do.call(rbind, lapply(ord, function(s) data.frame(
  vOTU_id = car, sample_id = s,
  trimmed_mean_depth = d_raw[car, s], covered_fraction = bred[car, s],
  masked_depth = a[car, s], detected = a[car, s] > 0,
  percent_of_catalogue = p[car, s], stringsAsFactors = FALSE)))
for (nm in names(set_ids)) long[[paste0("eligible_", nm)]] <- long$vOTU_id %in% set_ids[[nm]]
for (nm in names(set_ids)) long[[paste0("hits_", nm)]] <- as.integer(agg(paste0("in_", nm))[long$vOTU_id])
long$functions_F0 <- fn(long$vOTU_id, "in_F0")
long$functions_S1 <- fn(long$vOTU_id, "in_S1")
long$breadth_threshold <- thr
long$denominator <- "summed masked trimmed mean depth over all catalogue representatives of the same sample"
# deterministic top-18 by the maximum catalogue share a carrier reaches in any sample
mx <- vapply(car, function(i) max(p[i, ]), numeric(1))
sel <- data.frame(vOTU_id = car, max_percent_of_catalogue = mx, stringsAsFactors = FALSE)
sel <- sel[order(-sel$max_percent_of_catalogue, sel$vOTU_id), ]
sel$rank <- seq_len(nrow(sel))
sel <- sel[sel$rank <= 18L, ]
sel$selection_rule <- "top 18 F0 carriers by the highest catalogue-relative percentage reached in any one sample; ties broken by ascending vOTU identifier"
sel$functions_F0 <- fn(sel$vOTU_id, "in_F0")
sel$strict_match_present <- sel$vOTU_id %in% set_ids$S0
sel$all_filtered_hits_region_excluded <- !sel$vOTU_id %in% set_ids$F1
long$heatmap_rank <- sel$rank[match(long$vOTU_id, sel$vOTU_id)]
long$in_heatmap <- !is.na(long$heatmap_rank)
rwv_check(checks, "carrier x sample cells", 798L, nrow(long))
rwv_check(checks, "unique carrier x sample keys", 798L, nrow(unique(long[, c("vOTU_id", "sample_id")])))
rwv_check(checks, "heatmap rows selected", 18L, nrow(sel))
rwv_check_def(checks, defs, "vf_heatmap_top", nrow(sel), source = "040/vf_heatmap_selection.tsv")
rwv_check(checks, "no cell passes breadth with a non-positive depth", 0L,
          sum(long$covered_fraction >= thr & !(long$masked_depth > 0)))
rwv_check(checks, "no missing abundance cells", 0L, sum(is.na(long$percent_of_catalogue)))
rwv_write_tsv(long[order(long$vOTU_id, match(long$sample_id, ord)), ], path_target("vf_carrier_abundance.tsv"))
rwv_write_tsv(sel, path_target("vf_heatmap_selection.tsv"))

# --- normalization audit, including the PMCR technical diagnostic ---
pmcr <- SummarizedExperiment::assay(tse, "trimmed_pmcr")[, ord, drop = FALSE]
rownames(pmcr) <- ids
audit <- data.frame(
  sample_id = ord,
  catalogue_masked_depth_sum = colSums(a),
  recorded_clean_reads = num(samples$clean_reads_virome[match(ord, samples$sample_id)]),
  stringsAsFactors = FALSE)
for (nm in names(set_ids)) audit[[paste0(nm, "_masked_depth_sum")]] <- vapply(ord, function(s) sum(a[rownames(a) %in% set_ids[[nm]], s]), numeric(1))
audit$F0_carrier_pmcr_sum_exploratory <- vapply(ord, function(s) sum(pmcr[rownames(pmcr) %in% set_ids$F0, s]), numeric(1))
audit$pmcr_definition <- "masked trimmed mean depth / recorded clean reads x 1e6; EXPLORATORY technical diagnostic only"
audit$pmcr_limits <- "the read/read-pair rule behind recorded clean reads and the original read length are not recovered; equal relative shares do not imply equal concentration; not used for ranking or load"
audit$breadth_threshold <- thr
rwv_check(checks, "normalization audit rows", 7L, nrow(audit))
rwv_write_tsv(audit, path_target("vf_normalization_audit.tsv"))

# --- hit-level catalogue (all 143 filtered matches) ---
hits <- data.frame(
  hit_key = fil$hit_key, vOTU_id = fil$vOTU_id, query = fil$query, target = fil$target,
  vf_function = fil$vf_function, vf_id = fil$vf_id, vf_category = fil$vf_category,
  vf_organism = fil$vf_organism, pident = num(fil$pident), qcov = num(fil$qcov),
  in_strict = fil$in_strict, localization = fil$localization,
  region_prediction_available = fil$localization != "no_region_prediction",
  region_excluded = fil$region_excluded,
  in_F0 = fil$in_F0, in_F1 = fil$in_F1, in_S0 = fil$in_S0, in_S1 = fil$in_S1,
  stringsAsFactors = FALSE)
hits$source_record <- ifelse(hits$region_prediction_available,
                             "annotation table + vf20_coordinates.tsv", "annotation table only")
rwv_check(checks, "hit catalogue rows", 143L, nrow(hits))
rwv_check(checks, "localization classes (no_region_prediction, host, boundary_crossing, viral)", c(123L, 18L, 1L, 1L),
          unname(table(factor(hits$localization, levels = c("no_region_prediction", "host", "boundary_crossing", "viral")))))
rwv_write_tsv(hits[order(hits$vOTU_id, hits$query, hits$target), ], path_target("vf_hit_catalogue.tsv"))
knitr::kable(vf_abund[, c("sample_id", "record_label", "catalogue_detected", "F0_percent_of_catalogue", "F1_percent_of_catalogue", "S0_percent_of_catalogue", "S1_percent_of_catalogue")], digits = 3)
```

### Task 7: Symmetric ecological contributions for process-associated positions

Construct descriptive decompositions from saved depth, breadth and prespecified comparisons, without changing detection rules or adding tests/models.

```r
# Authors: Jinlong Ru, Cunli Pan. Codex implementation, 2026-10-15.
# Adapted with attribution from the saved-object process-ecology candidate.
# New descriptive sums only; frozen detection and abundance rules are unchanged.
ec_lp <- as.data.frame(rwv_read_tsv(rwv_step_input(step, path_source, "020-community-analysis", "label_pairs.tsv")))
ec_lp <- ec_lp[ec_lp$omic == "virome", , drop = FALSE]
ec_lp <- ec_lp[order(match(ec_lp$clean_sample, ord)), , drop = FALSE]
ec_cmp <- data.frame(comparison = paste(ec_lp$dirty_sample, ec_lp$clean_sample, sep = "-"),
                     site = samples$site[match(ec_lp$clean_sample, samples$sample_id)],
                     process_sample = ec_lp$dirty_sample, nearby_sample = ec_lp$clean_sample)
rwv_check(checks, "ecology: three designated comparisons, bc2 unpaired", TRUE,
          nrow(ec_cmp) == 3L && identical(ec_cmp$comparison, c("bd1-bc1", "gd1-gc1", "od1-oc1")))
ec_count <- SummarizedExperiment::assay(tse, "count")[, ord, drop = FALSE]
rownames(ec_count) <- ids
ec_det <- a > 0
ec_input <- data.frame(sample_id = ord,
                       count_positive_vOTUs = colSums(ec_count > 0),
                       count_positive_zero_trimmed_depth_vOTUs = colSums(ec_count > 0 & d_raw == 0),
                       positive_trimmed_depth_vOTUs = colSums(d_raw > 0),
                       qualifying_vOTUs = colSums(ec_det),
                       unmasked_depth_sum = colSums(d_raw), masked_depth_sum = colSums(a),
                       breadth_threshold = thr)
rwv_check(checks, "ecology: input diagnostics reproduce existing qualifying counts", TRUE,
          identical(as.integer(ec_input$qualifying_vOTUs), as.integer(vf_abund$catalogue_detected)))
rwv_check(checks, "ecology: positive-count zero-depth field is a subset, not all mapped members", TRUE,
          all(ec_input$count_positive_zero_trimmed_depth_vOTUs <= ec_input$count_positive_vOTUs))
rwv_write_tsv(ec_input, path_target("process_input_diagnostics.tsv"))

ec_members <- do.call(rbind, lapply(seq_len(nrow(ec_cmp)), function(i) {
  D <- ec_cmp$process_sample[i]; C <- ec_cmp$nearby_sample[i]
  z <- data.frame(comparison = ec_cmp$comparison[i], site = ec_cmp$site[i], vOTU_id = ids,
                  process_sample = D, nearby_sample = C,
                  detected_D = ec_det[, D], detected_C = ec_det[, C],
                  percent_D = p[, D], percent_C = p[, C],
                  count_D = ec_count[, D], count_C = ec_count[, C],
                  trimmed_depth_D = d_raw[, D], trimmed_depth_C = d_raw[, C],
                  breadth_D = bred[, D], breadth_C = bred[, C])
  z$member_set <- ifelse(z$detected_D & z$detected_C, "both_qualified",
                         ifelse(z$detected_D, "process_only_qualified",
                                ifelse(z$detected_C, "nearby_only_qualified", "neither_qualified")))
  for (nm in names(set_ids)) z[[paste0("eligible_", nm)]] <- ids %in% set_ids[[nm]]
  rownames(z) <- NULL
  z
}))
rwv_check(checks, "ecology: complete unique comparison by vOTU register", TRUE,
          nrow(ec_members) == nrow(ec_cmp) * length(ids) &&
          !anyDuplicated(paste(ec_members$comparison, ec_members$vOTU_id)))
rwv_write_tsv(ec_members, path_target("process_comparison_members.tsv"))

# Opposite-side mapping categories do not promote weak mapping to detection.
ec_status <- function(count, depth, breadth) {
  stopifnot(all(is.finite(count)), all(is.finite(depth)), all(is.finite(breadth)))
  signal <- count > 0 | depth > 0 | breadth > 0
  ifelse(!signal, "no_saved_mapping_signal",
         ifelse(breadth < thr, "subthreshold_breadth_signal", "breadth_pass_zero_trimmed_depth"))
}
ec_community <- list(); ec_vf <- list()
for (i in seq_len(nrow(ec_cmp))) for (side in c("D", "C")) {
  z <- ec_members[ec_members$comparison == ec_cmp$comparison[i], , drop = FALSE]
  opposite <- if (side == "D") "C" else "D"
  det <- z[[paste0("detected_", side)]]; det_opp <- z[[paste0("detected_", opposite)]]
  shared <- det & det_opp; only <- det & !det_opp
  pc <- z[[paste0("percent_", side)]]
  opposite_status <- ec_status(z[[paste0("count_", opposite)]],
                               z[[paste0("trimmed_depth_", opposite)]], z[[paste0("breadth_", opposite)]])
  smp <- if (side == "D") ec_cmp$process_sample[i] else ec_cmp$nearby_sample[i]
  meta <- data.frame(comparison = ec_cmp$comparison[i], site = ec_cmp$site[i], sample_id = smp,
                     opposite_sample_id = if (side == "D") ec_cmp$nearby_sample[i] else ec_cmp$process_sample[i],
                     position = if (side == "D") "process_water" else "nearby_water")
  diag_values <- function(mask) data.frame(
    position_only_opposite_subthreshold_n = sum(mask & opposite_status == "subthreshold_breadth_signal"),
    position_only_opposite_no_signal_n = sum(mask & opposite_status == "no_saved_mapping_signal"),
    position_only_opposite_breadth_pass_zero_depth_n = sum(mask & opposite_status == "breadth_pass_zero_trimmed_depth"),
    position_only_subthreshold_catalogue_percent = sum(pc[mask & opposite_status == "subthreshold_breadth_signal"]))
  row <- cbind(meta, data.frame(qualifying_vOTUs = sum(det), shared_vOTUs = sum(shared),
                               position_only_vOTUs = sum(only), shared_catalogue_percent = sum(pc[shared]),
                               position_only_catalogue_percent = sum(pc[only]), catalogue_percent = sum(pc),
                               catalogue_masked_depth_sum = sum(a[, smp])), diag_values(only))
  ec_community[[length(ec_community) + 1L]] <- row
  rwv_check(checks, paste("ecology: catalogue partition conserves members and shares", smp), TRUE,
            sum(shared) + sum(only) == sum(det) && abs(sum(pc[shared]) + sum(pc[only]) - 100) <= 1e-9)
  for (nm in names(set_ids)) {
    eligible <- z[[paste0("eligible_", nm)]]
    sh <- shared & eligible; po <- only & eligible
    total <- sum(pc[sh]) + sum(pc[po])
    original <- vf_abund[[paste0(nm, "_percent_of_catalogue")]][match(smp, vf_abund$sample_id)]
    ec_vf[[length(ec_vf) + 1L]] <- cbind(meta, data.frame(definition = nm,
      shared_carriers = sum(sh), position_only_carriers = sum(po),
      shared_catalogue_percent = sum(pc[sh]), position_only_catalogue_percent = sum(pc[po]),
      total_VF_catalogue_percent = total,
      shared_percent_of_VF = if (total > 0) 100 * sum(pc[sh]) / total else NA_real_), diag_values(po))
    rwv_check(checks, paste("ecology: VF partition reproduces saved total", smp, nm), TRUE,
              abs(total - original) <= 1e-12 * max(1, abs(original)))
  }
}
ec_community <- do.call(rbind, ec_community); ec_vf <- do.call(rbind, ec_vf)
rwv_check(checks, "ecology: symmetric community and VF table shapes", c(6L, 24L), c(nrow(ec_community), nrow(ec_vf)))
rwv_check(checks, "ecology: diagnostic categories partition position-only members", TRUE,
          all(ec_community$position_only_opposite_subthreshold_n + ec_community$position_only_opposite_no_signal_n +
                ec_community$position_only_opposite_breadth_pass_zero_depth_n == ec_community$position_only_vOTUs))
rwv_check(checks, "ecology: zero VF denominator has NA conditional share", TRUE,
          identical(is.na(ec_vf$shared_percent_of_VF), ec_vf$total_VF_catalogue_percent == 0))
rwv_write_tsv(ec_community, path_target("process_community_contribution.tsv"))
rwv_write_tsv(ec_vf, path_target("process_vf_contribution.tsv"))

ec_rows <- function(t) {
  position_labels <- c(process_water = "Process water", nearby_water = "Nearby water")
  display_position <- unname(position_labels[as.character(t$position)])
  if (anyNA(display_position)) stop("Unknown process-ecology position label", call. = FALSE)
  sprintf("| %s | %s | %s | %d | %d | %.2f | %.2f |",
          t$site, t$sample_id, display_position, t$qualifying_vOTUs, t$shared_vOTUs,
          t$shared_catalogue_percent, t$position_only_catalogue_percent)
}
note5 <- c("# Supplementary Note 5. Process-water and nearby-water contributions", "",
  "## Scope and definitions", "",
  "The three comparisons use the designated same-location records in Data 1 S07: bd1/bc1, gd1/gc1 and od1/oc1. They contrast treatment-process water with nearby water after facility outflow; they do not establish hydraulic tracking of the same water. bc2 has no designated d counterpart and remains in the seven-sample analyses without being pooled into a pair.", "",
  "A vOTU qualifies in a sample when its saved trimmed mean depth is positive after the whole-contig coverage-breadth threshold of 75% is applied. That mask was decided at full depth, not recalculated after rarefaction. Shared means qualified at both positions; position-only means qualified at one position and not at the other, not biological absence. The reference catalogue is fixed, but the qualifying set is sample-specific.", "",
  "For each sample, the contribution is 100 times the sum of masked trimmed mean depth of the specified members divided by the masked depth sum over the entire catalogue in that sample. No renormalization within shared members or candidate carriers is applied. A VF conditional share uses that sample's VF-carrier total instead; it is NA when the total is zero. Region exclusion changes eligibility, not the retained contig abundance. All four existing annotation definitions are reported in Data 1 S55; they form overlapping subsets of F0 and are sensitivity settings, not replicates.", "",
  "## Whole-catalogue contributions (Data 1 S54)", "",
  "| Location | Sample | Position | Qualified vOTUs | Shared vOTUs | Shared contribution (%) | Position-only contribution (%) |",
  "|---|---|---|---:|---:|---:|---:|", ec_rows(ec_community), "",
  "The fixed shared set contributes different fractions at the two positions. Numbers of shared members are not retention probabilities and must not be ranked across locations without their qualifying catalogue context. These are relative carrier-sequence contributions, not absolute viral concentrations, transport, persistence or removal efficiencies.", "",
  "## VF-carrier contributions and mapping diagnostics", "",
  "Data 1 S55 gives the complete symmetric decomposition for both positions under F0 (filtered), F1 (filtered with region exclusion), S0 (strict), and S1 (strict with region exclusion). Figure 4b displays only the selected carriers and is not a complete contribution ledger. The machine-readable comparison register accompanies this Note and retains every catalogue vOTU, including members qualifying at neither position.", "",
  "For position-only members, the tables separately count opposite-side mapping with subthreshold breadth, no saved mapping signal (count, depth and breadth all zero), and breadth passing with zero trimmed depth. Positive count with zero trimmed depth is not the total mapped-member count. Weak mapping is diagnostic only: conserved-sequence cross-mapping and true low abundance have not been distinguished. It neither proves absence nor establishes that observed differences are solely technical. The counts and independent depth denominators are in Process_input_diagnostics.tsv.", "",
  "No treatment-effect model, new significance test, alternative breadth threshold, read alignment, concentration estimate or source-tracking model was fitted for this descriptive summary.", "",
  "Sources: saved 012 TSE assays, 020 designated comparisons, and 040 carrier definitions and abundance; derivations recorded in the formal workflow and Data 1 field dictionary.")
writeLines(note5, path_target("supplementary-note-5-process-ecology.md"), useBytes = TRUE)
knitr::kable(ec_community[, c("sample_id", "qualifying_vOTUs", "shared_vOTUs", "shared_catalogue_percent", "position_only_catalogue_percent")], digits = 3)
```

### Task 7b: Unadjusted candidate carriage under two lifestyle rules

Summarize binary candidate carriage for the complete 3,060-member catalogue under two existing lifestyle rules and six existing candidate sets. Denominators are all catalogue members in each lifestyle group, not the 3,013-member completeness-assessable model set. Unadjusted proportions are not the VF-hit-per-kb model IRRs. Length/completeness backgrounds are supplied without fitting new models.

```r
lit_amg_carriers <- as.data.frame(rwv_read_tsv(rwv_step_input(step, path_source, "030-function-inputs", "amg_ko_carriers.tsv")))
lit_defense_membership <- as.data.frame(rwv_read_tsv(rwv_step_input(step, path_source, "030-function-inputs", "defense_membership.tsv")))
lit_carriage <- rwv_literature_lifestyle_carriage(vmi, lit_amg_carriers, lit_defense_membership, set_ids)
rwv_check(checks, "raw lifestyle carriage: two rules x two groups x six candidate sets", 24L, nrow(lit_carriage))
rwv_check(checks, "lifestyle carriage keeps full catalogue denominators", TRUE,
          all(vapply(split(lit_carriage, paste(lit_carriage$lifestyle_rule, lit_carriage$function_set)),
                     function(x) sum(x$group_n) == nrow(vmi), logical(1))))
rwv_check(checks, "raw lifestyles: original and no-CheckV temperate / virulent counts", c(262L, 2798L, 246L, 2814L),
          lit_carriage$group_n[lit_carriage$function_set == "AMG_export"], source = "votu_model_input.tsv full catalogue")
rwv_check(checks, "raw candidate-set counts conserved within both lifestyle rules", TRUE,
          all(vapply(split(lit_carriage, lit_carriage$lifestyle_rule), function(x) {
            total <- tapply(x$carrier_n, x$function_set, sum)
            expected <- c(AMG_export = length(unique(lit_amg_carriers$vOTU_id)),
                          anti_defense_union = sum(as.numeric(lit_defense_membership$antidefense_union) > 0), lengths(set_ids))
            identical(as.integer(total[names(expected)]), as.integer(expected))
          }, logical(1))))
rwv_check(checks, "available completeness totals reproduce model set without discarding catalogue members", TRUE,
          all(vapply(split(lit_carriage, paste(lit_carriage$lifestyle_rule, lit_carriage$function_set)),
                     function(x) sum(x$group_completeness_available_n) == unique(s34$n), logical(1))))
# The virulent group is an operational complement, but it is not a group
# without classifier support: every retained original virulent record has
# a Replidec lytic prediction. Prediction does not establish activity.
rwv_check(checks, "original virulent records retain Replidec lytic predictions", TRUE,
          all(vmi$replidec_lifestyle[vmi$lifestyle == "virulent"] == "lytic"), source = "saved model-input classifier fields")
rwv_write_tsv(lit_carriage, path_target("lifestyle_function_carriage.tsv"))
knitr::kable(lit_carriage[, c("lifestyle_rule", "lifestyle", "function_set", "carrier_n", "group_n", "carrier_percent")], digits = 2)
```

### Task 8: Record checks and the run

```r
check_table <- rwv_checks_finish(checks, path_target("input-checks.tsv"))
knitr::kable(check_table[, c("check", "expected", "observed", "pass")])
rwv_write_session_info(path_target("session-info.txt"),
                       c(step = params$name, run_id = step$run_id, mode = step$mode, quarto = rwv_quarto_version()))
```
