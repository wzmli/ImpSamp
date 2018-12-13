## 

library(epigrowthfit)
library(bbmle)
library(dplyr)
library(mvtnorm)
library(ggplot2)


print(length(replogistfit))

for(i in 1:length(replogistfit)){
	print(growthRate(replogistfit[[i]]))
}


quit()
repdd <- lapply(1:ncol(repcases)

	, function(x){
		dd <- ImpSamp(replogistfit[[x]]@mle2,nsamples=nsamp,PDify=TRUE)
		df <- data.frame(CIdf(replogistfit[[x]]@mle2,dd),rep=x)
		return(df)
	}
)


CIdat <- (rbind_list(repdd) 
	%>% filter(par == "r") 
	%>% rowwise()
#	%>% mutate(inCI = between(log(R_0-1),exp(lower),exp(upper)))
#	%>% group_by(type)
#	%>% mutate(coverage = mean(inCI))
)


print(CIdat)

quit()

gg <- (ggplot(CIdat, aes(x=type, y=coverage))
#	+ geom_pointrange(position=position_dodge(width=-0.7))
	+ geom_point(size=3)
	+ theme_bw()
)

print(gg)









