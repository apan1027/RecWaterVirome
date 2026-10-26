# Isolated source-provenance regression tests. No scientific calculation.
# Authors (display order): Jinlong Ru, Cunli Pan.
(function() {
  root <- normalizePath(getwd(), winslash = "/")
  ns <- new.env(parent = globalenv()); sys.source(file.path(root, "R/workflow.R"), ns)
  results <- list()
  ok <- function(name, cond) results[[length(results)+1L]] <<- data.frame(test=name, pass=isTRUE(cond))
  wr <- function(tmp, rel, text) { p <- file.path(tmp,rel); dir.create(dirname(p),recursive=TRUE,showWarnings=FALSE); writeLines(text,p); p }
  fixtures <- character()
  on.exit(unlink(fixtures, recursive=TRUE), add=TRUE)
  fixture <- function(id) {
    tmp <- tempfile("rwv-source-"); dir.create(tmp); fixtures <<- c(fixtures,tmp)
    # Use the actual 012/020 QMD source bytes, without evaluating a chunk.
    for (p in ns$rwv_source_files(root,id)) {
      dest <- file.path(tmp,p);dir.create(dirname(dest),recursive=TRUE,showWarnings=FALSE)
      stopifnot(file.copy(file.path(root,p),dest))
    }
    sources <- ns$rwv_source_snapshot(tmp,id)
    rec <- list(step=id,status="complete",run_id="isolated-test",source_contract="rwv-source-v1",sources=sources,inputs=list(),
                outputs=list(list(file="value.tsv",sha256=digest::digest("value",algo="sha256"))))
    wr(tmp,paste0("analyses/data/",id,"/value.tsv"),"unchanged output")
    rec$outputs[[1]]$sha256 <- ns$rwv_sha256(file.path(tmp,"analyses/data",id,"value.tsv"))
    record_path <- file.path(tmp,"analyses/data",id,"step-record.json")
    jsonlite::write_json(rec,record_path,auto_unbox=TRUE)
    list(root=tmp,id=id,rec=rec,path=record_path)
  }
  for (id in c("012-tse-construction","020-community-analysis")) {
    f <- fixture(id); before <- readBin(f$path,"raw",n=file.size(f$path))
    ok(paste(id,"unchanged sources accepted"),!length(ns$rwv_step_inputs_changed(f$root,id)))
    q <- file.path(f$root,"analyses",paste0(id,".qmd"));cat('\n```{r}\nstop("changed source")\n```\n',file=q,append=TRUE)
    ok(paste(id,"executable QMD change detected"),paste0("analyses/",id,".qmd") %in% ns$rwv_step_inputs_changed(f$root,id))
    ok(paste(id,"checking never rewrites historical record"),identical(before,readBin(f$path,"raw",n=file.size(f$path))))
    f <- fixture(id);cat('\nrwv_comm_composition <- function(...) stop("changed helper")\n',file=file.path(f$root,"R/community.R"),append=TRUE)
    ok(paste(id,"unregistered shared helper change detected"),"R/community.R" %in% ns$rwv_step_inputs_changed(f$root,id))
  }
  for (rel in c("DESCRIPTION","NAMESPACE","analyses/_quarto.yml","scripts/render.R","scripts/render-step.R","scripts/gfm-from-knit.R")) {
    f <- fixture("012-tse-construction");cat("\n# changed\n",file=file.path(f$root,rel),append=TRUE)
    ok(paste("execution context change detected",rel),rel %in% ns$rwv_step_inputs_changed(f$root,f$id))
  }
  f <- fixture("012-tse-construction");wr(f$root,"R/new-helper.R","f <- function() 1")
  ok("new shared helper detected","R/new-helper.R" %in% ns$rwv_step_inputs_changed(f$root,f$id))
  f <- fixture("012-tse-construction");unlink(file.path(f$root,"R/community.R"))
  ok("deleted shared helper detected","R/community.R" %in% ns$rwv_step_inputs_changed(f$root,f$id))
  f <- fixture("012-tse-construction");legacy <- f$rec;legacy$sources <- NULL
  ok("legacy missing source hashes require rerender",length(ns$rwv_source_changes(f$root,f$id,legacy))>0)
  legacy <- f$rec;legacy$source_contract <- "unknown"
  ok("unknown source contract rejected",length(ns$rwv_source_changes(f$root,f$id,legacy))>0)
  bad <- f$rec;bad$sources[[1]]$sha256 <- "not-a-hash"
  ok("malformed source hash rejected",length(ns$rwv_source_changes(f$root,f$id,bad))>0)
  bad <- f$rec;bad$sources <- c(bad$sources,bad$sources[1])
  ok("duplicate source entries rejected",length(ns$rwv_source_changes(f$root,f$id,bad))>0)
  bad <- f$rec;bad$sources[[1]]$path <- "../../outside"
  ok("unexpected source path rejected without reading it",length(ns$rwv_source_changes(f$root,f$id,bad))>0)
  # The real finish function checks the begin-time snapshot before publishing.
  f <- fixture("012-tse-construction");cat("\n# modified during execution\n",file=file.path(f$root,"R/community.R"),append=TRUE)
  step <- list(root=f$root,name=f$id,source_contract="rwv-source-v1",sources=f$rec$sources)
  err <- tryCatch(ns$rwv_step_finish(step,function(...) stop("must not reach output processing")),error=conditionMessage)
  ok("source edit during a run stops before output publication",grepl("sources changed during",err))
  # The real downstream reader must reject stale upstream code, not just sync.
  f <- fixture("012-tse-construction")
  step <- list(name="020-community-analysis",root=f$root,mode="test",spec=list(depends_on=f$id,upstream_inputs=list(list(step=f$id,file="value.tsv"))))
  locate <- function(from,file) file.path(f$root,"analyses/data",from,file)
  ok("fresh upstream source record is readable",file.exists(ns$rwv_step_input(step,locate,f$id,"value.tsv")))
  cat("\n# changed\n",file=file.path(f$root,"R/community.R"),append=TRUE)
  err <- tryCatch(ns$rwv_step_input(step,locate,f$id,"value.tsv"),error=conditionMessage)
  ok("stale upstream source is refused",grepl("unverified executable sources",err))
  res <- do.call(rbind,results); print(res,row.names=FALSE)
  if (!all(res$pass)) stop("Source-tracking regression failed.",call.=FALSE)
  message("All ",nrow(res)," source-tracking checks passed.")
})()
