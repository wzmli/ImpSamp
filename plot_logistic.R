library(epigrowthfit)
library(bbmle)

print(plot(mod_epigrowthfit))
print(plot(profile(mod_epigrowthfit@mle2)))
print(plot(profile(rawfit)))
