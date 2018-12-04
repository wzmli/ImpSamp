## nb
library(bbmle)
library(MASS)
library(mvtnorm)

set.seed(1204)

cases <- c(4, 1, 3, 6, 13, 4, 3, 7, 20, 32, 30, 19, 14, 41, 43)

r <- rnorm(length(cases),0.5,0.01)
t <- 1:length(cases)

if(!grepl("data",rtargetname)){
	cases <- round(exp(r*t))
}

plot(t,cases)
dat <- data.frame(t,cases)

glmfit <- glm(cases ~ t, data = dat, family = "poisson")

cest <- coef(glmfit)
print(cest)
vv <- vcov(glmfit)
mv_samps <- rmvnorm(nsamp, mean = cest, sigma = vv)

nbglmll <- function(int,r){
	unclass(
		logLik(
			glm(cases ~  offset(rep(int,length(cases)) + r*t), data=dat, family="poisson")
			)
		)[1]
}

like_wt_l <- sapply(1:nsamp
	, function(x){
		nbglmll(int=mv_samps[x,1],r=mv_samps[x,2])
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
print(confint(glmfit, method="profile"))
print(quantile(mv_samps[,2], c(0.025,0.975)))



