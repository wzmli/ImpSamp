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

#repcases <- repcases[,1:20]

replogistfit <- lapply(1:ncol(repcases), function(x){
	dat <- data.frame(time = 1:tsteps, cases = repcases[,x])
	fakepeak <- which(dat$cases == max(dat$cases))
	newpeak <- fakepeak - ceiling(fakepeak*0.2)
	mod <- try(logisticfit <- epigrowthfit(data=dat
		, deaths_var = "cases"
		, optimizer = "nlminb"
		, verbose = TRUE
#		, distrib = "nbinom"
		, model = "logistic"
		, peak = newpeak
		, drop_mle2_call = FALSE
		, optCtrl=list(eval.max=1e6,iter.max=1e6)
	), silent=TRUE)
	print(x)
	if(class(mod) != "epigrowthfit"){return(NA)}
	#print(window(logisticfit))
	return(mod)
	
	}
)


print(replogistfit)
