library(epigrowthfit)
library(ggplot2)
library(bbmle)
library(dplyr)

epilist <- lapply(1:nrep,function(x){
	rest <- growthRate(epilogfit[[x]])
	convergence <- epilogfit[[x]]@mle2@details$convergence
	data.frame(est = rest[1], lower = rest[2], upper = rest[3]
		, real = r, convergence, type="epigrowthfit")
	}
)

nllepi <- function(r=0.3,x0=1,K=6){
  cumulative_cases = (exp(K)/(1 + (K/(atan(x0) * 2/pi + 1)/2 - 1) * exp(-exp(r) * 1:length(cases))))
  incidence = diff(cumulative_cases)
  sum(-lgamma(cases[-length(cases)] + 1) + cases[-length(cases)] * log(incidence) - incidence)
}


cases <- aa@deaths[window(aa)]
bb <- mle2(nllepi, optimizer="nlminb",control = list(eval.max = 1e+08, iter.max = 1e+08))#optCtrl=list(eval.max=1e8,iter.max=1e8))
bb


epidf <- rbind_list(epilist)
print(epidf)

rawdf <- data.frame()
for(x in 1:nrep){
  print(x)
	mod <- epilogfit[[x]]
	cases <- mod@deaths[window(mod)]
	rawfit <- mle2(nll)
	cc <- coef(rawfit)[["r"]]
	convergence <- rawfit@details$convergence
	if(sum(rawfit@details$hessian > 0) ==9 ){
	  ci <- confint(rawfit,parm = "r")
	}
	if(sum(rawfit@details$hessian > 0) < 9){
	  ci <- c(cc,cc)
	}
	tempdf <- data.frame(est = cc
		, lower = ci[1]
		, upper = ci[2]
		, real = r
		, convergence
		, type = "rawfit"
		)
	rawdf <- rbind(rawdf,tempdf)
}


df <- rbind(rawdf,epidf)
df2 <- (df 
   %>% mutate(inCI = (lower<real)&(real<upper)
          , count = 1
          , error = est - real
        )
   %>% filter(lower != upper)
   %>% group_by(type)
   %>% mutate(coverage = sum(inCI)/sum(count))
)

print(summary(df2))

print(head(df2))
print(tail(df2))

gg <- (ggplot(df2, aes(x=type,y=error))
  + geom_boxplot()      
)

plot(gg)
