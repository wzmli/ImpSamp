## simulating reed frost chain binomial

set.seed(1213)

nrep <- 20

simrf <- function(rr,NN,tt){
	r0 <- rr
	N0 <- NN
	I0 <- 10
	R0 <- I0
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
		R[i+1] <- I[i] + I[i+1]
	}
	Inc <- I
	Ipois <- sapply(1:length(I), function(x){rpois(1,Inc[x])})
#	print(plot(Ipois))
	return(head(Ipois,tt))

}

repcases <- replicate(nrep, simrf(R_0,Npop,tsteps))

## avoid bad epidemics 
repcases <- repcases[,which(colSums(repcases) > rejectdat)]
crazy_epi <- repcases>0

repcases <- repcases[,which(colSums(crazy_epi)>rejectdat)]

print(dim(repcases))

print(dim(repcases))
