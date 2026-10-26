# Concise report presentation; calculations and full diagnostics are retained.
# Authors (display order): Jinlong Ru, Cunli Pan.

rwv_report_escape <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  gsub('"', "&quot;", x, fixed = TRUE)
}

rwv_report_setup <- function(step) {
  state <- new.env(parent = emptyenv())
  state$events <- list()
  state$outputs <- NULL
  step$report <- state
  base <- getOption("rwv.report.base_hooks")
  if (is.null(base)) {
    base <- knitr::knit_hooks$get(c("warning", "message"))
    options(rwv.report.base_hooks = base)
  }
  record <- function(kind) function(x, options) {
    text <- paste(x, collapse = "\n")
    # evaluate/knitr may combine repeated warnings into one hook invocation.
    parts <- text
    if (kind == "warning") {
      lines <- strsplit(text, "\n", fixed = TRUE)[[1]]
      starts <- grep("^(?:#+[ \t]*)?Warning(?: in |:)", lines, perl = TRUE)
      if (length(starts)) {
        ends <- c(starts[-1L] - 1L, length(lines))
        starts[1L] <- 1L
        parts <- vapply(seq_along(starts), function(i) paste(lines[seq.int(starts[i], ends[i])], collapse = "\n"), "")
      }
    }
    for (part in parts[nzchar(trimws(parts))]) state$events[[length(state$events) + 1L]] <- list(kind = kind,
      label = if (is.null(options$label)) "unlabelled" else options$label, text = part)
    ""
  }
  knitr::knit_hooks$set(warning = record("warning"), message = record("message"))
  # Conditions are collected, not suppressed: unique warning text and counts
  # appear in the summary; every full event is available in its diagnostics.
  knitr::opts_chunk$set(echo = FALSE, warning = TRUE, message = TRUE)
  invisible(NULL)
}

rwv_report_complete <- function(step, outputs) {
  step$report$outputs <- outputs
  invisible(NULL)
}

rwv_report_check_counts <- function(step) {
  counts <- c(passed = 0L, failed = 0L, unclassified = 0L)
  if (is.null(step$report$outputs)) return(counts)
  files <- grep("checks[.]tsv$", step$report$outputs$file, value = TRUE)
  for (file in files) {
    p <- step$path_target(file)
    if (!file.exists(p)) next
    tab <- utils::read.delim(p, stringsAsFactors = FALSE, check.names = FALSE)
    if (!"pass" %in% names(tab)) next
    value <- tolower(as.character(tab$pass))
    counts <- counts + c(sum(value == "true", na.rm = TRUE), sum(value == "false", na.rm = TRUE),
                         sum(is.na(value) | !value %in% c("true", "false")))
  }
  counts
}

rwv_report_summary <- function(step) {
  state <- step$report
  complete <- isTRUE(step$published) && !is.null(state$outputs)
  checks <- rwv_report_check_counts(step)
  heading <- if (complete) "Step completed" else "Step not completed"
  if (checks[["failed"]] > 0L || checks[["unclassified"]] > 0L) heading <- "Verification needs attention"
  txt <- c('<section class="rwv-report-summary" aria-label="Run summary">',
    paste0('<h2>Run summary</h2><p><strong>', heading, '</strong>'),
    if (complete) paste0(' · ', nrow(state$outputs), ' output files.') else '.', '</p>')
  if (sum(checks)) txt <- c(txt, paste0('<p>Saved assertions: ', checks[["passed"]], ' passed, ',
    checks[["failed"]], ' failed, ', checks[["unclassified"]], ' unclassified.</p>'))
  if (complete) {
    files <- state$outputs$file
    primary <- grep('[.](xlsx|pdf|png)$|^table1[.]tsv$|^supplementary-note.*[.]md$', files, value = TRUE)
    if (!length(primary)) primary <- utils::head(files[!grepl('checks|session-info|export[.]json', files)], 3L)
    primary <- utils::head(primary, 8L)
    links <- vapply(primary, function(file) paste0('<a href="data/', rwv_report_escape(step$name), '/',
      rwv_report_escape(file), '">', rwv_report_escape(file), '</a>'), "")
    if (length(links)) txt <- c(txt, paste0('<p>Key files: ', paste(links, collapse = ' · '), '</p>'))
  }
  events <- state$events
  warnings <- Filter(function(e) identical(e$kind, "warning"), events)
  if (length(warnings)) {
    keys <- vapply(warnings, function(e) trimws(gsub("[[:space:]]+", " ",
      gsub("(?m)^## ?", "", e$text, perl = TRUE))), "")
    distinct <- unique(keys)
    txt <- c(txt, paste0('<p><strong>Warnings: ', length(distinct), ' distinct; ', length(warnings),
      ' occurrences. Review the messages below.</strong></p><ul class="rwv-warning-summary">'))
    for (key in distinct) txt <- c(txt, paste0('<li>', rwv_report_escape(key), ' <strong>(', sum(keys == key), ' times)</strong></li>'))
    txt <- c(txt, '</ul>')
  } else txt <- c(txt, '<p>No runtime warnings were captured after report initialization.</p>')
  if (length(events)) {
    txt <- c(txt, '<details class="rwv-runtime-log"><summary>Full runtime diagnostics (messages and warnings)</summary><pre>')
    for (event in events) txt <- c(txt, rwv_report_escape(paste0('[', event$kind, '; ', event$label, ']\n', event$text)))
    txt <- c(txt, '</pre></details>')
  }
  paste(c('<!-- RWV_REPORT_SUMMARY_START -->', txt, '</section>',
          '<!-- RWV_REPORT_SUMMARY_END -->'), collapse = "\n")
}

# Quarto's post-render hook moves the finished summary to the report front.
# This avoids a document hook captured before setup, and includes conditions
# from late chunks such as published image previews and output-file listings.
rwv_report_relocate <- function(text) {
  position <- "<!-- RWV_REPORT_SUMMARY_POSITION -->"
  start <- "<!-- RWV_REPORT_SUMMARY_START -->"
  end <- "<!-- RWV_REPORT_SUMMARY_END -->"
  a <- regexpr(start, text, fixed = TRUE)[1]
  b <- regexpr(end, text, fixed = TRUE)[1]
  target <- regexpr(position, text, fixed = TRUE)[1]
  if (a < 1L && b < 1L && target < 1L) return(text)
  if (a > 0L && b > a && target < 1L) return(text) # already relocated
  if (any(c(a, b, target) < 1L) || b <= a) stop("Incomplete report-summary markers.", call. = FALSE)
  block <- substr(text, a, b + nchar(end) - 1L)
  remaining <- paste0(substr(text, 1L, a - 1L), substr(text, b + nchar(end), nchar(text)))
  target <- regexpr(position, remaining, fixed = TRUE)[1]
  paste0(substr(remaining, 1L, target - 1L), block,
         substr(remaining, target + nchar(position), nchar(remaining)))
}

rwv_report_files <- function(step, outputs) {
  links <- vapply(seq_len(nrow(outputs)), function(i) paste0('<li><a href="data/', rwv_report_escape(step$name), '/',
    rwv_report_escape(outputs$file[i]), '">', rwv_report_escape(outputs$file[i]), '</a> (',
    format(round(outputs$bytes[i] / 1024, 1), trim = TRUE), ' KB)</li>'), "")
  knitr::asis_output(paste(c('<ul>', links, '</ul>'), collapse = "\n"))
}
