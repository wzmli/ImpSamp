## simulate SIR
library(deSolve)
library(dplyr)
init <- c(S=1-1e-6,I=1e-6,R=0, CI=0)

N0 <- 1e7
b <- 1
g <- 0.5
steps <- 100

nrep <- 100

pars <- c(bet=b,gamm=g)

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

out <- ode(y=init,times=tt,eqn,parms=pars)
df <- as.data.frame(out)

Inc <- diff(df$CI)

repcases <- replicate(nrep,sapply(Inc*N0,function(x){rpois(1,x)}))

