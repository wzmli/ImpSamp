library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

## ----sim data
set.seed(1211)

mlefit <- simNormalmle(nsims=nsim, x=nmean, y=nsd)

dd <- ImpSamp(mlefit,nsamples=nsamp, PDify=TRUE)

eff_samp <- effsamp(dd)
print(eff_samp) 

print(CIdf(mlefit,dd))

repmle <- replicate(nrep ,simNormalmle(nsims=nsim,x=nmean,y=nsd))

repdd <- lapply(1:nrep
	, function(x){
		dd <- ImpSamp(repmle[[x]],nsamples=nsamp,PDify=TRUE)
		df <- data.frame(CIdf(repmle[[x]],dd),rep=x,truePar=rep(c(nmean,nsd),4))
		return(df)
	}
)

print(repdd)

