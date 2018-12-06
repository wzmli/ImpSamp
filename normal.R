library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

## ----sim data
set.seed(1203)

mlefit10 <- simNormalmle(nsims=nsim, x=0, y=1)

dd10 <- ImpSamp(mlefit10,nsamples=nsamp, PDify=TRUE)

eff_samp <- effsamp(dd10)
print(eff_samp) 

print(CIdf(mlefit10,dd10))
