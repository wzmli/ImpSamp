library(bbmle)
library(mvtnorm)
library(dplyr)
library(LaplacesDemon)

pvals <- sapply(1:nrep,function(x){coef(summary(repmle[[x]]))[,"Pr(z)"]})

if(is.null(nrow(pvals))){
	print(hist(pvals,main="r"))
}

if(!is.null(nrow(pvals))){
	for(i in 1:nrow(pvals)){
		print(hist(pvals[i,],main=rownames(pvals)[i]))
	}
}
