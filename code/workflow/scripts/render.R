# RecWaterVirome launcher: render the explicit workflow (config/workflow.yml)
# in its listed order, one fresh Quarto/R process per step.
# Authors (display order): Jinlong Ru, Cunli Pan
#
# From the project root:
#   RStudio Console:  source("scripts/render.R")
#   Terminal:         Rscript scripts/render.R
# Optional checks (014 legacy comparison, 090 style proof) are skipped unless
# asked for:  Rscript scripts/render.R --with-checks
#             (RStudio: rwv_with_checks <- TRUE; source("scripts/render.R"))
#
# Each QMD is rendered by its own `quarto render --execute --no-cache`
# process, so every step starts from a clean R session; freeze is off in
# analyses/_quarto.yml. R runs once per step, for the HTML report; the
# Markdown report is derived from that execution by scripts/gfm-from-knit.R.
# After each render the step record, the output hashes and both reports are
# checked before the next step starts; at the end the review bundle is
# checked against its sources. Single steps: scripts/render-step.R.
# The launcher never installs packages or downloads anything. Set
# QUARTO_PATH if `quarto` is not on PATH.

(function() {
  fail <- function(...) stop(paste0(...), call. = FALSE)

  # Project root: nearest directory upward whose DESCRIPTION declares the package.
  root <- normalizePath(getwd(), winslash = "/")
  repeat {
    desc_file <- file.path(root, "DESCRIPTION")
    if (file.exists(desc_file) &&
      identical(unname(read.dcf(desc_file, fields = "Package")[1, 1]), "RecWaterVirome")) {
      break
    }
    parent <- dirname(root)
    if (identical(parent, root)) {
      fail("Run this from the RecWaterVirome project root: no DESCRIPTION with ",
           "'Package: RecWaterVirome' was found above ", getwd(), ".")
    }
    root <- parent
  }

  # The frozen design copies have non-ASCII (Chinese) file names; a non-UTF-8
  # locale (e.g. LANG unset, C locale in a bare terminal) cannot resolve them.
  if (!isTRUE(l10n_info()[["UTF-8"]])) {
    fail("R is not running in a UTF-8 locale (", Sys.getlocale("LC_CTYPE"), "). ",
         "Start R with a UTF-8 locale, e.g. `LANG=en_US.UTF-8 Rscript scripts/render.R`.")
  }

  # Required R packages are the DESCRIPTION Imports; check without installing.
  imports <- read.dcf(file.path(root, "DESCRIPTION"), fields = "Imports")[1, 1]
  pkgs <- trimws(sub("\\(.*$", "", strsplit(imports, ",")[[1]]))
  pkgs <- pkgs[nzchar(pkgs)]
  missing <- pkgs[!nzchar(vapply(pkgs, function(p) system.file(package = p), character(1)))]
  if (length(missing)) {
    fail("Missing R packages: ", paste(missing, collapse = ", "), ".\n",
         "Install them yourself (this launcher never installs anything), then run it again.")
  }

  # Quarto CLI.
  quarto <- Sys.getenv("QUARTO_PATH", unset = "")
  if (!nzchar(quarto)) quarto <- unname(Sys.which("quarto"))
  if (!nzchar(quarto) && nzchar(system.file(package = "quarto"))) {
    quarto <- tryCatch(quarto::quarto_path(), error = function(e) "")
  }
  if (is.null(quarto) || !nzchar(quarto) || !file.exists(quarto)) {
    fail("Quarto CLI not found. Install Quarto or set QUARTO_PATH; this launcher never installs anything.")
  }
  quarto_version <- tryCatch(system2(quarto, "--version", stdout = TRUE), error = function(e) character())
  if (!length(quarto_version)) fail("Could not run '", quarto, " --version'.")

  # Shared helpers from R/ (manifest validation, step-record checks),
  # loaded without attaching the package to the search path.
  pkgload::load_all(root, attach = FALSE, quiet = TRUE, helpers = FALSE)
  ns <- asNamespace("RecWaterVirome")
  steps <- ns$rwv_workflow_read(root)$steps
  with_checks <- "--with-checks" %in% commandArgs(trailingOnly = TRUE) || isTRUE(get0("rwv_with_checks", envir = globalenv()))
  skipped <- vapply(steps, function(s) s$id, character(1))[vapply(steps, function(s) isTRUE(s[["optional"]]), logical(1))]
  if (!with_checks) steps <- Filter(function(s) !isTRUE(s[["optional"]]), steps)

  run_id <- paste0(format(Sys.time(), "%Y%m%dT%H%M%S"), "-", Sys.getpid())
  old_run <- Sys.getenv("RWV_RUN_ID", unset = NA)
  Sys.setenv(RWV_RUN_ID = run_id)
  old_wd <- setwd(root)
  on.exit({
    setwd(old_wd)
    if (is.na(old_run)) Sys.unsetenv("RWV_RUN_ID") else Sys.setenv(RWV_RUN_ID = old_run)
  }, add = TRUE)

  message("RecWaterVirome launcher | run ", run_id, " | Quarto ", quarto_version[1], " | ", R.version.string)
  if (!with_checks && length(skipped)) message("Optional checks not run (use --with-checks): ", paste(skipped, collapse = ", "))
  results <- vector("list", length(steps))
  for (i in seq_along(steps)) {
    s <- steps[[i]]
    message(sprintf("\n==> [%d/%d] %s: quarto render %s --execute --no-cache", i, length(steps), s$id, s$qmd))
    since <- Sys.time()
    status <- system2(quarto, c("render", shQuote(s$qmd), "--execute", "--no-cache"))
    if (!identical(as.integer(status), 0L)) {
      fail("Step ", s$id, " failed (quarto exit status ", status, "); later steps were not run. ",
           "See the messages above.")
    }
    results[[i]] <- ns$rwv_step_verify(root, s$id, run_id, since)
    # The Markdown report is derived from the same execution by the
    # post-render hook (scripts/gfm-from-knit.R); both must show this run's
    # output hashes.
    sync <- ns$rwv_report_sync(root, s$id)
    if (length(sync)) fail(paste(sync, collapse = "\n"))
    message("    verified: ", nrow(results[[i]]), " outputs in analyses/data/", s$id, "/ and report ",
            sub("\\.qmd$", ".html", s$qmd))
  }
  summary <- do.call(rbind, results)
  bundle <- ns$rwv_bundle_sync(root)
  if (length(bundle)) fail(paste(bundle, collapse = "\n"))
  message("\nAll ", length(steps), " steps rendered and verified (run ", run_id, ").")
  print(summary[, c("step", "file", "bytes")], row.names = FALSE)
  invisible(summary)
})()
