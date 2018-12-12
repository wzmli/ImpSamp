library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)
library(ggplot2)
library(tidyr)

gg <- (ggplot(pval_df, aes(x=pvals))
	+ geom_histogram(bins=10)
	+ facet_grid(par~method)
	+ theme_bw()
)

print(gg)
