# Self-test of the daily / strict sync check (scripts/check-sync.R).
# Authors (display order): Jinlong Ru, Cunli Pan
#
#   Terminal:  LANG=en_US.UTF-8 Rscript scripts/selftest-check-sync.R
#
# Stale states are injected through the step_problems argument of
# rwv_sync_status(); real outputs are only read, never changed. The "never
# run" case uses a temporary project that holds a copy of config/workflow.yml
# and empty step records.
#   - an out-of-date optional check is a note in the daily mode and a
#     problem in the strict mode (it is named in both);
#   - an out-of-date daily step is a problem in both modes;
#   - an optional check that was never run is a note in the daily mode and a
#     problem in the strict mode.

(function() {
  root <- normalizePath(getwd(), winslash = "/")
  while (!file.exists(file.path(root, "RecWaterVirome.Rproj"))) {
    parent <- dirname(root)
    if (identical(parent, root)) stop("Run this inside the RecWaterVirome project.", call. = FALSE)
    root <- parent
  }
  pkgload::load_all(root, attach = FALSE, quiet = TRUE, helpers = FALSE)
  ns <- asNamespace("RecWaterVirome")
  results <- list()
  ok <- function(name, cond, detail = "") results[[length(results) + 1L]] <<- data.frame(test = name, pass = isTRUE(cond), detail = detail)
  stale <- function(ids) function(root, id) if (id %in% ids) paste0(id, ": inputs changed since it ran (config/style.yml); render it again") else character(0)
  names_of <- function(p) unique(sub(":.*$", "", p))

  fixture_root <- tempfile("rwv-sync-seeded-")
  dir.create(file.path(fixture_root, "config"), recursive=TRUE)
  file.copy(file.path(root,"config/workflow.yml"),file.path(fixture_root,"config/workflow.yml"))
  manifest <- yaml::read_yaml(file.path(fixture_root,"config/workflow.yml"))
  for (step in manifest$steps) {
    q <- file.path(fixture_root,step$qmd);dir.create(dirname(q),recursive=TRUE,showWarnings=FALSE);file.create(q)
    for (rel in step$project_inputs) { f <- file.path(fixture_root,rel);dir.create(dirname(f),recursive=TRUE,showWarnings=FALSE);file.create(f) }
    d <- file.path(fixture_root,"analyses/data",step$id);dir.create(d,recursive=TRUE,showWarnings=FALSE)
    writeLines('{"run_id":"seeded-test"}',file.path(d,"step-record.json"))
  }
  writeLines("source_step\tsource_file\tsource_sha256",file.path(fixture_root,"analyses/data/900-publication-bundle/bundle-manifest.tsv"))
  on.exit(unlink(fixture_root,recursive=TRUE),add=TRUE)
  d <- ns$rwv_sync_status(fixture_root, FALSE, stale("090-style-proof"))
  s <- ns$rwv_sync_status(fixture_root, TRUE, stale("090-style-proof"))
  ok("1. stale optional 090: daily mode has no problem for it", !"090-style-proof" %in% names_of(d$problems))
  ok("1. stale optional 090: daily mode names it in a note", any(grepl("090-style-proof: inputs changed", d$notes)))
  ok("1. stale optional 090: not counted as checked in daily mode", !"090-style-proof" %in% d$checked)
  ok("1. stale optional 090: strict mode reports it as a problem", "090-style-proof" %in% names_of(s$problems))

  d <- ns$rwv_sync_status(fixture_root, FALSE, stale("120-fig2-community-links"))
  s <- ns$rwv_sync_status(fixture_root, TRUE, stale("120-fig2-community-links"))
  ok("2. stale daily step 120: problem in daily mode", "120-fig2-community-links" %in% names_of(d$problems))
  ok("2. stale daily step 120: problem in strict mode", "120-fig2-community-links" %in% names_of(s$problems))

  tmp <- tempfile("rwv-sync-")
  dir.create(file.path(tmp, "config"), recursive = TRUE)
  file.copy(file.path(root, "config", "workflow.yml"), file.path(tmp, "config", "workflow.yml"))
  dir.create(file.path(tmp, "analyses"))
  file.create(file.path(tmp, "analyses", basename(Sys.glob(file.path(root, "analyses", "*.qmd")))))
  pin <- unique(unlist(lapply(yaml::read_yaml(file.path(tmp, "config", "workflow.yml"))$steps, function(x) x$project_inputs)))
  for (f in file.path(tmp, pin)) { dir.create(dirname(f), recursive = TRUE, showWarnings = FALSE); file.create(f) }
  wf <- ns$rwv_workflow_read(tmp)
  ids <- vapply(wf$steps, function(x) x$id, character(1))
  opt <- ids[vapply(wf$steps, function(x) isTRUE(x[["optional"]]), logical(1))]
  for (id in setdiff(ids, opt)) {
    dir.create(file.path(tmp, "analyses", "data", id), recursive = TRUE)
    writeLines('{"run_id": "selftest"}', file.path(tmp, "analyses", "data", id, "step-record.json"))
  }
  writeLines("source_step\tsource_file\tsource_sha256", file.path(tmp, "analyses", "data", "900-publication-bundle", "bundle-manifest.tsv"))
  d <- ns$rwv_sync_status(tmp, FALSE, stale(character(0)))
  s <- ns$rwv_sync_status(tmp, TRUE, stale(character(0)))
  ok("3. never-run optional checks: no problem in daily mode", !length(d$problems), paste(d$problems, collapse = "; "))
  ok("3. never-run optional checks: named in a daily note", all(vapply(opt, function(o) any(grepl(o, d$notes)), logical(1))))
  ok("3. never-run optional checks: problems in strict mode", setequal(names_of(s$problems), opt), paste(s$problems, collapse = "; "))
  unlink(tmp, recursive = TRUE)

  if (file.exists(file.path(root, "analyses/data/900-publication-bundle/step-record.json"))) {
    d <- ns$rwv_sync_status(root, FALSE)
    ok("4. the real project is in sync in the daily mode", !length(d$problems), paste(d$problems, collapse = "; "))
  } else message("SKIP: optional production-sync check; the source package contains no generated workflow records.")

  res <- do.call(rbind, results)
  print(res[, c("test", "pass")], row.names = FALSE, right = FALSE)
  if (!all(res$pass)) stop("Self-test failed.", call. = FALSE)
  message("All ", nrow(res), " sync-check tests passed.")
  invisible(res)
})()
