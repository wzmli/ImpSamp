library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

## ----sim data
set.seed(1203)

mlefit <- simNormalmle(nsims=nsim, x=nmean, y=nsd)

dd <- ImpSamp(mlefit,nsamples=nsamp, PDify=TRUE)

eff_samp <- effsamp(dd)
print(eff_samp) 

print(CIdf(mlefit,dd))

repmle <- replicate(nrep ,simNormalmle(nsims=nsim,x=nmean,y=nsd))

