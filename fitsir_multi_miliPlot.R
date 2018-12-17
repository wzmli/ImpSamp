library(dplyr)
alldf <- data.frame()
newN <- c(1e4, 1e5, 1e6)
newb <- c(1.5, 2, 2.5)
for( i in newN){
	for (j in newb){
		Npop <- i
		b <- j
		print(i)
		print(j)
		source("sir.R")
		source("fitsir.R")
		source("fitsir_miliPlot.R")
		newdf <- (estdf
			%>% mutate(Npop = i
				, b = j
				)
			)
		alldf <- rbind(alldf,newdf)
	}
}
