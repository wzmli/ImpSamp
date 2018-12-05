library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

## ----sim data
set.seed(1203)

mlefit <- simGammamle(nsims=nsim, gs=2, gm=20)

dd <- ImpSamp(mlefit,nsamples=nsamp, PDify=TRUE)

print(head(dd))

eff_samp <- 1/sum(dd[["imp_wts_norm"]]^2,na.rm=TRUE)
print(eff_samp) 


wq <- sapply(1:length(coef(mlefit))
  , function(x){Hmisc::wtd.quantile(dd[,x]
    , weights = dd[["imp_wts_norm"]]
    , probs = c(0.025, 0.975)
    , normwt = TRUE
    )
  }
)
print(t(wq))
print(confint(mlefit))


