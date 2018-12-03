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

## using estimated parameters to simulate MVN parameter samples 

mv_samps <- rmvnorm(nsamp, mean = cest, sigma=vv)

## imp_wts

like_wt_l <- sapply(1:nsamp
	, function(x){
		sum(dnorm(simdat,mean = mv_samps[x,1], sd = exp(mv_samps[x,2]),log=TRUE))
	}
)

sample_wt_l <- sapply(1:nsamp
	, function(x){
		dmvnorm(mv_samps[x,]
   		, mean = coef(mlefit)
      	, sigma=vv
      	, log = TRUE
      )
    }
)



Log_imp_wts <- like_wt_l - sample_wt_l


Log_scaled_imp_wts <- Log_imp_wts - max(Log_imp_wts,na.rm=TRUE)

imp_wts <- exp(Log_scaled_imp_wts)

imp_wts_norm <- imp_wts/sum(imp_wts,na.rm=TRUE) 


eff_samp <- 1/sum(imp_wts_norm^2,na.rm=TRUE)
print(eff_samp) 

imp_wts_norm[is.na(imp_wts_norm)] <- 0

wq <- sapply(1:nrow(vv)
  , function(x){Hmisc::wtd.quantile(mv_samps[,x]
    , weights = imp_wts_norm
    , probs = c(0.025, 0.975)
    , normwt = TRUE
    )
  }
)
print(t(wq))
print(confint(mlefit))

