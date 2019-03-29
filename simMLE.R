simNormalmle <- function(nsims, x, y=1){
	simdat <- rnorm(nsims, mean=x, sd=y)
	sample_mean <- mean(simdat)

## another way to do the mle step without using global data
	dd <- data.frame(dat = simdat)

	suppressWarnings(mlefit <- mle2(dat ~ dnorm(mean=m,sd=1)
		, start = list(m = sample_mean)
		, data = dd
		)
	)
	return(mlefit)
}


simExpmle <- function(nsims, x){
	simdat <- rexp(nsims, rate = exp(x))
	sample_mean <- mean(simdat)

	dd <- data.frame(dat = simdat)

	suppressWarnings(mlefit <- mle2(dat ~ dexp(rate=exp(r))
		, start = list(r = exp(sample_mean))
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


wald_pnorm <- function(mleobj,p,m=NULL,s=NULL,real){
	psummary <- coef(summary(mleobj))[p,]
	if((p == "m") & !is.null(m)){
	  est <- m
	}
	if((p == "s") & !is.null(s)){
	  est <- s
	}
	se <- psummary["Std. Error"]
	if(is.null(m) & is.null(s)){
	est <- psummary["Estimate"]
	}
	
	zv <- abs(real-est)/se
	pv <- 2*pnorm(zv,lower.tail=FALSE)
	return(pv)
} 

## Want to use z instead of Chisq eventually (soon?) 2018 Dec 12 (Wed)
## Put sd on the natural (log) scale
profile_pnorm <- function(mleobj,p,real){
	if(p == "m"){
		nullmod <- update(mleobj, fixed=list(m=real))
		return(anova(mleobj,nullmod)[2,"Pr(>Chisq)"])
	}
	if(p == "s"){
		nullmod <- update(mleobj, fixed = list(s=real))
		return(anova(mleobj,nullmod)[2,"Pr(>Chisq)"])
	}
}

## Calculate PPI and ImpSamp P values (for μ and σ) in parallel
ppi_pnorm <- function(mleobj,nsamp,realm,reals){
    impdat <- ImpSamp(mleobj,nsamples=nsamp, PDify=TRUE)
    impdat2 <- (impdat 
      %>% rowwise()
      %>% mutate(ppi_m = as.numeric(m >= realm) / nsamp 
          , ppi_s = as.numeric(s>=reals)/nsamp
          , is_m = ppi_m*nsamp*imp_wts_norm
          , is_s = ppi_s*nsamp*imp_wts_norm
      )
    )
    return(impdat2
      %>% select(ppi_m,ppi_s,is_m,is_s)
      %>% ungroup()
      %>% summarise_each(funs(sum))
    )
  }




### exp

wald_pexp <- function(mleobj,p,r=NULL,real){
  psummary <- coef(summary(mleobj))
  if(!is.null(r)){
    est <- r
  }
  if(is.null(r)){
    est <- psummary[1,"Estimate"]
  }
  se <- psummary[1,"Std. Error"]
  
  zv <- abs(real-est)/se
  pv <- 2*pnorm(zv,lower.tail=FALSE)
  return(pv)
} 

profile_pexp <- function(mleobj,real){
    nullmod <- update(mleobj, fixed = list(r=real))
    return(anova(mleobj,nullmod)[2,"Pr(>Chisq)"])
}

ppi_pexp <- function(mleobj,nsamp, real){
  impdat <- ImpSamp(mleobj,nsamples=nsamp, PDify=TRUE)
  impdat2 <- (impdat 
              %>% rowwise()
              %>% mutate(ppi_r = as.numeric(mv_samps >= real)/nsamp
                         , is_r = ppi_r*nsamp*imp_wts_norm
              )
  )
  impdat3 <- (impdat2
              %>% select(ppi_r,is_r)
              %>% ungroup()
              %>% summarise_each(funs(sum))
  )
  return(impdat3)
}


wald_plogistic <- function(mleobj,p,r=NULL,real){
  psummary <- coef(summary(mleobj))
  if(!is.null(r)){
    est <- r
  }
  if(is.null(r)){
    est <- psummary[1,"Estimate"]
  }
  se <- psummary[1,"Std. Error"]
  
  zv <- abs(real-est)/se
  pv <- 2*pnorm(zv,lower.tail=FALSE)
  return(pv)
} 

profile_plogistic <- function(mleobj,real){
  nullmod <- update(mleobj, fixed = list(r=real))
  return(anova(mleobj,nullmod)[2,"Pr(>Chisq)"])
}

ppi_plogistic <- function(mleobj,nsamp, real){
  if(mleobj@details$convergence == 1){
    return(data.frame(ppi_r=NA,is_r=NA))
  }
  impdat <- ImpSamp(mleobj,nsamples=nsamp, PDify=TRUE)
  impdat2 <- (impdat
              %>% select(-x0,-K)
              %>% rowwise()
              %>% mutate(ppi_r = as.numeric(r >= real)/nsamp
                         , is_r = ppi_r*nsamp*imp_wts_norm
              )
  )
  impdat3 <- (impdat2
              %>% select(ppi_r,is_r)
              %>% ungroup()
              %>% summarise_each(funs(sum))
  )
  return(impdat3)
}
