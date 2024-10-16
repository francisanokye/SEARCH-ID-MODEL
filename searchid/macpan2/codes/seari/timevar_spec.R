library(macpan2)
library(shellpipes)
rpcall("timevar_spec.Rout timevar_spec.R flows.rda params.rda")

loadEnvironments()

beta_changepoints <- c(0, 10, 25, 55, 90)
beta_values = c(0.3, 0.30, 0.34, 0.34, 0.33)




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
  , expression = list(sero_cases ~ S * foi * report_prob, 
		      serop ~ (R/N)
  )
  , at = Inf
  , phase = "during"
)

## update  model specification with piece-wise transmission rates
timevar_spec <- mp_tmb_insert(nspec
	, expression = list(beta ~ time_var(beta_values, beta_changepoints))
	, phase = "during", at = 1L
	, default = list(beta_values = beta_values)
   , integers = list(beta_changepoints = beta_changepoints)
)

timevar_spec = mp_tmb_insert_reports(timevar_spec
  , incidence_name = "exposure"
  , report_prob = 0.5#0.1
  , mean_delay = 11
  , cv_delay = 0.95#0.25
  , reports_name = "cases"
  , report_prob_name = "report_prob"
)


rdsSave(timevar_spec)
