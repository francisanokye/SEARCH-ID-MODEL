library(macpan2)
library(shellpipes)

loadEnvironments()

n = 50

specs = rdsRead()
newspecs = mp_tmb_update(specs, default = list(I0 = I0, pop = pop, Rstart = Rstart)) 

time_steps = 100

outputs = c("I", "infection")

sir = mp_simulator(model = specs
                   , time_steps = time_steps
                   , outputs = outputs
                   )

inc_sim = mp_trajectory(sir)

print(inc_sim)
