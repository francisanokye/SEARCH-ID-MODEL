library(shellpipes)

pop = 510550

I0 = 1

gamma = 1/14

R0 = 1.5

params = list(beta = R0/ gamma,gamma = gamma)

S <- pop - I0
I <- I0
Rstart <- 0

states = list(N = pop
	, S = S
	, I = I
	, R = Rstart
	, pop = pop
	)

saveEnvironment()
