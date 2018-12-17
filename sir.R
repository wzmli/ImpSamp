## simulate SIR
library(deSolve)
library(dplyr)

N0 <- 1e4
b <- 1.25
g <- 1
steps <- 101
reporting <- 1
nrep <- 200

init <- c(S=1-1e-7,I=1e-7,R=0,CI=0)


tt <- 1:steps
tt2 <- 1:(steps -1)
  
eqn <- function(time,state,parameters){
	with(as.list(c(state,parameters)),{
		dS <- -bet*S*I
    	dI <- bet*S*I-gamm*I
    	dR <- gamm*I
	 	dCI <- bet*S*I
   	return(list(c(dS,dI,dR,dCI)))
	})
}


	pars <- c(bet=b,gamm=g)

episim <- function(x,reporting_rate){
	out <- ode(y=init,times=tt,eqn,parms=x)
	df <- as.data.frame(out)
	Inc <- diff(df$CI)
	#Inc <- df$I
	Ipois <- sapply(Inc*N0,function(x){rpois(1,x*reporting_rate)})
	return(Ipois)
}

epidat <- replicate(nrep, episim(x=pars,reporting_rate=reporting))

for(i in 1:nrep){
	print(plot(epidat[,i]))
}
