library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)
library(ggplot2)
library(tidyr)
if(grepl("normal",rtargetname)){

m <- sapply(1:nrep,function(x){wald_pnorm(repmle[[x]],p="m",real=0)})
s <- sapply(1:nrep,function(x){wald_pnorm(repmle[[x]],p="s",real=1)})

pm <- sapply(1:nrep,function(x){profilep_norm(repmle[[x]],"m",0)})
ps <- sapply(1:nrep,function(x){profilep_norm(repmle[[x]],"s",1)})

ppi_pval <- lapply(1:nrep,function(x){ppi_pnorm(repmle[[x]],nsamp=nsamp)})
ppidf <- (rbind_list(ppi_pval)
  %>% gather(key="par",value="pvals")
  %>% separate(par,c("method","par"),by="_")
)


pval_df <- data.frame(m=c(m,pm),s=c(s,ps),method=rep(c("Wald","profile"),nrep))
pval_df <- (pval_df 
  %>% gather(key="par",value="pvals", -method)
  %>% rbind(.,ppidf)
)



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

gg <- (ggplot(pval_df, aes(x=pvals))
	+ geom_histogram()
	+ facet_grid(par~method)
	+ theme_bw()
)

print(gg)
