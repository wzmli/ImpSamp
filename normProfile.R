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

pm <- sapply(1:nrep,function(x){profile_pnorm(repmle[[x]],"m", nmean)})
# ps <- sapply(1:nrep,function(x){profile_pnorm(repmle[[x]],"s", nsd)})

print(hist(pm, breaks=seq(0, 1, by=0.05)))

