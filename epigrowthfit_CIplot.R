## 

library(epigrowthfit)
library(bbmle)
library(dplyr)
library(mvtnorm)
library(ggplot2)


print(R_0)

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
# 
logdf <- (rbind_list(loglist)
 	%>% arrange(value)
 	%>% mutate(ind = 1:nrow(.))
 )
 
fitdf <- (rbind(logdf)
 	%>% rowwise()
 	%>% mutate(highpar = 1
 		, realpar = log(R_0)
 		, value = as.numeric(value)
 		, lower = as.numeric(lower)
 		, upper = as.numeric(upper)
 		, inCI = ifelse(between(realpar, lower, upper), "in","out")
 		)
)
 
gg <- (ggplot(fitdf, aes(x=ind, y=value, ymin=lower, ymax=upper, color=inCI))
 	+ geom_hline(yintercept = log(1.25),aes(color="blue"))
 	+ geom_pointrange(size=0.0001)
 	+ theme_bw()
 	+ scale_color_manual(values=c("gray","red"))
 	+ ggtitle("R0 = 1.25")
 #	+ scale_y_log10()
)
 
print(gg)
 
quit()

repdd <- lapply(1:ncol(repcases)

	, function(x){
	  print(x)
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

CIdat2 <- (CIdat
	%>% rowwise()
	%>% mutate(truepar = log(R_0)
		, mleest = exp(mleest)
		, lower = exp(lower)
		, upper = exp(upper)
		, inCI = ifelse(between(truepar, lower, upper),"in","out")
		)
	%>% ungroup()
	%>% arrange(mleest)
	%>% mutate(ind = 1:nrow(.))
)

print(CIdat2)

gg <- (ggplot(CIdat2, aes(x=ind, y=mleest, ymin=lower, ymax=upper,color=inCI))
	+ geom_pointrange(position=position_dodge(width=-0.7))
	+ geom_point(size=0.1)
	+ geom_hline(yintercept=log(R_0))
	+ facet_wrap(~type,nrow=4)
	+ scale_color_manual(values=c("black","gray"))
	+ theme_bw()
)

print(gg)








