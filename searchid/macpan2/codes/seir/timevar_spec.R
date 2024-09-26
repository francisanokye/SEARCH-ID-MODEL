library(macpan2)
library(shellpipes)
rpcall("timevar_spec.Rout timevar_spec.R flows.rda params.rda")

loadEnvironments()

spec = mp_tmb_model_spec(
before = list(N ~ N
	      , E ~ E0
	      , I ~ I0
	      , R ~ R0
	      , S ~ N - E - I - R
	     )
	, during = flows
	, default = c(params)
	)


## ------------------------------------
# time-varying transmission parameters
## ------------------------------------
beta_changepoints <- c(0, 10, 21, 55, 90)
#beta_values <- c(0.150, 0.30, 0.35, 0.45, 0.25)
beta_values = c(0.71, 0.34, 0.34,0.33,0.33)

## why?!?
spec <- mp_tmb_model_spec(
  before = list(
    N ~ N,
    E ~ E0,
    I ~ I0,
    R ~ R0,
    S ~ N - E - I - R
  ),
  during = flows,  
  default = c(params)
)

newspec <- mp_tmb_update(spec
	, default = list(alpha = alpha
		, beta = beta
		, gamma = gamma
    	, N = N
		, E0 = E0
		, I0 = I0
		, R0 = R0
	)
)


## accumulate infections
nspec <- mp_tmb_insert(newspec
  , expression = list(cases ~ infection, serop ~ R/510550)
  , at = Inf
  , phase = "during"
)

## update  model specification with piece-wise transmission rates
timevar_spec <- mp_tmb_insert(nspec
   , expression = list(beta ~ time_var(beta_values, beta_changepoints))
   , phase = "during"
   , at = 1L
   , default = list(beta_values = beta_values)
   , integers = list(beta_changepoints = beta_changepoints)
)

rdsSave(timevar_spec)
