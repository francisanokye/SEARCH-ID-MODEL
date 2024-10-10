library(macpan2)
library(shellpipes)

flows = list(foi ~ (beta * (A + I)/N)
	     , mp_per_capita_flow("S", "E", exposure ~ foi)
	     , mp_per_capita_flow("E", "A", expo_asymp ~ sigma * mu)
	     , mp_per_capita_flow("E", "I", expo_symp ~ sigma * (1-mu ))
	     , mp_per_capita_flow("I", "R", symp_recov ~  gamma_i)
	     , mp_per_capita_flow("A", "R", asymp_recov ~ gamma_a)
)

saveVars(flows)
