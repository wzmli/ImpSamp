## 

library(epigrowthfit)
library(dplyr)
library(bbmle)


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
  return(logisticfit)
#return(logisticfit)
# return(window(logisticfit))
}
)


