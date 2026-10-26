# Export one assembled figure object to PDF, SVG and PNG at physical size,
# after probing that each device really works on this machine, and verify
# page size, fonts, text, strokes and background of the written files.
# Authors (display order): Jinlong Ru, Cunli Pan
#
# Pure function definitions only.

# PDF devices in the order config/style.yml may request them. capabilities()
# can report cairo as available while its library fails to load, so a device
# counts as usable only after rwv_device_probe() succeeds.
rwv_pdf_openers <- function() {
  list(
    cairo_pdf = function(file, width, height, family, bg) {
      grDevices::cairo_pdf(file, width = width, height = height, family = family, bg = bg, onefile = TRUE)
    },
    quartz_pdf = function(file, width, height, family, bg) {
      grDevices::quartz(type = "pdf", file = file, width = width, height = height, family = family, bg = bg)
    }
  )
}

rwv_svg_open <- function(file, width_in, height_in, bg) {
  svglite::svglite(file, width = width_in, height = height_in, bg = bg)
}

rwv_tiff_open <- function(file, width_mm, height_mm, dpi, bg) {
  ragg::agg_tiff(file, width = width_mm, height = height_mm, units = "mm", res = dpi, background = bg,
                 compression = "lzw")
}

# Minimal baseline-TIFF header reader (no extra package): width, height, resolution, compression, samples.
rwv_tiff_info <- function(file) {
  b <- readBin(file, "raw", n = file.size(file))
  little <- identical(rawToChar(b[1:2]), "II")
  endian <- if (little) "little" else "big"
  u <- function(off, n) readBin(b[(off + 1):(off + n)], "integer", size = n, signed = FALSE, endian = endian)
  u32 <- function(off) { v <- as.numeric(u(off, 2)) ; w <- as.numeric(u(off + 2, 2))
    if (little) v + w * 65536 else v * 65536 + w }
  ifd <- u32(4); n <- u(ifd, 2); out <- list()
  for (i in seq_len(n)) {
    e <- ifd + 2 + (i - 1) * 12
    tag <- u(e, 2); type <- u(e + 2, 2)
    val <- switch(as.character(type),
      "3" = u(e + 8, 2), "4" = u32(e + 8),
      "5" = { off <- u32(e + 8); u32(off) / u32(off + 4) },
      NA)
    out[[as.character(tag)]] <- val
  }
  unit <- if (is.null(out[["296"]])) 2 else out[["296"]]
  per_inch <- if (unit == 3) 2.54 else 1
  list(width = out[["256"]], height = out[["257"]], compression = out[["259"]], samples = out[["277"]],
       xdpi = out[["282"]] * per_inch, ydpi = out[["283"]] * per_inch)
}

rwv_png_open <- function(file, width_mm, height_mm, dpi, bg) {
  ragg::agg_png(file, width = width_mm, height = height_mm, units = "mm", res = dpi, background = bg)
}

rwv_pdf_font_names <- function(file) {
  fonts <- pdftools::pdf_fonts(file)
  if (!all(fonts$embedded)) {
    rwv_fail("Fonts not embedded in ", basename(file), ": ", paste(fonts$name[!fonts$embedded], collapse = ", "), ".")
  }
  sort(unique(sub("^[A-Z]{6}\\+", "", fonts$name)))
}

# Open a device on a temporary file, draw regular and bold text in the
# requested family, close it and confirm that a file was written (and, for
# PDF, which fonts were embedded). A warning while opening counts as failure.
# Returns "ok" or the reason why the device is unusable.
rwv_device_probe <- function(open, ext, family, expect_fonts = NULL) {
  file <- tempfile("rwv-probe-", fileext = ext)
  on.exit(unlink(file), add = TRUE)
  before <- grDevices::dev.list()
  result <- tryCatch(
    {
      withCallingHandlers(open(file), warning = function(w) rwv_fail(conditionMessage(w)))
      opened <- setdiff(grDevices::dev.list(), before)
      if (length(opened) != 1L) rwv_fail("no device was opened")
      grid::grid.newpage()
      grid::grid.text("Probe Ag", y = 0.6, gp = grid::gpar(fontfamily = family, fontsize = 9))
      grid::grid.text("Probe Ag", y = 0.3, gp = grid::gpar(fontfamily = family, fontsize = 9, fontface = "bold"))
      grDevices::dev.off(opened)
      if (!file.exists(file) || file.size(file) == 0) rwv_fail("no output was written")
      if (length(expect_fonts)) {
        embedded <- rwv_pdf_font_names(file)
        if (!setequal(embedded, expect_fonts)) {
          rwv_fail("embedded ", paste(embedded, collapse = ", "), " instead of ", paste(expect_fonts, collapse = ", "))
        }
      }
      "ok"
    },
    error = function(e) gsub("\\s+", " ", conditionMessage(e))
  )
  for (d in setdiff(grDevices::dev.list(), before)) grDevices::dev.off(d)
  result
}

rwv_pdf_device_choose <- function(style, fonts) {
  expect <- fonts$postscript_name[fonts$role %in% c("text", "text-bold")]
  openers <- rwv_pdf_openers()
  probes <- character()
  for (name in rwv_chr(style$export$pdf_devices)) {
    open <- openers[[name]]
    probes[[name]] <- rwv_device_probe(
      function(f) open(f, 2, 1, style$font$family, style$colours$background), ".pdf", style$font$family, expect
    )
    if (identical(probes[[name]], "ok")) return(list(device = name, probes = probes))
  }
  rwv_fail("No usable PDF device: ", paste0(names(probes), ": ", probes, collapse = "; "))
}

# grid.grabExpr defaults to pdf(NULL), whose PostScript font database does
# not necessarily contain installed TrueType fonts. Capture the vector grobs
# on the same font-verified PDF backend used for the final export instead.
rwv_capture_grob <- function(expr, width, height, style, fonts) {
  expression <- substitute(expr)
  evaluation_env <- parent.frame()
  choice <- rwv_pdf_device_choose(style, fonts)
  open <- rwv_pdf_openers()[[choice$device]]
  scratch <- tempfile("rwv-layout-", fileext = ".pdf")
  on.exit(unlink(scratch), add = TRUE)
  grob <- grid::grid.grabExpr(eval(expression, envir = evaluation_env),
    width = width, height = height,
    device = function(width, height) open(scratch, width, height, style$font$family, style$colours$background))
  attr(grob, "rwv_capture_device") <- choice$device
  grob
}

# Draw the complete object on a freshly opened device. print() of a
# patchwork object draws the whole assembly, never only its last panel.
rwv_draw <- function(plot, file, open) {
  before <- grDevices::dev.list()
  open(file)
  opened <- setdiff(grDevices::dev.list(), before)
  if (length(opened) != 1L) rwv_fail("Could not open a device for ", basename(file), ".")
  on.exit(if (opened %in% grDevices::dev.list()) grDevices::dev.off(opened), add = TRUE)
  print(plot)
  grDevices::dev.off(opened)
  invisible(file)
}

# Write <stem>.pdf/.svg/.png through path_target() from the same object.
rwv_export_figure <- function(plot, path_target, stem, width_mm, height_mm, style, fonts) {
  family <- style$font$family
  bg <- style$colours$background
  dpi <- style$export$png_dpi
  w <- rwv_mm_to_in(width_mm)
  h <- rwv_mm_to_in(height_mm)
  pdf <- rwv_pdf_device_choose(style, fonts)
  open_pdf <- rwv_pdf_openers()[[pdf$device]]
  svg_probe <- rwv_device_probe(function(f) rwv_svg_open(f, 2, 1, bg), ".svg", family)
  png_probe <- rwv_device_probe(function(f) rwv_png_open(f, 50, 25, dpi, bg), ".png", family)
  tiff_dpi <- style$export$tiff_dpi
  tiff_probe <- rwv_device_probe(function(f) rwv_tiff_open(f, 50, 25, tiff_dpi, bg), ".tiff", family)
  if (!identical(svg_probe, "ok")) rwv_fail("svglite is unusable: ", svg_probe)
  if (!identical(png_probe, "ok")) rwv_fail("ragg::agg_png is unusable: ", png_probe)
  if (!identical(tiff_probe, "ok")) rwv_fail("ragg::agg_tiff is unusable: ", tiff_probe)

  files <- rwv_target_files(path_target, paste0(stem, c(".pdf", ".svg", ".png", ".tiff")))
  rwv_draw(plot, files[1], function(f) open_pdf(f, w, h, family, bg))
  rwv_draw(plot, files[2], function(f) rwv_svg_open(f, w, h, bg))
  rwv_draw(plot, files[3], function(f) rwv_png_open(f, width_mm, height_mm, dpi, bg))
  rwv_draw(plot, files[4], function(f) rwv_tiff_open(f, width_mm, height_mm, tiff_dpi, bg))
  data.frame(
    format = c("pdf", "svg", "png", "tiff"),
    file = basename(files),
    path = files,
    device = c(pdf$device, "svglite", "ragg::agg_png", "ragg::agg_tiff (LZW)"),
    width_mm = width_mm,
    height_mm = height_mm,
    probe = c(paste0(names(pdf$probes), ": ", pdf$probes, collapse = "; "),
              paste0("svglite: ", svg_probe), paste0("agg_png: ", png_probe), paste0("agg_tiff: ", tiff_probe))
  )
}

rwv_text_found <- function(s, words, text) {
  if (grepl(" ", s, fixed = TRUE)) grepl(s, text, fixed = TRUE) else s %in% words
}

# One row per check; the caller decides what to do with failures.
# ruler_mm: length of a grid line drawn in mm that must appear in the SVG.
rwv_verify_exports <- function(exports, style, fonts, expected_text, ruler_mm = NULL, tolerance_mm = 0.05,
                               registered_rasters = NULL) {
  rows <- list()
  add <- function(format, check, expected, observed, pass) {
    rows[[length(rows) + 1L]] <<- data.frame(
      format = format, check = check, expected = paste(expected, collapse = ", "),
      observed = paste(observed, collapse = ", "), pass = isTRUE(pass)
    )
  }
  w <- exports$width_mm[1]
  h <- exports$height_mm[1]
  size_txt <- function(a, b) sprintf("%.2f x %.2f", a, b)
  size_ok <- function(a, b) abs(a - w) <= tolerance_mm && abs(b - h) <= tolerance_mm

  pdf <- exports$path[exports$format == "pdf"]
  pages <- pdftools::pdf_info(pdf)$pages
  add("pdf", "pages", 1, pages, pages == 1)
  ps <- pdftools::pdf_pagesize(pdf)
  pw <- rwv_bigpt_to_mm(ps$width[1])
  ph <- rwv_bigpt_to_mm(ps$height[1])
  add("pdf", "page size (mm)", size_txt(w, h), size_txt(pw, ph), size_ok(pw, ph))
  pf <- pdftools::pdf_fonts(pdf)
  add("pdf", "all fonts embedded", TRUE, all(pf$embedded), all(pf$embedded))
  embedded <- sort(unique(sub("^[A-Z]{6}\\+", "", pf$name)))
  add("pdf", "embedded fonts are resolved fonts (no substitution)", fonts$postscript_name, embedded,
      length(embedded) > 0 && all(embedded %in% fonts$postscript_name))
  words <- pdftools::pdf_data(pdf)[[1]]$text
  text <- gsub("\\s+", " ", paste(pdftools::pdf_text(pdf), collapse = " "))
  for (s in expected_text) {
    found <- rwv_text_found(s, words, text)
    add("pdf", "text present", s, if (found) "found" else "missing", found)
  }

  svg <- exports$path[exports$format == "svg"]
  doc <- xml2::read_xml(svg)
  root <- xml2::xml_root(doc)
  sw <- rwv_bigpt_to_mm(as.numeric(sub("pt$", "", xml2::xml_attr(root, "width"))))
  sh <- rwv_bigpt_to_mm(as.numeric(sub("pt$", "", xml2::xml_attr(root, "height"))))
  add("svg", "page size (mm)", size_txt(w, h), size_txt(sw, sh), size_ok(sw, sh))
  nodes <- xml2::xml_find_all(doc, "//*[local-name()='text']")
  texts <- xml2::xml_text(nodes)
  css <- xml2::xml_attr(nodes, "style")
  families <- unique(sub('^.*font-family: ?"([^"]+)".*$', "\\1", css))
  add("svg", "font families are the resolved fonts", unique(fonts$family), families,
      all(families %in% fonts$family))
  sizes <- as.numeric(sub("^.*font-size: ?([0-9.]+)px.*$", "\\1", css))
  add("svg", "smallest text (pt)", paste(">=", style$text_pt$minimum), min(sizes),
      min(sizes) >= style$text_pt$minimum - 0.005)
  image_nodes <- xml2::xml_find_all(doc, "//*[local-name()='image']")
  images <- length(image_nodes)
  if (is.null(registered_rasters)) {
    add("svg", "no embedded raster images", 0, images, images == 0)
  } else {
    # v40 (Supplementary Figure 3d only): the page may embed exactly the registered renders, and each embedded
    # image must decode to the same pixels (RGB) as one registered file; any other raster still fails.
    same <- vapply(image_nodes, function(node) {
      href <- xml2::xml_attr(node, "href"); if (is.na(href)) href <- xml2::xml_attr(node, "xlink:href")
      img <- png::readPNG(jsonlite::base64_dec(sub("^data:image/png;base64,", "", href)))
      any(vapply(registered_rasters, function(r) identical(dim(img)[1:2], dim(r)[1:2]) &&
                   max(abs(img[, , 1:3] - r[, , 1:3])) <= 1 / 255 + 1e-9, logical(1)))
    }, logical(1))
    add("svg", "embedded raster images are exactly the registered renders (pixel-identical RGB)",
        length(registered_rasters), sprintf("%d (%d matched)", images, sum(same)), images == length(registered_rasters) && all(same))
  }
  all_text <- paste(texts, collapse = " ")
  for (s in expected_text) {
    # Single tokens (panel letters, IDs) must match a whole text node; phrases
    # may span nodes. A bare substring test would let "A" match inside "AMG".
    found <- if (grepl(" ", s, fixed = TRUE)) (s %in% texts || grepl(s, all_text, fixed = TRUE)) else s %in% texts
    add("svg", "text present", s, if (found) "found" else "missing", found)
  }
  strokes <- xml2::xml_attr(xml2::xml_find_all(doc, "//*[local-name()='line' or local-name()='polyline']"), "style")
  widths <- as.numeric(sub("^.*stroke-width: ?([0-9.]+).*$", "\\1", strokes[grepl("stroke-width", strokes)]))
  main_pt <- style$line_mm$main / 25.4 * 72
  add("svg", "main stroke width (pt)", sprintf("%.2f (%.2f mm)", main_pt, style$line_mm$main),
      sprintf("%.2f", sort(unique(widths))), any(abs(widths - main_pt) < 0.01))
  if (!is.null(ruler_mm)) {
    lines <- xml2::xml_find_all(doc, "//*[local-name()='line']")
    num <- function(a) as.numeric(xml2::xml_attr(lines, a))
    len_mm <- rwv_bigpt_to_mm(sqrt((num("x2") - num("x1"))^2 + (num("y2") - num("y1"))^2))
    best <- if (length(len_mm)) len_mm[which.min(abs(len_mm - ruler_mm))] else NA_real_
    add("svg", "ruler length (mm)", ruler_mm, sprintf("%.3f", best), isTRUE(abs(best - ruler_mm) < 0.01))
  }

  png <- exports$path[exports$format == "png"]
  img <- png::readPNG(png, info = TRUE)
  info <- attr(img, "info")
  dpi <- style$export$png_dpi
  px <- dim(img)[c(2, 1)]
  expected_px <- round(c(w, h) / 25.4 * dpi)
  add("png", "pixels (w x h)", paste(expected_px, collapse = " x "), paste(px, collapse = " x "),
      all(abs(px - expected_px) <= 1))
  add("png", "resolution (dpi)", dpi, sprintf("%.2f", info$dpi[1]), all(abs(info$dpi - dpi) < 0.5))
  opaque <- dim(img)[3] == 3L || all(img[, , 4] == 1)
  add("png", "opaque (no transparency)", TRUE, opaque, opaque)
  corners <- c(img[1, 1, 1:3], img[1, px[1], 1:3], img[px[2], 1, 1:3], img[px[2], px[1], 1:3])
  add("png", "white corners", "1", unique(corners), all(corners == 1))

  tif <- exports$path[exports$format == "tiff"]
  ti <- rwv_tiff_info(tif)
  tdpi <- style$export$tiff_dpi
  expected_tpx <- round(c(w, h) / 25.4 * tdpi)
  add("tiff", "pixels (w x h)", paste(expected_tpx, collapse = " x "), paste(ti$width, ti$height, sep = " x "),
      all(abs(c(ti$width, ti$height) - expected_tpx) <= 1))
  add("tiff", "resolution (dpi)", tdpi, sprintf("%.2f x %.2f", ti$xdpi, ti$ydpi), all(abs(c(ti$xdpi, ti$ydpi) - tdpi) < 0.5))
  add("tiff", "LZW compression (code 5)", 5, ti$compression, identical(as.numeric(ti$compression), 5))
  add("tiff", "RGB without alpha (3 samples per pixel)", 3, ti$samples, identical(as.numeric(ti$samples), 3))
  do.call(rbind, rows)
}
