## 

library(epigrowthfit)
library(bbmle)
library(dplyr)
library(mvtnorm)
library(ggplot2)

print(dim(CIdat))

CIdat2 <- (CIdat
	%>% rowwise()
	%>% mutate(truepar = log(2)
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
	+ geom_hline(yintercept=log(2))
	+ facet_wrap(~type,nrow=2)
	+ scale_color_manual(values=c("gray","black"))
	+ theme_bw()
)

print(gg)









