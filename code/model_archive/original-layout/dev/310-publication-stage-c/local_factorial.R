suppressPackageStartupMessages({library(data.table);library(MASS);library(jsonlite)})
p <- 'dev/310-publication-stage-c';o<-file.path(p,'results');dir.create(o,showWarnings=FALSE)
d<-fread('dev/280-publication-stage-a/local/votu_input.tsv')
d<-d[!is.na(checkv_completeness) & lifestyle %in% c('temperate','virulent')]
stopifnot(nrow(d)==3013,uniqueN(d$vOTU_id)==3013)
for(nm in c('vibrant_type','genomad_topology','replidec_lifestyle'))d[is.na(get(nm)),(nm):='']
d[,alt:=ifelse(vibrant_type=='lysogenic' | genomad_topology=='Provirus' | replidec_lifestyle=='temperate','temperate','virulent')]
stopifnot(sum(d$lifestyle!=d$alt)==16,sum(d$alt=='temperate')==244)
rows<-list()
for(label in c('original','without_checkv'))for(correction in c('original','viral_region')){
 z<-copy(d);z[,group:=factor(if(label=='original')lifestyle else alt,levels=c('virulent','temperate'))]
 z[,N:=if(correction=='original')filtered_all else filtered_all-filtered_host-filtered_crossing]
 z[,kb:=(if(correction=='original')contig_length else viral_length)/1000]
 stopifnot(all(z$N>=0),all(z$kb>0));warnings<-character()
 m<-withCallingHandlers(glm.nb(N~group+checkv_completeness+offset(log(kb)),data=z,control=glm.control(maxit=100)),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
 co<-coef(summary(m))['grouptemperate',];rows[[length(rows)+1]]<-data.table(label,correction,n=nrow(z),temperate=sum(z$group=='temperate'),hits=sum(z$N),temperate_hits=sum(z[group=='temperate']$N),irr=exp(co[1]),lo=exp(co[1]-1.96*co[2]),hi=exp(co[1]+1.96*co[2]),p=co[4],converged=m$converged,theta=m$theta,warnings=paste(unique(warnings),collapse=' | '))
}
x<-rbindlist(rows)
expected<-c(2.520701248780353,1.049622,0.9508111663719426)
got<-c(x[label=='original'&correction=='original',irr],x[label=='original'&correction=='viral_region',irr],x[label=='without_checkv'&correction=='original',irr])
stopifnot(all(abs(expected-got)<1e-6),all(x$converged))
fwrite(x,file.path(o,'local_factorial.tsv'),sep='\t');fwrite(d[,.(vOTU_id,lifestyle,alt,filtered_all,filtered_host,filtered_crossing,contig_length,viral_length,checkv_completeness)],file.path(o,'local_factorial_input.tsv'),sep='\t')
write_json(list(anchor_expected=expected,anchor_observed=got,R=R.version.string,MASS=as.character(packageVersion('MASS')),scope='Fixed completeness, same rows; definition sensitivity, not causal decomposition'),file.path(o,'local_factorial_run.json'),pretty=TRUE,auto_unbox=TRUE);print(x)
