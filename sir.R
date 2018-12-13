## simulate SIR
library(deSolve)
library(dplyr)

N0 <- 1e7
b0 <- 1
g <- 1
steps <- 101

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

epidat <- matrix(0,nrow=(steps-1),ncol=10)

for(i in 1:ncol(epidat)){
	b <- b0 + 0.25*i
	pars <- c(bet=b,gamm=g)
	out <- ode(y=init,times=tt,eqn,parms=pars)
	df <- as.data.frame(out)

	Inc <- diff(df$CI)

	Ipois <- sapply(Inc*N0,function(x){rpois(1,x)})
	epidat[,i] <- Ipois
	print(b)
}

print(epidat)
