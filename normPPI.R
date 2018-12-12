library(bbmle)
library(mvtnorm)
library(dplyr)
library(tidyr)
library(LaplacesDemon)

nsim <- 1e2

nsamp <- 1e2

nrep <- 1e3

## distribution parameters

nmean <- 0
nsd <- 1

## ----sim data
set.seed(1202)

repmle <- replicate(nrep ,simNormalmle(nsims=nsim,x=nmean,y=nsd))


ppi_pval <- lapply(1:nrep
	, function(x){
		ppi_pnorm(repmle[[x]]
			, nsamp=nsamp
			, realm = nmean
			, reals = nsd
		)
	}
)

print(ppi_pval)
