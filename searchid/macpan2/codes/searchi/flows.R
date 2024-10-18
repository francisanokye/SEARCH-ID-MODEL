library(macpan2)
library(shellpipes)

flows = list(
    foi ~ beta * (zeta * A + I) / N
  , mp_per_capita_flow("S", "E", exposure ~ foi)
  , mp_per_capita_flow("E", "A", expo_asymp ~ sigma * mu)
  , mp_per_capita_flow("E", "I", expo_symp ~ sigma * (1 - mu))
  , mp_per_capita_flow("A", "R", asymp_recov ~ gamma)
  , mp_per_capita_flow("I", "H", symp_hosp ~ phi * xi)
  , mp_per_capita_flow("I", "R", symp_recov ~ phi * (1-xi))
  , mp_per_capita_flow("H", "R", hosp_recov ~ omega * theta)
  , mp_per_capita_flow("H", "C", hosp_icu ~ omega * (1-theta))
  , mp_per_capita_flow("C", "R", icu_recov ~ eta)
)



saveVars(flows)
