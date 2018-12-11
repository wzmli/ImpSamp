library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

if(grepl("normal",rtargetname)){

m <- sapply(1:nrep,function(x){pvalues(repmle[[x]],"m",nmean)})
s <- sapply(1:nrep,function(x){pvalues(repmle[[x]],"s",nsd)})

pval_df <- data.frame(m=m,s=s)
}

if(grepl("exp", rtargetname)){
	print(hist(sapply(1:nrep,function(x){pvalues(repmle[[x]],"r",expr)}),main="r"))
	pval_df <- NULL
}

if(grepl("gamma", rtargetname)){
m <- sapply(1:nrep,function(x){pvalues(repmle[[x]],"m",gm)})
s <- sapply(1:nrep,function(x){pvalues(repmle[[x]],"s",gs)})

pval_df <- data.frame(m=m,s=s)
}

if(!is.null(col(pval_df))){
	for(i in 1:ncol(pval_df)){
		print(hist(pval_df[,i],main=colnames(pval_df)[i]))
	}
}
