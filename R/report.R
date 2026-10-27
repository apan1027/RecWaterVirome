# Native Markdown reporting; no HTML site or duplicated report pipeline.
# Authors (display order): Jinlong Ru, Cunli Pan.
rwv_report_setup <- function(step) {
  step$report <- new.env(parent = emptyenv()); step$report$outputs <- NULL
  knitr::opts_chunk$set(echo = TRUE, warning = TRUE, message = TRUE)
  invisible(NULL)
}
rwv_report_complete <- function(step, outputs) { step$report$outputs <- outputs; invisible(NULL) }
rwv_report_summary <- function(step) {
  if (!isTRUE(step$published)) return("\n## Run status\n\nStep not completed.\n")
  paste0("\n## Run status\n\nCompleted `", step$name, "`; run `", step$run_id,
    "`. Output hashes are recorded above and in the local step record.\n")
}
rwv_report_files <- function(step, outputs) {
  knitr::asis_output(paste(paste0("- `", outputs$file, "` (", outputs$bytes, " bytes)"), collapse = "\n"))
}
# Markdown image assets are report companions, not scientific data outputs.
# Copy only after a successful step; do not introduce a second figure render.
rwv_public_preview <- function(step, source, filename) {
  if (!isTRUE(step$published)) rwv_fail("Publish the verified step before copying its report image.")
  source <- step$path_target(source)
  target <- file.path(step$root, "analyses", paste0(step$name, "_files"), "figure-commonmark", filename)
  dir.create(dirname(target), recursive = TRUE, showWarnings = FALSE)
  if (!file.copy(source, target, overwrite = TRUE)) rwv_fail("Could not write Markdown figure companion.")
  file.path(paste0(step$name, "_files"), "figure-commonmark", filename)
}
