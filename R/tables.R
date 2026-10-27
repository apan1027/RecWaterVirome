# Final supplementary exports from saved tables; no statistical calculations.
# Authors (display order): Jinlong Ru, Cunli Pan.

# Retain the frozen Figure 2 panel geometry while drawing the adopted legend
# directly with native grid. Rebuilding the guides with longer labels would
# otherwise change panel allocation. The obsolete guide is removed, not hidden.
rwv_final_figure2 <- function(plot, style, fonts, spec) {
  force(plot); force(style)
  m <- style$figure_mm$margin
  plot <- plot + patchwork::plot_annotation(theme = ggplot2::theme(
    plot.margin = ggplot2::margin(m, m, m, m, unit = "mm"),
    plot.background = ggplot2::element_rect(fill = style$colours$background, colour = NA)))
  # Build on the active export device, preserving that device's native font
  # metrics. A wrapper plot would introduce new outer margins.
  function() {
  grid::grid.newpage()
  labels <- function(g) {
    own <- if (inherits(g, "text")) as.character(g$label) else character()
    kids <- c(g$grobs, as.list(g$children))
    c(own, unlist(lapply(kids, labels), use.names = FALSE))
  }
  removed <- 0L
  erase <- function(g) {
    text <- labels(g)
    if (inherits(g, "gtable") && "Water position" %in% text && !"Site" %in% text) {
      removed <<- removed + 1L
      return(grid::nullGrob())
    }
    if (length(g$grobs)) g$grobs <- lapply(g$grobs, erase)
    if (length(g$children)) g$children <- do.call(grid::gList, lapply(as.list(g$children), erase))
    g
  }
  base <- erase(patchwork::patchworkGrob(plot))
  if (removed != 1L) rwv_fail("The frozen Figure 2 water guide was not uniquely identified.")
  spec <- style$water_legend
  point <- function(x, y) list(x = grid::unit(x, "bigpts"), y = grid::unit(1, "npc") - grid::unit(y, "bigpts"))
  label <- function(text, x, y) {
    p <- point(x, y)
    g <- grid::textGrob(text, x = p$x, y = p$y, just = c("left", "bottom"),
      gp = grid::gpar(fontfamily = style$font$family, fontsize = spec$font_pt, col = style$colours$text))
    g
  }
  centre <- point(spec$circle_x, spec$circle_y)
  circle <- grid::circleGrob(centre$x, centre$y, r = grid::unit(spec$radius_pt, "bigpts"),
    gp = grid::gpar(fill = "#737373", col = "#737373", lwd = 0.23 / 0.75))
  triangle <- grid::polygonGrob(grid::unit(unlist(spec$triangle_x), "bigpts"),
    grid::unit(1, "npc") - grid::unit(unlist(spec$triangle_y), "bigpts"),
    gp = grid::gpar(fill = "#737373", col = "#737373", lwd = 0.23 / 0.75))
  page <- grid::grobTree(base,
    label("Water type", spec$title_x, spec$text_y), circle, triangle,
    label("c: reclaimed water", spec$c_x, spec$text_y),
    label("d: wastewater", spec$d_x, spec$text_y))
  grid::grid.draw(page)
  invisible(NULL)
  }
}

rwv_literal_tsv <- function(path) {
  utils::read.delim(path, header = TRUE, sep = "\t", quote = '"',
    colClasses = "character", check.names = FALSE, na.strings = character(),
    strip.white = FALSE, comment.char = "", blank.lines.skip = FALSE)
}

rwv_xml_text <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  gsub(">", "&gt;", x, fixed = TRUE)
}

rwv_excel_letters <- function(n) {
  result <- ""
  while (n > 0L) { j <- (n - 1L) %% 26L; result <- paste0(LETTERS[j + 1L], result); n <- (n - 1L) %/% 26L }
  result
}

rwv_sheet_xml <- function(table) {
  rows <- rbind(names(table), as.matrix(table))
  body <- vapply(seq_len(nrow(rows)), function(i) {
    cells <- vapply(seq_len(ncol(rows)), function(j) {
      value <- rows[i, j]; ref <- paste0(rwv_excel_letters(j), i)
      if (is.na(value)) value <- ""
      if (i > 1L && value %in% c("TRUE", "FALSE")) {
        paste0('<c r="', ref, '" t="b"><v>', as.integer(value == "TRUE"), '</v></c>')
      } else if (i > 1L && grepl("^[+-]?(?:[0-9]+(?:[.][0-9]*)?|[.][0-9]+)(?:[eE][+-]?[0-9]+)?$", value, perl = TRUE)) {
        paste0('<c r="', ref, '"><v>', value, '</v></c>')
      } else paste0('<c r="', ref, '" t="inlineStr"><is><t xml:space="preserve">', rwv_xml_text(value), '</t></is></c>')
    }, character(1))
    paste0('<row r="', i, '">', paste(cells, collapse = ""), '</row>')
  }, character(1))
  paste0('<?xml version="1.0" encoding="UTF-8"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">',
    '<dimension ref="A1:', rwv_excel_letters(ncol(rows)), nrow(rows), '"/><sheetViews><sheetView workbookViewId="0">',
    '<pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/></sheetView></sheetViews>',
    '<sheetFormatPr defaultRowHeight="15"/><sheetData>', paste(body, collapse = ""), '</sheetData></worksheet>')
}

rwv_unzip_workbook <- function(path, directory) {
  files <- utils::unzip(path, list = TRUE)$Name
  if (any(grepl("^/|(^|/)\\.\\.(/|$)|\\\\", files))) rwv_fail("Unsafe workbook ZIP path.")
  utils::unzip(path, exdir = directory)
  invisible(files)
}

rwv_xlsx_map <- function(directory) {
  ns <- c(s = "http://schemas.openxmlformats.org/spreadsheetml/2006/main")
  rels <- xml2::read_xml(file.path(directory, "xl/_rels/workbook.xml.rels"))
  ids <- xml2::xml_attr(xml2::xml_children(rels), "Id")
  targets <- setNames(xml2::xml_attr(xml2::xml_children(rels), "Target"), ids)
  workbook <- xml2::read_xml(file.path(directory, "xl/workbook.xml"))
  sheets <- xml2::xml_find_all(workbook, ".//s:sheets/s:sheet", ns)
  rid <- xml2::xml_attr(sheets, "id", ns = c(r = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"))
  # xml2 needs the prefixed attribute name when a namespace is supplied.
  if (anyNA(rid)) rid <- xml2::xml_attr(sheets, "r:id", ns = c(r = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"))
  paths <- unname(targets[rid])
  paths <- ifelse(startsWith(paths, "/"), substring(paths, 2L), paste0("xl/", paths))
  setNames(paths, xml2::xml_attr(sheets, "name"))
}

rwv_excel_cell_value <- function(cell, strings) {
  ns <- c(s = "http://schemas.openxmlformats.org/spreadsheetml/2006/main")
  if (inherits(cell, "xml_missing")) return("")
  type <- xml2::xml_attr(cell, "t")
  if (identical(type, "inlineStr")) return(xml2::xml_text(xml2::xml_find_first(cell, "s:is", ns)))
  value <- xml2::xml_text(xml2::xml_find_first(cell, "s:v", ns))
  if (is.na(value)) value <- ""
  if (identical(type, "s")) value <- strings[as.integer(value) + 1L]
  if (identical(type, "b")) value <- if (value == "1") "TRUE" else "FALSE"
  value
}

rwv_zip_workbook <- function(directory, destination) {
  destination <- file.path(normalizePath(dirname(destination), mustWork = TRUE), basename(destination))
  old <- setwd(directory); on.exit(setwd(old), add = TRUE)
  status <- utils::zip(destination, list.files(".", recursive = TRUE, all.files = TRUE, no.. = TRUE), flags = "-qX")
  if (!identical(as.integer(status), 0L)) rwv_fail("Could not write workbook ", destination)
  invisible(destination)
}

rwv_public_workbook <- function(source, destination, book, input_dir, root = rwv_root()) {
  cfg <- jsonlite::read_json(file.path(root, "analyses/R/supplementary-tables.json"))$books[[as.character(book)]]
  edits <- rwv_literal_tsv(file.path(root, "analyses/R/table-fields.tsv"))
  edits <- edits[edits$book == as.character(book), , drop = FALSE]
  temp <- tempfile("rwv-workbook-"); dir.create(temp); on.exit(unlink(temp, recursive = TRUE), add = TRUE)
  rwv_unzip_workbook(source, temp)
  mapping <- rwv_xlsx_map(temp)
  if (!identical(names(mapping), unname(unlist(cfg$base_sheets)))) rwv_fail("Unexpected base workbook sheet set.")
  ns <- c(s = "http://schemas.openxmlformats.org/spreadsheetml/2006/main")
  ss <- file.path(temp, "xl/sharedStrings.xml")
  strings <- if (file.exists(ss)) xml2::xml_text(xml2::xml_children(xml2::read_xml(ss))) else character()
  for (sheet in unique(edits$sheet)) {
    path <- file.path(temp, mapping[[sheet]]); doc <- xml2::read_xml(path)
    data <- xml2::xml_find_first(doc, "s:sheetData", ns)
    changes <- edits[edits$sheet == sheet, , drop = FALSE]
    for (i in seq_len(nrow(changes))) {
      change <- changes[i, ]; ref <- change$cell; row_id <- sub("^[A-Z]+", "", ref)
      cell <- xml2::xml_find_first(data, paste0('s:row/s:c[@r="', ref, '"]'), ns)
      current <- rwv_excel_cell_value(cell, strings)
      if (!current %in% c(change$before, change$value)) rwv_fail("Unregistered text change: ", sheet, "!", ref)
      if (!sheet %in% c("INDEX", "FIELDS") && !identical(change$after_type, "text")) rwv_fail("Numeric scientific edits are forbidden.")
      if (identical(change$after_type, "blank")) { xml2::xml_remove(cell); next }
      row <- xml2::xml_find_first(data, paste0('s:row[@r="', row_id, '"]'), ns)
      if (inherits(row, "xml_missing")) row <- xml2::xml_add_child(data, xml2::read_xml(paste0('<row xmlns="', ns[[1]], '" r="', row_id, '"/>')))
      replacement <- if (change$after_type == "text") paste0('<c xmlns="', ns[[1]], '" r="', ref, '" t="inlineStr"><is><t xml:space="preserve">', rwv_xml_text(change$value), '</t></is></c>') else {
        value <- if (change$after_type == "b") as.integer(change$value == "TRUE") else change$value
        paste0('<c xmlns="', ns[[1]], '" r="', ref, '"', if (change$after_type == "b") ' t="b"' else '', '><v>', value, '</v></c>')
      }
      if (inherits(cell, "xml_missing")) xml2::xml_add_child(row, xml2::read_xml(replacement)) else xml2::xml_replace(cell, xml2::read_xml(replacement))
    }
    dimension <- xml2::xml_find_first(doc, "s:dimension", ns)
    xml2::xml_set_attr(dimension, "ref", cfg$dimensions[[sheet]])
    xml2::write_xml(doc, path, options = character())
  }
  wb_path <- file.path(temp, "xl/workbook.xml"); wb <- xml2::read_xml(wb_path)
  sh <- xml2::xml_find_first(wb, "s:sheets", ns)
  rel_path <- file.path(temp, "xl/_rels/workbook.xml.rels"); rel <- xml2::read_xml(rel_path)
  type_path <- file.path(temp, "[Content_Types].xml"); types <- xml2::read_xml(type_path)
  sheet_id <- max(as.integer(xml2::xml_attr(xml2::xml_children(sh), "sheetId")))
  rid <- max(as.integer(sub("rId", "", xml2::xml_attr(xml2::xml_children(rel), "Id"))))
  for (spec in cfg$additional) {
    path <- file.path(input_dir, spec$file)
    if (!file.exists(path) || !identical(rwv_sha256(path), spec$sha256)) rwv_fail("Missing or changed final table: ", spec$file)
    table <- rwv_literal_tsv(path)
    if (nrow(table) != spec$rows || ncol(table) != spec$columns) rwv_fail("Final table dimensions changed: ", spec$file)
    sheet_id <- sheet_id + 1L; rid <- rid + 1L
    target <- paste0("worksheets/sheet", sheet_id, ".xml")
    if (file.exists(file.path(temp, "xl", target))) rwv_fail("Worksheet path collision.")
    writeLines(rwv_sheet_xml(table), file.path(temp, "xl", target), useBytes = TRUE)
    xml2::xml_add_child(sh, xml2::read_xml(paste0('<sheet xmlns="', ns[[1]], '" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" name="', spec$sheet, '" sheetId="', sheet_id, '" r:id="rId', rid, '"/>')))
    xml2::xml_add_child(rel, xml2::read_xml(paste0('<Relationship xmlns="http://schemas.openxmlformats.org/package/2006/relationships" Id="rId', rid, '" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="', target, '"/>')))
    xml2::xml_add_child(types, xml2::read_xml(paste0('<Override xmlns="http://schemas.openxmlformats.org/package/2006/content-types" PartName="/xl/', target, '" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>')))
  }
  xml2::write_xml(wb, wb_path, options = character()); xml2::write_xml(rel, rel_path, options = character()); xml2::write_xml(types, type_path, options = character())
  rwv_zip_workbook(temp, destination)
  invisible(unname(unlist(cfg$final_sheets)))
}

rwv_public_register <- function(destination, input_dir, root = rwv_root()) {
  spec <- jsonlite::read_json(file.path(root, "analyses/R/supplementary-tables.json"))$register
  source <- file.path(input_dir, spec$file)
  if (!file.exists(source) || !identical(rwv_sha256(source), spec$sha256)) rwv_fail("Missing or changed construct register.")
  table <- rwv_literal_tsv(source)
  if (nrow(table) != spec$rows || ncol(table) != spec$columns) rwv_fail("Construct register dimensions changed.")
  for (name in names(spec$column_types)) {
    if (identical(spec$column_types[[name]], "n")) {
      value <- table[[name]]; value[value == ""] <- NA_character_
      table[[name]] <- as.numeric(value)
    } else if (identical(spec$column_types[[name]], "b")) {
      value <- table[[name]]; table[[name]] <- ifelse(value == "", NA, value == "TRUE")
    }
  }
  # writexl is used for a new workbook; existing scientific workbooks above
  # keep their original worksheet XML and only append registered tables.
  writexl::write_xlsx(setNames(list(table), spec$sheet), destination, format_headers = FALSE)
  invisible(destination)
}
