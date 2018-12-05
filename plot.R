## pair plots

library(dplyr)

dd <- dd %>% select(index,everything())
print(pairs(dd, pch = 16, cex=0.2))
#print(pairs(sampdf2, pch = 16, cex = 0.2))
