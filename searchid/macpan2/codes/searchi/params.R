library(shellpipes)
set.seed(2024)

beta = 0.25
eta = 0.99
omega = 1/3
theta = 0.005
xi = 0.005
phi = 1/5
mu = 1/3
gamma = 1/14
sigma = 0.60 
zeta = 0.75
report_prob <- 1.0
serop_frac <- 1.0

N = 510550
E0 = 700 
A0 = 550 
R0 = 4000
C0 = 0 
H0 = 0 
I0 = 550
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
	      , zeta = zeta
	      , report_prob = report_prob
              , serop_frac = serop_frac
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
