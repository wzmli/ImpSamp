library(ggplot2)
library(dplyr)

estdf <- (rbind_list(epilogfit)
	%>% rowwise()
	%>% mutate(value = as.numeric(value)
		 , lower = as.numeric(lower)
		 , upper = as.numeric(upper)
		 , r = b - g
		 , inCI = between(r, lower, upper)
		)
	%>% ungroup()
	%>% mutate(ind = rank(value))
)




gg <- (ggplot(estdf, aes(x=ind, y=value, ymin = lower, ymax=upper, colour=inCI))
+ geom_pointrange()
# + geom_point(colour="black")
#       + geom_text(hjust=-1.5)
+ geom_hline(yintercept=r)
+ scale_color_manual(values=c("red","gray"))
+ scale_y_continuous(breaks=seq(0,2.5,0.25))
+ xlab("ind")
+ ylab("Estimate")
)


print(gg)
