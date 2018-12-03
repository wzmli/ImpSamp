## pair plots

library(dplyr)

sampdf <- data.frame(mv_samps, like_wt_l, sample_wt_l, imp_wts)

print(pairs(sampdf, pch = 16, cex=0.2))
