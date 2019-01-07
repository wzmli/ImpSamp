
set.seed(1218)

sirpars <- c(beta = beta
	, gamma = gamma
	, N = Npop
)

sirstart <- c(S = (Npop-I0), I = I0, R = 0)

gall <- replicate(nrep, gillesp(start=sirstart
	, pars = sirpars
	, time = 1:(tsteps + 1)
	, ratefun = sirfun
	, trans = sirtrans
	, progress = TRUE
	)
)

lapply(gall[3,],function(x)print(plot(x)))


print(gall[3,])
print(1e4)
lapply(gall[3,],function(x)print(sum(x,na.rm=TRUE)))

print(gall[2,][[1]])
print(gall[3,][[1]])
