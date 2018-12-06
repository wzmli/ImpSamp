## nb
library(epigrowthfit)
library(bbmle)
library(MASS)
library(mvtnorm)

cases <- c(4, 1, 3, 6, 13, 4, 3, 7, 20, 32, 30, 19, 14, 41, 43)
#cases <- c(2, 4, 1, 4, 8, 8, 8, 7, 10, 19, 7)

time <- 1:length(cases)

plot(t,cases)
dat <- data.frame(time,cases)

epifit <- epigrowthfit(data = dat
	, deaths_var = "cases"
	, optimizer = "nlminb"
	, verbose = TRUE
	, distrib = "poisson"
	, model = "exp"
	, drop_mle2_call = FALSE
)


cest <- coef(epifit@mle2)
vv <- vcov(epifit@mle2)

mv_samps <- rmvnorm(nsamp, mean = cest, sigma = vv)

egf_expll <- function(rr,xx){
  -epifit@mle2@call$minuslogl(list(r = rr, x0=xx))
}

like_wt_l <- sapply(1:nsamp
	, function(x){
		egf_expll(rr=mv_samps[x,1], xx=mv_samps[x,2])
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

wtq <- t(wq)
proCI<- confint(epifit@mle2)

r <- quantile(mv_samps[,1],c(0.025,0.975))
x0 <- quantile(mv_samps[,2],c(0.025,0.975))

wald <- confint(epifit@mle2, method="quad")


lower <- c(proCI[,1],wtq[,1],r[1],x0[1],wald[,1])
upper <- c(proCI[,2],wtq[,2],r[2],x0[2],wald[,2])

mleest <- rep(coef(epifit@mle2),4)
par <- rep(rownames(vcov(epifit@mle2)),4)
type <- rep(c("profile","impSamp","ppi","wald"),each=2)
CIdat <- data.frame(type,lower,mleest,upper,par)


