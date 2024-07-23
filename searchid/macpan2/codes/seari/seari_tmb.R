library(macpan2)

initialize_state = list(
  S ~ N - E - A - I - R
)

flow_rates = list(
  mp_per_capita_flow("S", "E", foi ~ (beta * (A + I)/N))
  , mp_per_capita_flow("E", "A", expo_asymp ~ sigma * mu)
  , mp_per_capita_flow("E", "I", expo_symp ~ sigma * (1-mu ))
  , mp_per_capita_flow("I", "R", symp_recov ~  gamma_i)
  , mp_per_capita_flow("A", "R", asymp_recov ~ gamma_a)
)

## set defaults
default = list(
  beta = 0.35
  , mu = 0.6
  , gamma_i = 1/14
  , gamma_a = 1/10
  , sigma = 1/3.5
  , N = 510550
  , I = 1
  , A = 1
  , E = 10000
  , R = 0
)

spec = mp_tmb_model_spec(
  before = c(initialize_state)
  , during = c(flow_rates)
  , default = default
)