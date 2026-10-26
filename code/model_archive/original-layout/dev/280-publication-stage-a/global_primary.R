suppressPackageStartupMessages({library(data.table);library(jsonlite);library(ggplot2)})
root<-normalizePath(if(length(commandArgs(TRUE)))commandArgs(TRUE)[1] else '.')
base<-file.path(root,'dev/280-publication-stage-a');out<-file.path(base,'global_primary');dir.create(out,showWarnings=FALSE)
src<-file.path(root,'outputs/manuscript-package-2026-08-28/02-figures/source')
g<-fread(file.path(src,'lin_genomes.tsv'));meta<-fread(file.path(base,'spark_recovery/artifacts/aset_metadata.tsv'))
stopifnot(nrow(g)==77951,uniqueN(g$uvig)==77951,nrow(meta)==77951,setequal(g$uvig,meta$uvig))
stopifnot(identical(as.integer(g$cds_count),as.integer(meta$cds_count[match(g$uvig,meta$uvig)])))
g<-merge(g,meta[,.(uvig,fam,host_phylum,host_genus,Ecosystem_Category)],by='uvig',sort=FALSE)
g[,i:=.I];xx<-sort(unique(g$cds_count));g[,bin:=match(cds_count,xx)];nb<-length(xx);n<-tabulate(g$bin,nbins=nb)
archive<-fread(file.path(root,'dev/220-scaling-cargo/results/j42-feature_slopes.tsv'))
pf<-fread(file.path(src,'lin_pfam.tsv'))[feat %in% archive[group=='METAB',feature]]
pr<-fread(file.path(root,'dev/220-scaling-cargo/results/j44-profile_slopes.tsv'));stopifnot(nrow(pr)==38,sum(!is.na(pr$category)&pr$category!='')==25)
ad<-fread(file.path(base,'spark_inputs/aset_profile_members.tsv'))
ac<-ad[,.(carriers=uniqueN(uvig)),by=profile][carriers>=30]
stopifnot(setequal(ac$profile,pr$profile),all(ac$carriers==pr$carriers[match(ac$profile,pr$profile)]))
raw<-rbind(pf[,.(feat,uvig,group='METAB')],ad[profile %in% pr$profile,.(feat=profile,uvig,group='ADF_profile')])
raw<-unique(raw);raw[,i:=match(uvig,g$uvig)];stopifnot(!anyNA(raw$i))
universe<-raw[,.(carriers=.N),by=.(feat,group)];stopifnot(universe[group=='METAB',.N]==285,universe[group=='ADF_profile',.N]==38)
universe[,named:=feat %in% pr[!is.na(category)&category!='',profile]]
carrier<-split(raw$i,raw$feat);fwrite(universe,file.path(out,'fixed_universe.tsv'),sep='\t')
fit<-function(k,nn,link='logit',null=FALSE,extra=NULL) {
 if(sum(k)==0||sum(k)==sum(nn))return(list(m=NULL,w='constant_response',valid=FALSE))
 ok<-nn>0
 dat<-if(is.null(extra))data.frame(k=k[ok],n=nn[ok],x=log10(xx[ok]),ln=log(xx[ok])) else data.frame(extra[ok,],k=k[ok],n=nn[ok])
 form<-if(!is.null(extra))cbind(k,n-k)~x+stratum else if(null)cbind(k,n-k)~1+offset(ln) else if(link=='cloglog')cbind(k,n-k)~ln else cbind(k,n-k)~x
 w<-character();m<-tryCatch(withCallingHandlers(glm(form,data=dat,family=binomial(link),control=glm.control(maxit=100,epsilon=1e-10)),warning=function(e){w<<-c(w,conditionMessage(e));invokeRestart('muffleWarning')}),error=function(e){w<<-c(w,conditionMessage(e));NULL})
 valid<-!is.null(m)&&isTRUE(m$converged)&&!isTRUE(m$boundary)&&all(is.finite(coef(m)))&&!length(w)
 list(m=m,w=paste(unique(w),collapse=' | '),valid=valid)
}
groups<-split(g$i,g$g);gc<-match(g$g,names(groups));ng<-length(groups)
rows<-list()
for(f in universe$feat) {
 ids<-carrier[[f]];k<-tabulate(g$bin[ids],nbins=nb);l<-fit(k,n);alt<-fit(k,n,'cloglog');nul<-fit(k,n,'cloglog',TRUE)
 if(!l$valid)stop(paste('Primary GLM invalid',f,l$w))
 stopifnot(!is.null(nul$m),nul$m$converged)
 if(!alt$valid)cat('Opportunity model flagged:',f,alt$w,'\n')
 co<-coef(summary(l$m));ca<-if(is.null(alt$m))matrix(NA_real_,2,4) else coef(summary(alt$m));eq<-fit(fitted(nul$m)*n,n)
 y<-numeric(nrow(g));y[ids]<-1;X<-cbind(1,log10(g$cds_count));mu<-plogis(drop(X%*%coef(l$m)))
 score<-rowsum(X*(y-mu),gc,reorder=FALSE);bread<-vcov(l$m);rob<-bread%*%crossprod(score)%*%bread*ng/(ng-1)*(nrow(g)-1)/(nrow(g)-2)
 rows[[length(rows)+1]]<-data.table(feat=f,group=universe[feat==f,group],named=universe[feat==f,named],carriers=sum(k),slope=co[2,1],se=co[2,2],cluster_se=sqrt(rob[2,2]),converged=l$m$converged,boundary=l$m$boundary,warnings=l$w,
  gamma=if(alt$valid)ca[2,1] else NA_real_,gamma_unaccepted_estimate=ca[2,1],gamma_se=if(alt$valid)ca[2,2] else NA_real_,gamma_valid=alt$valid,gamma_converged=if(is.null(alt$m))FALSE else alt$m$converged,gamma_warnings=alt$w,null_valid=nul$valid,null_warnings=nul$w,null_logit_equivalent=coef(eq$m)[2],residual_slope=co[2,1]-coef(eq$m)[2])
}
r<-rbindlist(rows);old<-rbind(archive[group=='METAB',.(feat=feature,archived_slope=slope)],pr[,.(feat=profile,archived_slope=slope)])
r<-merge(r,old,by='feat');r[,difference:=slope-archived_slope];stopifnot(max(abs(r$difference))<1e-5)
fwrite(r,file.path(out,'full_feature_fits.tsv'),sep='\t');cat('Full 285/38 fits verified\n')

# Fixed-member aggregation first; lower-carrier profiles enter only the separate all-profile scenario.
map<-fread(file.path(base,'spark_inputs/family_category.tsv'),header=FALSE,col.names=c('profile','category'))
ad<-merge(ad,map,by='profile',all.x=TRUE);ad[,unit:=ifelse(is.na(category)|category=='',profile,category)]
ar<-list()
for(mode in c('fixed38','all_profiles_then_threshold')) {
 z<-if(mode=='fixed38')ad[profile %in% pr$profile] else ad
 z<-unique(z[,.(unit,uvig)]);z[,i:=match(uvig,g$uvig)]
 for(u in unique(z$unit)) {
  ix<-z[unit==u,i];if(length(ix)<30)next
  rr<-fit(tabulate(g$bin[ix],nbins=nb),n)
  ar[[length(ar)+1]]<-data.table(mode,unit=u,carriers=length(ix),n_member_profiles=uniqueN(ad[unit==u & (mode!='fixed38'|profile %in% pr$profile),profile]),slope=if(rr$valid)coef(rr$m)[2] else NA_real_,valid=rr$valid,warnings=rr$w)
 }
}
agg<-rbindlist(ar);fwrite(agg,file.path(out,'aggregation_fits.tsv'),sep='\t')
fwrite(unique(ad[,.(profile,category,unit,selected38=profile %in% pr$profile)]),file.path(out,'aggregation_members.tsv'),sep='\t')

# Covariate labels are frozen by population size, not outcome or coefficient.
covariate<-function(v){v<-as.character(v);v[is.na(v)|v=='']<-'Unknown';counts<-table(v);v[!v %in% names(counts[counts>=1000]) & v!='Unknown']<-'Other';v}
g[,ecosystem:=covariate(Ecosystem_Category)];g[,host:=covariate(host_phylum)]
adjusted<-list();stratified<-list();strata_counts<-list()
for(cv in c('ecosystem','host')) {
 strata_counts[[cv]]<-g[,.(n=.N),by=.(stratum=get(cv))][,covariate:=cv]
 cellkey<-paste(g$bin,g[[cv]],sep='|');cell<-match(cellkey,unique(cellkey));first<-match(seq_len(max(cell)),cell)
 dat<-data.frame(x=log10(g$cds_count[first]),stratum=factor(g[[cv]][first]));nn<-tabulate(cell,nbins=max(cell))
 for(f in universe$feat){k<-tabulate(cell[carrier[[f]]],nbins=length(nn));rr<-fit(k,nn,extra=dat)
  adjusted[[length(adjusted)+1]]<-data.table(covariate=cv,feat=f,valid=rr$valid,slope=if(rr$valid)coef(rr$m)['x'] else NA_real_,se=if(rr$valid)coef(summary(rr$m))['x',2] else NA_real_,warnings=rr$w)
 }
 for(st in strata_counts[[cv]][n>=1000 & !stratum %in% c('Unknown','Other'),stratum]) {
  keep<-g[[cv]]==st;nn<-tabulate(g$bin[keep],nbins=nb)
  for(f in universe$feat){ids<-carrier[[f]];ids<-ids[keep[ids]];k<-tabulate(g$bin[ids],nbins=nb)
   rr<-if(sum(k)>=5&&sum(nn-k)>=5)fit(k,nn) else list(valid=FALSE,w='fewer_than_5_carriers_or_negatives')
   stratified[[length(stratified)+1]]<-data.table(covariate=cv,stratum=st,n=sum(nn),feat=f,carriers=sum(k),valid=rr$valid,slope=if(rr$valid)coef(rr$m)[2] else NA_real_,warnings=rr$w)
  }
 }
 cat('Covariate checked:',cv,'\n')
}
adj<-rbindlist(adjusted);strat<-rbindlist(stratified)
fwrite(adj,file.path(out,'adjusted_fits.tsv'),sep='\t');fwrite(strat,file.path(out,'stratum_fits.tsv'),sep='\t');fwrite(rbindlist(strata_counts),file.path(out,'stratum_population.tsv'),sep='\t')

set.seed(20260917);all_diag<-list();contrasts<-list()
contrast<-function(sl,valid,mode,b) {
 res<-list()
 for(def in c('all38','named25')) {
  ismet<-universe$group=='METAB';isa<-universe$group=='ADF_profile' & (def=='all38' | universe$named)
  ok<-all(valid[ismet|isa]);res[[def]]<-data.table(mode,rep=b,definition=def,valid=ok,n_invalid_metab=sum(!valid[ismet]),n_invalid_adf=sum(!valid[isa]),difference=if(ok)median(sl[ismet])-median(sl[isa]) else NA_real_)
 }
 rbindlist(res)
}
for(mode in c('representative','cluster_bootstrap')) for(b in seq_len(if(mode=='representative')50 else 200)) {
 if(mode=='representative') {pick<-vapply(groups,function(ix)ix[sample.int(length(ix),1)],integer(1));weights<-integer(nrow(g));weights[pick]<-1L}
 else weights<-tabulate(sample.int(ng,ng,replace=TRUE),nbins=ng)[gc]
 nn<-tabulate(rep.int(g$bin,weights),nbins=nb);sl<-rep(NA_real_,nrow(universe));valid<-logical(nrow(universe))
 for(j in seq_len(nrow(universe))) {
  ix<-carrier[[universe$feat[j]]];k<-tabulate(rep.int(g$bin[ix],weights[ix]),nbins=nb);rr<-fit(k,nn);valid[j]<-rr$valid
  if(rr$valid)sl[j]<-coef(rr$m)[2]
  all_diag[[length(all_diag)+1]]<-data.table(mode,rep=b,feat=universe$feat[j],carriers=sum(k),valid=rr$valid,slope=sl[j],warnings=rr$w)
 }
 contrasts[[length(contrasts)+1]]<-contrast(sl,valid,mode,b)
 if(b%%25==0)cat(mode,b,'\n')
}
reps<-rbindlist(contrasts);fwrite(reps,file.path(out,'resample_contrasts.tsv'),sep='\t');fwrite(rbindlist(all_diag),file.path(out,'resample_features.tsv'),sep='\t')
summary_reps<-reps[,.(B=.N,valid_reps=sum(valid),median=median(difference,na.rm=TRUE),q025=quantile(difference,.025,na.rm=TRUE),q975=quantile(difference,.975,na.rm=TRUE)),by=.(mode,definition)]
summary_groups<-rbind(r[group=='METAB',.(definition='METAB285',n=.N,median_slope=median(slope),median_gamma=median(gamma),median_residual=median(residual_slope))],r[group=='ADF_profile',.(definition='ADF38',n=.N,median_slope=median(slope),median_gamma=median(gamma),median_residual=median(residual_slope))],r[group=='ADF_profile'&named==TRUE,.(definition='ADF25',n=.N,median_slope=median(slope),median_gamma=median(gamma),median_residual=median(residual_slope))])
adjust_summary<-list()
for(cv in unique(adj$covariate)){z<-adj[covariate==cv][match(universe$feat,feat)];adjust_summary[[cv]]<-contrast(z$slope,z$valid,cv,0)}
fwrite(rbindlist(adjust_summary),file.path(out,'adjusted_contrasts.tsv'),sep='\t')
write_json(list(n_genomes=nrow(g),n_clusters=ng,groups=summary_groups,max_slope_difference=max(abs(r$difference)),aggregation=agg[,.(units=.N,median=median(slope)),by=mode],resampling=summary_reps,adjusted=rbindlist(adjust_summary),seed=20260917,scope='Conditional annotation associations; no biological or causal function established.'),file.path(out,'summary.json'),pretty=TRUE,auto_unbox=TRUE,digits=16)
plot<-ggplot(r,aes(group,slope,fill=group))+geom_violin(alpha=.3)+geom_jitter(width=.13,alpha=.4,size=1)+theme_bw()+labs(x=NULL,y='Log-odds slope per log10 CDS',title='Standard GLM: fixed 285 domains and 38 profiles')+theme(legend.position='none')
ggsave(file.path(out,'primary_slopes.png'),plot,width=7,height=5,dpi=180)
print(summary_groups);print(summary_reps);print(rbindlist(adjust_summary))
