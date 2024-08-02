library(macpan2)
library(shellpipes)

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
	, during = c(flow_rates, update_states)
	, default = c(params)
	)

rdsSave(spec)
