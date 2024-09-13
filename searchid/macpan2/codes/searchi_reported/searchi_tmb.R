library(macpan2)

initialize_state = list(
  S ~ N - E - A - R - C - H - I
)

constant_computations = list(
  N ~ sum(S, E, A, R, C, H, I)
)

# flow_rates = list(
#   mp_per_capita_flow("S", "E", foi ~ (beta * (A + I)/N))
#   , mp_per_capita_flow("E", "A", expo_asymp ~ sigma * mu)
#   , mp_per_capita_flow("E", "I", expo_symp ~ sigma * (1-mu ))
#   , mp_per_capita_flow("A", "R", asymp_recov ~ gamma_a)
#   , mp_per_capita_flow("I", "H", symp_hosp ~  phi * xi)
#   , mp_per_capita_flow("I", "R", symp_recov ~  phi * (1-xi))
#   , mp_per_capita_flow("H", "R", hosp_recov ~ omega * theta)
#   , mp_per_capita_flow("H", "C", hosp_icu ~ omega * (1-theta))
#   , mp_per_capita_flow("C", "R", icu_recov ~ alpha)
# )

flow_rates = list(
  foi ~ reulermultinom(S, clamp(beta * (A + I)/N))
  , expo_asymp ~ reulermultinom(E, clamp(sigma * mu))
  ,expo_symp ~ reulermultinom(E, clamp(sigma * (1-mu )))
  , asymp_recov ~ reulermultinom(A, clamp(gamma_a))
  , symp_hosp ~  reulermultinom(I, clamp(phi * xi))
  , symp_recov ~  reulermultinom(I, clamp(phi * (1-xi)))
  , hosp_recov ~ reulermultinom(H, clamp(omega * theta))
  , hosp_icu ~ reulermultinom(H, clamp(omega * (1-theta)))
  , icu_recov ~ reulermultinom(C, clamp(alpha))
)

update_states = list(
  S ~ S - foi
  , E ~ E + foi - expo_asymp - expo_symp
  , A ~ A + expo_asymp - asymp_recov
  , R ~ R + asymp_recov + symp_recov + hosp_recov + icu_recov
  , C ~ C + hosp_icu - icu_recov
  , H ~ H + symp_hosp - hosp_icu - hosp_recov
  , I ~ I + expo_symp - symp_hosp - symp_recov
)


## set defaults
default = list(
  beta = 0.035
  , alpha = 0.001
  , omega = 1/10
  , theta = 0.150
  , xi = 0.5
  , phi = 1/5
  , mu = 0.6
  , gamma_a = 1/14
  , sigma = 1/3.3
  , N = 510550
  , E = 2000
  , A = 10
  , R = 100
  , C = 0
  , H = 0
  , I = 10
)

spec = mp_tmb_model_spec(
  before = c(initialize_state, constant_computations)
  , during = c(flow_rates, update_states)
  , default = default
)

spec = mp_tmb_insert(spec
                     , expressions = list(cases ~ R)
                     , at = Inf
                     , phase = "during"
)