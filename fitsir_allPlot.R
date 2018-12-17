library(ggplot2)

gg <- (ggplot(alldf, aes(x=ind, y=value, ymin=lower, ymax=upper, colour=inCI))
	+ geom_pointrange()
#	+ geom_hline(yintercept = r)
	+ scale_color_manual(values=c("red","gray"))
	+ xlab("ind")
	+ ylab("Estimate")
	+ facet_grid(b~Npop,scale="free")
	+ theme_bw()
)

print(gg)


