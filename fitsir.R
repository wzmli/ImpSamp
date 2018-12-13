## 

library(epigrowthfit)
library(dplyr)


epiexpfit <- lapply(1:ncol(epidat), function(x){
 	dat <- data.frame(time = 1:nrow(epidat), cases=epidat[,x])  
 	expfit <- epigrowthfit(data=dat
 		, deaths_var = "cases"
 		, optimizer = "nlminb"
 		, verbose = FALSE
 		, distrib = "poisson"
 		, model = "exp"
 		, drop_mle2_call = FALSE
 	)
 	return(c(growthRate(expfit),winWidth = length(window(expfit))))
 	}
)

epilogfit <- lapply(1:ncol(epidat), function(x){
	dat <- data.frame(time = 1:nrow(epidat), cases = epidat[,x])
	logisticfit <- epigrowthfit(data=dat
		, deaths_var = "cases"
		, optimizer = "nlminb"
		, verbose = TRUE
		, distrib = "poisson"
		, model = "logistic"
		, drop_mle2_call = FALSE
	)
	return(c(growthRate(logisticfit),winWidth = length(window(logisticfit))))
	}
)

