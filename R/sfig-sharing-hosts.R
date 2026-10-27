# Supplementary Figure 2 (adopted 2026-10-17): seven-sample sharing, abundance contributions and the
# 83 co-detected best-host links. Authors (display order): Jinlong Ru, Cunli Pan.
#
# Layout and encodings are those of the reviewed candidate outputs/pooled-host-network-2026-10-17
# (draw-network.R, draw-split-candidate.R; shared-host inset after outputs/chen2021-final-candidates-
# 2026-10-17/draw-S1.R). Here the page is built as one grid grob from the workflow's own 020 tables,
# with colours from analyses/R/palettes.yml (sample_codetection, sharing) and the site colours of
# analyses/R/style.yml, so that rwv_figure_export() writes PDF/SVG/PNG/TIFF from the same object. The
# drawing uses a native 180 x 254 mm frame (y downwards) inside the figure margin; no value is
# derived beyond counting saved table rows. Node and spoke sizes encode nothing; the star layout
# follows the one-best-genus display rule, not an inferred network module.

#' Display form of a GTDB genus name. Placeholder names such as ELB16-189 contain a hyphen between
#' digits, which the house text rule (a digit-digit range takes an en dash) would read as a range.
#' A zero-width non-joiner (U+200C) follows the hyphen: the drawn name is unchanged (tested with Arial
#' in the quartz PDF, ragg PNG and svglite SVG devices) and the range rule stays enforced on every
#' other text. Arial has no glyph for the non-breaking hyphens U+2010/U+2011. Tables keep the name.
rwv_taxon_display <- function(x) gsub("(?<=[0-9])-(?=[0-9])", "-\u200c", x, perl = TRUE)

#' One row per vOTU whose saved best iPHoP host genus was detected in the same sample at least once.
rwv_host_links <- function(hosts, codet, samples) {
  ip <- codet[codet$endpoint == "iPHoP record (score >= 90)", , drop = FALSE]
  ip$co <- toupper(ip$codetected) == "TRUE"
  hit <- ip[ip$co, , drop = FALSE]
  ids <- sort(unique(hit$vOTU_id))
  h <- hosts[match(ids, hosts$vOTU_id), , drop = FALSE]
  out <- data.frame(vOTU_id = ids, host_genus = sub("^g__", "", h$host_genus_clean),
                    iphop_score = as.numeric(h$iphop_confidence), stringsAsFactors = FALSE)
  for (s in samples) out[[s]] <- as.integer(ids %in% hit$vOTU_id[hit$sample_id == s])
  out$n_codetected_samples <- rowSums(out[, samples, drop = FALSE])
  out$codetected_samples <- apply(out[, samples, drop = FALSE], 1, function(r) paste(samples[r == 1], collapse = ";"))
  out[order(out$host_genus, out$vOTU_id), c("vOTU_id", "host_genus", "iphop_score", "n_codetected_samples",
                                            "codetected_samples", samples)]
}

#' Node, spoke and host-diamond positions of panel c (mm, y downwards from the page top).
rwv_host_link_layout <- function(links, samples, cols, top = 144, row_step = 16) {
  freq <- table(links$host_genus)
  genera <- names(freq)[order(-as.integer(freq), names(freq))]
  n_of <- as.integer(freq[genera]); n_rows <- ceiling(length(genera) / 6)
  row_gap <- vapply(seq_len(n_rows), function(r) if (any(n_of[((r - 1) * 6 + 1):min(r * 6, length(genera))] > 1)) 17 else 13, numeric(1))
  nodes <- list(); events <- list(); hosts <- list()
  for (i in seq_along(genera)) {
    g <- genera[i]; z <- links[links$host_genus == g, , drop = FALSE]; z <- z[order(z$vOTU_id), , drop = FALSE]
    # v40: six genera per row at 28 mm so that 9.2 pt italic genus labels do not touch; rows holding a genus
    # with two or more links (spokes reach 6.3 mm below the diamond) are 17 mm apart, single-link rows 13 mm.
    r <- (i - 1) %/% 6
    xc <- 6 + (i - 1) %% 6 * 28 + 14
    yc <- top + sum(row_gap[seq_len(r)])
    hosts[[i]] <- data.frame(genus = g, x = xc, y = yc, label_y = yc - 8, n = nrow(z))
    # Equal-length spokes at stable angles; the angle carries no information.
    ang <- if (nrow(z) == 1) pi / 2 else seq(pi / 2, pi / 2 + 2 * pi, length.out = nrow(z) + 1)[seq_len(nrow(z))]
    for (k in seq_len(nrow(z))) {
      x <- xc + 5.3 * cos(ang[k]); y <- yc - 5.3 * sin(ang[k]); ss <- samples[as.integer(z[k, samples]) == 1]
      nodes[[length(nodes) + 1]] <- data.frame(vOTU_id = z$vOTU_id[k], genus = g, x = x, y = y, samples = paste(ss, collapse = ";"))
      for (j in seq_along(ss)) {
        events[[length(events) + 1]] <- data.frame(vOTU_id = z$vOTU_id[k], genus = g, sample = ss[j], colour = cols[[ss[j]]],
                                                   x0 = xc, y0 = yc, x1 = x, y1 = y, shift = (j - (length(ss) + 1) / 2) * 0.9)
      }
    }
  }
  hosts <- do.call(rbind, hosts)
  # legend row: 7 mm below the lowest diamond; footer lines 7 and 14 mm further down
  list(nodes = do.call(rbind, nodes), events = do.call(rbind, events), hosts = hosts, legend_y = max(hosts$y) + 8.5)
}

#' The whole Supplementary Figure 2 page as one grob (180 mm x H design frame; H = page height).
rwv_sharing_hosts_grob <- function(pat, ss, members, hosts, links, lay, palettes, style, samples, site_of, H = 254) {
  W <- 180   # v40: the page height H comes from analyses/R/figures.yml (sfig2)
  pt <- style$text_pt; fam <- style$font$family; ink <- style$colours$text
  sh <- palettes$sharing; cols <- unlist(palettes$sample_codetection)
  site_col <- rwv_site_colours(style)
  scol <- function(s) site_col[[site_of[[s]]]]
  lw <- function(mm) mm / 25.4 * 96                       # grid lwd is in 1/96 inch
  g <- list()
  add <- function(x) g[[length(g) + 1L]] <<- x
  u <- function(v) grid::unit(v, "native")
  txt <- function(s, x, y, size = pt$annotation, just = "left", face = "plain")
    add(grid::textGrob(s, u(x), u(y), just = just, gp = grid::gpar(fontfamily = fam, fontsize = size, fontface = face, col = ink, lineheight = 1)))
  line <- function(x0, y0, x1, y1, col = ink, mm = style$line_mm$thin)
    add(grid::linesGrob(u(c(x0, x1)), u(c(y0, y1)), gp = grid::gpar(col = col, lwd = lw(mm))))
  # Rectangles as polygons in native coordinates (the y axis runs downwards).
  box <- function(x0, y0, x1, y1, fill)
    add(grid::polygonGrob(u(c(x0, x1, x1, x0)), u(c(y0, y0, y1, y1)), gp = grid::gpar(fill = fill, col = NA)))
  pie <- function(x, y, r, s) {
    for (j in seq_along(s)) {
      a <- seq(pi / 2 + (j - 1) * 2 * pi / length(s), pi / 2 + j * 2 * pi / length(s), length.out = 30)
      add(grid::polygonGrob(u(c(x, x + r * cos(a))), u(c(y, y - r * sin(a))), gp = grid::gpar(fill = cols[[s[j]]], col = NA)))
    }
    add(grid::circleGrob(u(x), u(y), r = grid::unit(r, "mm") * (1 - 2 * style$figure_mm$margin / W),
                         gp = grid::gpar(fill = NA, col = sh$network_ink, lwd = lw(0.16))))
  }
  diamond <- function(x, y)
    add(grid::polygonGrob(u(x + c(0, 1.45, 0, -1.45)), u(y + c(-1.45, 0, 1.45, 0)),
                          gp = grid::gpar(fill = "#FFFFFF", col = sh$network_ink, lwd = lw(0.28))))
  # ---- a: exact sharing patterns (UpSet) with the shared-member host inset
  shared <- members$vOTU_id[as.integer(members$n_qualifying_samples) >= 2]
  shh <- hosts[hosts$vOTU_id %in% shared, , drop = FALSE]
  phyla <- vapply(strsplit(shh$host_genus_full, ";", fixed = TRUE), function(z) sub("^p__", "", z[startsWith(z, "p__")]), character(1))
  hp <- table(phyla); hp <- hp[order(-as.integer(hp), names(hp))]
  n_all7 <- sum(as.integer(members$n_qualifying_samples) == length(samples))
  # v50 figure cleanup (2026-10-19, Codex task book docs/figure-cleanup-v49-2026-10-19/00): panel letters only; the
  # introductory titles, the a summary block, the shared-member host inset and the c ledger/key sentences are no longer
  # drawn (their values are in the figure notes, the caption or Supplementary Note 2). Bars, dots, links unchanged.
  txt(rwv_tag(style, "A"), 3, 7, pt$tag, face = "bold")
  px <- 46 + (seq_len(nrow(pat)) - 0.5) * 128 / nrow(pat)
  mx <- max(pat$n_vOTUs)
  for (i in seq_len(nrow(pat))) {
    ytop <- 35 - pat$n_vOTUs[i] / mx * 22
    # v40: a count label that would touch its left neighbour (same height band, overlapping widths) moves one line up
    ly <- ytop - 1.5
    if (i > 1) { w <- 1.75 * (nchar(pat$n_vOTUs[i]) + nchar(pat$n_vOTUs[i - 1])) / 2
      if (px[i] - px[i - 1] < w + 0.4 && abs(ly - prev_ly) < 3.4) ly <- prev_ly - 3.4 }
    prev_ly <- ly
    box(px[i] - 1.6, ytop, px[i] + 1.6, 35, sh$bar); txt(as.character(pat$n_vOTUs[i]), px[i], ly, just = "centre")
    bits <- as.integer(strsplit(pat$pattern[i], "")[[1]]); ys <- 43 + (seq_along(samples) - 1) * 4
    line(px[i], min(ys[bits == 1]), px[i], max(ys[bits == 1]), mm = 0.25)
    for (k in seq_along(samples)) add(grid::circleGrob(u(px[i]), u(ys[k]), r = grid::unit(0.55, "mm"),
                                                       gp = grid::gpar(fill = if (bits[k] == 1) scol(samples[k]) else sh$inactive_dot, col = NA)))
    txt(as.character(i), px[i], 73, just = "centre")
  }
  line(45, 35, 174, 35, mm = style$line_mm$main)
  for (k in seq_along(samples)) {
    y <- 43 + (k - 1) * 4; q <- ss$qualifying_vOTUs[ss$sample_id == samples[k]]
    txt(samples[k], 3, y); box(17, y - 1, 17 + 17 * q / max(ss$qualifying_vOTUs), y + 1, scol(samples[k])); txt(as.character(q), 36, y)
  }
  # ---- b: catalogue abundance of sample-only and shared members
  txt(rwv_tag(style, "B"), 3, 81, pt$tag, face = "bold")
  for (k in seq_along(samples)) {
    y <- 88 + (k - 1) * 3.5; v <- ss$sample_only_catalogue_percent[ss$sample_id == samples[k]]
    txt(samples[k], 42, y, just = "right")
    box(46, y - 1.1, 157, y + 1.1, sh$shared_fill); if (v > 0) box(46, y - 1.1, 46 + 111 * v / 100, y + 1.1, sh$bar)
    txt(sprintf("%.1f%%", v), 160, y)
  }
  line(46, 114, 157, 114, mm = style$line_mm$main)
  for (v in c(0, 25, 50, 75, 100)) { x <- 46 + 111 * v / 100; line(x, 114, x, 115); txt(as.character(v), x, 118, just = "centre") }
  box(46, 122.2, 49, 124.2, sh$bar); txt("Only this sample", 51, 123.2)
  box(96, 122.2, 99, 124.2, sh$shared_fill); txt("Also qualifies elsewhere", 101, 123.2)
  # ---- c: the 83 co-detected best-host links, pooled across samples
  txt(rwv_tag(style, "C"), 3, 130, pt$tag, face = "bold")
  ev <- lay$events
  for (i in seq_len(nrow(ev))) {
    e <- ev[i, ]; dx <- e$x1 - e$x0; dy <- e$y1 - e$y0; len <- sqrt(dx * dx + dy * dy)
    p0 <- -dy / len * e$shift; q0 <- dx / len * e$shift
    add(grid::bezierGrob(u(c(e$x0, e$x0 + dx / 3 + p0, e$x0 + 2 * dx / 3 + p0, e$x1)),
                         u(c(e$y0, e$y0 + dy / 3 + q0, e$y0 + 2 * dy / 3 + q0, e$y1)), gp = grid::gpar(col = e$colour, lwd = lw(0.26))))
  }
  for (i in seq_len(nrow(lay$nodes))) pie(lay$nodes$x[i], lay$nodes$y[i], 0.95, strsplit(lay$nodes$samples[i], ";", fixed = TRUE)[[1]])
  for (i in seq_len(nrow(lay$hosts))) {
    h <- lay$hosts[i, ]; diamond(h$x, h$y); txt(rwv_taxon_display(h$genus), h$x, h$label_y, just = "centre", face = "italic")
  }
  ly <- lay$legend_y
  for (i in seq_along(samples)) { x <- 7 + (i - 1) * 24; pie(x, ly, 1.05, samples[i]); txt(samples[i], x + 2.5, ly) }
  grid::gTree(children = do.call(grid::gList, g),
              vp = grid::viewport(xscale = c(0, W), yscale = c(H, 0)))
}
