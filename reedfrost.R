## simulating reed frost chain binomial

nrep <- 10

simrf <- function(rr,NN,tt){
r <- rr
N0 <- NN
I0 <- 1
R0 <- 0
S0 <- N0-I0

t <- tt

S <- rep(S0,t)
I <- rep(I0,t)
R <- rep(R0,t)

p <- r/N0

q <- 1-p

for(i in 1:t){
	I[i+1] <- rbinom(1, S[i], 1-q^I[i])
	S[i+1] <- S[i] - I[i+1]
	R[i+1] <- R[i] + I[i]
}

return(head(I,tt))

}

repcases <- replicate(nrep, simrf(2.5,1e3,20))


print(repcases)
