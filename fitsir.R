## 

library(epigrowthfit)
library(dplyr)
library(bbmle)

# epiexpfit <- lapply(1:ncol(epidat), function(x){
#  	dat <- data.frame(time = 1:nrow(epidat), cases=epidat[,x])
#  	expfit <- epigrowthfit(data=dat
#  		, deaths_var = "cases"
#  		, optimizer = "nlminb"
#  		, verbose = FALSE
#  		, distrib = "poisson"
#  		, first = 33
#  		, peak = 43
#  		, model = "exp"
#  		, drop_mle2_call = FALSE
#  	)
#  	# return(c(growthRate(expfit),winWidth = length(window(expfit))))
#  	return(expfit)
#  	}
# )

# 
# exp2 <- lapply(1:ncol(epidat),function(x){
# 	dat <- epidat[33:43,x]
# 	mean_rate <- mean(dat)
# 	dd <- data.frame(dat)
# 	suppressWarnings(mlefit <- mle2(dat~dexp(rate=r)
# 		, start = list(r = mean_rate)
# 		, data = dd
# 		)
# 		)
# 	return(mlefit)
# }
# )

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
  return(c(growthRate(logisticfit)))
#return(logisticfit)
# return(window(logisticfit))
}
)


print(epilogfit)


#print(epilogfit[[1]]@deaths)
#print(epilogfit[[2]]@deaths)
#print(epilogfit[[3]]@deaths)


#for(i in 1:nrep){
#print(growthRate(epilogfit[[i]]))
#print(exp(confint(epilogfit[[i]]@mle2)))
# print(summary(epilogfit[[i]]@mle2))
#}

# lapply(epiexpfit, function(x){print(growthRate(x))})
# lapply(exp2, function(x){print(summary(x))})

