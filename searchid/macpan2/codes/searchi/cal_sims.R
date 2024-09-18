library(macpan2)
library(shellpipes)
library(tidyverse)
library(ggthemes)

loadEnvironments()

n = 170

calobj = rdsRead("calibrate.rds")

seroprevdata <- rdsRead("seroprevdata.rds")

inc_sim <- mp_trajectory(calobj)
print(inc_sim)

beta_changepoints = c(0, 10, 21, 55, 90)

pp <- (ggplot(data = inc_sim, aes(x = time, y= value))
        + geom_line(aes(color = matrix))
	+ geom_point(data = seroprevdata, aes(x = time, y = value, color = "data"))
        + geom_vline(aes(xintercept = x), linetype = "dashed", alpha = 0.5, data = data.frame(x = beta_changepoints))
        + labs(x = "Date (Dec 2021 - June 2022)", y = "Incidence", title = "SEARCHI Model: Incidence Trajectory with Calibrated Params (macpan2)", color = "")
        + facet_wrap(~matrix, scales = "free")
        + theme_clean()
       )

print(pp)



