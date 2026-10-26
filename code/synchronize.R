# Authors (code-document order): Jinlong Ru, Cunli Pan.
# Default: verify workflow + reproduce publication edits in temporary storage.
# RStudio from workflow: source("../synchronize.R")
# Explicit full established rerender, then publication check:
# Rscript ../synchronize.R --render
(function() {
  candidates <- c(getwd(), file.path(getwd(), ".."), file.path(getwd(), "07_Code"))
  found <- candidates[file.exists(file.path(candidates, "sync_publication.py"))]
  if (!length(found)) stop("Run from 07_Code or 07_Code/workflow.", call. = FALSE)
  code <- normalizePath(found[1], winslash = "/")
  bundled <- file.path(path.expand("~"), ".cache", "codex-runtimes", "codex-primary-runtime", "dependencies", "python", "bin", "python3")
  python <- Sys.getenv("RWV_PYTHON", unset = if (file.exists(bundled)) bundled else unname(Sys.which("python3")))
  if (!nzchar(python) || !file.exists(python)) stop("Provide an existing Python with lxml and Pillow using RWV_PYTHON.", call. = FALSE)
  render <- "--render" %in% commandArgs(trailingOnly = TRUE) || isTRUE(get0("rwv_render", envir = globalenv()))
  args <- c(shQuote(file.path(code, "sync_publication.py")), "--check", if (render) "--render")
  message(if (render) "Explicit rerender + publication verification." else "Synchronization/publication verification only; no scientific execution.")
  status <- system2(python, args)
  if (!identical(as.integer(status), 0L)) stop("Publication synchronization failed; inspect the error above.", call. = FALSE)
  invisible(TRUE)
})()
