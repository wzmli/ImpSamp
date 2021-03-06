library(ggplot2)

gg <- (ggplot(pval_df, aes(pvals))
	+ geom_histogram(breaks=seq(0,1,0.05))
	+ facet_grid(par~method)
	+ theme_bw()
)

print(gg)
