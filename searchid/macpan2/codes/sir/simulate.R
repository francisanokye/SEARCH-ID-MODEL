library(macpan2)
library(tidyverse)

nsim <- 50

newspec <- mp_tmb_update(spec, default=list(I0 = I0, pop=pop, Rstart=Rstart))

time_steps <- 20

outputs <- c("I","infection")

sir = mp_simulator(model = newspec
	, time_steps = time_steps
	, outputs = outputs
)

inc_sim <- function(x){
	simdf <- (mp_trajectory(sir)
		|> mutate(NULL
			, seed = x
		)
	)
}


incdf <- bind_rows(lapply(1:nsim,inc_sim))

gg <- (ggplot(incdf, aes(time,value,group=seed))
	+ geom_line(alpha=0.01)
	+ facet_wrap(~matrix,scale="free",nrow=2)
)

print(gg)

