pop <- 510550 
I0 <- 1

R0 <- 2 

gamma <- 1/14

params <- list(beta = R0/gamma
	, gamma = gamma
)

S <- pop - I0
I <- I0
Rstart <- 0

states = list(N = pop
	, S = S
	, I = I
	, R = Rstart
)

