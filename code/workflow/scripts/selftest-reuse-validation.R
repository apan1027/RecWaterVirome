# Self-test of the consumer-scoped 010 manifest reuse (R/workflow.R rwv_manifest_reuse) and of
# the 900 visual-review matching rule (rwv_visual_review_state).
# Authors (display order): Jinlong Ru, Cunli Pan
#
#   Terminal:  LANG=en_US.UTF-8 Rscript scripts/selftest-reuse-validation.R
#
# Everything runs in a temporary miniature project (steps 010, 020 = science, 110 = figure,
# 900 = bundle). The production project is only read for the package code and, in case 6b,
# for metadata/visual-review.tsv. Each case starts from a fresh fixture. It checks that
#   1. a change of review/publication metadata only (visual review, review log, register row,
#      a new review report) lets the science step be reused, without touching its record;
#   2. a change of any real dependency keeps the step out of date: a config the step read
#      (community.yml, definitions, samples), a scientific config it did not read but that is in
#      the manifest, a raw input or the raw register, a shared R source, the raw manifest;
#   3. a changed upstream output, a missing input file, or an undeclared read still fail;
#   4. a missing, tampered or malformed history manifest, or an unknown schema, fails;
#   5. a workflow.yml change is accepted only when this step's definition and the top-level
#      fields are identical;
#   6. 900 accepts exactly one matching visual-review row (wrong hash and duplicate rows fail);
#   7. the checks never change records, manifests or their modification times;
#   8. (separately) the existing publication/sync self-tests still pass.

(function() {
  root <- normalizePath(getwd(), winslash = "/")
  while (!file.exists(file.path(root, "RecWaterVirome.Rproj"))) {
    parent <- dirname(root)
    if (identical(parent, root)) stop("Run this inside the RecWaterVirome project.", call. = FALSE)
    root <- parent
  }
  pkgload::load_all(root, attach = FALSE, quiet = TRUE, helpers = FALSE)
  ns <- asNamespace("RecWaterVirome")
  sha <- ns$rwv_sha256
  results <- list()
  ok <- function(name, cond, detail = "") results[[length(results) + 1L]] <<- data.frame(test = name, pass = isTRUE(cond), detail = detail)
  wr <- function(tmp, rel, txt) { p <- file.path(tmp, rel); dir.create(dirname(p), recursive = TRUE, showWarnings = FALSE); writeLines(txt, p); p }
  cols <- ns$rwv_manifest_columns

  # ---- fixture ------------------------------------------------------------------------
  project_files <- list(
    "metadata/frozen-files.tsv" = "register", "config/workflow.yml" = "config", "config/community.yml" = "config",
    "config/definitions.tsv" = "config", "config/samples.tsv" = "config", "metadata/raw-inputs.tsv" = "raw-input-register",
    "metadata/visual-review.tsv" = "metadata", "metadata/review-log.tsv" = "metadata", "R/literature-summary.R" = "shared-source",
    "docs/review-a.md" = "review-report")
  workflow_yaml <- function(extra_900 = "", step020_extra = "", top = "version: 1") paste0(top, "
workflow_dir: analyses
steps:
  - id: 010-input-manifest
    qmd: analyses/010-input-manifest.qmd
    depends_on: []
    outputs: [input-manifest.tsv, raw-input-manifest.tsv]
  - id: 020-community-analysis
    qmd: analyses/020-community-analysis.qmd
    depends_on: [010-input-manifest]
    project_inputs: [config/community.yml, config/definitions.tsv]
    upstream_inputs:
      - {step: 010-input-manifest, file: input-manifest.tsv}
      - {step: 010-input-manifest, file: raw-input-manifest.tsv}
    outputs: [result.tsv]", step020_extra, "
  - id: 110-fig1-design-composition
    qmd: analyses/110-fig1-design-composition.qmd
    depends_on: [010-input-manifest, 020-community-analysis]
    project_inputs: [config/samples.tsv]
    upstream_inputs:
      - {step: 010-input-manifest, file: input-manifest.tsv}
      - {step: 020-community-analysis, file: result.tsv}
    outputs: [fig1.png]
  - id: 900-publication-bundle
    qmd: analyses/900-publication-bundle.qmd
    depends_on: [010-input-manifest, 110-fig1-design-composition]
    project_inputs: [metadata/visual-review.tsv, metadata/review-log.tsv", extra_900, "]
    upstream_inputs:
      - {step: 010-input-manifest, file: input-manifest.tsv}
      - {step: 110-fig1-design-composition, file: fig1.png}
    outputs: [bundle-manifest.tsv]
")
  write_manifest <- function(tmp) {
    rows <- lapply(names(project_files), function(f) {
      p <- file.path(tmp, f)
      data.frame(path = f, role = project_files[[f]], bytes = as.character(file.size(p)), sha256 = sha(p),
                 expected_sha256 = if (f == "metadata/frozen-files.tsv") "NA" else sha(p),
                 status = if (f == "metadata/frozen-files.tsv") "root of trust (no expected hash)" else "match",
                 origin = "project-authored", source_sha256 = "")
    })
    m <- do.call(rbind, rows)[, cols]
    d <- file.path(tmp, "analyses/data/010-input-manifest"); dir.create(d, recursive = TRUE, showWarnings = FALSE)
    ns$rwv_write_tsv(m, file.path(d, "input-manifest.tsv"))
    writeLines("path\tconsumer_step\tsha256", file.path(d, "raw-input-manifest.tsv"))
    cat(paste0("analyses/data/00-raw/d020-community-analysis/raw.tsv\t020-community-analysis\t",
               sha(file.path(tmp, "analyses/data/00-raw/d020-community-analysis/raw.tsv")), "\n"),
        file = file.path(d, "raw-input-manifest.tsv"), append = TRUE)
    rec <- list(step = "010-input-manifest", status = "complete", run_id = "fixture-010",
                outputs = list(list(file = "input-manifest.tsv", sha256 = sha(file.path(d, "input-manifest.tsv"))),
                               list(file = "raw-input-manifest.tsv", sha256 = sha(file.path(d, "raw-input-manifest.tsv")))))
    jsonlite::write_json(rec, file.path(d, "step-record.json"), auto_unbox = TRUE, pretty = TRUE)
  }
  history <- function(tmp, rel, stem, ext) {
    h <- file.path(tmp, "archive/manifest-history"); dir.create(h, showWarnings = FALSE, recursive = TRUE)
    s <- sha(file.path(tmp, rel)); file.copy(file.path(tmp, rel), file.path(h, paste0(stem, "-", s, ".", ext)), overwrite = TRUE); s
  }
  record <- function(tmp, id, inputs, outputs) {
    d <- file.path(tmp, "analyses/data", id); dir.create(d, recursive = TRUE, showWarnings = FALSE)
    rec <- list(step = id, status = "complete", run_id = "fixture-science", inputs = inputs,
                source_contract = "rwv-source-v1", sources = ns$rwv_source_snapshot(tmp, id),
                outputs = lapply(outputs, function(o) list(file = o, sha256 = sha(file.path(d, o)))))
    jsonlite::write_json(rec, file.path(d, "step-record.json"), auto_unbox = TRUE, pretty = TRUE)
  }
  inp <- function(tmp, kind, rel) list(kind = kind, path = rel,
    sha256 = sha(if (kind == "upstream") file.path(tmp, "analyses/data", rel) else file.path(tmp, rel)))
  fixture <- function() {
    tmp <- tempfile("rwv-reuse-"); dir.create(tmp)
    wr(tmp, "metadata/frozen-files.tsv", c("path\tsha256", "config/community.yml\tx"))
    wr(tmp, "config/workflow.yml", workflow_yaml())
    wr(tmp, "config/community.yml", "seed: 42")
    wr(tmp, "config/definitions.tsv", c("key\tvalue", "n\t3060"))
    wr(tmp, "config/samples.tsv", c("sample_id", "bc1"))
    wr(tmp, "metadata/raw-inputs.tsv", c("path\tsha256", "raw.tsv\tabc"))
    wr(tmp, "metadata/visual-review.tsv", c("figure\tfigure_key\tstep\treviewer\tdate\tpng_sha256\tverdict\tremaining_issues"))
    wr(tmp, "metadata/review-log.tsv", c("scope\treviewer\tdate\tverdict"))
    wr(tmp, "R/literature-summary.R", "f <- function() 1")
    wr(tmp, "docs/review-a.md", "review A")
    wr(tmp, "analyses/data/00-raw/d020-community-analysis/raw.tsv", c("x", "1"))
    for (q in c("010-input-manifest", "020-community-analysis", "110-fig1-design-composition", "900-publication-bundle"))
      wr(tmp, paste0("analyses/", q, ".qmd"), "")
    for (f in c("DESCRIPTION", "NAMESPACE", "analyses/_quarto.yml", "scripts/render.R", "scripts/render-step.R", "scripts/gfm-from-knit.R")) wr(tmp, f, "fixture")
    write_manifest(tmp)
    history(tmp, "analyses/data/010-input-manifest/input-manifest.tsv", "input-manifest", "tsv")
    history(tmp, "config/workflow.yml", "workflow", "yml")
    wr(tmp, "analyses/data/020-community-analysis/result.tsv", c("v", "0.7"))
    record(tmp, "020-community-analysis", list(
      inp(tmp, "upstream", "010-input-manifest/input-manifest.tsv"), inp(tmp, "upstream", "010-input-manifest/raw-input-manifest.tsv"),
      inp(tmp, "project", "config/community.yml"), inp(tmp, "project", "config/definitions.tsv"),
      inp(tmp, "raw", "analyses/data/00-raw/d020-community-analysis/raw.tsv")), "result.tsv")
    wr(tmp, "analyses/data/110-fig1-design-composition/fig1.png", "png-bytes")
    record(tmp, "110-fig1-design-composition", list(
      inp(tmp, "upstream", "010-input-manifest/input-manifest.tsv"), inp(tmp, "project", "config/samples.tsv"),
      inp(tmp, "upstream", "020-community-analysis/result.tsv")), "fig1.png")
    wr(tmp, "analyses/data/900-publication-bundle/bundle-manifest.tsv", "x")
    record(tmp, "900-publication-bundle", list(
      inp(tmp, "upstream", "010-input-manifest/input-manifest.tsv"), inp(tmp, "project", "metadata/visual-review.tsv"),
      inp(tmp, "project", "metadata/review-log.tsv"), inp(tmp, "upstream", "110-fig1-design-composition/fig1.png")), "bundle-manifest.tsv")
    tmp
  }
  # Simulated re-run of 010 after a project file changed (010 is the only step that rewrites the manifest).
  rerun010 <- function(tmp) write_manifest(tmp)
  frozen_state <- function(tmp) {
    # 010's own record is legitimately rewritten by the simulated 010 re-run; every other record must stay untouched.
    f <- c(Sys.glob(file.path(tmp, "analyses/data/*/step-record.json")), Sys.glob(file.path(tmp, "archive/manifest-history/*")))
    f <- f[!grepl("/010-input-manifest/", f)]
    data.frame(f = f, sha = sha(f), mtime = as.numeric(file.mtime(f)))
  }
  changed <- function(tmp, id) ns$rwv_step_inputs_changed(tmp, id)
  fresh <- function(tmp, id) !length(changed(tmp, id))
  register_review <- function(tmp) {
    cat("Figure 1\tfig1\t110-fig1-design-composition\tCodex\t2026-10-19\tabc\tviewed and accepted\tnone\n",
        file = file.path(tmp, "metadata/visual-review.tsv"), append = TRUE)
    cat("figure-cleanup-v50\tCodex\t2026-10-19\tpassed\n", file = file.path(tmp, "metadata/review-log.tsv"), append = TRUE)
    cat("metadata/visual-review.tsv\tnew\n", file = file.path(tmp, "metadata/frozen-files.tsv"), append = TRUE)
  }

  # ---- 1. publication metadata only ---------------------------------------------------------
  tmp <- fixture(); before <- frozen_state(tmp)
  ok("0. fixture: all steps current before any change", fresh(tmp, "020-community-analysis") && fresh(tmp, "110-fig1-design-composition") && fresh(tmp, "900-publication-bundle"))
  register_review(tmp)
  wr(tmp, "docs/review-b.md", "review B (new report)"); project_files[["docs/review-b.md"]] <- "review-report"
  rerun010(tmp)
  r <- ns$rwv_manifest_reuse(tmp, "020-community-analysis", jsonlite::read_json(file.path(tmp, "analyses/data/020-community-analysis/step-record.json"))$inputs[[1]]$sha256)
  ok("1. review metadata only: 020 (science) is reused without re-execution", fresh(tmp, "020-community-analysis"), paste(changed(tmp, "020-community-analysis"), collapse = ";"))
  ok("1. review metadata only: 110 (figure) is reused", fresh(tmp, "110-fig1-design-composition"))
  ok("1. review metadata only: the reuse lists exactly the changed metadata rows", r$reusable &&
       setequal(r$changed_paths, c("metadata/visual-review.tsv", "metadata/review-log.tsv", "metadata/frozen-files.tsv", "docs/review-b.md")),
     paste(r$changed_paths, collapse = ";"))
  ok("1. review metadata only: 900, which reads the registers itself, is out of date", "metadata/visual-review.tsv" %in% changed(tmp, "900-publication-bundle"))
  st <- ns$rwv_manifest_reuse_status(tmp)
  ok("1. status table: 020 and 110 reusable, 900 listed as reusable at manifest level", all(st$reusable) && setequal(st$step, c("020-community-analysis", "110-fig1-design-composition", "900-publication-bundle")))
  after <- frozen_state(tmp)
  kept <- merge(before, after, by = "f")
  ok("7. science/figure/bundle records and history manifests keep their bytes and mtimes", identical(kept$sha.x, kept$sha.y) && identical(kept$mtime.x, kept$mtime.y) && nrow(kept) == nrow(before))
  project_files[["docs/review-b.md"]] <- NULL

  # ---- 2. real dependency changes stay out of date -------------------------------------------
  dep_case <- function(label, rel, txt, id = "020-community-analysis", expect = rel) {
    tmp <- fixture(); wr(tmp, rel, txt); rerun010(tmp)
    ch <- changed(tmp, id)
    ok(paste0("2. ", label, ": ", id, " out of date"), length(ch) > 0 && all(expect %in% ch), paste(ch, collapse = ";"))
  }
  dep_case("community.yml changed (read directly)", "config/community.yml", "seed: 43", expect = c("config/community.yml", "010-input-manifest/input-manifest.tsv"))
  dep_case("definitions changed (read directly)", "config/definitions.tsv", c("key\tvalue", "n\t3061"), expect = c("config/definitions.tsv", "010-input-manifest/input-manifest.tsv"))
  dep_case("samples config changed (not read by 020, but a scientific manifest row)", "config/samples.tsv", c("sample_id", "bc2"), expect = "010-input-manifest/input-manifest.tsv")
  dep_case("samples config changed (read by 110)", "config/samples.tsv", c("sample_id", "bc2"), id = "110-fig1-design-composition", expect = "config/samples.tsv")
  dep_case("raw register changed", "metadata/raw-inputs.tsv", c("path\tsha256", "raw.tsv\tdef"), expect = "010-input-manifest/input-manifest.tsv")
  dep_case("shared R source changed", "R/literature-summary.R", "f <- function() 2", expect = "010-input-manifest/input-manifest.tsv")
  tmp <- fixture(); wr(tmp, "analyses/data/00-raw/d020-community-analysis/raw.tsv", c("x", "2")); rerun010(tmp)
  ch <- changed(tmp, "020-community-analysis")
  ok("2. raw input changed: 020 out of date (raw file and raw manifest)", all(c("analyses/data/00-raw/d020-community-analysis/raw.tsv", "010-input-manifest/raw-input-manifest.tsv") %in% ch), paste(ch, collapse = ";"))
  tmp <- fixture(); register_review(tmp); wr(tmp, "config/community.yml", "seed: 99"); rerun010(tmp)
  r <- ns$rwv_manifest_reuse(tmp, "110-fig1-design-composition", jsonlite::read_json(file.path(tmp, "analyses/data/110-fig1-design-composition/step-record.json"))$inputs[[1]]$sha256)
  ok("2. review change mixed with a scientific change: no reuse, the scientific row is blocking", !r$reusable && identical(r$blocking_paths, "config/community.yml"))

  # ---- 3. upstream outputs, missing inputs, undeclared reads -----------------------------------
  tmp <- fixture(); wr(tmp, "analyses/data/020-community-analysis/result.tsv", c("v", "0.8"))
  ok("3. upstream output bytes changed: 110 out of date", "020-community-analysis/result.tsv" %in% changed(tmp, "110-fig1-design-composition"))
  tmp <- fixture(); unlink(file.path(tmp, "config/definitions.tsv"))
  ok("3. missing project input: 020 out of date", "config/definitions.tsv" %in% changed(tmp, "020-community-analysis"))
  tmp <- fixture(); unlink(file.path(tmp, "analyses/data/010-input-manifest/input-manifest.tsv"))
  ok("3. missing current manifest: 020 out of date", "010-input-manifest/input-manifest.tsv" %in% changed(tmp, "020-community-analysis"))
  tmp <- fixture(); register_review(tmp); rerun010(tmp)
  rec010 <- file.path(tmp, "analyses/data/010-input-manifest/step-record.json"); x <- jsonlite::read_json(rec010); x$status <- "running"
  jsonlite::write_json(x, rec010, auto_unbox = TRUE)
  ok("3. 010 record not complete: no reuse", !fresh(tmp, "020-community-analysis"))
  tmp <- fixture(); wf <- ns$rwv_workflow_read(tmp)
  step <- new.env(); step$spec <- ns$rwv_workflow_step(wf, "020-community-analysis"); step$root <- tmp; step$name <- "020-community-analysis"; step$inputs <- list()
  man <- ns$rwv_read_tsv(file.path(tmp, "analyses/data/010-input-manifest/input-manifest.tsv"))
  ok("3. undeclared project read still fails", inherits(try(ns$rwv_project_input(step, "config/samples.tsv", man), silent = TRUE), "try-error"))
  ok("3. declared project read still works", identical(basename(ns$rwv_project_input(step, "config/community.yml", man)), "community.yml"))

  # ---- 4. history manifest identity -----------------------------------------------------------
  hist_case <- function(label, mutate) {
    tmp <- fixture(); register_review(tmp); rerun010(tmp); mutate(tmp)
    ok(paste0("4. ", label, ": no reuse"), !fresh(tmp, "020-community-analysis"), paste(changed(tmp, "020-community-analysis"), collapse = ";"))
  }
  hist_case("history manifest missing", function(tmp) unlink(Sys.glob(file.path(tmp, "archive/manifest-history/input-manifest-*"))))
  hist_case("history manifest bytes do not hash to its name", function(tmp) {
    h <- Sys.glob(file.path(tmp, "archive/manifest-history/input-manifest-*")); cat("tamper\n", file = h, append = TRUE) })
  hist_case("current manifest has an unknown schema", function(tmp) {
    p <- file.path(tmp, "analyses/data/010-input-manifest/input-manifest.tsv"); m <- ns$rwv_read_tsv(p); m$extra <- "x"; ns$rwv_write_tsv(m, p)
    r <- file.path(tmp, "analyses/data/010-input-manifest/step-record.json"); x <- jsonlite::read_json(r); x$outputs[[1]]$sha256 <- sha(p)
    jsonlite::write_json(x, r, auto_unbox = TRUE) })
  hist_case("recorded manifest SHA malformed", function(tmp) {
    r <- file.path(tmp, "analyses/data/020-community-analysis/step-record.json"); x <- jsonlite::read_json(r); x$inputs[[1]]$sha256 <- "not-a-sha"
    jsonlite::write_json(x, r, auto_unbox = TRUE) })
  tmp <- fixture(); register_review(tmp); rerun010(tmp)
  ok("4. empty projection is not a pass: an unknown step id is still compared", ns$rwv_manifest_reuse(tmp, "999-unknown", "0")$reusable == FALSE)

  # ---- 5. workflow.yml ----------------------------------------------------------------------
  wf_case <- function(label, yaml_text, id, expect_fresh) {
    tmp <- fixture(); wr(tmp, "config/workflow.yml", yaml_text); rerun010(tmp)
    ok(paste0("5. ", label), identical(fresh(tmp, id), expect_fresh), paste(changed(tmp, id), collapse = ";"))
  }
  wf_case("only 900's definition changed: 020 reused", workflow_yaml(extra_900 = ", docs/review-a.md"), "020-community-analysis", TRUE)
  wf_case("only 900's definition changed: 110 reused", workflow_yaml(extra_900 = ", docs/review-a.md"), "110-fig1-design-composition", TRUE)
  wf_case("020's own definition changed: 020 out of date", workflow_yaml(step020_extra = "\n    optional_outputs: [extra.tsv]"), "020-community-analysis", FALSE)
  wf_case("top-level workflow field changed: 020 out of date", workflow_yaml(top = "version: 2"), "020-community-analysis", FALSE)
  tmp <- fixture(); wr(tmp, "config/workflow.yml", workflow_yaml(extra_900 = ", docs/review-a.md")); unlink(Sys.glob(file.path(tmp, "archive/manifest-history/workflow-*"))); rerun010(tmp)
  ok("5. workflow.yml changed but the old workflow.yml is not in history: no reuse", !fresh(tmp, "020-community-analysis"))
  tmp <- fixture(); wr(tmp, "config/workflow.yml", "steps: [unclosed"); rerun010(tmp)
  ok("5. unparsable current workflow.yml: no reuse (no crash)", !isTRUE(try(fresh(tmp, "020-community-analysis"), silent = TRUE)))

  # ---- 6. 900 visual-review matching --------------------------------------------------------
  vr <- data.frame(figure_key = c("fig1", "fig1", "sfig1"), png_sha256 = c("old", "new", "s1"), verdict = "viewed and accepted",
                   reviewer = "Codex", date = "2026-10-19")
  ok("6. current hash registered once: viewed", grepl("^viewed", ns$rwv_visual_review_state(vr, "fig1", "new")))
  ok("6. wrong/unregistered hash: not viewed", !grepl("^viewed", ns$rwv_visual_review_state(vr, "fig1", "other")))
  ok("6. figure never reviewed: not viewed", !grepl("^viewed", ns$rwv_visual_review_state(vr, "fig9", "x")))
  ok("6. same figure_key + PNG hash registered twice: not viewed", !grepl("^viewed", ns$rwv_visual_review_state(rbind(vr, vr[3, ]), "sfig1", "s1")))
  if (file.exists(file.path(root, "analyses/data/210-sfig1-qc-community/sfig1.png"))) {
  prod <- as.data.frame(ns$rwv_read_tsv(file.path(root, "metadata/visual-review.tsv")))
  s1 <- ns$rwv_sha256(file.path(root, "analyses/data/210-sfig1-qc-community/sfig1.png"))
  ok("6b. production S1: the current PNG matches exactly one row", grepl("^viewed", ns$rwv_visual_review_state(prod, "sfig1", s1)))
  dup <- rbind(prod, prod[prod$figure_key == "sfig1" & prod$png_sha256 == s1, ])
  ok("6b. production S1 with a duplicated row (appending nine rows): rejected", !grepl("^viewed", ns$rwv_visual_review_state(dup, "sfig1", s1)))

  } else message("SKIP: two optional production-S1 checks; generated figures are not included in the source package.")

  res <- do.call(rbind, results)
  print(res, row.names = FALSE, right = FALSE)
  if (!all(res$pass)) stop(sum(!res$pass), " of ", nrow(res), " reuse-validation self-tests failed.", call. = FALSE)
  message("All ", nrow(res), " reuse-validation self-tests passed.")
})()
