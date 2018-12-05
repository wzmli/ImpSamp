library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

## ----sim data
set.seed(1203)

mlefit <- simExpmle(nsims=nsim, x=1)

dd <- ImpSamp(mlefit,nsamples=nsamp, PDify=TRUE)

eff_samp <- effsamp(dd)
print(eff_samp)

CIdat <- CIdf(mlefit,dd)   
print(CIdat)


