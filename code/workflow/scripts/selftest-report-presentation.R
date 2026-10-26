# Real knitr report hooks and font-aware vector capture; temporary data only.
# Authors (display order): Jinlong Ru, Cunli Pan.
(function() {
  root <- normalizePath(getwd(),winslash="/")
  ns <- new.env(parent=globalenv())
  for (file in c("workflow.R","style.R","fonts.R","export.R","report.R")) sys.source(file.path(root,"R",file),ns)
  results <- list()
  ok <- function(label,value) results[[length(results)+1L]] <<- data.frame(test=label,pass=isTRUE(value))
  tmp <- tempfile("rwv-report-");dir.create(tmp)
  previous <- setwd(tmp);on.exit(setwd(previous),add=TRUE)
  writeLines(c("check\tpass","one\tTRUE","two\tTRUE"),"input-checks.tsv")
  step <- new.env();step$name <- "010-probe";step$published <- FALSE
  step$path_target <- function(file) file.path(tmp,file)
  outputs <- data.frame(file="input-checks.tsv",bytes=file.size("input-checks.tsv"))
  env <- new.env(parent=ns);env$step <- step;env$outputs <- outputs
  text <- paste(c('```{r}', 'rwv_report_setup(step)', '```',
    '<!-- RWV_REPORT_SUMMARY_POSITION -->','',
    '<details class="rwv-analysis-details">','<summary>Analysis detail</summary>','',
    '```{r}', 'for (i in 1:5) warning("Repeated diagnostic",call.=FALSE)',
    'warning("Different diagnostic",call.=FALSE)', 'message("Routine progress message")',
    'print(1:100)', 'step$published <- TRUE', 'rwv_report_complete(step,outputs)', '```', '', '</details>', '', '```{r, results="asis"}', 'cat(rwv_report_summary(step))', '```'),collapse="\n")
  md <- ns$rwv_report_relocate(knitr::knit(text=text,envir=env,quiet=TRUE))
  ok("report marker is replaced by an overview",!grepl('RWV_REPORT_SUMMARY_POSITION',md,fixed=TRUE) && grepl('Run summary',md,fixed=TRUE))
  ok("source code is not echoed",!grepl('for (i in 1:5)',md,fixed=TRUE))
  ok("all six warnings retained",sum(vapply(step$report$events,function(x)x$kind=="warning",logical(1)))==6L)
  ok("two distinct warnings and repetition counts remain visible",grepl('Warnings: 2 distinct; 6 occurrences',md,fixed=TRUE) && grepl('(5 times)',md,fixed=TRUE))
  ok("routine messages remain in the diagnostics",any(vapply(step$report$events,function(x)x$kind=="message",logical(1))) && grepl('Full runtime diagnostics',md,fixed=TRUE))
  ok("saved check counts are summarized",grepl('2 passed, 0 failed, 0 unclassified',md,fixed=TRUE))
  ok("summary relocation is idempotent",identical(ns$rwv_report_relocate(md),md))
  ok("unrelated reports pass through unchanged",identical(ns$rwv_report_relocate("ordinary report"),"ordinary report"))
  ok("incomplete summary markers are rejected",inherits(try(ns$rwv_report_relocate("<!-- RWV_REPORT_SUMMARY_POSITION -->"),silent=TRUE),"try-error"))
  writeLines(paste(md,'\n## Published figure preview\n\n<figure id="published-proof">Visible main result</figure>'),"probe.md")
  pandoc <- file.path(rmarkdown::find_pandoc()$dir,"pandoc")
  status <- system2(pandoc,c("--from","markdown+raw_html","--to","html5","--section-divs","probe.md","-o","probe.html"))
  dom <- xml2::read_html("probe.html")
  ok("native Markdown details do not enclose the overview or main preview",status==0L &&
    !length(xml2::xml_find_all(dom,"//section[contains(@class,'rwv-report-summary')]/ancestor::details")) &&
    !length(xml2::xml_find_all(dom,"//*[@id='published-proof']/ancestor::details")))
  ok("output file list contains no checksums",!grepl('sha256',as.character(ns$rwv_report_files(step,outputs)),fixed=TRUE))
  writeLines(c("check\tpass","one\tFALSE"),"input-checks.tsv")
  ok("failed saved check never receives a success headline",grepl('Verification needs attention',ns$rwv_report_summary(step),fixed=TRUE))
  step$published <- FALSE
  writeLines(c("check\tpass","one\tTRUE"),"input-checks.tsv")
  ok("unfinished execution never receives a success headline",grepl('Step not completed',ns$rwv_report_summary(step),fixed=TRUE))
  # The capture uses installed Arial on a verified vector device, without
  # registering an alias, substituting Helvetica or suppressing the warning.
  style <- yaml::read_yaml(file.path(root,"config/style.yml"))
  fonts <- ns$rwv_fonts_resolve(style,italic=TRUE)
  old_warnings <- character()
  tryCatch(withCallingHandlers(grid::grid.grabExpr(grid::grid.text("Arial probe",gp=grid::gpar(fontfamily="Arial"))),
    warning=function(w){old_warnings <<- c(old_warnings,conditionMessage(w));invokeRestart("muffleWarning")}),error=function(e)NULL)
  ok("default offscreen font issue reproduced",any(grepl("PostScript font database",old_warnings,fixed=TRUE)))
  new_warnings <- character()
  grob <- withCallingHandlers(ns$rwv_capture_grob({grid::grid.text("Arial regular",y=.7,gp=grid::gpar(fontfamily="Arial"));
    grid::grid.text("Arial bold",y=.3,gp=grid::gpar(fontfamily="Arial",fontface="bold"))},width=2,height=1,style=style,fonts=fonts),
    warning=function(w){new_warnings <<- c(new_warnings,conditionMessage(w))})
  ok("font-aware capture produces no warnings",!length(new_warnings))
  ok("capture uses a verified PDF backend",attr(grob,"rwv_capture_device") %in% c("quartz_pdf","cairo_pdf"))
  file <- file.path(tmp,"font-probe.pdf")
  choice <- ns$rwv_pdf_device_choose(style,fonts)
  open <- ns$rwv_pdf_openers()[[choice$device]]
  open(file,2,1,"Arial","white");grid::grid.draw(grob);grDevices::dev.off()
  ok("captured vector exports embed real Arial regular and bold",setequal(ns$rwv_pdf_font_names(file),c("ArialMT","Arial-BoldMT")))
  for (file in Sys.glob(file.path(root,"analyses/*.qmd"))) {
    q <- paste(readLines(file,warn=FALSE),collapse="\n")
    stopifnot(grepl('rwv_report_setup(step)',q,fixed=TRUE),grepl('rwv_report_complete(step, outputs)',q,fixed=TRUE),
              grepl('rwv-analysis-details',q,fixed=TRUE),grepl('rwv_report_files(step, outputs)',q,fixed=TRUE),
              !grepl('grid::grid.grabExpr(',q,fixed=TRUE))
  }
  ok("all 21 entry points have the concise-report contract",TRUE)
  res <- do.call(rbind,results);print(res,row.names=FALSE)
  if(!all(res$pass)) stop("Report-presentation regression failed.",call.=FALSE)
  message("All ",nrow(res)," report-presentation/font checks passed.")
})()
