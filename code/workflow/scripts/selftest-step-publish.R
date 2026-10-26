# Self-test of staged step outputs (W1), in a temporary directory only.
# Authors (display order): Jinlong Ru, Cunli Pan
#
#   Terminal:  LANG=en_US.UTF-8 Rscript scripts/selftest-step-publish.R
#
# A toy step directory is published once (v1), then these failures are made
# and the kept result is compared file by file with v1:
#   1. the step fails before finishing (for example a missing input);
#   2. the R process is killed while the step runs;
#   3. publication is interrupted after some new files were moved in;
#   4. publication is interrupted while the previous result is moved aside;
#   5. the record was committed but the clean-up did not run.
# Downstream reads must refuse a step whose latest run did not finish, and a
# later successful run must publish normally. Nothing in the project changes.

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

  final <- file.path(tempfile("rwv-publish-"), "data", "toy-step")
  dir.create(final, recursive = TRUE)
  snapshot <- function(dir) {
    f <- list.files(dir, recursive = TRUE, all.files = TRUE, no.. = TRUE)
    f <- sort(f[!startsWith(f, ".rwv-")])
    stats::setNames(vapply(file.path(dir, f), function(p) digest::digest(file = p, algo = "sha256"), ""), f)
  }
  write_version <- function(staging, v) {
    writeLines(paste("table", v), file.path(staging, "a.tsv"))
    writeLines(paste("figure", v), file.path(staging, "b.png"))
    dir.create(file.path(staging, "bundle"))
    writeLines(paste("bundled", v), file.path(staging, "bundle", "c.txt"))
  }
  record_for <- function(run_id) list(step = "toy-step", status = "complete", run_id = run_id)
  downstream <- function() tryCatch({ ns$rwv_step_record_read(file.path(final, "step-record.json"), "toy-step"); "accepted" },
                                    error = function(e) conditionMessage(e))
  controls_left <- function() any(file.exists(file.path(final, c(".rwv-staging", ".rwv-previous", ".rwv-publish.json"))))

  # v1: a normal run.
  st <- ns$rwv_stage_open(final, "run-v1", "test")
  write_version(st, "v1")
  ns$rwv_stage_publish(final, st, "run-v1", record_for("run-v1"))
  v1 <- snapshot(final)
  ok("0. first run publishes files, output folder and record", setequal(names(v1), c("a.tsv", "b.png", "bundle/c.txt", "step-record.json")) &&
       ns$rwv_stage_status_read(final)$status == "complete" && !controls_left() && downstream() == "accepted")

  # 1. Failure before finishing: new outputs stay in staging, v1 untouched.
  st <- ns$rwv_stage_open(final, "run-fail", "test")
  writeLines("half-written", file.path(st, "a.tsv"))
  ok("1. failed run keeps the previous result unchanged", identical(snapshot(final), v1))
  ok("1. downstream refuses the step after a failed run", grepl("did not finish", downstream()), downstream())

  # 2. The R process is killed while the step runs.
  script <- tempfile(fileext = ".R")
  writeLines(c(sprintf("pkgload::load_all('%s', attach = FALSE, quiet = TRUE, helpers = FALSE)", root),
               "ns <- asNamespace('RecWaterVirome')",
               sprintf("st <- ns$rwv_stage_open('%s', 'run-killed', 'test')", final),
               "writeLines('partial', file.path(st, 'a.tsv'))",
               sprintf("writeLines('started', '%s')", paste0(script, ".started")),
               "Sys.sleep(60)"), script)
  pid <- sys::exec_background(file.path(R.home("bin"), "Rscript"), script, std_out = FALSE, std_err = FALSE)
  for (i in 1:60) { if (file.exists(paste0(script, ".started"))) break; Sys.sleep(0.5) }
  tools::pskill(pid, tools::SIGKILL); Sys.sleep(0.5)
  st_killed <- ns$rwv_stage_status_read(final)
  ok("2. killed run keeps the previous result unchanged", identical(snapshot(final), v1) && identical(st_killed$run_id, "run-killed"),
     paste("status after kill:", st_killed$status, st_killed$run_id))
  ok("2. downstream refuses the step after a killed run", grepl("did not finish", downstream()))

  # 3. Publication interrupted after one new file was moved in.
  st <- ns$rwv_stage_open(final, "run-v2a", "test")
  write_version(st, "v2")
  op <- options(rwv.test_stop_publish_after = 1)
  e3 <- tryCatch(ns$rwv_stage_publish(final, st, "run-v2a", record_for("run-v2a")), error = function(e) conditionMessage(e))
  options(op)
  ok("3. interrupted publication is refused downstream", grepl("interrupted", downstream()), downstream())
  ok("3. recovery restores the previous result exactly", ns$rwv_stage_recover(final) == "restored" && identical(snapshot(final), v1) &&
       ns$rwv_stage_status_read(final)$status == "failed" && !controls_left())

  # 4. Publication interrupted while the previous result was moved aside.
  st <- ns$rwv_stage_open(final, "run-v2b", "test")
  write_version(st, "v2")
  op <- options(rwv.test_stop_aside_after = 2)
  tryCatch(ns$rwv_stage_publish(final, st, "run-v2b", record_for("run-v2b")), error = function(e) NULL)
  options(op)
  ok("4. recovery after a partial move-aside restores the previous result exactly",
     ns$rwv_stage_recover(final) == "restored" && identical(snapshot(final), v1) && !controls_left())

  # 5. Record committed, clean-up not run: recovery completes the new result.
  st <- ns$rwv_stage_open(final, "run-v2c", "test")
  write_version(st, "v2")
  ns$rwv_stage_publish(final, st, "run-v2c", record_for("run-v2c"))
  v2 <- snapshot(final)
  dir.create(file.path(final, ".rwv-previous"))
  jsonlite::write_json(list(run_id = "run-v2c", phase = "publishing", new_entries = list(), old_entries = list()),
                       file.path(final, ".rwv-publish.json"), auto_unbox = TRUE)
  ok("5. recovery after the commit keeps the new result and clears the control files",
     ns$rwv_stage_recover(final) == "completed" && identical(snapshot(final), v2) && !identical(v2, v1) && !controls_left() &&
       downstream() == "accepted")

  # 6. A later normal run after all failures.
  st <- ns$rwv_stage_open(final, "run-v3", "test")
  write_version(st, "v3")
  ns$rwv_stage_publish(final, st, "run-v3", record_for("run-v3"))
  ok("6. a later run publishes normally and is accepted downstream",
     grepl("v3", readLines(file.path(final, "a.tsv"))) && downstream() == "accepted" && !controls_left())

  res <- do.call(rbind, results)
  print(res, row.names = FALSE, right = FALSE)
  if (!all(res$pass)) stop("Self-test failed.", call. = FALSE)
  message("All ", nrow(res), " staged-publication checks passed.")
  invisible(res)
})()
