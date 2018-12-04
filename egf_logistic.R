## nb
library(epigrowthfit)
library(bbmle)
library(MASS)
library(mvtnorm)
library(LaplacesDemon)

set.seed(1203)

cases <- c(4, 1, 3, 6, 13, 4, 3, 7, 20, 32, 30, 19, 14, 41, 43)

time <- 1:length(cases)

dat <- data.frame(time,cases)

epifit <- epigrowthfit(data = dat
	, deaths_var = "cases"
	, optimizer = "nlminb"
	, verbose = TRUE
	, distrib = "poisson"
	, model = "logistic"
	, drop_mle2_call = FALSE
	, optCtrl=list(eval.max=1e5,iter.max=1e5)
)

print(epifit@mle2@details$convergence)

cest <- coef(epifit@mle2)
vv <- vcov(epifit@mle2)

print(cest)
print(vv)

vv <- vv[-2,]
vv <- vv[,-2]

print(logLik(epifit@mle2))


mv_samps <- rmvnorm(nsamp, mean = cest[-2], sigma = vv)


sample_wt_l <- sapply(1:nsamp
	, function(x){
		dmvnorm(mv_samps[x,]
			, mean = cest[-2]
			, sigma = vv
			, log=TRUE
		)
	}
)

if(grepl("mvt",rtargetname)){
	vv <- as.matrix(Matrix::nearPD(vv)$mat)
	mv_samps <- rmvt(nsamp, mu = cest[-2], S = vv, df=3)
	sample_wt_l <- sapply(1:nsamp
		, function(x){
			dmvt(mv_samps[x,]
				, mu = cest[-2]
				, S = vv
				, df = 3
				, log = TRUE
			)
		}
	)
}

egf_expll <- function(rr,xx,kk,LL.K){
  -epifit@mle2@call$minuslogl(list(r = rr, x0=xx, K=kk))
}

like_wt_l <- sapply(1:nsamp
	, function(x){
		egf_expll(rr=mv_samps[x,1]
			, xx=cest[2] #mv_samps[x,2]
			, kk=mv_samps[x,2]
		)
	}
)



Log_imp_wts <- like_wt_l - sample_wt_l

Log_scaled_imp_wts <- Log_imp_wts - max(Log_imp_wts,na.rm=TRUE)

imp_wts <- exp(Log_scaled_imp_wts)

imp_wts_norm <- imp_wts/sum(imp_wts, na.rm=TRUE)

eff_samp <- 1/sum(imp_wts_norm^2, na.rm=TRUE)

print(eff_samp)

wq <- sapply(1:nrow(vv)
	, function(x){Hmisc::wtd.quantile(mv_samps[,x]
		, weights = imp_wts_norm
		, probs = c(0.025, 0.975)
		, normwt = TRUE
		)
	}
)

print(quantile(mv_samps[,1],c(0.025,0.975)))

print(t(wq))
pp <- profile(epifit@mle2)
print(confint(pp))

print(log(growthRate(epifit)))
