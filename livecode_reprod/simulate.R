library(macpan2)
library(shellpipes)
library(tidyverse)

loadEnvironments()

n = 500

spec = rdsRead()

newspec <- mp_tmb_update(spec, default = list(I0 = I0, pop = pop, Rstart = Rstart))

time_steps = 170

outputs = c("I", "infection")

sir = mp_simulator(model = newspec, time_steps = time_steps, outputs = outputs)

inc_sim <- mp_trajectory(sir)
print(inc_sim)

gg <- ggplot(data = inc_sim, aes(x = time, y = value), color = "blue")+
	geom_line()+
	facet_wrap(~matrix, scale = "free", nrow = 2)+
	theme_bw()


print(gg)

rdsSave(inc_sim)
