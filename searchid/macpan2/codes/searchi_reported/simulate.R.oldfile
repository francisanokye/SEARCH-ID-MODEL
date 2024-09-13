library(macpan2)
library(shellpipes)
rpcall("simulate.Rout simulate.R timevar_spec.rds params.rda")
library(tidyverse)
library(ggthemes)

loadEnvironments()

n = 100

timevar_spec = rdsRead()

beta_changepoints <- c(0, 10, 21, 55, 90)

time_steps = 170

outputs = c("S", "E", "A", "R", "C","H","I")

searchi = mp_simulator(model = timevar_spec, time_steps = time_steps, outputs = outputs)

inc_sim <- mp_trajectory(searchi)

print(inc_sim)

gg <- ggplot(data = inc_sim)+ 
	geom_line(aes(time, value, colour = matrix))+  
	geom_vline(aes(xintercept = x),linetype = "dashed",alpha = 0.5,data = data.frame(x = beta_changepoints))+
	labs(x = "Date (Dec 2021  - June 2022)", y = "Incidence", title = "SEARCHI Model - Incidence Trajectory With macpan2", color = "")+
	facet_wrap(~ matrix, scales = "free")+ 
	theme_clean()

print(gg)

rdsSave(inc_sim)



