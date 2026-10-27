# Authors (display order): Jinlong Ru, Cunli Pan.
# Run the declared R/Quarto analyses; never install packages or fetch data.
(function() {
  root <- normalizePath(getwd(), winslash = "/")
  while (!file.exists(file.path(root, "RecWaterVirome.Rproj"))) {
    parent <- dirname(root); if (parent == root) stop("Run inside RecWaterVirome.", call. = FALSE); root <- parent
  }
  pkgload::load_all(root, attach = FALSE, quiet = TRUE, helpers = FALSE)
  ns <- asNamespace("RecWaterVirome")
  steps <- ns$rwv_workflow_read(root)$steps
  inputs <- ns$rwv_read_tsv(file.path(root, "analyses/data/inputs.tsv"))
  missing <- inputs$path[!file.exists(file.path(root, inputs$path))]
  if (length(missing)) stop("Required inputs are supplied separately from code. Missing ", length(missing), " file(s):\n",
    paste(head(missing, 12L), collapse = "\n"), "\nSee analyses/data/inputs.tsv and README.md.", call. = FALSE)
  quarto <- Sys.getenv("QUARTO_PATH", unset = unname(Sys.which("quarto")))
  if (!nzchar(quarto)) stop("Quarto is required; nothing is installed automatically.")
  args <- commandArgs(trailingOnly = TRUE)
  wanted <- setdiff(args, "--downstream")
  ids <- vapply(steps, function(x) x$id, "")
  if (length(wanted)) {
    if (length(setdiff(wanted, ids))) stop("Unknown step; see analyses/README.md.")
    if ("--downstream" %in% args) repeat {
      more <- ids[vapply(steps, function(x) any(ns$rwv_chr(x$depends_on) %in% wanted), logical(1))]
      if (all(more %in% wanted)) break
      wanted <- union(wanted, more)
    }
    steps <- Filter(function(x) x$id %in% wanted, steps)
  }
  run <- paste0(format(Sys.time(), "%Y%m%dT%H%M%S"), "-", Sys.getpid())
  old <- setwd(root); on.exit(setwd(old), add = TRUE)
  # Single-step execution may read independently verified upstream records.
  if (!length(wanted)) Sys.setenv(RWV_RUN_ID = run) else Sys.unsetenv("RWV_RUN_ID")
  on.exit(Sys.unsetenv("RWV_RUN_ID"), add = TRUE)
  for (step in steps) {
    message("Rendering ", step$id)
    since <- Sys.time()
    status <- system2(quarto, c("render", shQuote(step$qmd), "--execute", "--no-cache"))
    if (as.integer(status) != 0L) stop("Step failed: ", step$id)
    bad <- ns$rwv_step_sync_problems(root, step$id)
    if (length(bad)) stop(paste(bad, collapse = "\n"))
  }
  message("Completed ", length(steps), " declared step(s).")
})()
