library(macpan2)
library(shellpipes)
rpcall("timevar_spec.Rout timevar_spec.R flows.rda params.rda")

loadEnvironments()

## ------------------------------------
# time-varying transmission parameters
## ------------------------------------
beta_changepoints <- c(0, 10, 21, 55, 90)
#beta_values <- c(0.150, 0.30, 0.35, 1.45, 2.25)
beta_values <- c(3.150, 2.30, 1.35, 1.45, 1.25)

## -------------------------
## Define the Model Specification
## -------------------------

spec <- mp_tmb_model_spec(
  before = list(
    N ~ N_value,
    E ~ E0,
    A ~ A0,
    R ~ R0,
    C ~ C0,
    H ~ H0,
    I ~ I0,
    S ~ N - E - A - R - C - H - I
  ),
  during = flows,  
  default = c(params,list(
      N_value = N,
      E0 = E0,
      A0 = A0,
      R0 = R0,
      C0 = C0,
      H0 = H0,
      I0 = I0,
      beta_values = beta_values,        
      log_beta_values = log(beta_values)
    ))
)

## -------------------------
## Add Variable Transformations
## -------------------------

# Apply parameter transformations
nspec <- spec |> mp_tmb_insert(
  phase = "before",
  at = 1L,
  expressions = list(
    # Time-varying beta_values
    beta_values ~ exp(log_beta_values),

    # Rates (positive real numbers)
    eta ~ exp(log_eta),
    omega ~ exp(log_omega),
    phi ~ exp(log_phi),
    mu ~ exp(log_mu),
    gamma ~ exp(log_gamma),

    # Proportions (between 0 and 1)
    theta ~ 1 / (1 + exp(-logit_theta)),
    xi ~ 1 / (1 + exp(-logit_xi)),
    sigma ~ 1 / (1 + exp(-logit_sigma)),
    reporting_frac ~ 1 / (1 + exp(-logit_reporting_frac))
  )
 
)

##----------------------------
## Accumulate infections
##---------------------------

nspec <- mp_tmb_insert(
  nspec,
  expressions = list(cases ~ incidence * reporting_frac),
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
   #, default = list(beta_values = beta_values)
   , integers = list(beta_changepoints = beta_changepoints)
)

rdsSave(timevar_spec)
