library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

## ----sim data
set.seed(1202)

mlefit10 <- simExpmle(nsims=nsim, x=1)

dd10 <- ImpSamp(mlefit10,nsamples=nsamp, PDify=TRUE)

eff_samp <- effsamp(dd10)
print(eff_samp) 

CIdat10 <- CIdf(mlefit10,dd10)	
print(CIdat10)

mlefit100 <- simExpmle(nsims = nsim*10, x=1)
dd100 <- ImpSamp(mlefit100, nsamples=nsamp, PDify=TRUE)
CIdat100 <- CIdf(mlefit100,dd100)

print(CIdat100)

mlefit1000 <- simExpmle(nsims = nsim*100, x=1)
dd1000 <- ImpSamp(mlefit1000, nsample=nsamp, PDify=TRUE)
CIdat1000 <- CIdf(mlefit1000,dd1000)

