library(tidyverse)

gg <- ggplot(data = inc_sim, aes(x = time, y = value), color = "red")+
	geom_line()+
	theme_bw()

gg
