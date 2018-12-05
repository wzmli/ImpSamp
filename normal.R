library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

## ----sim data
set.seed(1203)
simdat <- rnorm(nsim)

sample_mean <- mean(simdat) 
sample_sd <- sd(simdat) 

t <- FALSE
## another way to do the mle step without using global data
dd <- data.frame(dat = simdat)

suppressWarnings(mlefit <- mle2(dat ~ dnorm(mean=m,sd=s)
	, start = list(m = sample_mean, s = sample_sd)
	, data = dd
	)
)


print(mlefit)

vv <- vcov(mlefit)
cest <- coef(mlefit)

dd <- ImpSamp(mlefit,nsamples=nsamp, PDify=TRUE)

print(summary(dd))

print(dd)

quit()

## using estimated parameters to simulate MVN parameter samples 

mv_samps <- rmvnorm(nsamp, mean = cest, sigma=vv)

if(t){
	vv <- as.matrix(Matrix::nearPD(vv)$mat)
	mv_samps <- rmvt(nsamp, mu = cest, S=vv, df=2)
}

## imp_wts

like_wt_l <- sapply(1:nsamp
	, function(x){
		sum(dnorm(simdat,mv_samps[x,1], mv_samps[x,2],log=TRUE))
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

if(t){
	sample_wt_l <- sapply(1:nsamp
		, function(x){
			dmvt(mv_samps[x,]
				, mu = cest
				, S = vv
				, df = 2
				, log = TRUE
			)
		}
	)
}

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


