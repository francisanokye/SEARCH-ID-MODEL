flow_rates = list(
	infection ~ reulermultinom(S, clamp(I * beta / N))
	, recovery ~ reulermultinom(I, clamp(gamma))
)

update_state = list(
	S ~ S - infection 
	, I ~ I + infection - recovery 
	, R ~ R + recovery
)

