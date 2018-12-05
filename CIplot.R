## 

library(ggplot2)
library(dplyr)

CIdat <- rbind(CIdat10, CIdat100, CIdat1000)
CIdat <- CIdat %>% mutate(nsim = rep(c(nsim,nsim*10,nsim*100),each=8))

print(CIdat)

gg <- (ggplot(CIdat, aes(x=factor(nsim), y=mleest, ymin=lower, ymax=upper, colour=type))
	+ geom_pointrange(position=position_dodge(width=-0.7))
	+ theme_bw()
	+ facet_wrap(~par,nrow=2)
)

print(gg)