simNormalmle <- function(nsims, x, y){
	simdat <- rnorm(nsims, mean=x, sd=y)
	sample_mean <- mean(simdat) 
	sample_sd <- sd(simdat) 

## another way to do the mle step without using global data
	dd <- data.frame(dat = simdat)

	suppressWarnings(mlefit <- mle2(dat ~ dnorm(mean=m,sd=s)
		, start = list(m = sample_mean, s = sample_sd)
		, data = dd
		)
	)
	return(mlefit)
}


simExpmle <- function(nsims, x){
	simdat <- rexp(nsims, rate = x)
	sample_mean <- mean(simdat)

	dd <- data.frame(dat = simdat)

	suppressWarnings(mlefit <- mle2(dat ~ dexp(rate=r)
		, start = list(r = sample_mean)
		, data = dd)
	)
	return(mlefit)
}
