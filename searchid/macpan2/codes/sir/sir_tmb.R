library(macpan2)

initialize_state = list(S ~ N - I - R)

flow_rates = list(
  mp_per_capita_flow("S", "I", infection ~ I * beta / N)
  , mp_per_capita_flow("I", "R", recovery ~ gamma)
)

default = list(
  beta = 0.8
  , gamma = 0.2
  , N = 510550
  , I = 1
  , R = 0
)

## model specification
spec = mp_tmb_model_spec(
  before = c(initialize_state)
  , during = c(flow_rates)
  , default = default
)

spec = mp_tmb_insert(spec
                     , expressions = list(cases ~ R)
                     , at = Inf
                     , phase = "during"
                     )