library(bbmle)
library(epigrowthfit)
library(mvtnorm)
library(dplyr)

nsamp <- 1000

epilogfit <- head(epilogfit)


epimle <- lapply(epilogfit, function(x){x@mle2})

ImpSampList <- lapply(epimle, function(x){
	ImpSampdf <- ImpSamp(x, nsamples=nsamp,PDify=TRUE)
	dd <- (ImpSampdf %>% dplyr:::select(-x0,-K))
	return(dd)
	}
)

CIList <- lapply(1:length(ImpSampList), function(x){
	print(x)
	CIdf(epimle[[x]],ImpSampList[[x]])
	}
)

print(CIList)
