library(macpan2)
library(shellpipes)
rpcall("simulate.Rout simulate.R timevar_spec.rds params.rda")
library(tidyverse)
library(ggthemes)

loadEnvironments()

n = 100

timevar_spec = rdsRead()

time_steps = 170

outputs = c("S", "E", "I", "R","cases","foi")

seir = mp_simulator(model = timevar_spec, time_steps = time_steps, outputs = outputs)

inc_sim <- mp_trajectory(seir)

print(inc_sim)

gg <- ggplot(data = inc_sim)+ 
	geom_line(aes(time, value, colour = matrix))+ 
	#geom_point(aes(time, value, colour = matrix))+ 
	labs(x = "Date (Dec 2021  - June 2022)", y = "Incidence", title = "SEIR Model - Incidence Trajectory With macpan2", color = "")+
	facet_wrap(~ matrix, scales = "free")+ 
	theme_clean()

print(gg)

rdsSave(inc_sim)



