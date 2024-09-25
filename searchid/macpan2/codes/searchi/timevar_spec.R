library(macpan2)
library(shellpipes)
rpcall("timevar_spec.Rout timevar_spec.R flows.rda params.rda")

loadEnvironments()

spec = mp_tmb_model_spec(
before = list(N ~ N
	      , E ~ E0
	      , A ~ A0
	      , R ~ R0
	      , C ~ C0
	      , H ~ H0
	      , I ~ I0
	      , S ~ N - E - A - R - C - H - I
	     )
	, during = flows
	, default = c(params)
	)

newspec <- mp_tmb_update(spec,
                         default = list(
      beta = beta, eta = eta, omega = omega, theta = theta, zeta = zeta
    , xi = xi, phi = phi, mu = mu, gamma = gamma, sigma = sigma
    , N = N, E0 = E0, A0 = A0, R0 = R0, C0 = C0, H0 = H0, I0 = I0
))

## accumulate infections
nspec <- mp_tmb_insert(newspec
  , expression = list(cases ~ infection, serop ~ (R+A+I)/510550)
  , at = Inf
  , phase = "during"
)

## time-varying parameters
beta_changepoints <- c(0, 10, 21, 55, 90)
beta_values <- c(0.150, 0.30, 0.35, 0.45, 0.25)
#beta_values <- c(0.78,0.72,0.96,0.92,1.14)
## update  model specification with piece-wise transmission rates
timevar_spec <- mp_tmb_insert(nspec
   , expression = list(beta ~ time_var(beta_values, beta_changepoints))
   , phase = "during"
   , at = 1L
   , default = list(beta_values = beta_values)
   , integers = list(beta_changepoints = beta_changepoints)
)

rdsSave(timevar_spec)
