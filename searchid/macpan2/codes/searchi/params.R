library(shellpipes)

beta = 5.25
eta = 0.99
omega = 1/3
theta = 0.05#0.01
xi = 0.09
phi = 1/3
mu = 1/10
gamma = 1/10
sigma = 0.60
zeta = 0.75

N = 510550
E0 = 0
A0 = 0 
R0 = 0
C0 = 0
H0 = 0
I0 = 15
S0 = N - E0 - A0 -R0 - C0 - H0 - H0 - I0

params = list(beta = beta
	      , gamma = gamma
	      , sigma = sigma
	      , mu = mu
	      , eta = eta
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
