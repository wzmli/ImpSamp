## 

library(epigrowthfit)
library(dplyr)


#repexpfit <- lapply(1:ncol(repcases), function(x){
# 	dat <- data.frame(time = 1:tsteps, cases=repcases[,x])  
# 	expfit <- epigrowthfit(data=dat
# 		, deaths_var = "cases"
# 		, optimizer = "nlminb"
# 		, verbose = FALSE
# 		, distrib = "poisson"
# 		, model = "exp"
# 		, drop_mle2_call = FALSE
# 	)
# 	return(expfit)
# 	}
# )

replogistfit <- lapply(1:ncol(repcases), function(x){
	dat <- data.frame(time = 1:tsteps, cases = repcases[,x])
	logisticfit <- epigrowthfit(data=dat
		, deaths_var = "cases"
		, optimizer = "nlminb"
		, verbose = TRUE
		, distrib = "nbinom"
		, model = "logistic"
		, drop_mle2_call = FALSE
		, optCtrl=list(eval.max=1e5,iter.max=1e5)
	)
	print(x)
	return(logisticfit)
	}
)


