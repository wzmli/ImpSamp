library(bbmle)
library(mvtnorm)
library(dplyr)

## ----sim data
set.seed(1203)

rr <- 1
simdat <- rexp(nsim,rate=rr)

sample_mean <- mean(simdat) 


## another way to do the mle step without using global data
dd <- data.frame(dat = simdat)

suppressWarnings(mlefit <- mle2(dat ~ dexp(rate=r)
	, start = list(r = sample_mean)
	, data = dd
	)
)


print(mlefit)

vv <- vcov(mlefit)
cest <- coef(mlefit)


## using estimated parameters to simulate MVN parameter samples 

mv_samps <- rnorm(nsamp, mean = cest, sd=sqrt(vv))



## imp_wts

like_wt_l <- sapply(1:nsamp
	, function(x){
		sum(dexp(simdat,mv_samps[x],log=TRUE))
	}
)

sample_wt_l <- sapply(1:nsamp
	, function(x){
		dnorm(mv_samps[x]
   		, mean = coef(mlefit)
      	, sd = sqrt(vv)
      	, log = TRUE
      )
    }
)


Log_imp_wts <- like_wt_l - sample_wt_l

# Log_imp_wts[is.na(Log_imp_wts)] <- 0


Log_scaled_imp_wts <- Log_imp_wts - max(Log_imp_wts,na.rm=TRUE)

imp_wts <- exp(Log_scaled_imp_wts)

imp_wts_norm <- imp_wts/sum(imp_wts, na.rm=TRUE) 

print(imp_wts_norm)

eff_samp <- 1/sum(imp_wts_norm^2,na.rm=TRUE)
print(eff_samp) 

imp_wts_norm[is.na(imp_wts_norm)] <- 0

print(imp_wts_norm)

wq <- sapply(1:nrow(vv)
  , function(x){Hmisc::wtd.quantile(mv_samps
    , weights = imp_wts_norm
    , probs = c(0.025, 0.975)
    , normwt = TRUE
    )
  }
)
print(t(wq))
print(confint(mlefit))
print(quantile(mv_samps, c(0.025, 0.975)))


