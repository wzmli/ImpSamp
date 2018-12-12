## 

library(ggplot2)
library(dplyr)


CIdat <- (rbind_list(repdd)
	%>% rowwise()
	%>% mutate(inCI = between(truePar, lower, upper))
	%>% group_by(type,par)
	%>% mutate(coverage = mean(inCI))
)

print(CIdat)

gg <- (ggplot(CIdat, aes(x=type, y=coverage, shape=par))
#	+ geom_pointrange(position=position_dodge(width=-0.7))
	+ geom_point(size=3)	
	+ theme_bw()
)

print(gg)
