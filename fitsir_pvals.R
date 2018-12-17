library(bbmle)
library(epigrowthfit)
library(mvtnorm)
library(dplyr)
library(tidyr)


nsamp <- 1000
r <- b - g
logr <- log(r)

epimle <- lapply(epilogfit, function(x){x@mle2})

r <- sapply(1:nrep,function(x){wald_plogistic(epimle[[x]],real=logr)})

pr <- sapply(1:nrep, function(x){profile_plogistic(epimle[[x]],real=logr)})



#ppi_pval <- lapply(1:nrep,function(x){
#  print(x)
#	ppi_plogistic(epimle[[x]],nsamp=nsamp,real=logr)
#	}
#)

#ppidf <- (rbind_list(ppi_pval)
#	%>% gather(key="par",value="pvals")
#	%>% separate(par,c("method","par"),by="_")
#)

pval_df <- data.frame(r=c(r,pr), method=rep(c("Wald","profile"),nrep))
pval_df <- (pval_df
	%>% gather(key="par",value="pvals",-method)
#	%>% rbind(.,ppidf)
)
	


