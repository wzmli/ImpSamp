## simulating reed frost chain binomial

set.seed(1213)

simrf <- function(rr,NN,tt){
	r0 <- rr
	N0 <- NN
	I0 <- 1
	R0 <- 0
	S0 <- N0-I0
	t <- tt

	S <- rep(S0,t)
	I <- rep(I0,t)
	R <- rep(R0,t)

	p <- r0/N0
	q <- 1-p
	for(i in 1:t){
		I[i+1] <- rbinom(1, S[i], 1-q^I[i])
		S[i+1] <- S[i] - I[i+1]
		R[i+1] <- R[i] + I[i]
	}
	Ipois <- sapply(1:length(I), function(x){rpois(1,I[x])})
	return(head(Ipois,tt))

}

repcases <- replicate(nrep, simrf(R_0,Npop,tsteps))

## avoid bad epidemics 
repcases <- repcases[,which(colSums(repcases) > rejectdat)]

