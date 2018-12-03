library(bbmle)
library(mvtnorm)
library(dplyr)

## ----sim data
set.seed(1203)

gs <- 1
gm <- 20

simdat <- rgamma(nsim, shape=gs, scale=gm/gs)

sample_mean <- mean(simdat) 
sample_shape <- sample_mean^2/var(simdat) 


## another way to do the mle step without using global data
dd <- data.frame(dat = simdat)

suppressWarnings(mlefit <- mle2(dat ~ dgamma(shape=s,scale=m/s)
	, start = list(s = gs, m = gm)
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
		sum(dgamma(simdat
			, shape = mv_samps[x,1]
			, scale = mv_samps[x,2]/mv_samps[x,1]
			,log=TRUE)
			)
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


Log_scaled_imp_wts <- Log_imp_wts - max(Log_imp_wts)

imp_wts <- exp(Log_scaled_imp_wts)

imp_wts_norm <- imp_wts/sum(imp_wts) 


eff_samp <- 1/sum(imp_wts_norm^2)
print(eff_samp) 

wq <- sapply(1:nrow(vv)
  , function(x){Hmisc::wtd.quantile(mv_samps[,x]
    , weights = imp_wts
    , probs = c(0.025, 0.975)
    , normwt = TRUE
    )
  }
)
print(t(wq))
print(confint(mlefit))


