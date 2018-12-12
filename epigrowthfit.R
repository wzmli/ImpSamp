## 

library(epigrowthfit)
library(dplyr)

repexpfit <- lapply(1:nrep, function(x){
	dat <- data.frame(time = tt2, cases=repcases[,1])  
	expfit <- epigrowthfit(data=dat
		, deaths_var = "cases"
		, optimizer = "nlminb"
		, verbose = FALSE
		, distrib = "poisson"
		, model = "exp"
		, drop_mle2_call = FALSE
	)
	return(growthRate(expfit))
	}
)

expdf <- (rbind_list(repexpfit)
	%>% mutate(truepar = b-g
		, method = "exp"
		)
)

replogistfit <- lapply(1:nrep, function(x){
	dat <- data.frame(time = tt2, cases = repcases[,1])
	logisticfit <- epigrowthfit(data=dat
		, deaths_var = "cases"
		, optimizer = "nlminb"
		, verbose = TRUE
		, distrib = "poisson"
		, model = "logistic"
		, drop_mle2_call = FALSE
	)
	return(growthRate(logisticfit))
	}
)

logistdf <- (rbind_list(replogistfit)
	%>% mutate(truepar = b-g
		, method = "logistic"
		)
)

epidf <- rbind(expdf, logistdf)

print(nrow(epidf))
print(nrow(epidf %>% distinct()))
