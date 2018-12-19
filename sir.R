## simulate SIR
library(deSolve)
library(dplyr)

steps <- 101
reporting <- 1
eps <- 1e-7

init <- c(S=1-eps,I=eps,R=0,CI=0)

tt <- 1:steps
tt2 <- 1:(steps -1)
  
eqn <- function(time,state,parameters){
	with(as.list(c(state,parameters)),{
		dS <- -beta*S*I
    	dI <- beta*S*I-gamma*I
    	dR <- gamma*I
	 	dCI <- beta*S*I
   	return(list(c(dS,dI,dR,dCI)))
	})
}


	pars <- c(beta=beta,gamma=gamma)

episim <- function(x,reporting_rate,Npop=500){
	out <- ode(y=init,times=tt,eqn,parms=x)
	df <- as.data.frame(out)
	Inc <- diff(df$CI)
	#Inc <- df$I
	Ipois <- sapply(Inc*Npop,function(x){rpois(1,x*reporting_rate)})
	return(Ipois)
#	return(df)
}


epidat <- replicate(nrep, episim(x=pars,reporting_rate=reporting,Npop=Npop))

print(epidat)

#for(i in 1:nrep){
#	print(plot(epidat[,i]))
#}
