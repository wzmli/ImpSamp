library(bbmle)
library(mvtnorm)
library(dplyr)

## ----sim data
set.seed(1203)
simdat <- rnorm(nsim)

sample_mean <- mean(simdat) 
sample_sd_log <- log(sd(simdat))


## another way to do the mle step without using global data
dd <- data.frame(dat = simdat)

suppressWarnings(mlefit <- mle2(dat ~ dnorm(mean=m,sd=exp(sd_log))
	, start = list(m = sample_mean, sd_log = sample_sd_log)
	, data = dd
	)
)


print(mlefit)

vv <- vcov(mlefit)
cest <- coef(mlefit)

dd <- ImpSamp(mlefit,nsamples=nsamp,PDify=TRUE)

eff_samp <- 1/sum(dd[["imp_wts_norm"]]^2,na.rm=TRUE)
print(eff_samp) 


wq <- sapply(1:nrow(vv)
  , function(x){Hmisc::wtd.quantile(dd[,x]
    , weights = dd[["imp_wts_norm"]]
    , probs = c(0.025, 0.975)
    , normwt = TRUE
    )
  }
)
print(t(wq))
print(confint(mlefit))


