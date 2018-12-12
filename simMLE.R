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

simGammamle <- function(nsims, gs, gm){
	simdat <- rgamma(nsims, shape=gs, scale=gm/gs)
	sample_mean <- mean(simdat)
	sample_shape <- sample_mean^2/var(simdat)

	dd <- data.frame(dat = simdat)
	
	suppressWarnings(mlefit <- mle2(dat ~ dgamma(shape=s, scale=m/s)
		, start = list(s=gs, m = gm)
		, data = dd
		)
	)

	return(mlefit)
}


waldp <- function(mleobj,p,real){
	psummary <- coef(summary(mleobj))[p,]
	est <- psummary["Estimate"]
	se <- psummary["Std. Error"]
	zv <- abs(real-est)/se
	pv <- 2*pnorm(zv,lower.tail=FALSE)
	return(pv)
} 

profilep_norm <- function(mleobj,p,real){
	if(p == "m"){
		nullmod <- update(mleobj, fixed=list(m=real,s=coef(mleobj)["s"]))
		return(anova(mleobj,nullmod)[2,"Pr(>Chisq)"])
	}
	if(p == "s"){
		nullmod <- update(mleobj, fixed = list(m=coef(mleobj)["m"],s=real))
		return(anova(mleobj,nullmod)[2,"Pr(>Chisq)"])
	}
}

