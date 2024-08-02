library(shellpipes)

pop = 510550
R0 = 3
I0 = 1
gamma = 1/14

sir_params = list(beta = R0 / gamma, gamma = gamma)

S = pop - I0
I = I0
R = 0

states = list(
  N = pop
  , S = S
  , I = I
  , R = R
)

saveEnvironment()