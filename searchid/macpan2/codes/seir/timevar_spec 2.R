library(macpan2)
library(shellpipes)
rpcall("timevar_spec.Rout timevar_spec.R flows.rda params.rda")

loadEnvironments()

beta_changepoints <- c(0, 10, 25, 55, 90)
beta_values = c(0.3, 0.30, 0.34, 0.34, 0.33)

reporting_changepoints <- c(0, 10, 25, 55, 90)
reporting_values = c(0.3, 0.30, 0.34, 0.34, 0.33)

# reads in sample of generated reported probabilities
reporting_probs = read.csv("../../data/report_probabilities.csv")
# change prob1 through to prob6 to select different shapes of the reporting probabilities
report_prob_ts <- reporting_probs |> dplyr::pull(prob6) |> dput()


spec <- mp_tmb_model_spec(
	before = list(N ~ N
		, E ~ exp(log_E0)
		, I ~ exp(log_I0)
		, R ~ exp(log_R0)
		, S ~ N - E - I - R
	)
	, during = flows
	, default = c(params)
)

newspec <- mp_tmb_update(spec
	, default = list(sigma = sigma
		, beta = beta
		, gamma = gamma
		, N = N
		, log_E0 = log(E0)
		, log_I0 = log(I0)
		, log_R0 = log(R0)
	)
)


## accumulate infections
nspec <- mp_tmb_insert(newspec
  , expression = list(serop ~ (R/N))#sero_cases ~ S * foi * report_prob 
  , at = Inf
  , phase = "during"
)

## update  model specification with piece-wise transmission rates
timevar_spec <- mp_tmb_insert(nspec
	, expression = list(report_prob ~ report_prob_ts[time_step(1)])
	, phase = "during", at = 1L
	, default = list(report_prob_ts = report_prob_ts)
)

#timevar_spec <- mp_tmb_insert(timevar_spec
#   , expression = list(report_prob ~ time_var(reporting_values, reporting_changepoints))
#   , phase = "during", at = 1L
#   , default = list(reporting_values = reporting_values)
#   , integers = list(reporting_changepoints = reporting_changepoints)
#)


timevar_spec = mp_tmb_insert_reports(timevar_spec
  , incidence_name = "exposure"
  , report_prob = 0.5#0.1
  , mean_delay = 11
  , cv_delay = 0.95#0.25
  , reports_name = "cases"
  , report_prob_name = "report_prob"
)

rdsSave(timevar_spec)
