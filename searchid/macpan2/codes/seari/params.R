library(shellpipes)
set.seed(2024)

beta = 0.35
mu = 0.6
gamma_i = 1/14
gamma_a = 1/10
sigma = 1/3
report_prob <- 1.0
serop_frac <- 1.0

N = 510550
E0 = 1
A0 = 1
R0 = 1
I0 = 1

S0 = N - E0 - A0 - I0 - R0

params = list(sigma = sigma
	, beta = beta
	, mu = mu
	, gamma_a = gamma_a
	, gamma_i = gamma_i 
	, report_prob = report_prob
	, serop_frac = serop_frac
)

states = list(N = N
	, S = S0
	, E = E0
	, A = A0
	, I = I0
	, R = R0
	)

saveEnvironment()
