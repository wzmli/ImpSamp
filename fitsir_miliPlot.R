## 

library(epigrowthfit)
library(dplyr)
library(ggplot2)
theme_set(theme_bw())

r <- b - g

#expdf <- (rbind_list(epiexpfit)
#	%>% mutate(method="exp"
#		, ind = 0.25*(1:10))
#)
expdf <- data.frame()

loglist <- lapply(epilogfit,function(x){c(growthRate(x))})

logdf <- (rbind_list(loglist)
	%>% rowwise()
	%>% mutate(method="logistic"
		, real = r
		, inCI = between(real,lower,upper)
	)
)

print(mean(logdf$inCI))

estdf <- (rbind(expdf,logdf)
	%>% ungroup()
	%>% arrange(value)
	%>% mutate(ind = rank(value))
)

print(estdf)

gg <- (
	ggplot(estdf, aes(x=ind, y=value, ymin = lower, ymax=upper, colour=inCI))
	+ geom_pointrange()
	# + geom_point(colour="black")
#	+ geom_text(hjust=-1.5)
	+ geom_hline(yintercept=r)
	+ scale_color_manual(values=c("red","gray"))
	+ scale_y_continuous(breaks=seq(0,2.5,0.25))
	+ xlab("ind")
	+ ylab("Estimate")
)

print(gg)
