library(dplyr)
alldf <- data.frame()
newbeta <- c(1.5,2,2.5,3) # c(1,0.75,0.6)
	for (i in newbeta){
		beta <- i
		gamma <- 1

		print(i)
		source("sir.R")
		source("fitsir.R")
		source("fitsir_miliPlot.R")
		newdf <- (estdf
			%>% mutate(r = beta-gamma
				, R0 = beta/gamma
				)
			)
		alldf <- rbind(alldf,newdf)
	}
