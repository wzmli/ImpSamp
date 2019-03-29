## 

library(epigrowthfit)
library(dplyr)
library(bbmle)

## adding observation error

## gall[3, ] is (somehow) a _list_ of the infectives time series

repcases <- lapply(gall[5,],function(x){
	cases <- sapply(x,function(y){rpois(1,y)})
	return(data.frame(time=1:tsteps, cases=cases[1:tsteps]))
})

replogistfit <- lapply(repcases, function(x){
	dat <- x
	mod <- try(logisticfit <- epigrowthfit(data=dat
		, deaths_var = "cases"
		, optimizer = "nlminb"
		, verbose = TRUE
		, distrib = "poisson"
		, model = "logistic"
		, drop_mle2_call = FALSE
		, optCtrl=list(eval.max=1e6,iter.max=1e6)
	), silent=TRUE)
	if(class(mod) != "epigrowthfit"){return(NA)}
	print(growthRate(logisticfit))
	return(mod)	
	}
)
mod_epigrowthfit <- replogistfit[[1]]
print(growthRate(mod_epigrowthfit))

cases <- mod_epigrowthfit@deaths[window(mod_epigrowthfit)]
rawfit <- mle2(nll)

print(summary(rawfit))

