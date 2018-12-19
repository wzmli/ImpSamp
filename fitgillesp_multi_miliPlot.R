library(dplyr)
alldf <- data.frame()
newbeta <- c(1.25, 1.5,1.75,2,2.25, 2.5)
	for (i in newbeta){
		beta <- i
		print(i)
		source("gillesp.R")
		source("fitgillesp.R")
		source("fitgillesp_CIplot.R")
		newdf <- (rdf
			%>% mutate(r = beta-gamma
				)
			)
		alldf <- rbind(alldf,newdf)
	}
