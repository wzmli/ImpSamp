## simulate SIR
library(deSolve)
library(dplyr)

steps <- 101
reporting <- 1
nrep <- 100
nrep <- 20
eps <- 1e-7

init <- c(S=1-eps,I=eps,R=0,CI=0)

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

episim <- function(x,reporting_rate,Npop=500){
	out <- ode(y=init,times=tt,eqn,parms=x)
	df <- as.data.frame(out)
	Inc <- diff(df$CI)
	#Inc <- df$I
	Ipois <- sapply(Inc*Npop,function(x){rpois(1,x*reporting_rate)})
	return(Ipois)
#	return(Inc)
}

epidat <- replicate(nrep, episim(x=pars,reporting_rate=reporting,Npop=Npop))

#for(i in 1:nrep){
#	print(plot(epidat[,i]))
#}
