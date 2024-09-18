library(shellpipes)
set.seed(2024)
alpha = 0.3
beta = 0.25
gamma = 1/10

N = 510550
E0 = 700 #650
R0 = 6000#5000
I0 = 550#550
S0 = N - E0 - I0 - R0

params = list(alpha = alpha
	, beta = beta
	, gamma = gamma
)

states = list(N = N
	, S = S0
	, E = E0
	, I = I0
	, R = R0
	)

saveEnvironment()
