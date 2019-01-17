library(dplyr)
library(ggplot2)
library(ggforce)

ode_alldf2 <- (ode_alldf
#	%>% select(-method)
	%>% mutate(process = "deterministic")
)

gillesp_alldf2 <- (gillesp_alldf
#	%>% select(-win)
	%>% mutate(process = "stochastic")
)


print(ode_alldf2)
print(gillesp_alldf2)


alldf <- (rbind(ode_alldf2, gillesp_alldf2)
	%>% ungroup()
	%>% group_by(process,R0)
	%>% mutate(ind = rank(value)
)	
)

print(alldf)

rdf <- data.frame(R0=rep(c(1.5,2,2.5,3),2)
	, value=rep(c(0.5,1,1.5,2),2)
	, process = rep(c("deterministic","stochastic"),each=4))

print(rdf)


gg <- (ggplot(alldf, aes(x=ind, y=value, ymin=lower, ymax=upper, color=win,alpha=inCI))
	+ geom_pointrange(aes(alpha=inCI))
	+ scale_alpha_discrete(range=c(0.3,1))
	+ geom_point()
#	+ scale_color_continuous(direction=-1)
	+ facet_wrap(~interaction(process,R0),ncol=2,scale="free")
	+ theme_bw()
#	+ geom_hline(aes(yintercept=value),rdf)
	+ xlab("Rank of r estimates")
	+ ylab("Estimated r")
)

print(gg2 <- gg + geom_hline(aes(yintercept=0.5)) + facet_grid(process~R0))


#print(gg + geom_hline(aes(yintercept=value),rdf))

quit()

gg2 <- (gg + facet_wrap(~interaction(process,R0),scale="fixed",ncol=2))


print(gg2 %+% (alldf %>% filter(R0 == 1.5)) 
	+ geom_hline(aes(yintercept=.5))
)

print(gg2 %+% (alldf %>% filter(R0 == 2))
	+ geom_hline(aes(yintercept=1))
)

print(gg2 %+% (alldf %>% filter(R0 == 2.5))
	+ geom_hline(aes(yintercept = 1.5))
)

print(gg2 %+% (alldf %>% filter(R0 == 3))
	+ geom_hline(aes(yintercept = 2))
)
