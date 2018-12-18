## 

library(epigrowthfit)
library(dplyr)
library(bbmle)

x=4

print(plot(epidat[,1]))

dat <- data.frame(time = 1:length(epidat[,1]), cases = epidat[,1])
logisticfit <- epigrowthfit(data=dat
	, deaths_var = "cases"
	, optimizer = "nlminb"
	, verbose = TRUE
#	, distrib = "poisson"
	, model = "logistic"
	, drop_mle2_call = FALSE
	, optCtrl=list(eval.max=1e5,iter.max=1e5)
)

print(summary(logisticfit))
print(window(logisticfit))

