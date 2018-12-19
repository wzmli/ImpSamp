library(ggplot2)

gg <- (ggplot(alldf, aes(x=value, y=value, ymin=lower, ymax=upper, colour=inCI))
	+ geom_pointrange()
#	+ geom_hline(yintercept = r)
	+ scale_color_manual(values=c("red","gray"))
	+ xlab("ind")
	+ ylab("Estimate")
	+ facet_wrap(~r,scale="free",nrow=6)
	+ theme_bw()
)

print(gg)

gillesp_alldf <- alldf
