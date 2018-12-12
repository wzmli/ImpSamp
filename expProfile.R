library(bbmle)
library(mvtnorm)
library(dplyr)
library(tidyr)
library(LaplacesDemon)

nsim <- 1e2

nrep <- 2e3


## distribution parameters

expr <- 1

## ----sim data
set.seed(1202)

repmle <- replicate(nrep, simExpmle(nsims=nsim,x=expr))

pr <- sapply(1:nrep,function(x){profile_pexp(repmle[[x]],real=1)})

print(hist(pr, breaks=seq(0, 1, by=0.05)))



repmle <- replicate(nrep, simExpmle(nsims=nsim,x=expr))

pr <- sapply(1:nrep,function(x){profile_pexp(repmle[[x]],real=1)})

print(hist(pr, breaks=seq(0, 1, by=0.05)))


