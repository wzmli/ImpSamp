## 

library(epigrowthfit)
library(dplyr)


## adding observation error

repcases <- lapply(gall[3,],function(x){
	cases <- sapply(x,function(y){rpois(1,y)})
	return(data.frame(time=1:tsteps, cases=cases[1:tsteps]))
}
)


replogistfit <- lapply(repcases, function(x){
	dat <- x
	mod <- try(logisticfit <- epigrowthfit(data=dat
		, deaths_var = "cases"
		, optimizer = "nlminb"
		, verbose = TRUE
#		, distrib = "nbinom"
		, model = "logistic"
		, drop_mle2_call = FALSE
		, optCtrl=list(eval.max=1e6,iter.max=1e6)
	), silent=TRUE)
	if(class(mod) != "epigrowthfit"){return(NA)}
	#print(window(logisticfit))
	return(mod)	
	}
)


print(replogistfit)