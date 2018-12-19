library(dplyr)
alldf <- data.frame()
newbeta <- c(1.5,2,2.5,3)  #c(1, 0.75,0.6)
	for (i in newbeta){
		beta <- i
		gamma <- 1
		print(i)
		source("gillesp.R")
		source("fitgillesp.R")
		source("fitgillesp_CIplot.R")
		newdf <- (rdf
			%>% mutate(r = beta-gamma
				, R0 = beta/gamma
				)
			)
		alldf <- rbind(alldf,newdf)
	}
