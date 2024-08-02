library(shellpipes)

flow_rates = list(
  infection ~ reulermultinom(S, clamp(beta * I / N))
  , recovery ~ reulermultinom(I, clamp(gamma))
)

update_states = list(
  S ~ S - infection
  , I ~ I + infection -recovery
  , R ~ R + recovery
)

saveVars(flow_rates, update_states)