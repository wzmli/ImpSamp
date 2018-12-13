## 

library(epigrowthfit)
library(bbmle)
library(dplyr)
library(mvtnorm)
library(ggplot2)


#explist <- lapply(repexpfit, function(x){
#	c(growthRate(x), method = "exp")
#	}
#)

#expdf <- (rbind_list(explist) 
#	%>% arrange(value)
#	%>% mutate(ind = 1:nrow(.))
#)

loglist <- lapply(replogistfit, function(x){
	c(growthRate(x),method="logistic")
	}
)

logdf <- (rbind_list(loglist)
	%>% arrange(value)
	%>% mutate(ind = 1:nrow(.))
)

fitdf <- (rbind(logdf)
	%>% rowwise()
	%>% mutate(highpar = 1
		, lowpar = log(2)
		, value = as.numeric(value)
		, lower = as.numeric(lower)
		, upper = as.numeric(upper)
		, inCI = ifelse(between(highpar, lower, upper), "inhigh","out")
		, inCI = ifelse(between(lowpar, lower, upper), "inlow", inCI)
		)
)

gg <- (ggplot(fitdf, aes(x=ind, y=value, ymin=lower, ymax=upper, color=inCI))
	+ geom_hline(yintercept = log(2),aes(color="blue"))
	+ geom_hline(yintercept = 1, aes(color="black"))
	+ geom_pointrange(size=0.0001)
	+ theme_bw()
	+ scale_color_manual(values=c("black","blue","gray"))
	+ ggtitle("R0 = 2")
#	+ scale_y_log10()
)

print(gg)

quit()

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









