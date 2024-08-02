library(shellpipes)

N = 510550
beta = 0.035
alpha = 0.001
omega = 1/10
theta = 0.150
xi = 0.5
phi = 1/5
mu = 0.6
gamma = 1/14
sigma = 1/3.3

E0 = 2000
A0 = 10
R0 = 100
C0 = 0
H0 = 0
I0 = 10

params = list(beta = beta
	      , gamma = gamma
	      , sigma = sigma
	      , mu = mu
	      , alpha = alpha
	      , omega = omega
	      , theta = theta
	      , xi = xi
	      , phi = phi)

E <- E0
A <- A0
R <- R0
C <- C0
H <- H0
I <- I0
S <- N - E0 - A0 - R0 - C0 - H0 - I0

states = list(N = N
	, S = S
	, E = E
	, A = A
	, R = R
	, C = C
	, H = H
	, I = I
	)

saveEnvironment()
