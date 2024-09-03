library(shellpipes)

beta = 0.25
alpha = 0.001
omega = 1/10
theta = 0.150
xi = 0.5
phi = 1/5
mu = 0.60
gamma = 1/14
sigma = 0.35

N = 510550
E0 =  2000
A0 = 1
R0 = 0
C0 = 0
H0 = 0
I0 = 24
S0 = N - E0 - A0 -R0 - C0 - H0 - H0 - I0

params = list(beta = beta
	      , gamma = gamma
	      , sigma = sigma
	      , mu = mu
	      , alpha = alpha
	      , omega = omega
	      , theta = theta
	      , xi = xi
	      , phi = phi
	     )

states = list(N = N
	, S = S0
	, E = E0
	, A = A0
	, R = R0
	, C = C0
	, H = H0
	, I = I0
	)

saveEnvironment()
