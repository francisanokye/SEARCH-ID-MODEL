library(shellpipes)
set.seed(2024)
beta = 1.25
eta = 0.99#0.99 params for beta+gamma+mu+eta+phi
omega = 1/3#1/3
theta = 0.005#0.005#0.01
xi = 0.005#0.005
phi = 1/5#1/5
mu = 1/3#1/3
gamma = 1/10#1/10
sigma =0.60 #0.60
zeta = 0.75# 0.75

N = 510550
E0 = 700 #700 beta+gamma+mu+eta+phi
A0 = 550#550 
R0 = 4000#4000
C0 = 0 # 0
H0 = 0 #
I0 = 550#550
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








