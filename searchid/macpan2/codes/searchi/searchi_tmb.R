library(macpan2)

initialize_state = list(
  S ~ N - E - A - R - C - H - I
)

constant_computations = list(
  N ~ sum(S, E, A, R, C, H, I)
)

flow_rates = list(
  mp_per_capita_flow("S", "E", foi ~ (beta * (A + I)/N))
  , mp_per_capita_flow("E", "A", expo_asymp ~ sigma * mu)
  , mp_per_capita_flow("A", "R", asymp_recov ~ gamma_a)
  , mp_per_capita_flow("E", "I", expo_symp ~ sigma * (1-mu ))
  , mp_per_capita_flow("I", "R", symp_recov ~  phi * (1-xi))
  , mp_per_capita_flow("I", "H", symp_recov ~  phi * xi)
  , mp_per_capita_flow("H", "R", asymp_recov ~ omega * theta)
  , mp_per_capita_flow("H", "C", asymp_recov ~ omega * (1-theta))
  , mp_per_capita_flow("C", "R", asymp_recov ~ alpha)
)

## set defaults
default = list(
  beta = 0.35
  , alpha = 0.67
  , omega = 1/8
  , theta = 0.50
  , xi = 0.5
  , phi = 1/5
  , mu = 0.5
  , gamma_a = 1/14
  , sigma = 0.35
  , N = 510550
  , E = 100
  , A = 10
  , R = 0
  , C = 0
  , H = 0
  , I = 1
)

spec = mp_tmb_model_spec(
  before = c(initialize_state, constant_computations)
  , during = c(flow_rates)
  , default = default
)