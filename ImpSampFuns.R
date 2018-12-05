

ImpSamp <- function(mle2obj, nsamples, tdist=FALSE, tdf=NULL, PDify){

vv <- vcov(mle2obj)
cest <- coef(mle2obj)

if(mle2obj@details$convergence > 0){
	return("mle did not converge")
}

if(PDify){
	vv <- as.matrix(Matrix::nearPD(vv)$mat)
}

if(tdist){	
	mv_samps <- rmvt(nsamp, mu = cest, S=vv, df=tdf)
	if(length(cest) == 1){mv_samps <- matrix(mv_samps,ncol=1)}
	sample_wt_l <- sapply(1:nsamples
		, function(x){
			dmvt(mv_samps[x,]
				, mu = cest
				, S = vv
				, df = tdf
				, log = TRUE
			)
		}
	)
}

if(length(cest) == 1){
	vv <- sqrt(vv)
	mv_samps <- rnorm(nsamples,mean=cest, sd=vv)
	sample_wt_l <- sapply(1:nsamples
		, function(x){
			dnorm(mv_samps[x], mean=cest, sd=vv, log=TRUE)
		}
	)
	like_wt_l <- sapply(1:nsamples
	   , function(x){
	      -mle2obj@minuslogl(mv_samps[x])	
	   }
	)
}

if(length(cest)>1){
	mv_samps <- rmvnorm(nsamples, mean = cest, sigma=vv)
	sample_wt_l <- sapply(1:nsamples
		, function(x){
			dmvnorm(mv_samps[x,]
				, mean = cest
				, sigma = vv
				, log = TRUE
			)
		}
	)


like_wt_l <- sapply(1:nsamples
	, function(x){
		-mle2obj@minuslogl(mv_samps[x,1],mv_samps[x,2])	
	}
)
}

Log_imp_wts <- like_wt_l - sample_wt_l


Log_scaled_imp_wts <- Log_imp_wts - max(Log_imp_wts,na.rm=TRUE)

imp_wts <- exp(Log_scaled_imp_wts)

imp_wts_norm <- imp_wts/sum(imp_wts,na.rm=TRUE) 

#if(length(imp_wts_norm[which(imp_wts_norm>0.5)])){
#  imp_wts_norm[which(imp_wts_norm>0.5)] <- median(imp_wts_norm)
#}

imp_wts_norm <- imp_wts_norm/sum(imp_wts_norm,na.rm=TRUE) 

df <- data.frame(mv_samps, like_wt_l, sample_wt_l, imp_wts_norm,index=1:nsamples)
return(df)
}


effsamp <- function(x){
	return(1/sum(x[["imp_wts_norm"]]^2,na.rm=TRUE))
}

wq <- function(df){
	npars <- ncol(df)-4
	sapply(1:npars
		, function(x){Hmisc::wtd.quantile(df[,x]
			,weights = df[["imp_wts_norm"]]
			, probs = c(0.025, 0.975)
			, normwt = TRUE
			)
		}
	)
}

quanti <- function(df){
	npars <- ncol(df) - 4
	sapply(1:npars
		, function(x){
			quantile(df[,x], c(0.025,0.975))
		}
	)
}

CIdf <- function(mleobj,df){
	npars <- length(coef(mleobj))
	wtq <- wq(df)
	wtq <- t(wtq)
	ppi <- quanti(df)
	ppi <- t(ppi)
	proCI <- confint(mleobj)
	WaldCI <- confint(mleobj,method="quad")
	type <- rep(c("profile", "impSamp", "ppi", "Wald"),each=npars)

	mleest <- rep(coef(mleobj),4)
	lower <- c(proCI[,1], wtq[,1], ppi[,1], WaldCI[,1])
	upper <- c(proCI[,2], wtq[,2], ppi[,2], WaldCI[,2])
	par <- rep(rownames(proCI),4)

	dd <- data.frame(type, par, lower, upper, mleest)
}
