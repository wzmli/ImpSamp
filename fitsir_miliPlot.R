## 

library(epigrowthfit)
library(dplyr)
library(ggplot2)
theme_set(theme_bw())

r <- beta - gamma
#
#ImpSampList <- lapply(epimle, function(x){
#	ImpSampdf <- ImpSamp(x, nsamples=nsamp,PDify=TRUE)
#	dd <- (ImpSampdf %>% dplyr:::select(-x0,-K))
#	return(dd)
#	}
#)

#CIList <- lapply(1:length(ImpSampList), function(x){
#	print(x)
#	CIdf(epimle[[x]],ImpSampList[[x]],epigrowthfit=TRUE)
#	}
#)

loglist <- lapply(epilogfit,function(x){c(growthRate(x))})

logdf <- (rbind_list(loglist)
	%>% rowwise()
	%>% mutate(method="logistic"
		, real = r
		, inCI = between(real,lower,upper)
	)
)

print(mean(logdf$inCI))

estdf <- (rbind(logdf)
	%>% ungroup()
	%>% arrange(value)
	%>% mutate(ind = rank(value))
)

print(estdf)

gg <- (ggplot(estdf, aes(x=ind, y=value, ymin = lower, ymax=upper, colour=inCI))
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
