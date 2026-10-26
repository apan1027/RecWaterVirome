# Self-test of the community checks (W2, W3, W4), with in-memory values only.
# Authors (display order): Jinlong Ru, Cunli Pan
#
#   Terminal:  LANG=en_US.UTF-8 Rscript scripts/selftest-community-checks.R
#
# W2: config/community.yml passes; each unsupported method value is refused.
# W3: a missing or non-finite permutation p value gives "undetermined" with a
#     reason, never "not_flagged"; valid p values keep their usual status.
# W4: a legacy name missing from the rebuilt set, or an empty common set, is a
#     difference; rebuilt-only names are additions.

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

  cfg <- yaml::read_yaml(file.path(root, "config", "community.yml"))
  ok("W2. the project configuration is accepted", !length(ns$rwv_community_config_check(cfg)))
  bad_values <- list(c("virome", "alpha_depth", 1e6), c("amplicon", "rarefy_depth", 50000), c("crossomics", "pcoa_k", 3),
                     c("diversity", "betadisper_groups", "location"), c("amplicon", "rarefy_row_order", "random"),
                     c("diversity", "permanova_formula", "~ location"), c("virome", "unknown_option", 1))
  for (b in bad_values) {
    x <- cfg; x[[b[1]]][[b[2]]] <- if (grepl("^[0-9.e+]+$", b[3])) as.numeric(b[3]) else b[3]
    p <- ns$rwv_community_config_check(x)
    ok(paste0("W2. refuses ", b[1], ".", b[2], " = ", b[3]), length(p) >= 1L, paste(p, collapse = "; "))
  }

  st <- function(a, b, ...) ns$rwv_dispersion_status(a, b, ...)$status
  ok("W3. NA / NA is undetermined", st(NA, NA) == "undetermined")
  ok("W3. NA / 0.6 is undetermined", st(NA_real_, 0.6) == "undetermined")
  ok("W3. 0.01 / NaN is undetermined", st(0.01, NaN) == "undetermined")
  ok("W3. the reason names the failed test and its error",
     grepl("permutation test: boom", ns$rwv_dispersion_status(NA, 0.3, err_perm = "boom")$reason))
  ok("W3. valid p values keep their status", st(0.01, 0.02) == "flagged_both" && st(0.01, 0.2) == "method_dependent" &&
       st(0.2, 0.3) == "not_flagged" && ns$rwv_dispersion_status(0.2, 0.3)$reason == "")

  n1 <- ns$rwv_name_sets(c("counts", "rarefied", "clr"), c("counts", "clr"))
  ok("W4. a legacy assay missing in the rebuilt object is a difference", n1$status == "different" && identical(n1$missing, "rarefied"))
  n2 <- ns$rwv_name_sets(c("a", "b"), c("c"))
  ok("W4. an empty common set is a difference, not a pass", n2$status == "different" && !length(n2$common))
  n3 <- ns$rwv_name_sets(c("a", "b"), c("a", "b", "reason"))
  ok("W4. a rebuilt-only field is listed as an addition", n3$status == "identical" && identical(n3$added, "reason"))

  res <- do.call(rbind, results)
  print(res[, c("test", "pass")], row.names = FALSE, right = FALSE)
  if (!all(res$pass)) stop("Self-test failed.", call. = FALSE)
  message("All ", nrow(res), " community-check tests passed.")
  invisible(res)
})()
