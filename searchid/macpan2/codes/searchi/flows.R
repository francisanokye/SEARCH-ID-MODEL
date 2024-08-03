library(shellpipes)

flow_rates = list(
  foi ~ reulermultinom(S, clamp(beta * (A + I)/N))
  , expo_asymp ~ reulermultinom(E, clamp(sigma * mu))
  ,expo_symp ~ reulermultinom(E, clamp(sigma * (1-mu )))
  , asymp_recov ~ reulermultinom(A, clamp(gamma))
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

saveVars(flow_rates, update_states)
