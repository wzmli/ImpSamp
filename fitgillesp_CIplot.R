## 
library(epigrowthfit)
library(rlist)
library(ggplot2)
library(dplyr)

if(length(which(is.na(replogistfit))) > 0){
  replogistfit <- list.remove(replogistfit,which(is.na(replogistfit)))
}
print(replogistfit)

rlist <- lapply(replogistfit, function(x){
	return(data.frame(t(c(growthRate(x))),win=length(window(x))))
	}
)


real = beta - gamma

rdf <- (rbind_list(rlist)
	%>% mutate(real = beta - gamma
		, value = as.numeric(value)
		, lower = as.numeric(lower)
		, upper = as.numeric(upper)
		, win = as.numeric(win)
		, ind = 1:nrow(.))
	%>% rowwise()
	%>% mutate(inCI = between(real, lower, upper))
)

print(rdf)

gg <- (ggplot(rdf, aes(x=value, y=value, ymin=lower, ymax=upper, color=inCI,group=ind))
+ geom_hline(yintercept = real, aes(color="blue"))
# + geom_pointrange(size=0.0001,position=position_dodge(width=-0.7))
+ geom_pointrange()
#+ geom_point(position=position_dodge(width=-0.7))
+ geom_point()
+ theme_bw()
+ scale_color_manual(values=c("gray","red"))
+ ggtitle(real)
# + scale_y_log10(
)

print(gg)

# gg2 <- (ggplot(rdf, aes(x=value, y=value, ymin=lower, ymax=upper, color=factor(win),lty=inCI))
# + geom_hline(yintercept = real)
# + geom_pointrange()
# + geom_point()
# + theme_bw()
# + scale_linetype_manual(values=c(2,1))
# + scale_color_manual(values=c("gray","red"))
# + ggtitle(real)
# # + scale_y_log10(
# )
# 
# print(gg2)

