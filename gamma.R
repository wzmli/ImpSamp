library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

## ----sim data
set.seed(1203)

mlefit <- simGammamle(nsims=nsim, gs=2, gm=20)

print(summary(mlefit))

dd <- ImpSamp(mlefit,nsamples=nsamp, PDify=TRUE)

eff_samp <- effsamp(dd)

print(CIdf(mlefit,dd))

repmle <- replicate(nrep, simGammamle(nsims=nsim, gs=2, gm=20))
