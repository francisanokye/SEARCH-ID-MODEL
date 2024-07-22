library(macpan2)

## model specification
spec = mp_tmb_model_spec(
  before = list(R ~ Rstart
  	, N ~ pop
	, I ~ I0
	, S ~ pop - I - R
	)
  , during = c(flow_rates, update_state)
  , default = params
)

