library(shellpipes)
set.seed(2024)
sigma = 1/5
beta = 0.27
gamma = 1/14
report_prob <- 1.0
serop_frac <- 1.0

N = 510550
E0 = 750
R0 = 549
I0 = 400
S0 = N - E0 - I0 - R0

params = list(sigma = sigma
	, beta = beta
	, gamma = gamma
	, report_prob = report_prob
	, serop_frac = serop_frac
)

states = list(N = N
	, S = S0
	, E = E0
	, I = I0
	, R = R0
	)

saveEnvironment()
