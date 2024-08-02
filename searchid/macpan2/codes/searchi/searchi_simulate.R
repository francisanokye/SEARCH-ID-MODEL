library(macpan2)
library(shellpipes)
library(tidyverse)

loadEnvironments()

n = 100

spec = rdsRead()

newspec <- mp_tmb_update(spec, 
			 default = list(beta = 0.035
					, alpha = 0.001
					, omega = 1/10
					, theta = 0.150
					, xi = 0.5
					, phi = 1/5
					, mu = 0.6
					, gamma = 1/14
					, sigma = 1/3.3
					, N = 510550
					, E0 = E0
					, A0 = A0
					, R0 = R0
					, C0 = C0
					, H0 = H0
					, I0 = I0)
			)

time_steps = 170

outputs = c("S", "E", "A", "R", "C","H","I")

searchi = mp_simulator(model = newspec, time_steps = time_steps, outputs = outputs)

searchi_inc_sim <- mp_trajectory(searchi)
print(searchi_inc_sim)

gg <- ggplot(data = searchi_inc_sim, aes(x = time, y = value))+
	geom_line()+
	facet_wrap(~matrix, scale = "free", nrow = 2)+
	theme_bw()
print(gg)

rdsSave(searchi_inc_sim)



