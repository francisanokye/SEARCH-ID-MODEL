library(macpan2)
library(shellpipes)

flows = list(
    foi ~ beta * (A + I) / N
  , mp_per_capita_flow("S", "E", "foi", "infection")
  , mp_per_capita_flow("E", "A", "sigma * mu", "expo_asymp")
  , mp_per_capita_flow("E", "I", "sigma * (1 - mu)", "expo_symp")
  , mp_per_capita_flow("A", "R", "gamma", "asymp_recov")
  , mp_per_capita_flow("I", "H", "phi * xi", "symp_hosp")
  , mp_per_capita_flow("I", "R", "phi * (1-xi)", "symp_recov")
  , mp_per_capita_flow("H", "R", "omega * theta", "hosp_recov")
  , mp_per_capita_flow("H", "C", "omega * (1-theta)", "hosp_icu")
  , mp_per_capita_flow("C", "R", "alpha", "icu_recov")
)

saveVars(flows)
