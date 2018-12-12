library(bbmle)
library(mvtnorm)
library(dplyr)
library(tidyr)
library(LaplacesDemon)

nsim <- 1e2

nrep <- 2e3

## distribution parameters

nmean <- 0
nsd <- 1

## ----sim data
set.seed(1202)

repmle <- replicate(nrep ,simNormalmle(nsims=nsim,x=nmean,y=nsd))

m <- sapply(1:nrep,function(x){wald_pnorm(repmle[[x]],p="m",real=nmean)})

print(hist(m, breaks=seq(0, 1, by=0.05)))

