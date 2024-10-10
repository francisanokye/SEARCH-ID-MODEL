library(shellpipes)

## -------------------------
## Define Parameters and Initial Conditions
## -------------------------
set.seed(2024)
# Parameters (original values)
beta <- 0.25
eta <- 0.99#0.5            # Recovery rate from critical cases
omega <- 1/3          # Rate of progression for hospitalized individuals
theta <- 0.005#0.005        # Proportion progressing to critical cases
xi <- 0.005#0.009           # Proportion hospitalized (symptomatic individuals)
phi <- 1/5#1/3            # Rate of progression for symptomatic individuals
mu <- 1/3#0.35            # Rate from exposed to symptomatic/asymptomatic
gamma <- 1/10         # Recovery rate for asymptomatic individuals
sigma <- 0.6#0.60         # Proportion progressing to asymptomatic infection
zeta <- 0.75          # Phenomenological heterogeneity parameter
reporting_frac <- 1.0 # Reporting fraction
serop_frac = 1.0

# Initial conditions
N <- 510550
E0 <- 0
A0 <- 80
R0 <- 3000
C0 <- 0
H0 <- 0
I0 <- 0
S0 <- N - E0 - A0 - R0 - C0 - H0 - I0

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
	      , reporting_frac = reporting_frac
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
