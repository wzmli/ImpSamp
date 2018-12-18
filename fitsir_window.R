##
library(epigrowthfit)
library(bbmle)


epilogfit <- lapply(1:ncol(epidat), function(x){
	dat <- data.frame(time = 1:nrow(epidat), cases = epidat[,x])
	logisticfit <- epigrowthfit(data=dat
	, deaths_var = "cases"
	, optimizer = "nlminb"
	, verbose = TRUE
#       , distrib = "poisson"
	, model = "logistic"
	, first = 18
	, peak = 27
	, drop_mle2_call = FALSE
	, optCtrl=list(eval.max=1e5,iter.max=1e5)
	)
#	return(logisticfit)
	return(c(growthRate(logisticfit)))
#	return(window(logisticfit))
	}
)


