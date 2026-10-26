# Generated English interpretation-guide contract; temporary files only.
# Authors (display order): Jinlong Ru, Cunli Pan.
(function() {
  ns <- new.env(parent=globalenv())
  for (f in c("workflow.R","export.R","figures.R")) sys.source(file.path("R",f),ns)
  p <- tempfile(fileext=".md");on.exit(unlink(p),add=TRUE)
  ns$rwv_write_legend(p,"Figure 1","Probe","a, Saved observations.","What is displayed.","No causal inference.","Archived source")
  x <- ns$rwv_read_legend(p)
  stopifnot(length(x$guide)==2L,length(x$sources)==1L,!length(x$notes),!any(grepl("[\u3400-\u9fff]",readLines(p))))
  ns$rwv_write_legend(p,"Figure 1","Probe","a, Saved observations.","What is displayed.","No causal inference.","Archived source",notes="Detailed constraint.")
  x <- ns$rwv_read_legend(p);stopifnot(identical(x$notes,"Detailed constraint."))
  cat("\n## Interpretation guide\n",file=p,append=TRUE)
  stopifnot(inherits(try(ns$rwv_read_legend(p),silent=TRUE),"try-error"))
  writeLines(c("# Probe","## Legend (English)","text","## Sources","source"),p)
  stopifnot(inherits(try(ns$rwv_read_legend(p),silent=TRUE),"try-error"))
  message("All 4 English-guide checks passed (no notes, notes, duplicate heading, missing heading).")
})()
