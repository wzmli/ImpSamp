library(bbmle)
library(mvtnorm)
library(dplyr)
library(tidyr)
library(LaplacesDemon)

## ----sim data
set.seed(1211)


mlefit <- simNormalmle(nsims=nobs, x=nmean, y=nsd)

dd <- ImpSamp(mlefit,nsamples=nsims, PDify=TRUE)

eff_samp <- effsamp(dd)
print(eff_samp) 

print(CIdf(mlefit,dd))

repmle <- replicate(nrep ,simNormalmle(nsims=nobs,x=nmean,y=nsd))

repdd <- lapply(1:nrep
	, function(x){
		dd <- ImpSamp(repmle[[x]],nsamples=nsims,PDify=TRUE)
		df <- data.frame(CIdf(repmle[[x]],dd),rep=x,truePar=rep(c(nmean,nsd),4))
		return(df)
	}
)

print(repdd)

m <- sapply(1:nrep,function(x){wald_pnorm(repmle[[x]],p="m",real=nmean)})
s <- sapply(1:nrep,function(x){wald_pnorm(repmle[[x]],p="s",real=nsd)})

pm <- sapply(1:nrep,function(x){profile_pnorm(repmle[[x]],"m",real=nmean)})
ps <- sapply(1:nrep,function(x){profile_pnorm(repmle[[x]],"s",real=nsd)})

ppi_pval <- lapply(1:nrep,function(x){ppi_pnorm(repmle[[x]],nsamp=nsamp,realm=nmean, reals=nsd)})
ppidf <- (rbind_list(ppi_pval)
          %>% gather(key="par",value="pvals")
          %>% separate(par,c("method","par"),by="_")
)


pval_df <- data.frame(m=c(m,pm),s=c(s,ps),method=rep(c("Wald","profile"),nrep))
pval_df <- (pval_df 
            %>% gather(key="par",value="pvals", -method)
            %>% rbind(.,ppidf)
)


