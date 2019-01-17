
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
