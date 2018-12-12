library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)
library(ggplot2)
library(tidyr)
if(grepl("normal",rtargetname)){

m <- sapply(1:nrep,function(x){waldp(repmle[[x]],"m",nmean)})
s <- sapply(1:nrep,function(x){waldp(repmle[[x]],"s",nsd)})

pm <- sapply(1:nrep,function(x){profilep_norm(repmle[[x]],"m",nmean)})
ps <- sapply(1:nrep,function(x){profilep_norm(repmle[[x]],"s",nsd)})


pval_df <- data.frame(m=c(m,pm),s=c(s,ps),method=rep(c("Wald","profile"),nrep))


}

if(grepl("exp", rtargetname)){
	print(hist(sapply(1:nrep,function(x){waldp(repmle[[x]],"r",expr)}),main="r"))
	pval_df <- NULL
}

if(grepl("gamma", rtargetname)){
m <- sapply(1:nrep,function(x){waldp(repmle[[x]],"m",gm)})
s <- sapply(1:nrep,function(x){waldp(repmle[[x]],"s",gs)})

pval_df <- data.frame(m=m,s=s)
}

#if(!is.null(col(pval_df))){
#	for(i in 1:ncol(pval_df)){
#		print(hist(pval_df[,i],main=paste(method,colnames(pval_df)[i])))
#	}
#}

pval_df <- pval_df %>% gather(key="par",value="pvals", -method) 

gg <- (ggplot(pval_df, aes(x=pvals))
	+ geom_histogram()
	+ facet_grid(par~method)
	+ theme_bw()
)

print(gg)
