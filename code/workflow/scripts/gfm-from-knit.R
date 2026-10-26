# Quarto post-render hook (analyses/_quarto.yml: project: post-render).
# Authors (display order): Jinlong Ru, Cunli Pan
#
# Each QMD is executed once, for its HTML report. With `keep-md: true` Quarto
# keeps the knitted Markdown of that single execution (<step>.html.md). This
# hook converts that file to GitHub-flavoured Markdown (<step>.md) with a
# Markdown-only render, which runs no R code, so the HTML report, the
# Markdown report and the step outputs all come from the same execution.
# It runs for `quarto render`, the RStudio Render button (quarto preview) and
# scripts/render.R alike. Nothing is installed or downloaded.

outs <- strsplit(Sys.getenv("QUARTO_PROJECT_OUTPUT_FILES"), "\n", fixed = TRUE)[[1]]
outs <- outs[nzchar(outs)]
# The conversion is itself a render inside the project and fires this hook
# again; that nested call has nothing to convert.
if (nzchar(Sys.getenv("RWV_GFM_CONVERTING"))) quit(save = "no")
Sys.setenv(RWV_GFM_CONVERTING = "1")

# Honor the same explicit launcher as scripts/render.R and rwv_quarto_version().
# Otherwise a configured native launcher is lost during the Markdown-only hook.
quarto <- Sys.getenv("QUARTO_PATH", unset = "")
if (!nzchar(quarto) || !file.exists(quarto)) quarto <- file.path(Sys.getenv("QUARTO_BIN_PATH"), "quarto")
if (!file.exists(quarto)) quarto <- unname(Sys.which("quarto"))
if (!nzchar(quarto)) stop("gfm-from-knit.R: quarto not found", call. = FALSE)

failed <- character(0)
for (html in outs[grepl("\\.html$", outs)]) {
  kept <- sub("\\.html$", ".html.md", html)
  if (!file.exists(kept)) {
    failed <- c(failed, paste0(html, " (no kept Markdown ", basename(kept), "; is keep-md on?)"))
    next
  }
  md <- sub("\\.html$", ".md", html)
  # Move the completed, late-evaluated run summary to the front in both
  # reports. This only changes presentation and executes no analysis code.
  report_text <- lapply(c(html, kept), function(file) paste(readLines(file, warn = FALSE, encoding = "UTF-8"), collapse = "\n"))
  if (any(vapply(report_text, function(text) grepl("<!-- RWV_REPORT_SUMMARY_", text, fixed = TRUE), logical(1)))) {
    presentation <- new.env(parent = baseenv())
    sys.source(file.path(dirname(normalizePath(html)), "..", "R", "report.R"), presentation)
    for (i in seq_along(report_text)) {
      updated <- presentation$rwv_report_relocate(report_text[[i]])
      if (!identical(report_text[[i]], updated)) writeLines(updated, c(html, kept)[i], useBytes = TRUE)
    }
  }
  # A distinct input name, because rendering <step>.html.md directly would
  # name its output after the double extension.
  tmp <- sub("\\.html$", ".knit-gfm.md", html)
  file.copy(kept, tmp, overwrite = TRUE)
  status <- system2(quarto, c("render", shQuote(tmp), "--to", "gfm", "--output", shQuote(basename(md)), "--quiet"))
  file.remove(tmp, kept)
  if (!identical(as.integer(status), 0L) || !file.exists(md)) failed <- c(failed, paste0(html, " (gfm conversion exit ", status, ")"))
  # Give the Markdown report the time stamp of the HTML report, so that no
  # tool can take the report for a source newer than the HTML it came from.
  if (file.exists(md)) Sys.setFileTime(md, file.mtime(html))
  # keep-md also leaves the HTML dependencies in <step>_files/libs; the HTML
  # is self-contained and the Markdown does not use them. Figures that the
  # Markdown references (<step>_files/figure-html) are kept.
  files_dir <- sub("\\.html$", "_files", html)
  libs <- file.path(files_dir, "libs")
  if (dir.exists(libs) && identical(dirname(normalizePath(libs)), normalizePath(files_dir))) unlink(libs, recursive = TRUE)
  if (dir.exists(files_dir) && !length(list.files(files_dir, all.files = TRUE, no.. = TRUE))) unlink(files_dir, recursive = TRUE)
}
if (length(failed)) stop("gfm-from-knit.R: Markdown report not written for ", paste(failed, collapse = "; "), call. = FALSE)
