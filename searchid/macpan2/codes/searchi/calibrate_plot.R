library(macpan2)
library(shellpipes)
library(conflicted)
library(tidyverse)
library(dplyr)
library(ggthemes)
library(broom.mixed)
set.seed(2024)

loadEnvironments()

seroprevdata <- rdsRead("seroprevdata.rds")

population = 510550

calibrator <- rdsRead("calibrate.rds")

ff <- mp_trajectory_sd(calibrator)

print(ff)

gg <- (ggplot(ff,aes(x=time,y=value))
	+ facet_wrap(~matrix,scale="free")
   + geom_point(data = seroprevdata, aes(x = time, y = value, color = "data"))
	+ geom_line()
	+ theme_bw()
)

print(gg)


print(gg + xlim(c(90,200)))



