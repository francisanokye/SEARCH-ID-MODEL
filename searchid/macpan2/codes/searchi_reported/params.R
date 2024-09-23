library(shellpipes)

## -------------------------
## Define Parameters and Initial Conditions
## -------------------------

# Parameters (original values)
beta <- 10.25
eta <- 0.85#0.5            # Recovery rate from critical cases
omega <- 1/3          # Rate of progression for hospitalized individuals
theta <- 0.005#0.005        # Proportion progressing to critical cases
xi <- 0.005#0.009           # Proportion hospitalized (symptomatic individuals)
phi <- 1/3#1/3            # Rate of progression for symptomatic individuals
mu <- 1/3#0.35            # Rate from exposed to symptomatic/asymptomatic
gamma <- 1/10         # Recovery rate for asymptomatic individuals
sigma <- 0.6#0.60         # Proportion progressing to asymptomatic infection
zeta <- 0.75          # Phenomenological heterogeneity parameter
reporting_frac <- 0.80 # Reporting fraction

# Initial conditions
N <- 510550
E0 <- 0
A0 <- 100
R0 <- 14000
C0 <- 0
H0 <- 0
I0 <- 0
S0 <- N - E0 - A0 - R0 - C0 - H0 - I0

# Create the params list with transformed parameters
params <- list(
    # Log-transformed rates
    log_beta = log(beta),
    log_eta = log(eta),
    log_omega = log(omega),
    log_phi = log(phi),
    log_mu = log(mu),
    log_gamma = log(gamma),

    # Logit-transformed proportions
    logit_theta = qlogis(theta),
    logit_xi = qlogis(xi),
    logit_sigma = qlogis(sigma),
    logit_reporting_frac = qlogis(reporting_frac),
    
    # Other parameters
    zeta = zeta
)

# Initial states
states <- list(
    N = N,
    S = S0,
    E = E0,
    A = A0,
    R = R0,
    C = C0,
    H = H0,
    I = I0
)



saveEnvironment()
