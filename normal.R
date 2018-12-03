library(bbmle)
library(mvtnorm)

## ----sim data
set.seed(1203)
simdat <- rnorm(nsim)

sample_mean <- mean(simdat) 
sample_sd <- sd(simdat) 

dd <- data.frame(dat = simdat)

suppressWarnings(mlefit <- mle2(dat ~ dnorm(mean=m,sd=s)
	, start = list(m = sample_mean, s = sample_sd)
	, data = dd
	)
)


print(mlefit)

vv <- vcov(mlefit)
cest <- coef(mlefit)

mv_samps <- rmvnorm(nsamp, mean = cest, sigma=vv)
print(summary(mv_samps))


quit()
## ----imp_wts
like_wt_l <- sapply(1:samp_size,function(x){-nll(mv_samps[x,1], mv_samps[x,2])})

sample_wt_l <- sapply(1:samp_size
  , function(x){dmvnorm(mv_samps[x,]
      , mean = coef(mlefit)
      , sigma=vv
      , log = TRUE
      )
    }
)

Log_imp_wts <- like_wt_l - sample_wt_l
print(summary(Log_imp_wts))

Log_scaled_imp_wts <- Log_imp_wts - max(Log_imp_wts)
print(summary(Log_scaled_imp_wts))

imp_wts <- exp(Log_scaled_imp_wts)
imp_wts <- imp_wts/sum(imp_wts) 
print(summary(imp_wts))


## ----eff_samp------------------------------------------------------------
eff_samp <- 1/sum(imp_wts^2)
print(eff_samp) 

## ----wq------------------------------------------------------------------
wq <- sapply(1:2
  , function(x){Hmisc::wtd.quantile(mv_samps[,x]
    , weights = imp_wts
    , probs = c(0.025, 0.975)
    , normwt = TRUE
    )
  }
)
print(t(wq))
print(confint(mlefit))


