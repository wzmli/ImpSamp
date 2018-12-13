## 

library(epigrowthfit)
library(dplyr)
library(ggplot2)
theme_set(theme_bw())

expdf <- (rbind_list(epiexpfit)
	%>% mutate(method="exp"
		, ind = 0.25*(1:10))
)

logdf <- (rbind_list(epilogfit)
	%>% mutate(method="logistic"
		, ind = 0.25*(1:10))
)

estdf <- rbind(expdf,logdf)

print(estdf)

gg <- (
	ggplot(estdf, aes(x=ind, y=value, ymin = lower, ymax=upper, colour=method, label=winWidth))
	+ geom_pointrange()
	# + geom_point(colour="black")
	+ geom_text(hjust=-1.5)
	+ geom_abline()
	+ scale_color_manual(values=c("red","blue"))
	+ scale_y_continuous(breaks=seq(0,2.5,0.25))
	+ xlab("True r")
	+ ylab("Estimate")
)

print(gg)
