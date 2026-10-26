# A real knitr regression for previews and staged publication; no science.
# Authors (display order): Jinlong Ru, Cunli Pan.
(function() {
  root <- normalizePath(getwd(),winslash="/")
  ns <- new.env(parent=globalenv());sys.source(file.path(root,"R/workflow.R"),ns)
  tmp <- tempfile("rwv-preview-");dir.create(tmp)
  previous <- setwd(tmp);on.exit(setwd(previous),add=TRUE)
  # A fixed 1x1 PNG is sufficient to test image-path lifetime.
  png <- jsonlite::base64_dec("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=")
  run <- function(preview_first) {
    final <- file.path(tmp,if(preview_first) "old" else "fixed")
    stage <- ns$rwv_stage_open(final,"test","test")
    writeBin(png,file.path(stage,"probe.png"))
    state <- new.env();state$published <- FALSE
    target <- function(file) file.path(if(state$published) final else stage,file)
    publish <- function() {
      rec <- list(step="preview-test",status="complete",run_id="test",outputs=list(list(file="probe.png",sha256=ns$rwv_sha256(file.path(stage,"probe.png")))))
      ns$rwv_stage_publish(final,stage,"test",rec);state$published <- TRUE
      invisible(NULL)
    }
    env <- new.env(parent=globalenv());env$target <- target;env$publish <- publish
    preview <- c("```{r}","knitr::include_graphics(target('probe.png'))","```")
    commit <- c("```{r}","publish()","```")
    txt <- paste(if(preview_first) c(preview,"",commit) else c(commit,"",preview),collapse="\n")
    md <- knitr::knit(text=txt,envir=env,quiet=TRUE)
    list(markdown=md,final=file.path(final,"probe.png"),stage=file.path(stage,"probe.png"))
  }
  old <- run(TRUE);fixed <- run(FALSE)
  stopifnot(file.exists(old$final),!file.exists(old$stage),grepl("[.]rwv-staging",old$markdown))
  stopifnot(file.exists(fixed$final),!file.exists(fixed$stage),!grepl("[.]rwv-staging",fixed$markdown))
  stopifnot(identical(ns$rwv_sha256(old$final),ns$rwv_sha256(fixed$final)))
  files <- Sys.glob(file.path(root,"analyses/*.qmd"));n <- 0L
  for (p in files) {
    text <- paste(readLines(p,warn=FALSE),collapse="\n")
    previews <- gregexpr("knitr::include_graphics",text,fixed=TRUE)[[1]]
    if(previews[1] < 0L) next
    finish <- regexpr("outputs <- rwv_step_finish(",text,fixed=TRUE)[1]
    stopifnot(finish>0L,all(previews>finish));n <- n+1L
  }
  stopifnot(n==9L)
  message("All 4 published-preview checks passed: original failure reproduced, final path survives, PNG bytes unchanged, all 9 QMDs ordered safely.")
})()
