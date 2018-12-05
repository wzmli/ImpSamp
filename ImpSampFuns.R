

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
			dnorm(mv_samps, mean=cest, sd=vv, log=TRUE)
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
}


like_wt_l <- sapply(1:nsamples
	, function(x){
		mle2obj@minuslogl(mv_samps[x,1],mv_samps[x,2])	
	}
)

Log_imp_wts <- like_wt_l - sample_wt_l


Log_scaled_imp_wts <- Log_imp_wts - max(Log_imp_wts,na.rm=TRUE)

imp_wts <- exp(Log_scaled_imp_wts)

imp_wts_norm <- imp_wts/sum(imp_wts,na.rm=TRUE) 

df <- data.frame(mv_samps, like_wt_l, sample_wt_l, imp_wts_norm)
return(df)
}



