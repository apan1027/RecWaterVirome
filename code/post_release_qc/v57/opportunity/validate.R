# Jinlong Ru; Cunli Pan
# Authorized scoped reproduction. Archived inputs are read-only; no publication output is written.
args <- commandArgs(TRUE)
stopifnot(length(args)==2)
pkg <- normalizePath(args[1]); out <- normalizePath(args[2])
suppressPackageStartupMessages({library(data.table);library(jsonlite)})
root <- file.path(pkg,'07_Code/model_archive/original-layout')
base <- file.path(root,'dev/280-publication-stage-a')
src <- file.path(root,'outputs/manuscript-package-2026-08-28/02-figures/source')
script <- file.path(base,'global_primary.R')
saved_path <- file.path(pkg,'07_Code/workflow/analyses/data/050-global-inputs/global_feature_fits.tsv')
input_paths <- c(script,saved_path,file.path(src,c('lin_genomes.tsv','lin_pfam.tsv')),
 file.path(root,'dev/220-scaling-cargo/results',c('j42-feature_slopes.tsv','j44-profile_slopes.tsv')),
 file.path(base,'spark_inputs/aset_profile_members.tsv'),file.path(base,'spark_recovery/artifacts/aset_metadata.tsv'))
before <- tools::md5sum(input_paths)
g <- fread(file.path(src,'lin_genomes.tsv'))
meta <- fread(file.path(base,'spark_recovery/artifacts/aset_metadata.tsv'))
stopifnot(nrow(g)==77951,uniqueN(g$uvig)==77951,setequal(g$uvig,meta$uvig),
 identical(as.integer(g$cds_count),as.integer(meta$cds_count[match(g$uvig,meta$uvig)])))
g <- merge(g,meta[,.(uvig,fam,host_phylum,host_genus,Ecosystem_Category)],by='uvig',sort=FALSE)
g[,i:=.I];xx <- sort(unique(g$cds_count));g[,bin:=match(cds_count,xx)]
nb <- length(xx);n <- tabulate(g$bin,nbins=nb)
archive <- fread(file.path(root,'dev/220-scaling-cargo/results/j42-feature_slopes.tsv'))
pf <- fread(file.path(src,'lin_pfam.tsv'))[feat %in% archive[group=='METAB',feature]]
pr <- fread(file.path(root,'dev/220-scaling-cargo/results/j44-profile_slopes.tsv'))
ad <- fread(file.path(base,'spark_inputs/aset_profile_members.tsv'))
ac <- ad[,.(carriers=uniqueN(uvig)),by=profile][carriers>=30]
stopifnot(nrow(pr)==38,setequal(ac$profile,pr$profile),all(ac$carriers==pr$carriers[match(ac$profile,pr$profile)]))
raw <- unique(rbind(pf[,.(feat,uvig,group='METAB')],ad[profile %in% pr$profile,.(feat=profile,uvig,group='ADF_profile')]))
raw[,i:=match(uvig,g$uvig)];stopifnot(!anyNA(raw$i))
universe <- raw[,.(carriers=.N),by=.(feat,group)]
stopifnot(universe[group=='METAB',.N]==285,universe[group=='ADF_profile',.N]==38)
carrier <- split(raw$i,raw$feat)
# Extract ONLY the original fit function. No original top-level execution occurs.
expr <- parse(script)
fit_expr <- Filter(function(e) is.call(e)&&identical(e[[1]],as.name('<-'))&&identical(e[[2]],as.name('fit')),as.list(expr))
stopifnot(length(fit_expr)==1);eval(fit_expr[[1]])
capture_glm <- function(dat,family) {
 w <- character()
 m <- withCallingHandlers(glm(cbind(k,n-k)~x,data=dat,family=family,
  control=glm.control(maxit=100,epsilon=1e-10)),warning=function(e){w<<-c(w,conditionMessage(e));invokeRestart('muffleWarning')})
 list(m=m,w=paste(unique(w),collapse=' | '))
}
# Independent minimization of weighted Bernoulli cross entropy of expected probabilities.
# Center x for conditioning; start with an intercept-only probability, not the saved projection.
cross_entropy_fit <- function(x,p,nn) {
 w <- nn/sum(nn);xm <- sum(w*x);X <- cbind(1,x-xm)
 b <- c(qlogis(sum(w*p)),0)
 loss <- function(z){eta<-drop(X%*%z);sum(w*(pmax(eta,0)+log1p(exp(-abs(eta)))-p*eta))}
 converged <- FALSE
 for(it in seq_len(200)) {
  mu <- plogis(drop(X%*%b));gr <- drop(crossprod(X,w*(mu-p)))
  if(max(abs(gr))<1e-12){converged<-TRUE;break}
  H <- crossprod(X,X*as.vector(w*mu*(1-mu)));d <- drop(solve(H,gr))
  step <- 1;old <- loss(b)
  while(loss(b-step*d)>old+1e-15 && step>2^-30)step<-step/2
  b <- b-step*d
 }
 list(intercept=b[1]-b[2]*xm,slope=b[2],converged=converged,iterations=it,
  max_normalized_score=max(abs(drop(crossprod(X,w*(plogis(drop(X%*%b))-p))))))
}
rows <- list()
for(j in seq_len(nrow(universe))) {
 f <- universe$feat[j];ids <- carrier[[f]];k <- tabulate(g$bin[ids],nbins=nb)
 actual <- fit(k,n);nul <- fit(k,n,'cloglog',TRUE)
 stopifnot(actual$valid,nul$valid)
 expected <- fitted(nul$m)*n
 eq <- fit(expected,n)
 dat <- data.frame(k=expected,n=n,x=log10(xx))
 quasi <- capture_glm(dat,quasibinomial('logit'))
 ce <- cross_entropy_fit(log10(xx),fitted(nul$m),n)
 co <- coef(eq$m)
 rows[[j]] <- data.table(feature=f,group=universe$group[j],carriers=sum(k),
  beta=unname(coef(actual$m)[2]),null_valid=nul$valid,
  projection=unname(co[2]),residual=unname(coef(actual$m)[2]-co[2]),
  original_strict_valid=eq$valid,projection_converged=eq$m$converged,
  projection_boundary=isTRUE(eq$m$boundary),projection_rank=eq$m$rank,
  projection_iterations=eq$m$iter,projection_warnings=eq$w,
  quasi_projection=unname(coef(quasi$m)[2]),quasi_converged=quasi$m$converged,
  quasi_boundary=isTRUE(quasi$m$boundary),quasi_warnings=quasi$w,
  independent_projection=ce$slope,independent_converged=ce$converged,
  independent_max_score=ce$max_normalized_score)
 if(j%%50==0)cat('Checked',j,'of',nrow(universe),'features\n')
}
r <- rbindlist(rows);saved <- fread(saved_path)
r <- merge(r,saved[,.(feature,saved_beta=slope,saved_projection=null_logit_equivalent,saved_residual=residual_slope)],by='feature',sort=FALSE)
r[,`:=`(beta_difference=beta-saved_beta,projection_difference=projection-saved_projection,
 residual_difference=residual-saved_residual,quasi_difference=quasi_projection-projection,
 independent_difference=independent_projection-projection)]
fwrite(r,file.path(out,'feature-validation.tsv'),sep='\t')
summary <- r[,.(n=.N,median_beta=median(beta),median_projection=median(projection),
 median_residual=median(residual),projection_converged=sum(projection_converged),
 original_strict_valid=sum(original_strict_valid),quasi_converged=sum(quasi_converged),
 independent_converged=sum(independent_converged)),by=group]
fwrite(summary,file.path(out,'group-summary.tsv'),sep='\t')
fwrite(r[,.(n=.N),by=projection_warnings],file.path(out,'projection-warning-counts.tsv'),sep='\t')
stopifnot(identical(before,tools::md5sum(input_paths)))
checks <- list(genomes=nrow(g),features=nrow(r),CDS_bins=length(xx),summary=summary,
 max_beta_error=max(abs(r$beta_difference)),max_projection_error=max(abs(r$projection_difference)),
 max_residual_error=max(abs(r$residual_difference)),max_quasi_error=max(abs(r$quasi_difference)),
 max_independent_error=max(abs(r$independent_difference)),max_independent_score=max(r$independent_max_score),
 projection_warnings=r[,.(n=.N),by=projection_warnings],input_md5_unchanged=TRUE,
 sources=data.frame(path=names(before),md5=unname(before)),
 scope='Only original feature-level logit, fixed opportunity and projection reproduction; quasibinomial coefficient and independent cross-entropy numerical verification. No gamma, covariates, cluster bootstrap, annotation or publication modification.')
write_json(checks,file.path(out,'verification.json'),pretty=TRUE,auto_unbox=TRUE,digits=16)
writeLines(capture.output(sessionInfo()),file.path(out,'session-info.txt'))
print(summary);print(checks[c('max_beta_error','max_projection_error','max_residual_error','max_quasi_error','max_independent_error')])
stopifnot(nrow(r)==323,all(r$projection_converged),!any(r$projection_boundary),
 all(r$projection_rank==2),all(r$quasi_converged),!any(r$quasi_boundary),
 all(r$independent_converged),max(abs(r$projection_difference))<1e-7,
 max(abs(r$beta_difference))<1e-7,max(abs(r$quasi_difference))<1e-7,
 max(abs(r$independent_difference))<1e-6)
