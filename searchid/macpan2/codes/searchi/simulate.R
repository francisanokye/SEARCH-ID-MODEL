library(macpan2)
library(shellpipes)
library(tidyverse)
library(ggthemes)

loadEnvironments()

n = 100

timevar_spec = rdsRead()

#newspec <- mp_tmb_update(spec, 
#			 default = list(beta = beta, alpha = alpha, omega = omega, theta = theta
#					, xi = xi, phi = phi, mu = mu, gamma = gamma, sigma = sigma
#					, N = N, E0 = E0, A0 = A0, R0 = R0, C0 = C0, H0 = H0, I0 = I0)
#			)

## accumulate infections
#newspec <- mp_tmb_insert(newspec
#			 , expression = list (case ~ R)
#			 , at = Inf
#			 , phase = "during"
#			)

## time-varying parameters

beta_changepoints <- c(0, 10, 21, 55, 90)
#beta_values <- c(0.051, 0.15301, 0.15390, 0.15188, 0.15230) 

#expr = list(beta ~ time_var(beta_values, beta_changepoints))

## update  model specification with piece-wise transmission rates
 
#newspec <- mp_tmb_insert(newspec
#			 , expression = expr 
#			 , phase="during" 
#			 , at=1L
#			 , default = list(beta_values = log(beta_values))
#			 , integers = list(beta_changepoints = beta_changepoints)
#			)

# rdsSave(newspec)

time_steps = 170

outputs = c("S", "E", "A", "R", "C","H","I")

searchi = mp_simulator(model = timevar_spec, time_steps = time_steps, outputs = outputs)

inc_sim <- mp_trajectory(searchi)

print(inc_sim)

gg <- ggplot(data = inc_sim)+ 
	geom_line(aes(time, value, colour = matrix))+ 
	#geom_point(aes(time, value, colour = matrix))+ 
	geom_vline(aes(xintercept = x),linetype = "dashed",alpha = 0.5,data = data.frame(x = beta_changepoints))+
	labs(x = "Date (Dec 2021  - June 2022)", y = "Incidence", title = "SEARCHI Model - Incidence Trajectory With macpan2", color = "")+
	facet_wrap(~ matrix, scales = "free")+ 
	theme_clean()

## gg <- ggplot(data = inc_sim, aes(x = time, y = value))+
##	geom_line()+
##	facet_wrap(~matrix, scale = "free")+
##	theme_bw()
print(gg)

rdsSave(inc_sim)



