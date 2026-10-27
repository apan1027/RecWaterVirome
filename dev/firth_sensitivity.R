# Authors (display order): Jinlong Ru, Cunli Pan. Optional method source; no automatic fitting.
# Uniform follow-up for separation in PRIMARY-CONTRACT; no constant-response resample imputation.
suppressPackageStartupMessages({library(data.table);library(logistf);library(jsonlite)})
args <- commandArgs(TRUE); stopifnot(length(args) == 2L)
root <- normalizePath(args[1], mustWork=TRUE); export_dir <- normalizePath(args[2], mustWork=TRUE)
b<-root;out<-export_dir
g<-fread(file.path(b,'aset_metadata.tsv'))
u<-fread(file.path(root,'fixed_universe.tsv'))
pf<-fread(file.path(root,'outputs/manuscript-package-2026-08-28/02-figures/source/lin_pfam.tsv'))[feat %in% u[group=='METAB',feat]]
ad<-fread(file.path(b,'aset_profile_members.tsv'))[profile %in% u[group=='ADF_profile',feat],.(feat=profile,uvig)]
raw<-rbind(pf[,.(feat,uvig)],ad);raw[,i:=match(uvig,g$uvig)];stopifnot(!anyNA(raw$i));carrier<-split(raw$i,raw$feat)
categorize<-function(v){v<-as.character(v);v[is.na(v)|v=='']<-'Unknown';cnt<-table(v);v[!v %in% names(cnt[cnt>=1000]) & v!='Unknown']<-'Other';v}
g[,ecosystem:=categorize(Ecosystem_Category)];g[,host:=categorize(host_phylum)]
rows<-list()
for(mode in c('unadjusted','ecosystem','host')) {
 stratum<-if(mode=='unadjusted')rep('All',nrow(g)) else g[[mode]]
 cell<-match(paste(g$cds_count,stratum),unique(paste(g$cds_count,stratum)));nc<-max(cell);first<-match(seq_len(nc),cell);nn<-tabulate(cell,nbins=nc)
 cov<-data.frame(x=log10(g$cds_count[first]),stratum=factor(stratum[first]))
 for(f in u$feat) {
  k<-tabulate(cell[carrier[[f]]],nbins=nc);z<-rbind(data.frame(cov,y=1,w=k),data.frame(cov,y=0,w=nn-k));z<-z[z$w>0,]
  warns<-character();m<-tryCatch(withCallingHandlers(logistf(if(mode=='unadjusted')y~x else y~x+stratum,data=z,weights=z$w,pl=FALSE,control=logistf.control(maxit=100)),warning=function(e){warns<<-c(warns,conditionMessage(e));invokeRestart('muffleWarning')}),error=function(e){warns<<-c(warns,conditionMessage(e));NULL})
  valid<-!is.null(m)&&all(is.finite(m$coefficients))&&all(m$conv<1e-5)&&!length(warns)
  rows[[length(rows)+1]]<-data.table(mode,feat=f,group=u[feat==f,group],named=u[feat==f,named],valid,slope=if(valid)m$coefficients['x'] else NA_real_,raw_slope=if(is.null(m))NA_real_ else m$coefficients['x'],se=if(valid)sqrt(m$var[match('x',names(m$coefficients)),match('x',names(m$coefficients))]) else NA_real_,max_conv=if(is.null(m))NA_real_ else max(m$conv),warnings=paste(unique(warns),collapse=' | '))
 }
 cat('Firth sensitivity finished',mode,'\n');fwrite(rbindlist(rows),file.path(out,'firth_feature_fits.tsv'),sep='\t')
}
r<-rbindlist(rows);res<-list()
for(cv_mode in unique(r$mode))for(def in c('all38','named25')) {
 x<-r[mode==cv_mode];m<-x[group=='METAB'];a<-x[group=='ADF_profile' & (def=='all38'|named==TRUE)];valid<-all(m$valid)&all(a$valid)
 res[[length(res)+1]]<-data.table(mode=cv_mode,definition=def,valid,n_invalid_metab=sum(!m$valid),n_invalid_adf=sum(!a$valid),metab=if(all(m$valid))median(m$slope) else NA_real_,adf=if(all(a$valid))median(a$slope) else NA_real_,difference=if(valid)median(m$slope)-median(a$slope) else NA_real_)
}
fwrite(rbindlist(res),file.path(out,'firth_contrasts.tsv'),sep='\t');print(rbindlist(res))
write_json(list(package='logistf',version=as.character(packageVersion('logistf')),pl=FALSE,maxit=100,full_universe=323,scope='Uniform sensitivity for separated nuisance strata. Not applied to zero-carrier bootstrap replicates; cannot manufacture lineage replication.'),file.path(out,'firth_run.json'),pretty=TRUE,auto_unbox=TRUE)
