library(macpan2)
library(shellpipes)

flows = list(
    foi ~ I * beta / N
  , mp_per_capita_flow("S", "E", "foi", "exposure")
  , mp_per_capita_flow("E", "I", "sigma", "infection")
  , mp_per_capita_flow("I", "R", "gamma", "recovery")
)

saveVars(flows)
