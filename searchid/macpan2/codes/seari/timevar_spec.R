library(macpan2)
library(shellpipes)
rpcall("timevar_spec.Rout timevar_spec.R flows.rda params.rda")

loadEnvironments()

spec <- mp_tmb_model_spec(
  before = list(
    N ~ N
    , E ~ exp(log_E0)
    , A ~ exp(log_A0)
    , I ~ exp(log_I0)
    , R ~ exp(log_R0)
    , S ~ N - E - A - I - R)
  , during = flows
  , default = c(params)
)

newspec <- mp_tmb_update(spec
			 , default = list(sigma = sigma
					  , mu = mu
					  , beta = beta
					  , gamma_a = gamma_a
					  , gamma_i = gamma_i
					  , N = N
					  , log_A0 = log(A0)
					  , log_E0 = log(E0)
					  , log_I0 = log(I0)
					  , log_R0 = log(R0))
			)


## accumulate infections
nspec <- mp_tmb_insert(newspec
  , expression = list(cases ~ S * foi * report_prob
		    , serop ~ (R/N) * serop_frac
  		     )
  , at = Inf
  , phase = "during"
)

## update  model specification with piece-wise transmission rates
timevar_spec <- mp_tmb_insert(nspec, phase = "during", at = 1L)

print(timevar_spec)

rdsSave(timevar_spec)
