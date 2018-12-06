library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

set.seed(1203)
size <- 20
reps <- 2000

checkOnce <- function(s){
	n <- rnorm(s)
	return(summary(lm(n~1))$coef[,4])
}

r <- replicate(reps, checkOnce(size))

print(hist(r))
