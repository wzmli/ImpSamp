## comparing deterministic vs stochastic time series
library(ggplot2)
library(deSolve)
library(dplyr)
library(deSolve)

## sir

compare_epi <- function(b,g,n){
	## deterministic SIR
	dpars <- c(beta=b,gamma=g) 
	ddat <- episim(x=pars, reporting_rate=reporting, Npop=n)
	## with process error
	spars <- c(beta = b, gamma=g, Npop=n)
	sstart <- c(S = (Npop - I0), I = I0, R=0)
	gilldat <- gillesp(start=sirstart
		, pars = sirpars
		, time = 1:(tsteps)
		, ratefun = sirfun
		, trans = sirtrans
		, progress = TRUE
		)
	dd <- data.frame(time = rep(1:tsteps,2)
		, type = rep(c("deterministic", "stochastic"),each=tsteps)
		, cases = c(ddat[1:tsteps],gilldat[["infection"]])
	)
	return(dd)
}

parlist <- list()

blist <- c(0.6, 0.75, 1, 1.5, 2, 2.5)
glist <- c(0.1, 0.25, 0.5, 1, 1, 1)
for( i in 1:6){
	dat <- compare_epi(b=blist[i],g=glist[i],n=1e4)

	gg <- (ggplot(dat, aes(time, cases,color=type))
	+ geom_point()
	+ theme_bw()
	+ ggtitle(paste("b=",blist[i] ," g=",glist[i]))	
#	+ scale_y_log10()
	+ scale_color_manual(values=c("black","blue"))
	)
	print(gg)
}


