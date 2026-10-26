# Self-test of the report mechanism, with a probe that contains no research
# data. Authors (display order): Jinlong Ru, Cunli Pan
#
#   Terminal:  LANG=en_US.UTF-8 Rscript scripts/selftest-report-sync.R
#
# It copies the project's analyses/_quarto.yml and scripts/gfm-from-knit.R
# into a temporary directory and renders a probe QMD that appends one line to
# a counter file per execution and draws a random number. It checks that:
#   1. one render executes R exactly once and writes both reports;
#   2. the HTML and Markdown reports show the same random number;
#   3. a changed input is executed again, not reused (no cache/freeze);
#   4. the kept intermediate Markdown and HTML libraries are cleaned up, and
#      neither the Markdown report nor a .qmd kept as data is a project input;
# and, with in-memory files, that the sync checks reject
#   5. a Markdown report from another execution and
#   6. a bundle whose source file changed after it was built, and
#   7. a field dictionary whose notes contradict the delivered values.
# Writes nothing into the project.

(function() {
  root <- normalizePath(getwd(), winslash = "/")
  while (!file.exists(file.path(root, "RecWaterVirome.Rproj"))) {
    parent <- dirname(root)
    if (identical(parent, root)) stop("Run this inside the RecWaterVirome project.", call. = FALSE)
    root <- parent
  }
  quarto <- Sys.getenv("QUARTO_PATH", unset = "")
  if (!nzchar(quarto)) quarto <- unname(Sys.which("quarto"))
  if (!nzchar(quarto)) stop("Quarto CLI not found; set QUARTO_PATH. No probe was run.", call. = FALSE)
  pkgload::load_all(root, attach = FALSE, quiet = TRUE, helpers = FALSE)
  ns <- asNamespace("RecWaterVirome")
  results <- list()
  ok <- function(name, cond, detail = "") {
    results[[length(results) + 1L]] <<- data.frame(test = name, pass = isTRUE(cond), detail = detail)
  }

  if (!("--checks-only" %in% commandArgs(trailingOnly=TRUE))) {
  tmp <- tempfile("rwv-selftest-")
  dir.create(file.path(tmp, "analyses"), recursive = TRUE)
  dir.create(file.path(tmp, "scripts"))
  file.copy(file.path(root, "analyses", "_quarto.yml"), file.path(tmp, "analyses", "_quarto.yml"))
  file.copy(file.path(root, "scripts", "gfm-from-knit.R"), file.path(tmp, "scripts", "gfm-from-knit.R"))
  writeLines(c("---", "title: probe", "---", "", "```{r}",
               "cat('x\\n', file = 'counter.txt', append = TRUE)",
               "input <- readLines('input.txt')",
               "cat('INPUT=', input, ' DRAW=', format(runif(1), digits = 15), '\\n', sep = '')",
               "```"), file.path(tmp, "analyses", "probe.qmd"))
  wd <- setwd(file.path(tmp, "analyses"))
  on.exit(setwd(wd), add = TRUE)
  # Quarto's own exit status and stderr are reported first: when Quarto cannot
  # run at all (for example a sandbox that blocks it), the test stops here
  # with that message instead of a misleading "counter.txt not found".
  quarto_run <- function(args) {
    err_file <- tempfile("quarto-stderr-")
    out <- suppressWarnings(system2(quarto, args, stdout = TRUE, stderr = err_file))
    err <- if (file.exists(err_file)) readLines(err_file, warn = FALSE) else character(0)
    st <- attr(out, "status"); if (is.null(st)) st <- 0L
    if (!identical(as.integer(st), 0L)) {
      stop("Quarto failed before the probe could be checked: `quarto ", paste(args, collapse = " "), "` exited with status ", st,
           ".\nQuarto stderr (last 20 lines):\n  ", paste(utils::tail(err, 20), collapse = "\n  "),
           "\nThis is an environment problem, not a result of the checks below.", call. = FALSE)
    }
    out
  }
  render <- function() { quarto_run(c("render", "probe.qmd", "--quiet")); 0L }
  draw <- function(f) {
    txt <- paste(readLines(f, warn = FALSE), collapse = "\n")
    regmatches(txt, regexpr("INPUT=[A-Za-z0-9]+ DRAW=[0-9.e-]+", txt))
  }

  writeLines("alpha", "input.txt")
  st <- render()
  n1 <- length(readLines("counter.txt"))
  ok("1. one render executes R once", identical(as.integer(st), 0L) && n1 == 1L, paste("executions:", n1))
  ok("1. both reports written", file.exists("probe.html") && file.exists("probe.md"))
  d_html <- draw("probe.html"); d_md <- draw("probe.md")
  ok("2. HTML and Markdown show the same random draw", length(d_html) == 1L && identical(d_html, d_md),
     paste("html:", d_html, "| md:", d_md))
  ok("4. intermediate Markdown removed and HTML libraries removed",
     !file.exists("probe.html.md") && !file.exists("probe.knit-gfm.md") && !dir.exists("probe_files/libs"))

  writeLines("beta", "input.txt")
  st <- render()
  n2 <- length(readLines("counter.txt"))
  ok("3. changed input is executed again, not reused", identical(as.integer(st), 0L) && n2 == 2L &&
       grepl("INPUT=beta", draw("probe.md")) && grepl("INPUT=beta", draw("probe.html")),
     paste("executions:", n2, "| md:", draw("probe.md")))

  # 4b. Only QMDs are project inputs: the Markdown report must not be indexed
  # as a source of probe.html (a preview server would otherwise re-execute the
  # step when the page is opened).
  insp <- quarto_run(c("inspect", "."))
  insp <- tryCatch(jsonlite::fromJSON(paste(insp, collapse = "\n")), error = function(e) NULL)
  inputs <- basename(unlist(insp$files$input))
  ok("4b. Markdown reports are not Quarto project inputs", !is.null(insp) && "probe.qmd" %in% inputs && !any(grepl("\\.(md|rmarkdown)$", inputs)),
     paste("inputs:", paste(inputs, collapse = ", ")))
  # 4c. A .qmd kept as migrated data under data/ is not a step either.
  dir.create(file.path("data", "00-raw", "dprobe"), recursive = TRUE)
  writeLines(c("---", "title: archived", "---", "archived document"), file.path("data", "00-raw", "dprobe", "archived.qmd"))
  insp2 <- quarto_run(c("inspect", "."))
  insp2 <- tryCatch(jsonlite::fromJSON(paste(insp2, collapse = "\n")), error = function(e) NULL)
  ok("4c. a .qmd stored as data under data/ is not a Quarto project input",
     !is.null(insp2) && !any(grepl("archived\\.qmd$", unlist(insp2$files$input))))

  } else {
    contract_tmp <- tempfile("rwv-report-contract-");dir.create(contract_tmp)
    previous <- setwd(contract_tmp);on.exit(setwd(previous),add=TRUE)
    message("SKIP: Quarto rendering/inspection probes (--checks-only); only temporary report contracts are tested.")
  }

  # 5. A Markdown report from another execution: the record lists a hash that
  # the old Markdown does not show.
  writeLines("output hash 0123456789abcdef", "a.html")
  writeLines("an older execution", "a.md")
  Sys.setFileTime("a.md", Sys.time() - 60)
  rec <- list(run_id = "test", outputs = list(list(file = "x.tsv", sha256 = paste0("0123456789abcdef", strrep("0", 48)))))
  ok("5. report check rejects a Markdown report from another execution",
     length(ns$rwv_report_sync_check("probe", "a.html", "a.md", rec)) >= 1L)
  writeLines("output hash 0123456789abcdef", "a.md")
  Sys.setFileTime("a.md", file.mtime("a.html"))
  ok("5. report check accepts matching reports", !length(ns$rwv_report_sync_check("probe", "a.html", "a.md", rec)))

  # 6. A bundle whose source changed after it was built.
  dir.create(file.path("data", "010-x"), recursive = TRUE)
  src <- file.path("data", "010-x", "t.tsv")
  writeLines("v\t1", src)
  man <- data.frame(source_step = "010-x", source_file = "t.tsv", source_sha256 = ns$rwv_sha256(src))
  ok("6. bundle check accepts a current bundle", !length(ns$rwv_bundle_sync_check(man, "data")))
  writeLines("v\t2", src)
  ok("6. bundle check rejects a bundle built before its source changed", length(ns$rwv_bundle_sync_check(man, "data")) == 1L)

  # 7. Field dictionary semantics: a note that contradicts the values.
  tabs <- list(T1 = data.frame(g = c("a", "b", NA), f = c(0.2, 1.5, 0.1)))
  dict <- data.frame(sheet = "T1", field = c("g", "f"), n_missing = c(1L, 0L), curated = TRUE,
                     unit_or_code = c("codes: a, b, c", "fraction (0-1)"), missing_rule = c("never empty", "never empty"))
  ok("7. dictionary check rejects wrong missing rule, range and code set",
     length(ns$rwv_field_dictionary_check(dict, tabs)) == 3L,
     paste(ns$rwv_field_dictionary_check(dict, tabs), collapse = " | "))
  dict$unit_or_code <- c("codes: a, b", "ratio"); dict$missing_rule <- c("empty where unresolved", "never empty")
  ok("7. dictionary check accepts a consistent dictionary", !length(ns$rwv_field_dictionary_check(dict, tabs)))

  res <- do.call(rbind, results)
  message("Quarto: ", quarto, " (", paste(system2(quarto, "--version", stdout=TRUE), collapse = " "), "); R: ", R.version.string)
  print(res, row.names = FALSE, right = FALSE)
  if (!all(res$pass)) stop("Self-test failed.", call. = FALSE)
  message("All ", nrow(res), " self-test checks passed (Quarto ", system2(quarto, "--version", stdout = TRUE), ").")
  invisible(res)
})()
