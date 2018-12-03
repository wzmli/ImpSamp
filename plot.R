## pair plots

library(dplyr)

sampdf <- data.frame(mv_samps, like_wt_l, sample_wt_l, imp_wts_norm)

print(pairs(sampdf, pch = 16, cex=0.2))
