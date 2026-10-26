# Check that every step's HTML and Markdown reports and the review bundle
# belong to the current step outputs. Exits with an error listing the stale
# items. Authors (display order): Jinlong Ru, Cunli Pan
#
#   RStudio Console:  source("scripts/check-sync.R")
#                     (strict: rwv_with_checks <- TRUE; source("scripts/check-sync.R"))
#   Terminal:         Rscript scripts/check-sync.R
#                     Rscript scripts/check-sync.R --with-checks   (strict)
#
# A step is out of date when its recorded inputs changed after it ran; a
# report is out of sync when the step was re-executed after it was written
# (for example a Markdown report left from an earlier run); the bundle is out
# of sync when any step it copies was re-rendered after 900 ran.
#
# The daily check covers the daily steps and the bundle. The optional checks
# (014, 090) are skipped by the daily scripts/render.R, so here they are only
# reported as notes when never run or out of date. With --with-checks (the
# same switch as scripts/render.R) they must be current as well.

(function() {
  root <- normalizePath(getwd(), winslash = "/")
  while (!file.exists(file.path(root, "RecWaterVirome.Rproj"))) {
    parent <- dirname(root)
    if (identical(parent, root)) stop("Run this inside the RecWaterVirome project.", call. = FALSE)
    root <- parent
  }
  strict <- "--with-checks" %in% commandArgs(trailingOnly = TRUE) || isTRUE(get0("rwv_with_checks", envir = globalenv()))
  pkgload::load_all(root, attach = FALSE, quiet = TRUE, helpers = FALSE)
  ns <- asNamespace("RecWaterVirome")
  res <- ns$rwv_sync_status(root, strict = strict)
  for (n in res$notes) message("Note: ", n)
  # v50 release engineering: steps whose recorded 010 manifest differs from the current one only in
  # review/publication metadata are re-verified and reused, not re-executed (R/workflow.R rwv_manifest_reuse).
  ru <- ns$rwv_manifest_reuse_status(root)
  if (nrow(ru) && any(ru$reusable)) message("Reused after content verification (010 manifest changed only in review/publication metadata; ",
                                           "not re-executed): ", paste(ru$step[ru$reusable], collapse = ", "))
  message("Step records come from ", length(res$runs), " run(s): ", paste(res$runs, collapse = ", "))
  if (length(res$problems)) {
    opt_bad <- any(sub(":.*$", "", res$problems) %in% res$optional)
    stop("Out of sync", if (strict) " (strict mode, optional checks included)", ":\n  ", paste(res$problems, collapse = "\n  "),
         "\nRe-render the listed steps (scripts/render-step.R <step>) or everything (scripts/render.R",
         if (opt_bad) " --with-checks" else "", ").", call. = FALSE)
  }
  message("In sync", if (strict) " (strict mode)", ": ", length(res$checked), " steps have HTML and Markdown reports from their current ",
          "execution, no unfinished run, and the bundle matches its sources.",
          if (!strict && length(res$optional)) paste0(" Optional checks (", paste(res$optional, collapse = ", "),
                                                      ") are not required in the daily check; use --with-checks to require them."))
  invisible(TRUE)
})()
