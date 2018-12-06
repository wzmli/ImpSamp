## 

library(ggplot2)
library(dplyr)



gg <- (ggplot(CIdat, aes(x="1", y=mleest, ymin=lower, ymax=upper, colour=type))

	+ geom_pointrange(position=position_dodge(width=-0.7))
	+ theme_bw()
	+ facet_wrap(~par,nrow=2,scale="free")
	+ ggtitle(rtargetname)
)

print(gg)
