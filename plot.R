## pair plots

library(dplyr)


adj_like_wt_l <- like_wt_l - max(like_wt_l,na.rm=TRUE)

# adj_like_wt_l[adj_like_wt_l < quantile(adj_like_wt_l,0.10)] <- NA

adj_sample_wt_l <- sample_wt_l - max(sample_wt_l, na.rm = TRUE)

sampdf <- data.frame(mv_samps, adj_like_wt_l, adj_sample_wt_l, imp_wts_norm)

sampdf2 <- (sampdf
	%>% filter(adj_sample_wt_l > quantile(adj_like_wt_l,0.2))
)

print(summary(sampdf))

print(pairs(sampdf, pch = 16, cex=0.2))
print(pairs(sampdf2, pch = 16, cex = 0.2))
