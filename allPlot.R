library(dplyr)
library(ggplot2)
library(ggforce)

ode_alldf2 <- (ode_alldf
	%>% select(-method)
	%>% mutate(process = "deterministic")
)

gillesp_alldf2 <- (gillesp_alldf
	%>% select(-win)
	%>% mutate(process = "stochastic")
)

alldf <- (rbind(ode_alldf2, gillesp_alldf2)
	%>% ungroup()
	%>% group_by(process,real)
	%>% mutate(ind = rank(value)
		, R0 = real+1)
	
)

print(alldf)

rdf <- data.frame(R0=rep(seq(1.25,2.5,0.25),2)
	, value=rep(seq(0.25,1.5,0.25),2)
	, process = rep(c("deterministic","stochastic"),each=6))

print(rdf)

gg <- (ggplot(alldf, aes(x=ind, y=value, ymin=lower, ymax=upper, color=inCI))
	+ geom_pointrange()
	+ geom_point()
	+ scale_color_manual(values=c("red","gray"))
	+ facet_wrap(~interaction(process,R0),ncol=2,scale="free")
	+ theme_bw()
#	+ geom_hline(aes(yintercept=value),rdf)
	+ xlab("Rank of r estimates")
	+ ylab("Estimated r")
)

print(gg + geom_hline(aes(yintercept=value),rdf))

gg2 <- (gg + facet_wrap(~interaction(process,R0),scale="fixed",ncol=2))


print(gg2 %+% (alldf %>% filter(R0 == 1.25)) 
	+ geom_hline(aes(yintercept=.25))
)

print(gg2 %+% (alldf %>% filter(R0 == 1.5))
	+ geom_hline(aes(yintercept=0.5))
)

print(gg2 %+% (alldf %>% filter(R0 == 1.75))
	+ geom_hline(aes(yintercept=0.75))
)

print(gg2 %+% (alldf %>% filter(R0 == 2))
	+ geom_hline(aes(yintercept = 1))
)

print(gg2 %+% (alldf %>% filter(R0 == 2.25))
	+ geom_hline(aes(yintercept = 1.25))
)

print(gg2 %+% (alldf %>% filter(R0 == 2.5))
	+ geom_hline(aes(yintercept = 1.5))
)
