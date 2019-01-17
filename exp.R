library(bbmle)
library(mvtnorm)
library(dplyr)
library(tidyr)
library(LaplacesDemon)

## ----sim data
set.seed(1202)

mlefit <- simExpmle(nsims=nobs, x=expr)

print(summary(mlefit))

dd <- ImpSamp(mlefit,nsamples=nsims, PDify=TRUE)

eff_samp <- effsamp(dd)
print(eff_samp) 

CIdat <- CIdf(mlefit,dd)	

print(CIdat)

repmle <- replicate(nrep, simExpmle(nsims=nobs,x=expr))


r <- sapply(1:nrep,function(x){wald_pexp(repmle[[x]],real=expr)})

pr <- sapply(1:nrep,function(x){profile_pexp(repmle[[x]],real=expr)})

ppi_pval <- lapply(1:nrep,function(x){ppi_pexp(repmle[[x]],nsamp=nsims,real=expr)})
ppidf <- (rbind_list(ppi_pval)
          %>% gather(key="par",value="pvals")
          %>% separate(par,c("method","par"),by="_")
)

pval_df <- data.frame(r=c(r,pr),method=rep(c("Wald","profile"),nrep))
pval_df <- (pval_df 
  %>% gather(key="par",value="pvals", -method)
  %>% rbind(.,ppidf)
)

print(pval_df)
