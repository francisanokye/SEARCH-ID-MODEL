library(macpan2)
library(shellpipes)
library(tidyverse)
library(ggthemes)

loadEnvironments()

n = 170

calobj = rdsRead("calibrate.rds")

reporteddata <- rdsRead("reporteddata.rds")
reporteddata <- reporteddata[(reporteddata$dates > "2021-12-14") &(reporteddata$dates <= "2022-03-18"),]

inc_sim <- mp_trajectory_sd(calobj, conf.int = TRUE)
start_date <- as.Date("2021-12-15")
inc_sim$dates <- start_date + inc_sim$time - 1
inc_sim <- inc_sim[(inc_sim$dates <= "2022-03-18"),]

beta_changepoints = c(0, 10, 21, 55, 90)
unique_values_matrix <- length(unique(inc_sim$matrix))

pp <- (ggplot(data = inc_sim, aes(x = dates, y= value))
        + geom_line(aes(color = matrix),linewidth = 1.5)
	+ geom_point(data = reporteddata, aes(x = dates, y = value, color = "data"))
	#+ geom_vline(aes(xintercept = x), linetype = "dashed",color = "gold4" , alpha = 0.5, data = data.frame(x = beta_changepoints))
        + geom_vline(xintercept = as.Date("2022-03-18"), colour = "purple", linetype = 4, size = 1)
	+ geom_vline(xintercept = as.Date("2021-12-23"), colour = "gold4", linetype = 4, size = 1)
	+ geom_vline(xintercept = as.Date("2022-01-03"), colour = "gold4", linetype = 4, size = 1)
        + geom_vline(xintercept = as.Date("2022-02-06"), colour = "gold4", linetype = 4, size = 1)
	+ geom_vline(xintercept = as.Date("2022-03-14"), colour = "gold4", linetype = 1, size = 1)
	+ labs(x = "Date (Dec 15, 2021 - March 18, 2022)", y = "Incidence", title = "SEARCHI Model Simulation: Incidence Trajectory", color = "")
        + facet_wrap(~matrix, scales = "free")
        + theme_clean()
	+ theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          axis.title.x = element_text(size = 15, color = "black", face = "bold"),
          axis.text.y = element_text(size = 10),
          axis.title.y = element_text(size = 15, color = "black", face = "bold"),
          plot.title = element_text(size = 18, face = "bold", color = "black", hjust = 0.5),
          legend.position = "right",
          legend.title = element_text(size = 15),
          legend.text = element_text(size = 10),
          legend.background = element_rect(color = NA),
          legend.margin = margin(0, 0, 0, 0),
          plot.background = element_blank()) +
    	  theme(plot.title = element_text(hjust = 0.5))
       )

if (unique_values_matrix == 1) {
    pp <- pp + scale_color_manual(labels = c("fit", "data"), values = c("red", "black"))
    pp <- pp + theme(legend.position = c(0.85, 0.35))
  } else {
    pp <- pp + scale_color_manual(labels = c("A", "C", "fit", "data", "E", "H", "I", "R", "S","serop"),
                                values = c("#008080", "blue", "red", "black", "brown", "orange", "green", "#2192FF", "magenta", "yellow4"))
  }

print(pp)
