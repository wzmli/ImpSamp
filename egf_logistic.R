## nb
library(epigrowthfit)
library(bbmle)
library(MASS)
library(mvtnorm)

cases <- c(4, 1, 3, 6, 13, 4, 3, 7, 20, 32, 30, 19, 14, 41, 43)

r <- rnorm(length(cases),0.5,0.01)
time <- 1:length(cases)

if(!grepl("data",rtargetname)){
	cases <- round(exp(r*time))
}

plot(t,cases)
dat <- data.frame(time,cases)

epifit <- epigrowthfit(data = dat
	, deaths_var = "cases"
	, optimizer = "nlminb"
	, verbose = TRUE
	, distrib = "poisson"
	, model = "logistic"
	, drop_mle2_call = FALSE
)


cest <- coef(epifit@mle2)
vv <- vcov(epifit@mle2)

print(cest)
print(vv)

mv_samps <- rmvnorm(nsamp, mean = cest, sigma = vv)

egf_expll <- function(rr,xx,kk){
  -epifit@mle2@call$minuslogl(list(r = rr, x0=xx, K=kk))
}

like_wt_l <- sapply(1:nsamp
	, function(x){
		egf_expll(rr=mv_samps[x,1], xx=mv_samps[x,2], kk=mv_samps[x,3])
	}
)

sample_wt_l <- sapply(1:nsamp
	, function(x){
		dmvnorm(mv_samps[x,]
			, mean = cest
			, sigma = vv
			, log=TRUE
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

print(t(wq))


print(log(growthRate(epifit)))

quit()
print(confint(epifit@mle2))



quit()

