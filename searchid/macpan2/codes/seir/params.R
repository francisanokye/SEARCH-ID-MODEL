library(shellpipes)
set.seed(2024)
alpha = 0.4
beta = 0.1
gamma = 1/10
report_prob <- 1

N = 510550
E0 = 1 #650
R0 = 1#5000
I0 = 1#550
S0 = N - E0 - I0 - R0

params = list(alpha = alpha
	, beta = beta
	, gamma = gamma
	, report_prob = report_prob
)

states = list(N = N
	, S = S0
	, E = E0
	, I = I0
	, R = R0
	)

saveEnvironment()
