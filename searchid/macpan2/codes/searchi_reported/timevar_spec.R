library(macpan2)
library(shellpipes)
rpcall("timevar_spec.Rout timevar_spec.R flows.rda params.rda")

loadEnvironments()

## -------------------------
## Define the Model Specification
## -------------------------

spec <- mp_tmb_model_spec(
  before = list(
    N ~ N,
    E ~ E0,
    A ~ A0,
    R ~ R0,
    C ~ C0,
    H ~ H0,
    I ~ I0,
    S ~ N - E - A - R - C - H - I
  ),
  during = flows,  
  default = c(params))

## -------------------------
## time-varying transmissoin parameters
## -------------------------
beta_changepoints <- c(0, 10, 21, 55, 90)
#beta_values <- c(0.150, 0.30, 0.35, 0.45, 0.25)
beta_values = c(0.71, 0.34, 0.34,0.33,0.33)

newspec <- mp_tmb_update(spec,
                         default = list(
      beta = beta, eta = eta, omega = omega, theta = theta, zeta = zeta
    , xi = xi, phi = phi, mu = mu, gamma = gamma, sigma = sigma, reporting_frac = reporting_frac, serop_frac = serop_frac,
     N = N, E0 = E0, A0 = A0, R0 = R0, C0 = C0, H0 = H0, I0 = I0))


##----------------------------
## Accumulate infections
##---------------------------

nspec <- mp_tmb_insert(
  newspec,
  expressions = list(cases ~ incidence * reporting_frac, serop ~ (R/510550) * serop_frac),
  at = Inf,
  phase = "during"
)

## -------------------------
## Insert piece-wise time-varying parameters
## -------------------------

timevar_spec <- mp_tmb_insert(nspec
   , expression = list(beta ~ time_var(beta_values, beta_changepoints))
   , phase = "during"
   , at = 1L
   , default = list(beta_values = beta_values)
   , integers = list(beta_changepoints = beta_changepoints)
)

rdsSave(timevar_spec)
