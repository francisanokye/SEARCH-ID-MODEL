library(macpan2)
library(shellpipes)
rpcall("timevar_spec.Rout timevar_spec.R flows.rda params.rda")

loadEnvironments()

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
  , expression = list(cases ~ S*foi * report_prob
  	, serop ~ R/N # 510550
	)
  , at = Inf
  , phase = "during"
  , default = list(report_prob = 1)
)

## update  model specification with piece-wise transmission rates
timevar_spec <- mp_tmb_insert(nspec
   , phase = "during"
   , at = 1L
   , default = list(beta = beta)
)

rdsSave(timevar_spec)
