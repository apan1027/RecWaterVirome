# Render one or more steps, optionally with everything downstream of them.
# Authors (display order): Jinlong Ru, Cunli Pan
#
#   Terminal:  Rscript scripts/render-step.R 140-fig4-vf-context
#              Rscript scripts/render-step.R 140-fig4-vf-context --downstream
#   RStudio:   rwv_steps <- c("140-fig4-vf-context"); rwv_downstream <- TRUE
#              source("scripts/render-step.R")
#
# Each step is executed once (HTML report; its Markdown report is derived by
# scripts/gfm-from-knit.R without executing R again) and checked. With
# --downstream every step that depends on the listed ones, up to the review
# bundle 900, is re-rendered in workflow order. At the end the whole project
# is checked with scripts/check-sync.R, so a bundle that was not refreshed is
# reported as an error. For the delivered version use scripts/render.R, which
# renders all steps in one launcher run.

(function() {
  fail <- function(...) stop(paste0(...), call. = FALSE)
  args <- commandArgs(trailingOnly = TRUE)
  if (exists("rwv_steps", envir = globalenv())) {
    args <- c(get("rwv_steps", envir = globalenv()),
              if (isTRUE(get0("rwv_downstream", envir = globalenv()))) "--downstream")
  }
  downstream <- "--downstream" %in% args
  wanted <- setdiff(args, "--downstream")
  if (!length(wanted)) fail("Name at least one step, e.g. Rscript scripts/render-step.R 140-fig4-vf-context")
  if (!isTRUE(l10n_info()[["UTF-8"]])) fail("Start R in a UTF-8 locale, e.g. LANG=en_US.UTF-8 Rscript scripts/render-step.R ...")

  root <- normalizePath(getwd(), winslash = "/")
  while (!file.exists(file.path(root, "RecWaterVirome.Rproj"))) {
    parent <- dirname(root)
    if (identical(parent, root)) fail("Run this inside the RecWaterVirome project.")
    root <- parent
  }
  quarto <- Sys.getenv("QUARTO_PATH", unset = "")
  if (!nzchar(quarto)) quarto <- unname(Sys.which("quarto"))
  if (!nzchar(quarto)) fail("Quarto CLI not found; set QUARTO_PATH.")
  pkgload::load_all(root, attach = FALSE, quiet = TRUE, helpers = FALSE)
  ns <- asNamespace("RecWaterVirome")
  steps <- ns$rwv_workflow_read(root)$steps
  ids <- vapply(steps, function(s) s$id, character(1))
  unknown <- setdiff(wanted, ids)
  if (length(unknown)) fail("Unknown step(s): ", paste(unknown, collapse = ", "), ". Steps are listed in config/workflow.yml.")

  todo <- wanted
  if (downstream) {
    repeat {
      # Optional checks (014, 090) are only rendered when named explicitly.
      more <- ids[vapply(steps, function(s) !isTRUE(s[["optional"]]) && any(ns$rwv_chr(s$depends_on) %in% todo), logical(1))]
      if (all(more %in% todo)) break
      todo <- union(todo, more)
    }
  }
  todo <- ids[ids %in% todo]
  old_wd <- setwd(root)
  on.exit(setwd(old_wd), add = TRUE)
  Sys.unsetenv("RWV_RUN_ID")
  for (id in todo) {
    s <- steps[[match(id, ids)]]
    message("\n==> ", id, ": quarto render ", s$qmd)
    status <- system2(quarto, c("render", shQuote(s$qmd), "--execute", "--no-cache"))
    if (!identical(as.integer(status), 0L)) fail("Step ", id, " failed (quarto exit status ", status, ").")
    bad <- ns$rwv_report_sync(root, id)
    if (length(bad)) fail(paste(bad, collapse = "\n"))
    message("    HTML and Markdown reports match the step outputs.")
  }
  message("\nRendered: ", paste(todo, collapse = ", "))
  source(file.path(root, "scripts", "check-sync.R"), local = new.env())
})()
