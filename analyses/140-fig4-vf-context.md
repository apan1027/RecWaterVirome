# Figure 4

Jinlong Ru; Cunli Pan.

[Editable QMD](140-fig4-vf-context.qmd) · [Analysis index](README.md)

Source reading companion with accepted figure previews; not a new scientific execution report.

![Figure 4](140-fig4-vf-context_files/figure-commonmark/Figure4.png)

## Tasks

Draw Figure 4 from verified 040 tables: seven-sample candidate-carrier shares under four annotation definitions, profiles of the 18 displayed carriers and four lifestyle-sensitivity models. Supplementary Figure 4a shows the localization scope for 143 catalogue hits; 4b shows coordinates on eight carriers and 4c the vOTU1009 zoom. Full settings and interpretation limits are in the caption and Supplementary Note 3. Saved scientific values are retained; no remapping, refitting or new test is performed.

### Task 1: Inputs

```r
manifest <- rwv_read_tsv(rwv_step_input(step, path_source, "010-input-manifest", "input-manifest.tsv"))
style <- rwv_style_read(rwv_project_input(step, "analyses/R/style.yml", manifest))
style <- rwv_style_for_figure(style, "fig4")   # v39: figure-specific text sizes (analyses/R/style.yml figure_text_pt)
palettes <- rwv_palettes_read(rwv_project_input(step, "analyses/R/palettes.yml", manifest))
figures <- rwv_figures_read(rwv_project_input(step, "analyses/R/figures.yml", manifest))
defs <- rwv_definitions_read(rwv_project_input(step, "analyses/R/definitions.tsv", manifest))
up4 <- function(f) as.data.frame(rwv_read_tsv(rwv_step_input(step, path_source, "040-vf-inputs", f)))
records <- up4("checkv_flagged_records.tsv")
vfl <- up4("vf_carrier_abundance.tsv")
sel <- up4("vf_heatmap_selection.tsv")
hits <- up4("vf_hit_catalogue.tsv")
excluded <- up4("vf_model_excluded.tsv")
models <- up4("vf_models.tsv")
loc <- up4("vf_hit_localization.tsv"); loc$hits <- as.numeric(loc$hits)
vfs <- up4("vf_sample_summary.tsv")
samples <- rwv_samples_read(rwv_project_input(step, "analyses/R/samples.tsv", manifest), style)
catalogue <- as.data.frame(rwv_read_tsv(rwv_step_input(step, path_source, "020-community-analysis", "checkv_catalogue.tsv")))
num <- as.numeric
for (k in c("irr", "lo", "hi", "p", "n", "hits")) models[[k]] <- num(models[[k]])
fonts <- rwv_fonts_resolve(style)
spec <- rwv_figure_spec(figures, "fig4", params$name)
checks <- rwv_checks_new()
pt <- style$text_pt; ink <- style$colours$text; fam <- style$font$family; col <- style$colours
full_loc <- table(factor(hits$localization, levels = c("host", "boundary_crossing", "viral", "no_region_prediction")))
full_carriers <- length(unique(hits$vOTU_id))
rwv_check(checks, "full catalogue localization scope", c(18L, 1L, 1L, 123L), as.integer(full_loc), source = "040 vf_hit_catalogue.tsv")
rwv_check(checks, "full catalogue filtered hits and carriers", c(143L, 114L), c(nrow(hits), full_carriers))
rwv_check(checks, "catalogue-to-model single hit bridge", TRUE,
          sum(hits$vOTU_id %in% excluded$vOTU_id) == 1L &&
          identical(hits$vOTU_id[hits$vOTU_id %in% excluded$vOTU_id], "vOTU2169"),
          source = "040 vf_hit_catalogue.tsv; vf_model_excluded.tsv")
```

### Task 1b: Panel a: candidate-carrier shares across seven samples

Panel a first shows total candidate-carrier shares, followed by selected carrier profiles and model sensitivity. The four bars represent annotation-definition sensitivity, not replicates or treatment stages. Zero values remain visible; the former supplementary copy is not repeated.

```r
lv <- c("Filtered", "Filtered + region exclusion", "Strict", "Strict + region exclusion")
keys <- c(F0 = lv[1], F1 = lv[2], S0 = lv[3], S1 = lv[4])
eE <- do.call(rbind, lapply(names(keys), function(k) data.frame(
  sample_id = vfs$sample_id, criteria = factor(keys[[k]], levels = lv),
  pct = num(vfs[[paste0(k, "_percent_of_catalogue")]]), stringsAsFactors = FALSE)))
eE$sample_id <- factor(eE$sample_id, levels = vfs$sample_id)
eE$zero <- eE$pct == 0
```

### Task 2: Panel b: sample profiles of displayed carriers

Retain all 126 saved cells and their selection, detection and eligibility rules. The 18 displayed rows are a subset of 114 carriers; their column sums are not the complete shares in panel a. Colours and catalogue-wide percentage denominators are unchanged.

```r
hm <- vfl[vfl$in_heatmap == "TRUE" | vfl$in_heatmap == TRUE, ]
hm$pct <- num(hm$percent_of_catalogue)
hm$rank <- as.integer(num(hm$heatmap_rank))
hm$detected <- hm$detected %in% c("TRUE", TRUE)
hm$sample_id <- factor(hm$sample_id, levels = vfs$sample_id)
# A3: rwv_read_tsv() returns every column as character, so order(sel$rank) sorted
# "1","10",...,"2" and put rank 2 in row 11. One integer rank is built here and
# reused by the heatmap rows, the row labels and both qualification columns, so the
# three cannot drift apart again.
sel$rank_i <- as.integer(num(sel$rank))
if (anyNA(sel$rank_i)) rwv_fail("140: non-numeric heatmap rank in vf_heatmap_selection.tsv.")
if (anyDuplicated(sel$rank_i)) rwv_fail("140: duplicated heatmap rank.")
ord <- order(sel$rank_i)
ordv <- sel$vOTU_id[ord]
rwv_check(checks, "panel B ranks convert to exactly 1:18", TRUE,
          identical(sel$rank_i[ord], seq_len(nrow(sel))), source = "vf_heatmap_selection.tsv")
hm$row <- factor(hm$vOTU_id, levels = rev(ordv))
# Display labels for the VFDB reference function(s). The source string stays in the
# data tables; here one representative label plus "+n" is shown when a sequence
# carries several annotations, so a truncated chemical name no longer stands in for
# the whole set. Splitting uses the recorded separator only; no function is
# re-assigned and nothing is re-annotated.
# Labels come from the DISTINCT annotation values of the per-hit table, not from
# splitting a concatenated string: a chemical name may itself contain a separator
# or an unbalanced bracket. One saved value of this catalogue is the fragment
# "3-hydroxymyristoyl] glucosamine N-acyltransferase [LPS", whose brackets are
# already unpaired in the source record. For such a long name the trailing
# bracketed token of the SAME value is used as the short label, so nothing is
# re-assigned; the complete original text stays in Data 1 S48.
hit_fun <- function(v) {
  f <- unique(hits$vf_function[hits$vOTU_id == v & hits$in_F0 %in% c("TRUE", TRUE)])
  trimws(f[nzchar(trimws(f))])
}
short_one <- function(s) {
  if (nchar(s) <= 24) return(s)
  tag <- sub("^.*\\[([^]\\[]+)\\]?\\s*$", "\\1", s)
  if (nzchar(tag) && tag != s && nchar(tag) <= 24) return(tag)
  paste0(substr(s, 1, 22), "\u2026")
}
rowlab <- setNames(vapply(ordv, function(v) {
  f <- hit_fun(v)
  if (!length(f)) return(paste(v, "unnamed VFDB function"))
  lab <- short_one(f[1])
  if (length(f) > 1L) lab <- paste0(lab, " +", length(f) - 1L)
  paste(v, lab)
}, character(1)), ordv)
# A2: two independent qualification marks. They are NOT mutually exclusive --
# vOTU0016 is strict-match-present AND all-filtered-hits-region-excluded -- so the
# former nested-ifelse three-way tag silently dropped one of its two facts.
qual <- data.frame(vOTU_id = ordv,
                   strict = sel$strict_match_present[ord] %in% c("TRUE", TRUE),
                   region = sel$all_filtered_hits_region_excluded[ord] %in% c("TRUE", TRUE),
                   stringsAsFactors = FALSE)
qm <- rbind(data.frame(vOTU_id = qual$vOTU_id, mark = "Strict match present", on = qual$strict),
            data.frame(vOTU_id = qual$vOTU_id, mark = "All filtered hits region-excluded", on = qual$region))
qm$row <- factor(qm$vOTU_id, levels = rev(ordv))
qm$mark <- factor(qm$mark, levels = c("Strict match present", "All filtered hits region-excluded"))
rwv_check(checks, "panel B draws two independent qualification columns", 2L, nlevels(qm$mark))
rwv_check(checks, "panel B vOTU0016 carries both marks at once", 2L,
          sum(qm$on[qm$vOTU_id == "vOTU0016"]), source = "vf_heatmap_selection.tsv")
# 2026-10-14 readability: the two mark columns carry their full names (Strict match;
# All hits excluded) instead of the former S/R codes, so the subtitle keeps only the
# detection key; the complete definitions of both marks are written once, in the legend.
mark_sub1 <- "\u2013: below detection threshold"
mark_subtitle <- mark_sub1
```

### Task 3: Panel c: four dependent lifestyle-sensitivity estimates

All four estimates use the same 3,013 vOTUs and are dependent sensitivity estimates, not independent replicates. No pooled estimate is drawn.

```r
rwv_check_def(checks, defs, "vf_model_n", unique(models$n), "vf_models.tsv")
rwv_check(checks, "saved IRR (3 dp)", c(2.521, 1.050, 0.951, 1.003), round(models$irr, 3), source = "S34_local_factorial.tsv")
rwv_check_def(checks, defs, "vf_model_hits_all", models$hits[1], "vf_models.tsv")
rwv_check_def(checks, defs, "vf_model_hits_viral", models$hits[2], "vf_models.tsv")
models$row <- factor(seq_len(nrow(models)), levels = rev(seq_len(nrow(models))))
# Label-only clarification, 2026-10-15: state both saved settings directly.
# No refit, interval calculation, reordering or scientific-value replacement.
region_changed <- grepl("retained", models$region_definition, ignore.case = TRUE)
label_changed <- models$label_definition != models$label_definition[1]
models$row_main <- ifelse(region_changed, "Region-excluded / retained length", "All hits / full length")
models$row_rule <- ifelse(label_changed, "CheckV branch omitted", "CheckV branch included")
models$row_name <- paste(models$row_main, models$row_rule, sep = "\n")
rwv_check(checks, "panel C labels state the saved region and lifestyle choices", TRUE,
          identical(region_changed, c(FALSE, TRUE, FALSE, TRUE)) &&
          identical(label_changed, c(FALSE, FALSE, TRUE, TRUE)), source = "vf_models.tsv")
rwv_check(checks, "panel C first row retains the CheckV provirus branch", TRUE,
          identical(models$label_definition[1], "including the CheckV provirus call"),
          source = "vf_models.tsv")
models$ci <- sprintf("%s (%s)", rwv_fmt_num(models$irr, 2), rwv_fmt_range(models$lo, models$hi, 2))
```

### Task 4: Assemble and export

```r
# 2026-10-18 (v38): adopted panel-consult version D (outputs/fig345-visual-review-2026-10-17, code/final-figure4.R,
# drawing "A": definition bars, carrier evidence table, model forest), plus three author-approved follow-ups:
# the 4c subtitle names the shared model set ("same 3,013 vOTUs in all models"), the unused "Undetermined" CheckV
# legend entry is dropped, and the region key uses "≥". Drawn with grid at absolute mm positions on the W x H page and
# handed to rwv_figure_export as one patchwork element inside a W x H viewport (positions unchanged by the margin).
W <- spec$width_mm; H <- spec$height_mm; P <- pt; rule <- col$grey_rule
lw <- function(mm) mm / 25.4 * 96   # grid lwd from the style line widths (1 lwd = 1/96 in)
rwv_check(checks, "page size of the adopted layout (mm)", c(180, 232), c(W, H), source = "analyses/R/figures.yml")
# Checks carried over from the former ggplot panels (v36), unchanged in meaning.
rwv_check(checks, "panel A bars (7 samples x 4 definitions)", 28L, nrow(eE))
rwv_check(checks, "panel A zero bars (strict and strict+region in oc1 and od1)", 4L, sum(eE$zero))
rwv_check(checks, "panel A filtered range (%), 2 dp", c(1.08, 9.95), round(range(eE$pct[eE$criteria == lv[1]]), 2),
          source = "040 vf_sample_summary.tsv")
mark_key <- c("Strict match present" = "Strict\nmatch", "All filtered hits region-excluded" = "All hits\nexcluded")
rwv_check(checks, "panel B mark heads spell the full names", c("Strict match", "All hits excluded"),
          unname(gsub("\n", " ", mark_key, fixed = TRUE)))
rwv_check(checks, "panel B rows", 18L, length(unique(hm$vOTU_id)))
rwv_check(checks, "panel B mark strip rows match the heatmap rows", TRUE,
          identical(levels(qm$row), levels(hm$row)))
rwv_check(checks, "panel B top row is the highest-ranked carrier", "vOTU0113",
          utils::tail(levels(hm$row), 1L), source = "vf_heatmap_selection.tsv")
rwv_check(checks, "panel B first five rows follow the numeric rank", TRUE,
          identical(rev(utils::tail(levels(hm$row), 5L)),
                    c("vOTU0113", "vOTU0073", "vOTU0022", "vOTU0016", "vOTU2009")),
          source = "vf_heatmap_selection.tsv")
rwv_check(checks, "panel B cells", 126L, nrow(hm))
rwv_check(checks, "panel B shows no imputed zero for undetected cells", 0L, sum(!hm$detected & !is.na(hm$pct) & hm$pct > 0))
rwv_check(checks, "panel B drawing rows equal the heatmap rows (top to bottom)", rev(levels(hm$row)), ordv)
smp <- as.character(vfs$sample_id)
rwv_check(checks, "sample order of panels a and b", c("bc1", "bd1", "bc2", "gc1", "gd1", "oc1", "od1"), smp)
site_of <- setNames(as.character(samples$site), as.character(samples$sample_id))[smp]
site_col <- rwv_site_colours(style)
defs4 <- c("F0", "F1", "S0", "S1")
dcoll <- unlist(palettes$annotation_criteria)[lv]
qc <- unlist(palettes$checkv)
qcode <- c(Complete = "C", "High-quality" = "HQ", "Medium-quality" = "MQ", "Low-quality" = "LQ", Undetermined = "U")
ramp <- grDevices::hcl.colors(palettes$heatmap$levels, "Reds", rev = TRUE)
# CheckV class and region-prediction flag of the 18 rows (row order = ordv)
vq <- catalogue$checkv_quality[match(ordv, catalogue$vOTU_id)]
rwv_check(checks, "panel b CheckV classes are among the four drawn in the key", TRUE,
          all(vq %in% c("Complete", "High-quality", "Medium-quality", "Low-quality")), source = "020 checkv_catalogue.tsv")
f0 <- hits[hits$in_F0 %in% c("TRUE", TRUE), ]
f0$avail <- f0$region_prediction_available %in% c("TRUE", TRUE)
reg_y <- vapply(ordv, function(v) any(f0$avail[f0$vOTU_id == v]), logical(1))
rwv_check(checks, "panel b region info: 3 rows with a prediction, 15 without", c(3L, 15L), c(sum(reg_y), sum(!reg_y)),
          source = "040 vf_hit_catalogue.tsv")
rwv_check(checks, "panel b region info rows are not mixed (all or none of a row's filtered hits predicted)", TRUE,
          all(vapply(ordv, function(v) { a <- f0$avail[f0$vOTU_id == v]; all(a) || !any(a) }, logical(1))))
cell <- function(v, s) { z <- hm[hm$vOTU_id == v & as.character(hm$sample_id) == s, ]; stopifnot(nrow(z) == 1L); z }
maxv <- max(hm$pct)
mods <- data.frame(irr = num(models$irr), lo = num(models$lo), hi = num(models$hi), hits = num(models$hits))
tx <- function(s, x, y, size = P$annotation, just = "left", face = "plain", colour = ink)
  grid::grid.text(s, unit(x, "mm"), unit(H - y, "mm"), just = just, gp = grid::gpar(fontfamily = fam, fontsize = size, fontface = face, col = colour))
box <- function(x, y, w, h, fill, colour = NA, lwd = lw(style$line_mm$hairline))
  grid::grid.rect(unit(x, "mm"), unit(H - y, "mm"), unit(w, "mm"), unit(h, "mm"), gp = grid::gpar(fill = fill, col = colour, lwd = lwd))
ln <- function(x1, y1, x2, y2, colour = rule, lwd = lw(style$line_mm$thin), lty = 1)
  grid::grid.lines(unit(c(x1, x2), "mm"), unit(H - c(y1, y2), "mm"), gp = grid::gpar(col = colour, lwd = lwd, lty = lty))
# v50 figure cleanup (2026-10-19, Codex task book docs/figure-cleanup-v49-2026-10-19/00): panel letters only, no
# explanatory panel titles or in-figure footnotes (their meaning is in the submission caption / Supplementary figure
# notes); compact 2 x 2 key in a; grey below-detection tiles instead of 94 dashes in b; the Region info column of b and
# the Length offset column of c are no longer drawn (data fields unchanged). Page size unchanged (analyses/R/figures.yml).
tag <- function(s, y) tx(rwv_tag(style, s), 5, y, P$tag, face = "bold")
x0 <- 66; cw <- 8.3; rowh <- 4.1
undetected_fill <- col$grey_rule
shares_bars <- function() {
  xa <- 42; cwa <- 11.7; tag("A", 7)
  ybase <- 35; scale <- 2.1
  for (v in c(0, 5, 10)) { yy <- ybase - v * scale; ln(xa - cwa / 2, yy, xa + 6 * cwa + cwa / 2, yy); tx(v, xa - cwa / 2 - 2, yy, just = "right") }
  tx("Carrier share\n(% of detected\ncatalogue)", 5, 24)
  for (j in seq_along(smp)) for (d in seq_along(defs4)) {
    v <- num(vfs[[paste0(defs4[d], "_percent_of_catalogue")]][j]); x <- xa + (j - 1) * cwa + (d - 2.5) * 2.3
    if (v > 0) box(x, ybase - v * scale / 2, 2.05, v * scale, dcoll[d]) else {
      ln(x - .7, ybase, x + .7, ybase, dcoll[d], lw(style$line_mm$main)); tx("0", x, ybase - 2, just = "centre", colour = dcoll[d]) }
  }
  for (j in seq_along(smp)) { x <- xa + (j - 1) * cwa; tx(smp[j], x, 41, just = "centre"); box(x, 45, cwa - .25, 1, site_col[[site_of[j]]]) }
  # 2 x 2 key: rows = matching stringency, columns = with/without exclusion of predicted host-region/boundary hits.
  kx <- c(155, 171); ky <- c(25, 32)
  tx("No region\nexclusion", kx[1], 15, just = "centre"); tx("Region\nexclusion", kx[2], 15, just = "centre")
  for (r in 1:2) { tx(c("Filtered", "Strict")[r], 145, ky[r], just = "right")
    for (k in 1:2) box(kx[k], ky[r], 4, 4, dcoll[(r - 1) * 2 + k]) }
}
quality <- function(q, x, y, w = 6, h = 3.8) {
  box(x, y, w, h, qc[[q]], rule); tx(qcode[[q]], x, y, just = "centre", colour = if (q %in% c("Complete", "High-quality")) "white" else ink)
}
mark <- function(on, x, y) { box(x, y, 3.5, 3.5, "white", rule); if (on) box(x, y, 1.8, 1.8, ink) }
carriers <- function() {
  tag("B", 55)
  tx("Carrier / VF label", 5, 61, face = "bold"); tx("CheckV", 132, 61, just = "centre", face = "bold")
  tx(mark_key[[1]], 150, 61, just = "centre"); tx(mark_key[[2]], 168, 61, just = "centre")
  for (j in seq_along(smp)) { x <- x0 + (j - 1) * cw; tx(smp[j], x, 66, just = "centre"); box(x, 70, cw - .25, 1, site_col[[site_of[j]]]) }
  yy <- 74 + (seq_along(ordv) - 1) * rowh
  for (i in seq_along(ordv)) {
    v <- ordv[i]
    if (i %% 2 == 0) box(90, yy[i], 170, rowh, "#FAFAFA")
    tx(rowlab[[v]], 5, yy[i]); quality(vq[i], 132, yy[i])
    mark(qual$strict[i], 150, yy[i]); mark(qual$region[i], 168, yy[i])
    for (j in seq_along(smp)) {
      z <- cell(v, smp[j]); x <- x0 + (j - 1) * cw
      box(x, yy[i], cw - .25, rowh - .45, if (z$detected) ramp[1 + round(255 * sqrt(z$pct / maxv))] else undetected_fill, rule)
      if (z$detected && z$pct < .01) tx("<0.01", x, yy[i], just = "centre")
    }
  }
  ykey <- utils::tail(yy, 1) + 9
  q4 <- c("Complete", "High-quality", "Medium-quality", "Low-quality")
  for (j in seq_along(q4)) { x <- 9 + (j - 1) * 34; quality(q4[j], x, ykey); tx(c("Complete", "High", "Medium", "Low")[j], x + 4, ykey) }
  tx("Carrier abundance", 5, ykey + 8); tx("(% of detected catalogue)", 5, ykey + 13)
  for (k in 1:256) box(49 + 35 * (k - .5) / 256, ykey + 7, 35 / 256 + .02, 2.3, ramp[k])
  for (v in c(0, .5, 1, 2, 3)) tx(v, 49 + 35 * sqrt(v / maxv), ykey + 12, just = "centre")
  box(98, ykey + 7, cw - .25, rowh - .45, undetected_fill, rule); tx("Below detection rule", 103, ykey + 7)
}
forest <- function(ytitle = 175) {
  tag("C", ytitle)
  yhead <- ytitle + 6; yy <- ytitle + 15 + c(0, 7.5, 15, 22.5)
  tx("Model", 5, yhead, face = "bold"); tx("Hit\nset", 27, yhead, just = "centre"); tx("CheckV\nbranch", 49, yhead, just = "centre")
  tx("IRR [95% CI]", 128, yhead, face = "bold"); tx("n hits", 171, yhead, just = "centre")
  fx <- function(v) 64 + 54 * (log2(v) - log2(.4)) / (log2(5) - log2(.4))
  ln(fx(1), yy[1] - 4, fx(1), yy[4] + 4, col$grey_ref, lw(style$line_mm$thin), 2)
  ek <- palettes$estimate$ink
  for (i in seq_len(nrow(mods))) {
    z <- mods[i, ]; tx(paste0("M", models$model[i]), 5, yy[i])
    tx(if (region_changed[i]) "Retained" else "All", 27, yy[i], just = "centre")
    tx(if (label_changed[i]) "No" else "Yes", 49, yy[i], just = "centre")
    ln(fx(z$lo), yy[i], fx(z$hi), yy[i], ek, lw(style$line_mm$main))
    ln(fx(z$lo), yy[i] - 1, fx(z$lo), yy[i] + 1, ek, lw(style$line_mm$main)); ln(fx(z$hi), yy[i] - 1, fx(z$hi), yy[i] + 1, ek, lw(style$line_mm$main))
    grid::grid.points(unit(fx(z$irr), "mm"), unit(H - yy[i], "mm"), pch = 16, size = unit(1.7, "mm"), gp = grid::gpar(col = ek, fill = ek))
    tx(sprintf("%.2f [%.2f, %.2f]", z$irr, z$lo, z$hi), 128, yy[i])
    tx(z$hits, 171, yy[i], just = "centre")
  }
  for (v in c(.5, 1, 2, 4)) { x <- fx(v); ln(x, yy[4] + 4, x, yy[4] + 5, ink, lw(style$line_mm$main)); tx(v, x, yy[4] + 8, just = "centre") }
  tx("VF hit-rate ratio: predicted temperate / putatively virulent", fx(1), 227, just = "centre")   # v39: >= 2.5 mm from the page edge
}
page <- grid::gTree(children = grid::gList(rwv_capture_grob({ shares_bars(); carriers(); forest(175) },
                                                                  width = rwv_mm_to_in(W), height = rwv_mm_to_in(H), style = style, fonts = fonts)),
                    vp = grid::viewport(width = unit(W, "mm"), height = unit(H, "mm"), clip = "off"))
fig <- patchwork::wrap_elements(full = page)
rwv_check(checks, "panel B grey below-detection tiles / detected tiles (v50, no dashes)", c(94L, 32L),
          c(sum(!hm$detected), sum(hm$detected)), source = "040 vf_carrier_abundance.tsv")
rwv_check(checks, "panel B detected tiles below 0.01% keep their text label", 1L, sum(hm$detected & hm$pct < .01))
# The Region info column is no longer drawn (v50). In THIS 18-row selection a CheckV region prediction exists exactly for
# the rows whose filtered hits are all region-excluded; checked here, stated in the figure notes, not generalised.
rwv_check(checks, "panel B region prediction rows equal the All hits excluded rows in the displayed selection",
          c("vOTU0073", "vOTU0016", "vOTU2681"), ordv[reg_y & qual$region], source = "040 vf_hit_catalogue.tsv; vf_heatmap_selection.tsv")
rwv_check(checks, "panel B no row has a region prediction without the exclusion mark, or vice versa", 0L, sum(xor(reg_y, qual$region)))
expected_text <- c(rwv_tag(style, c("A", "B", "C")), "Carrier share",
                   "No region", "exclusion", "Filtered", "Strict", "0", smp,
                   unname(rowlab), "CheckV", "excluded", "<0.01", "Below detection rule",
                   "(% of detected catalogue)", "Model", "CheckV", "branch", "n hits", "IRR [95% CI]",
                   "2.52 [1.51, 4.22]", "1.05 [0.57, 1.94]", "0.95 [0.49, 1.84]", "1.00 [0.53, 1.89]",
                   "VF hit-rate ratio: predicted temperate / putatively virulent")
res <- rwv_figure_export(fig, path_target, "fig4", spec, style, fonts, expected_text, step)
knitr::kable(res$qa[, c("format", "check", "observed", "pass")])
```

### Task 5: Record all-panel plot values, caption and checks

```r
# 2026-10-14: B inherits old S3E; C inherits old F4D; old F4B/C move to S3E/F.
base_cols <- function(d) {
  for (k in c("sample_id", "detected", "display_order", "strict_match_present",
              "all_filtered_hits_region_excluded", "ci_low", "ci_high")) if (is.null(d[[k]])) d[[k]] <- NA
  d[, c("panel", "item", "value", "value2", "unit", "sample_id", "detected",
        "display_order", "strict_match_present", "all_filtered_hits_region_excluded", "ci_low", "ci_high")]
}
vals <- rbind(
  base_cols(data.frame(panel = "A", item = paste(eE$sample_id, eE$criteria), value = eE$pct, value2 = NA,
                       unit = "% of detected catalogue (bar height); one whole-catalogue denominator per sample")),
  base_cols(data.frame(panel = "B", item = hm$vOTU_id, value = ifelse(hm$detected, hm$pct, NA_real_), value2 = hm$rank,
                       unit = "% of detected catalogue (tile fill); value2 = numeric rank", sample_id = as.character(hm$sample_id),
                       detected = hm$detected, display_order = hm$rank,
                       strict_match_present = qual$strict[match(hm$vOTU_id, qual$vOTU_id)],
                       all_filtered_hits_region_excluded = qual$region[match(hm$vOTU_id, qual$vOTU_id)])),
  base_cols(data.frame(panel = "C", item = paste(models$label_definition, "|", models$region_definition), value = models$irr,
                       value2 = models$n, unit = "IRR (value2 = vOTUs in the model)", ci_low = models$lo, ci_high = models$hi))
)
rwv_check(checks, "plot-values panels equal the figure tags", c("A", "B", "C"), sort(unique(vals$panel)))
rwv_check(checks, "plot-values panel B has every heatmap cell", 126L, sum(vals$panel == "B"))
rwv_check(checks, "all four model intervals recorded", TRUE,
          identical(vals$ci_low[vals$panel == "C"], models$lo) && identical(vals$ci_high[vals$panel == "C"], models$hi))
rwv_write_tsv(vals, path_target("fig4-plot-values.tsv"))
legend_en <- paste0(
  sprintf("(a) Candidate VF-carrier shares in seven samples under four combinations of matching stringency and region exclusion (filtered or strict, each with or without exclusion of predicted host-region and boundary hits). Filtered shares range from %s%s%s%%. ",
          rwv_fmt_num(min(eE$pct[eE$criteria == lv[1]])), rwv_ndash, rwv_fmt_num(max(eE$pct[eE$criteria == lv[1]]))),
  "Each carrier is counted once against the sample's whole detected catalogue; exclusion changes membership, not whole-contig abundance or the denominator. The bars are sensitivity settings, not replicates or treatment stages, and cannot be summed. ",
  sprintf("(b) The %d of %d filtered carriers with the highest maximum sample share (ties by vOTU identifier), using the same denominator as (a); these rows do not include every carrier. ", nrow(sel), full_carriers),
  "Labels are VFDB reference-function homologues, not validated functions; +n denotes further function labels omitted, not gene counts or complete systems. The square-root colour scale is labelled in percentages. Coloured tiles mark whole-contig detection (breadth ≥ 75%); grey tiles denote failure to meet this detection rule, not biological absence. CheckV gives the estimated-completeness class of each carrier. Strict match marks at least one hit meeting identity ≥ 40% and query coverage ≥ 80%. All hits excluded marks carriers whose filtered hits all fall in predicted host regions or cross their boundaries. These marks are independent and can both apply; a blank exclusion mark does not establish viral localization. Zeros in (a) also denote no qualifying carrier, not biological absence. ",
  sprintf("(c) All four models use filtered matches on the same %s vOTUs; they do not correspond to the four definitions in (a). Negative-binomial models compare VF-hit rates per kilobase in predicted-temperate versus predicted-virulent vOTUs, adjusting for CheckV completeness. Points are incidence rate ratios (IRR); bars are 95%% Wald confidence intervals on a log scale; the vertical line marks IRR = 1. ", rwv_fmt_int(unique(models$n))),
  "Row labels cross region/length handling with inclusion or omission of the CheckV lifestyle branch. Region exclusion changes hit counts and length offsets together; their separate effects are not identified. The estimates share CheckV information, are dependent, and are not combined. Unlocalized hits are not confirmed viral genes; alternatives near one establish neither a zero biological effect nor a validated definition. Carrier shares measure neither VF expression nor water-health risk. Model specifications, catalogue-to-model accounting and mark details: Supplementary Note 3; carrier records: Data 1 S46–S48. ",
  sprintf("Details: Supplementary figure notes, %s.", spec$label)
)
notes_en <- c(
  "Panel b mark details: Strict match requires at least one qualifying strict hit, not every hit. All hits excluded removes the candidate-carrier designation under regional definitions, not the sequence from the catalogue. If both marks apply, this does not imply retention under strict matching with region exclusion. Blank marks do not establish biological absence, lack of uncertainty or viral localization. Reference-function labels and +n do not validate whole systems.",
  "Panel a: fixed full-catalogue denominator; eligibility changes only, with no trimming or re-alignment. These are carrier-sequence shares, not VF gene abundance, expression, virulence or water concentration.",
  sprintf("Panel a: region exclusion alone takes gc1 from %s%% to %s%%, while strict annotation gives %s%%. Four zero bars are the two strict definitions in oc1 and od1.",
          rwv_fmt_num(eE$pct[eE$sample_id == "gc1" & eE$criteria == lv[1]]), rwv_fmt_num(eE$pct[eE$sample_id == "gc1" & eE$criteria == lv[2]]),
          rwv_fmt_num(eE$pct[eE$sample_id == "gc1" & eE$criteria == lv[3]])),
  "Panel b: source values and all 114 carriers remain in Data 1 S47, annotation evidence in S48, and sample totals in S46. The displayed 18 rows are selected by maximum individual share, not per-sample top lists. Their column sums are not panel a's totals.",
  "Panel b: whether any filtered hit of a carrier has a CheckV region prediction is not drawn as a separate column. Among the 18 displayed carriers it applies exactly to the three rows marked All hits excluded (vOTU0073, vOTU0016, vOTU2681); this holds for this selection only, and the field remains in Data 1 S48 and Supplementary Note 3. Grey tiles mark carriers that do not meet whole-contig detection in that sample; zero bars in (a) mean no qualifying carrier. Neither denotes biological absence.",
  "Panel b: Strict match and All hits excluded are independent marks; vOTU0016 carries both. Contig-level detection (whole-contig breadth \u2265 75%) does not prove read coverage of each annotated VF locus, and function labels are sequence-level annotations rather than per-sample gene detection. Tile colour is carrier-sequence abundance, not VF locus coverage, expression, virulence or water concentration.",
  sprintf("Model set (c): %s vOTUs have an estimated CheckV completeness; the 47 without it remain in the full catalogue and are excluded from these models only. All four models use filtered matching criteria, not the strict 40/80 threshold.", rwv_fmt_int(unique(models$n))),
  "Full-catalogue and model scopes: 143 hits = 18 predicted host + 1 boundary + 1 predicted viral + 123 without a region prediction; 142 model hits = the same 20 localized hits + 122 without prediction. Regional retention leaves 124 catalogue hits and 123 model hits; the two occurrences of 123 are different sets.",
  sprintf("Offsets (c): all-hits rows use log(contig length / 1000), regional rows use log(retained viral length / 1000), differing only for the %d flagged records. Both hit counts and length denominators change; their contributions are not separated.", nrow(records)),
  sprintf("Lifestyle (c): temperate if VIBRANT lysogenic OR geNomad provirus OR CheckV provirus OR Replidec temperate. Excluding only the CheckV branch changes %d labels (%d to %d temperate), while leaving all counted hits and the full-length offset unchanged. Neither label is an experimentally established lifestyle.",
          as.integer(models$temperate[1]) - as.integer(models$temperate[3]), as.integer(models$temperate[1]), as.integer(models$temperate[3])),
  sprintf("IRRs (c): %s, %s, %s and %s under the four dependent definitions. They are catalogue-level per-kilobase hit-rate comparisons, not sample-level abundance or treatment effects.",
          rwv_fmt_num(models$irr[1]), rwv_fmt_num(models$irr[2]), rwv_fmt_num(models$irr[3]), rwv_fmt_num(models$irr[4]))
)
rwv_write_legend(path_target("fig4-legend.md"), spec$label,
  "Candidate VF-carrier shares, carrier composition and lifestyle-definition sensitivity", legend_en,
  can_read = "Panel a shows seven-sample candidate-carrier shares under four annotation definitions. Panel b shows 18 of 114 carriers selected by maximum single-sample share. Panel c shows candidate VF hits per kb for predicted-temperate relative to predicted-virulent members of the same 3,013-vOTU model set; IRR > 1 favours temperate. All four models use Filtered candidates, not the four panel-a definitions. Localization scope/coordinates are in Supplementary Figure 4a/b and Note 3.",
  cannot_infer = "Bars are annotation sensitivity, not replicates or treatment stages. Carriage is not VF expression, pathogenic risk or concentration. Zero bars and grey below-detection cells do not prove biological absence. The 18-row sums are not panel-a totals; a row is a carrier vOTU, and +n counts omitted function labels. Strict match and All hits excluded are independent flags and can coincide; blank flags do not prove absence or viral localization. The 123 unlocalized catalogue hits and 123 retained after model region exclusion are different sets. The models cannot establish that host contamination explains all association, the true effect is zero or one definition is correct; region and offset change together, and estimates are not independent replicates.",
  sources = c("analyses/data/040-vf-inputs/vf_sample_summary.tsv (a: unchanged seven-sample, four-definition shares)",
              "analyses/data/040-vf-inputs/vf_carrier_abundance.tsv, vf_heatmap_selection.tsv, vf_hit_catalogue.tsv (b: unchanged selected-carrier values, ranks, detection and the independent Strict match and All hits excluded marks; formerly S3e)",
              "analyses/data/040-vf-inputs/vf_models.tsv, vf_model_excluded.tsv, vf_hit_localization.tsv, checkv_flagged_records.tsv (c: fixed filtered-criteria models and scope bridge; formerly Figure 4d)"),
  abbreviations = c("VF, virulence factor", "IRR, incidence rate ratio", "CI, confidence interval"), notes = notes_en)
check_table <- rwv_checks_finish(checks, path_target("fig4-checks.tsv"))
knitr::kable(check_table[, c("check", "expected", "observed", "pass")])
rwv_write_session_info(path_target("session-info.txt"),
                       c(step = params$name, run_id = step$run_id, mode = step$mode, quarto = rwv_quarto_version()))
```


## Published figure preview
