library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

## ----sim data
set.seed(1202)

mlefit <- simExpmle(nsims=nsim, x=expr)

print(summary(mlefit))

dd <- ImpSamp(mlefit,nsamples=nsamp, PDify=TRUE)

eff_samp <- effsamp(dd)
print(eff_samp) 

CIdat <- CIdf(mlefit,dd)	

print(CIdat)

repmle <- replicate(nrep, simExpmle(nsims=nsim,x=expr))

