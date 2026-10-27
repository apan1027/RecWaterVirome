# Shared figure style: config readers, physical unit conversions, the common
# ggplot2 theme and fixed site/sample scales.
# Authors (display order): Jinlong Ru, Cunli Pan
#
# Pure function definitions: config files are read only when a reader is
# called with an explicit path.

# ---------------------------------------------------------------------------
# Unit conversions (the only place where pt/mm/inch/lwd factors appear)
#
# - Text sizes are pt (1/72 in). Theme element_text(size) takes pt directly.
# - ggplot2 geom text `size` is in ggplot mm units: fontsize = size * .pt.
# - R graphics draw lwd = 1 as 1/96 in; ggplot2 uses lwd = linewidth * .pt,
#   so a ggplot2 linewidth of 1 is 72.27/96 mm on paper, not 1 mm.

rwv_mm_to_in <- function(mm) mm / 25.4

rwv_bigpt_to_mm <- function(pt) pt * 25.4 / 72

rwv_geom_text_size <- function(pt) pt / ggplot2::.pt

rwv_linewidth <- function(mm) mm * 96 / 72.27

rwv_lwd <- function(mm) mm / 25.4 * 96

# ---------------------------------------------------------------------------
# Config readers

rwv_style_read <- function(path) {
  s <- yaml::read_yaml(path)
  bad <- function(...) rwv_fail(basename(path), ": ", ...)
  if (!identical(as.integer(s$version), 1L)) bad("unsupported version.")
  if (!is.character(s$font$family) || !nzchar(s$font$family)) bad("font$family must be set.")
  sizes <- c("ordinary", "minimum", "title", "tag")
  pt <- s$text_pt
  if (!all(sizes %in% names(pt)) || !all(vapply(pt[sizes], is.numeric, logical(1)))) {
    bad("text_pt needs numeric ", paste(sizes, collapse = ", "), ".")
  }
  if (any(unlist(pt[sizes]) < pt$minimum)) bad("no text size may be below text_pt$minimum.")
  positive <- list(figure_mm = s$figure_mm$width, line_mm = s$line_mm$main, point_mm = s$point_mm$sample)
  for (n in names(positive)) {
    if (!is.numeric(positive[[n]]) || positive[[n]] <= 0) bad(n, " must be a positive number.")
  }
  hex <- "^#[0-9A-Fa-f]{6}$"
  sites <- unlist(s$site_colours)
  if (!length(sites) || is.null(names(sites)) || !all(grepl(hex, sites)) || anyDuplicated(sites)) {
    bad("site_colours must be distinct, named #RRGGBB values.")
  }
  if (!all(grepl(hex, unlist(s$colours)))) bad("colours must be #RRGGBB values.")
  for (key in names(s$figure_text_pt)) {
    ov <- s$figure_text_pt[[key]]
    if (!length(ov) || !all(names(ov) %in% names(pt)) || !all(vapply(ov, is.numeric, logical(1)))) {
      bad("figure_text_pt$", key, " may only set numeric text_pt sizes.")
    }
    merged <- utils::modifyList(pt, ov)
    if (any(unlist(merged[sizes]) < merged$minimum) || merged$minimum < pt$minimum) {
      bad("figure_text_pt$", key, ": no size below its minimum, and the minimum not below text_pt$minimum.")
    }
  }
  if (!is.null(s$panel_tag$case) && !s$panel_tag$case %in% c("lower", "upper")) bad("panel_tag$case must be lower or upper.")
  if (!is.numeric(s$export$png_dpi) || s$export$png_dpi < 300) bad("export$png_dpi must be at least 300.")
  if (!length(s$export$pdf_devices) || !all(rwv_chr(s$export$pdf_devices) %in% names(rwv_pdf_openers()))) {
    bad("export$pdf_devices must name devices from: ", paste(names(rwv_pdf_openers()), collapse = ", "), ".")
  }
  s
}

# Style of one figure: text_pt with the figure's own sizes from figure_text_pt
# (v39, Figures 3-5); a figure without an entry gets the shared text_pt unchanged.
# Export QA then checks that figure against its own minimum.
rwv_style_for_figure <- function(style, key) {
  ov <- style$figure_text_pt[[key]]
  if (!is.null(ov)) style$text_pt <- utils::modifyList(style$text_pt, ov)
  style
}

# Sample dictionary in its fixed order; sample_id and site become factors
# whose levels carry that order and the configured site order.
rwv_samples_read <- function(path, style) {
  x <- as.data.frame(rwv_read_tsv(path))
  if (!identical(names(x), c("sample_id", "sample_order", "site"))) {
    rwv_fail(basename(path), " must have the columns sample_id, sample_order, site.")
  }
  order <- suppressWarnings(as.integer(x$sample_order))
  if (anyNA(order) || !identical(sort(order), seq_len(nrow(x)))) {
    rwv_fail(basename(path), ": sample_order must be 1..", nrow(x), ".")
  }
  if (anyDuplicated(x$sample_id) || !all(nzchar(x$sample_id))) rwv_fail(basename(path), ": sample_id must be unique.")
  unknown <- setdiff(x$site, names(style$site_colours))
  if (length(unknown)) rwv_fail(basename(path), ": sites without a configured colour: ", paste(unknown, collapse = ", "), ".")
  x$sample_order <- order
  x <- x[order(order), , drop = FALSE]
  x$sample_id <- factor(x$sample_id, levels = x$sample_id)
  x$site <- factor(x$site, levels = names(style$site_colours))
  rownames(x) <- NULL
  x
}

# ---------------------------------------------------------------------------
# Theme and scales

rwv_theme <- function(style) {
  pt <- style$text_pt
  family <- style$font$family
  ink <- style$colours$text
  paper <- style$colours$background
  lw <- rwv_linewidth(style$line_mm$main)
  txt <- function(size, ...) ggplot2::element_text(family = family, size = size, colour = ink, ...)
  ggplot2::theme_classic(base_size = pt$ordinary, base_family = family, base_line_size = lw, base_rect_size = lw) +
    ggplot2::theme(
      text = txt(pt$ordinary),
      axis.text = txt(pt$ordinary),
      axis.title = txt(pt$ordinary),
      legend.text = txt(pt$ordinary),
      legend.title = txt(pt$ordinary),
      strip.text = txt(pt$ordinary, margin = ggplot2::margin(1.2, 1.2, 1.2, 1.2, unit = "mm")),
      plot.title = txt(pt$title, hjust = 0, margin = ggplot2::margin(b = 1.5, unit = "mm")),
      plot.subtitle = txt(pt$ordinary, hjust = 0),
      plot.caption = txt(pt$ordinary, hjust = 0),
      plot.tag = txt(pt$tag, face = "bold"),
      plot.title.position = "plot",
      plot.caption.position = "plot",
      line = ggplot2::element_line(colour = ink, linewidth = lw),
      axis.line = ggplot2::element_line(colour = ink, linewidth = lw),
      axis.ticks = ggplot2::element_line(colour = ink, linewidth = lw),
      axis.ticks.length = ggplot2::unit(1, "mm"),
      strip.background = ggplot2::element_rect(fill = style$colours$strip_fill, colour = NA),
      plot.background = ggplot2::element_rect(fill = paper, colour = NA),
      panel.background = ggplot2::element_rect(fill = paper, colour = NA),
      legend.background = ggplot2::element_rect(fill = paper, colour = NA),
      legend.key = ggplot2::element_rect(fill = paper, colour = NA)
    )
}

rwv_site_colours <- function(style) {
  unlist(style$site_colours)
}

# Fixed site colours: every configured site keeps its colour and legend
# position whether or not it occurs in the plotted data.
rwv_scale_colour_site <- function(style, name = "Site", ...) {
  values <- rwv_site_colours(style)
  ggplot2::scale_colour_manual(name = name, values = values, limits = names(values), ...)
}

rwv_scale_fill_site <- function(style, name = "Site", ...) {
  values <- rwv_site_colours(style)
  ggplot2::scale_fill_manual(name = name, values = values, limits = names(values), ...)
}

rwv_sample_levels <- function(samples) {
  levels(samples$sample_id)
}
