# Shared helpers for the scientific figure, table and data steps: readers for
# analyses/R/palettes.yml, analyses/R/figures.yml and analyses/R/definitions.tsv, a
# numeric-check ledger tied to the definitions table, number formatting,
# the export-and-verify wrapper and the legend writer.
# Authors (display order): Jinlong Ru, Cunli Pan
#
# Pure function definitions only.

rwv_palettes_read <- function(path) {
  p <- yaml::read_yaml(path)
  if (!identical(as.integer(p$version), 1L)) rwv_fail(basename(path), ": unsupported version.")
  hex <- "^#[0-9A-Fa-f]{6}$"
  # `heatmap` is a continuous-ramp spec, not a category dictionary: it names a
  # colormap instead of listing hex values, so it is validated separately below.
  cols <- unlist(p[setdiff(names(p), c("version", "taxon_display_labels", "feature_group_shape", "heatmap"))])
  if (!all(grepl(hex, cols))) rwv_fail(basename(path), ": every colour must be #RRGGBB.")
  h <- p$heatmap
  if (is.null(h)) rwv_fail(basename(path), ": no heatmap ramp spec.")
  if (!is.character(h$palette) || length(h$palette) != 1L)
    rwv_fail(basename(path), ": heatmap$palette must be one colormap name.")
  if (!as.integer(h$direction) %in% c(-1L, 1L))
    rwv_fail(basename(path), ": heatmap$direction must be -1 or 1.")
  if (!is.numeric(h$levels) || as.integer(h$levels) < 2L)
    rwv_fail(basename(path), ": heatmap$levels must be at least 2.")
  if (!grepl(hex, h$zero)) rwv_fail(basename(path), ": heatmap$zero must be #RRGGBB.")
  p
}

# Continuous ramp shared by Figure 3a and Supplementary Figure 3e.
# Returns the full colormap as registered in analyses/R/palettes.yml. The ramp is
# handed to scale_fill_gradientn() whole, so ggplot2 interpolates inside the real
# colormap; sampling three stops and interpolating between them would no longer be
# that colormap. Alpha is dropped: viridisLite returns #RRGGBBFF, the project and
# its exports use #RRGGBB.
rwv_heatmap_colours <- function(palettes) {
  h <- palettes$heatmap
  if (!requireNamespace("viridisLite", quietly = TRUE))
    rwv_fail("viridisLite is required for the heatmap ramp registered in analyses/R/palettes.yml.")
  # Base-R HCL sequential palettes ("hcl:<name>", grDevices::hcl.colors; no extra
  # package). direction -1 orders the ramp light -> dark, as for viridisLite.
  if (startsWith(h$palette, "hcl:")) {
    nm <- sub("^hcl:", "", h$palette)
    if (!nm %in% grDevices::hcl.pals("sequential")) rwv_fail("analyses/R/palettes.yml: unknown sequential HCL palette ", nm, ".")
    cols <- substr(grDevices::hcl.colors(as.integer(h$levels), nm), 1L, 7L)
    lum <- function(x) sum(c(0.2126, 0.7152, 0.0722) * grDevices::col2rgb(x)[, 1])
    if ((as.integer(h$direction) == -1L) != (lum(cols[1]) > lum(cols[length(cols)]))) cols <- rev(cols)
    return(cols)
  }
  fun <- switch(h$palette,
                magma = viridisLite::magma, inferno = viridisLite::inferno,
                plasma = viridisLite::plasma, viridis = viridisLite::viridis,
                cividis = viridisLite::cividis, rocket = viridisLite::rocket,
                mako = viridisLite::mako, turbo = viridisLite::turbo,
                rwv_fail("analyses/R/palettes.yml: unsupported heatmap palette ", h$palette, "."))
  substr(fun(as.integer(h$levels), direction = as.integer(h$direction)), 1L, 7L)
}

rwv_figures_read <- function(path) {
  f <- yaml::read_yaml(path)
  if (!identical(as.integer(f$version), 1L)) rwv_fail(basename(path), ": unsupported version.")
  f$figures
}

rwv_figure_spec <- function(figures, key, step_name) {
  spec <- figures[[key]]
  if (is.null(spec)) rwv_fail("analyses/R/figures.yml has no entry ", key, ".")
  if (!identical(spec$step, step_name)) rwv_fail("analyses/R/figures.yml: ", key, " belongs to ", spec$step, ", not ", step_name, ".")
  spec
}

rwv_definitions_read <- function(path) {
  d <- as.data.frame(rwv_read_tsv(path))
  cols <- c("id", "figure", "study_unit", "object", "value", "unit", "denominator", "definition", "limitation", "source")
  if (!identical(names(d), cols)) rwv_fail(basename(path), " must have the columns ", paste(cols, collapse = ", "), ".")
  if (anyDuplicated(d$id)) rwv_fail(basename(path), ": duplicated id.")
  d
}

# Registered value of one definition (as number when it is one).
rwv_def <- function(defs, id) {
  row <- defs[defs$id == id, , drop = FALSE]
  if (nrow(row) != 1L) rwv_fail("analyses/R/definitions.tsv has no id ", id, ".")
  v <- suppressWarnings(as.numeric(row$value))
  if (is.na(v)) row$value else v
}

# ---------------------------------------------------------------------------
# Check ledger: every number shown in a figure is compared with its source or
# with the registered definition; all rows are written, failures stop the step.
# `source` names where the expected value comes from; a value typed from the
# same table it is compared with must say so ("regression constant").

rwv_checks_new <- function() {
  env <- new.env(parent = emptyenv())
  env$rows <- list()
  env
}

rwv_check <- function(checks, what, expected, observed, tol = 0, source = "") {
  e <- expected
  o <- observed
  pass <- if (is.numeric(e) && is.numeric(o)) {
    length(e) == length(o) && all(abs(e - o) <= tol)
  } else {
    identical(as.character(e), as.character(o))
  }
  fmt <- function(x) {
    v <- if (is.numeric(x)) format(x, digits = 10) else as.character(x)
    if (length(v) > 12) paste0(paste(head(v, 5), collapse = ", "), ", ... (", length(v), " values)") else paste(v, collapse = ", ")
  }
  checks$rows[[length(checks$rows) + 1L]] <- data.frame(
    check = what, expected = fmt(e), observed = fmt(o), tolerance = tol, pass = isTRUE(pass), source = source
  )
  invisible(isTRUE(pass))
}

rwv_check_def <- function(checks, defs, id, observed, source = "") {
  rwv_check(checks, paste0("definitions.tsv:", id), rwv_def(defs, id), observed, 0, source)
}

rwv_checks_finish <- function(checks, path) {
  out <- do.call(rbind, checks$rows)
  rwv_write_tsv(out, path)
  if (!all(out$pass)) {
    bad <- out[!out$pass, , drop = FALSE]
    rwv_fail("Numeric checks failed:\n", paste0("  ", bad$check, ": expected ", bad$expected,
                                               ", observed ", bad$observed, collapse = "\n"))
  }
  out
}

# ---------------------------------------------------------------------------
# Typography helpers: true minus sign, en dash ranges, k/n fractions,
# thousands separators. Arial carries U+2212, U+2013, U+2265, U+00B1, U+00D7.

rwv_minus <- "−"
rwv_ndash <- "–"

rwv_fmt_int <- function(x) formatC(x, format = "d", big.mark = ",")

rwv_fmt_num <- function(x, digits = 2) {
  out <- formatC(abs(x), format = "f", digits = digits, big.mark = ",")
  ifelse(x < 0, paste0(rwv_minus, out), out)
}

# Axis label function: thousands separators and a true minus.
rwv_axis_num <- function(x) {
  out <- format(abs(x), big.mark = ",", scientific = FALSE, trim = TRUE, drop0trailing = TRUE)
  ifelse(is.na(x), NA, ifelse(x < 0, paste0(rwv_minus, out), out))
}

rwv_fmt_frac <- function(k, n) paste0(rwv_fmt_int(k), "/", rwv_fmt_int(n))

rwv_fmt_range <- function(a, b, digits = NULL) {
  f <- if (is.null(digits)) rwv_fmt_int else function(v) rwv_fmt_num(v, digits)
  paste0(f(a), rwv_ndash, f(b))
}

# ---------------------------------------------------------------------------
# Plot helpers

# Small text layer at an explicit pt size.
rwv_text_pt <- function(style, pt = style$text_pt$ordinary) rwv_geom_text_size(pt)

# Display letter of a panel. Internal panel IDs (A-F in plot-values, checks
# and code) stay unchanged; only the letter drawn on the page follows
# style$panel_tag$case ("lower" -> a, b, c; "upper" -> A, B, C), so the
# journal convention can be switched in one place. NULL stays NULL.
rwv_tag <- function(style, id) {
  if (is.null(id)) return(NULL)
  case <- style$panel_tag$case
  if (is.null(case)) case <- "upper"
  switch(case, lower = tolower(id), upper = toupper(id),
         rwv_fail("style.yml: panel_tag$case must be 'lower' or 'upper'."))
}

# Label ink for text drawn on a coloured fill: `dark` on light fills, white on
# dark fills, by WCAG relative luminance (threshold 0.30), so a label stays
# legible when a palette colour changes instead of following a fixed class list.
rwv_label_ink <- function(fill, dark = "#000000") {
  rgb <- grDevices::col2rgb(fill) / 255
  lin <- ifelse(rgb <= 0.04045, rgb / 12.92, ((rgb + 0.055) / 1.055)^2.4)
  lum <- colSums(lin * c(0.2126, 0.7152, 0.0722))
  ifelse(lum > 0.30, dark, "#FFFFFF")
}

# Common panel theme: titles aligned to the plot edge, 9 pt axis text, 8 pt
# annotations (style$text_pt$annotation) and compact legends.
rwv_panel <- function(style, ...) {
  pt <- style$text_pt
  rwv_theme(style) + ggplot2::theme(
    plot.margin = ggplot2::margin(1.5, 2, 1.5, 1.5, unit = "mm"),
    plot.subtitle = ggplot2::element_text(size = pt$annotation, family = style$font$family, colour = style$colours$text,
                                          hjust = 0, lineheight = 1.05, margin = ggplot2::margin(b = 1, unit = "mm")),
    legend.key.size = ggplot2::unit(3, "mm"),
    legend.margin = ggplot2::margin(0, 0, 0, 0),
    legend.box.spacing = ggplot2::unit(1, "mm"),
    ...
  )
}

# Theme for text-only or table panels built with theme_void(): same title,
# subtitle and tag style as rwv_panel(), titles aligned to the plot edge.
rwv_void_panel <- function(style) {
  pt <- style$text_pt
  fam <- style$font$family
  ink <- style$colours$text
  ggplot2::theme_void(base_family = fam) + ggplot2::theme(
    plot.title = ggplot2::element_text(size = pt$title, colour = ink, hjust = 0, margin = ggplot2::margin(b = 0.5, unit = "mm")),
    plot.subtitle = ggplot2::element_text(size = pt$annotation, colour = ink, hjust = 0, lineheight = 1.05,
                                          margin = ggplot2::margin(b = 1, unit = "mm")),
    plot.tag = ggplot2::element_text(size = pt$tag, face = "bold", colour = ink),
    plot.title.position = "plot",
    plot.background = ggplot2::element_rect(fill = style$colours$background, colour = NA),
    plot.margin = ggplot2::margin(1.5, 2, 1.5, 1.5, unit = "mm"))
}

# ---------------------------------------------------------------------------
# Export + verification of one assembled figure; writes <stem>-export.json.

# Strings that must not appear on a figure page or in a legend: ASCII stand-ins
# for typographic symbols, hyphen-for-dash ranges, the British spelling mixed
# with DefenseFinder's American one, and workflow jargon.
rwv_forbidden_text <- c(
  ">=" = ">=", "+-" = "\\+-", "digit-hyphen-digit range" = "[0-9]-[0-9]", "defence spelling" = "[Dd]efence",
  "'saved' (workflow jargon)" = "\\bsaved\\b", "'source project' (workflow jargon)" = "source project",
  "'rho' spelled out" = "\\brho\\b", "ASCII times" = "[0-9] x [0-9A-Z]", "'not a vote'" = "not a vote",
  "'exported' (workflow jargon)" = "not exported|were not exported")

rwv_text_violations <- function(text) {
  hits <- vapply(rwv_forbidden_text, function(p) grepl(p, text, perl = TRUE), logical(1))
  names(rwv_forbidden_text)[hits]
}

rwv_figure_export <- function(fig, path_target, stem, spec, style, fonts, expected_text, step, extra = list(),
                              registered_rasters = NULL) {
  m <- style$figure_mm$margin
  if (!is.function(fig)) fig <- fig + patchwork::plot_annotation(
    theme = ggplot2::theme(plot.margin = ggplot2::margin(m, m, m, m, unit = "mm"),
                           plot.background = ggplot2::element_rect(fill = style$colours$background, colour = NA)))
  exports <- rwv_export_figure(fig, path_target, stem, spec$width_mm, spec$height_mm, style, fonts)
  qa <- rwv_verify_exports(exports, style, fonts, expected_text = expected_text, registered_rasters = registered_rasters)
  pdf <- exports$path[exports$format == "pdf"]
  words <- pdftools::pdf_data(pdf)[[1]]
  size <- pdftools::pdf_pagesize(pdf)
  edge_pt <- min(words$x, words$y, size$width[1] - (words$x + words$width), size$height[1] - (words$y + words$height))
  edge_mm <- rwv_bigpt_to_mm(edge_pt)
  qa <- rbind(qa, data.frame(format = "pdf", check = "text >= 2.5 mm from every page edge (mm)", expected = ">= 2.5",
                             observed = sprintf("%.2f", edge_mm), pass = edge_mm >= 2.5))
  page_text <- paste(pdftools::pdf_text(pdf), collapse = " ")
  bad <- rwv_text_violations(page_text)
  qa <- rbind(qa, data.frame(format = "pdf", check = "no forbidden strings on the page", expected = "none",
                             observed = if (length(bad)) paste(bad, collapse = "; ") else "none", pass = !length(bad)))
  record <- c(list(
    figure = stem, label = spec$label, scientific_content = TRUE, run_id = step$run_id,
    width_mm = spec$width_mm, height_mm = spec$height_mm, png_dpi = style$export$png_dpi, tiff_dpi = style$export$tiff_dpi,
    files = lapply(seq_len(nrow(exports)), function(i) {
      list(format = exports$format[i], file = exports$file[i], device = exports$device[i],
           bytes = file.size(exports$path[i]), sha256 = rwv_sha256(exports$path[i]))
    }),
    device_probes = structure(as.list(exports$probe), names = exports$format),
    fonts = fonts, qa = qa
  ), extra)
  jsonlite::write_json(record, path_target(paste0(stem, "-export.json")),
                       auto_unbox = TRUE, pretty = TRUE, digits = NA, dataframe = "rows")
  if (!all(qa$pass)) {
    rwv_fail("Export checks failed for ", stem, ":\n",
             paste0("  ", qa$format[!qa$pass], " ", qa$check[!qa$pass], ": expected ", qa$expected[!qa$pass],
                    ", observed ", qa$observed[!qa$pass], collapse = "\n"))
  }
  list(exports = exports, qa = qa)
}

# Legend file: one title used both as heading and as the first sentence, the
# panel descriptions, an abbreviation line, a short Chinese reading note (what
# can and cannot be read from the figure) and the sources. The English legend
# is checked against the same forbidden strings as the figure page.
# Supplementary figure notes: the "Figure notes" section of each generated
# legend, collected in figure order into one shareable Markdown file. Only the
# scientific notes are taken; the Sources section (paths, hashes) stays in the
# legends and step records. The QMDs remain the single active text source.
# `legends` is a named character vector: figure label -> legend.md path.
rwv_figure_notes_compile <- function(legends) {
  out <- c("# Supplementary figure notes", "",
           paste("Detailed notes for each figure, in figure order. Each submission caption points to its section here;",
                 "the notes carry definitions, normalisation details and limits that are not repeated in the caption."), "")
  for (label in names(legends)) {
    txt <- readLines(legends[[label]], warn = FALSE, encoding = "UTF-8")
    title <- sub("^# [^.]*\\. ", "", txt[1])
    at <- grep("^## Figure notes", txt)
    if (length(at) != 1L) rwv_fail(basename(legends[[label]]), " has no single Figure notes section.")
    notes <- txt[(at + 1L):length(txt)]
    notes <- notes[nzchar(notes)]
    if (!length(notes) || !all(startsWith(notes, "- "))) rwv_fail(basename(legends[[label]]), ": Figure notes must be a non-empty bullet list.")
    out <- c(out, paste0("## ", label), "", paste0("*", title, "*"), "", notes, "")
  }
  out
}

# legend_en is the submission caption (kept short); notes are the detailed figure
# notes (definitions, normalisation details, map/basemap sources, reproduction
# remarks) written as a separate section after Sources. Both come from the same
# QMD, so the QMD stays the single active text source; 900 reads the sections.
rwv_write_legend <- function(path, label, title, legend_en, can_read, cannot_infer, sources, abbreviations = character(),
                             notes = character()) {
  if (grepl(paste0("^", label, " *\\|"), legend_en)) {
    rwv_fail("Legend of ", label, " repeats the figure label: legend_en must start with the first panel.")
  }
  body <- paste0(label, " | ", title, ". ", legend_en)
  if (length(abbreviations)) body <- paste0(body, " Abbreviations: ", paste(abbreviations, collapse = "; "), ".")
  bad <- rwv_text_violations(paste(c(body, notes), collapse = " "))
  if (length(bad)) rwv_fail("Legend of ", label, " contains forbidden strings: ", paste(bad, collapse = "; "))
  txt <- c(
    paste0("# ", label, ". ", title), "",
    "## Legend (English)", "", body, "",
    "## Interpretation guide", "", paste0("- What the figure shows: ", can_read), paste0("- Interpretation limits: ", cannot_infer), "",
    "## Sources", "", paste0("- ", sources)
  )
  if (length(notes)) txt <- c(txt, "", "## Figure notes (detail; not part of the submission caption)", "", paste0("- ", notes))
  writeLines(txt, path, useBytes = TRUE)
  invisible(path)
}

# ---------------------------------------------------------------------------
# Read generated legend sections; optional notes need not be present.
rwv_read_legend <- function(path) {
  txt <- readLines(path, warn = FALSE, encoding = "UTF-8")
  section <- function(heading, required = TRUE) {
    hit <- which(txt == heading)
    if (!length(hit) && !required) return(character())
    if (length(hit) != 1L) rwv_fail("Missing or duplicated legend section: ", heading, " in ", path)
    following <- which(startsWith(txt, "## ") & seq_along(txt) > hit)
    end <- if (length(following)) following[1] - 1L else length(txt)
    if (end <= hit) return(character())
    body <- txt[seq.int(hit + 1L, end)]
    body[nzchar(trimws(body))]
  }
  list(title = sub("^# ", "", txt[1]),
       en = paste(section("## Legend (English)"), collapse = " "),
       guide = section("## Interpretation guide"),
       sources = sub("^- ", "", section("## Sources")),
       notes = sub("^- ", "", section("## Figure notes (detail; not part of the submission caption)", FALSE)))
}

# Field-level dictionary for the data workbooks: one row per delivered field,
# with the type and missing-value pattern read from the delivered table and the
# meaning taken from analyses/R/field-notes.tsv. A note whose sheet is "*" applies
# to that field name in every sheet; a sheet-specific note wins over it.
# Fields without a curated note are listed with an empty meaning and
# curated = FALSE, so that the coverage is visible rather than implied.

rwv_field_notes_read <- function(path) {
  n <- as.data.frame(rwv_read_tsv(path))
  cols <- c("sheet", "field", "meaning", "unit_or_code", "missing_rule")
  if (!identical(names(n), cols)) rwv_fail(basename(path), " must have the columns ", paste(cols, collapse = ", "), ".")
  if (anyDuplicated(paste(n$sheet, n$field))) rwv_fail(basename(path), ": duplicated sheet/field pair.")
  n
}

rwv_field_dictionary <- function(tables, index, notes) {
  kind <- function(x) {
    if (is.numeric(x)) "numeric" else if (is.logical(x)) "logical" else "text"
  }
  rows <- lapply(names(tables), function(sh) {
    tb <- tables[[sh]]
    if (!ncol(tb)) return(NULL)
    data.frame(sheet = sh, position = seq_along(tb), field = names(tb),
               type = vapply(tb, kind, ""),
               n_missing = vapply(tb, function(x) sum(is.na(x) | (is.character(x) & !nzchar(as.character(x)))), 0L),
               example = vapply(tb, function(x) {
                 v <- x[!is.na(x) & (!is.character(x) | nzchar(as.character(x)))]
                 if (!length(v)) "" else substr(as.character(v[1]), 1, 60)
               }, ""),
               row.names = NULL)
  })
  d <- do.call(rbind, rows)
  pick <- function(sheet, field, col) {
    hit <- notes[notes$sheet == sheet & notes$field == field, col]
    if (length(hit) == 1L) return(hit)
    hit <- notes[notes$sheet == "*" & notes$field == field, col]
    if (length(hit) == 1L) hit else ""
  }
  for (col in c("meaning", "unit_or_code", "missing_rule")) {
    d[[col]] <- vapply(seq_len(nrow(d)), function(i) pick(d$sheet[i], d$field[i], col), "")
  }
  d$curated <- nzchar(d$meaning)
  d$sheet_content <- index$content[match(d$sheet, index$sheet)]
  d$source_file <- index$source_file[match(d$sheet, index$sheet)]
  d[order(match(d$sheet, index$sheet), d$position), ]
}

# Semantic checks of a field dictionary against the delivered tables, so that
# a curated note cannot contradict the values it describes. Returns one line
# per violation (empty when the dictionary is consistent):
# - "never empty" fields must have no missing value;
# - "fraction (0-1)", "per cent" and "0 / 1" / "1 / 0" units bound the values;
# - a unit written as "codes: a, b, c" must equal the set of observed values.
rwv_field_dictionary_check <- function(d, tables) {
  bad <- character(0)
  for (i in seq_len(nrow(d))) {
    r <- d[i, ]
    if (!isTRUE(r$curated)) next
    x <- tables[[r$sheet]][[r$field]]
    present <- x[!is.na(x) & (!is.character(x) | nzchar(as.character(x)))]
    tag <- paste0(r$sheet, "$", r$field, ": ")
    if (identical(r$missing_rule, "never empty") && r$n_missing > 0) {
      bad <- c(bad, paste0(tag, "'never empty' but ", r$n_missing, " missing"))
    }
    num <- suppressWarnings(as.numeric(as.character(present)))
    range_ok <- function(lo, hi) !length(num) || (!anyNA(num) && min(num) >= lo - 1e-12 && max(num) <= hi + 1e-12)
    if (startsWith(r$unit_or_code, "fraction (0-1)") && !range_ok(0, 1)) bad <- c(bad, paste0(tag, "values outside 0-1"))
    if (startsWith(r$unit_or_code, "per cent") && !range_ok(0, 100)) bad <- c(bad, paste0(tag, "values outside 0-100"))
    if (r$unit_or_code %in% c("0 / 1", "1 / 0") && !all(as.character(present) %in% c("0", "1"))) {
      bad <- c(bad, paste0(tag, "values other than 0/1"))
    }
    if (startsWith(r$unit_or_code, "codes:")) {
      # "codes: a, b; may be absent: c" -- a and b must all occur, c is allowed.
      parts <- strsplit(sub("^codes:", "", r$unit_or_code), ";", fixed = TRUE)[[1]]
      codes <- trimws(strsplit(parts[1], ",", fixed = TRUE)[[1]])
      optional <- if (length(parts) > 1L) trimws(strsplit(sub("^\\s*may be absent:", "", parts[2]), ",", fixed = TRUE)[[1]]) else character()
      seen <- sort(unique(as.character(present)))
      if (!all(codes %in% seen) || !all(seen %in% c(codes, optional))) {
        bad <- c(bad, paste0(tag, "codes {", paste(sort(codes), collapse = ", "), "}",
                             if (length(optional)) paste0(" (may be absent: ", paste(optional, collapse = ", "), ")") else "",
                             " but observed {", paste(seen, collapse = ", "), "}"))
      }
    }
  }
  bad
}
