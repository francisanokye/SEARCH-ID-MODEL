library(macpan2)
library(shellpipes)

flows = list(
    foi ~ I * beta / N
  , mp_per_capita_flow("S", "E", exposure ~ foi)
  , mp_per_capita_flow("E", "I", infection ~ alpha)
  , mp_per_capita_flow("I", "R", recovery ~ gamma)
)

saveVars(flows)
