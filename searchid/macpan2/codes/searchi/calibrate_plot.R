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

fitted_data <- mp_trajectory_sd(calibrator)
start_date <- as.Date("2021-12-15")
fitted_data$dates <- start_date + as.numeric(fitted_data$time) - 1
fitted_data <- fitted_data[(fitted_data$dates > "2021-12-14")& (fitted_data$dates <= "2022-06-02"),]

gg <- (ggplot(fitted_data, aes(x = dates, y = value))
   + geom_point(data = seroprevdata, aes(x = dates, y = value, color = "data"))
   + geom_line(aes(color = matrix),linewidth = 1)
   + geom_vline(xintercept = as.Date("2022-03-18"), colour = "purple", linetype = 6, size = 1)  
   + geom_vline(xintercept = as.Date("2021-12-23"), colour = "gold4", linetype = 2, size = 1)  
   + geom_vline(xintercept = as.Date("2022-01-03"), colour = "gold4", linetype = 2, size = 1)  
   + geom_vline(xintercept = as.Date("2022-02-06"), colour = "gold4", linetype = 2, size = 1)  
   + geom_vline(xintercept = as.Date("2022-03-14"), colour = "gold4", linetype = 1, size = 1)  
   + scale_color_manual(labels = c("A","C","fit_cases", "data","C", "E", "H", "I", "R","report_prob","S","fit_serop"),
                        values = c("#2192FF","red", "#008080","black", "blue", "green", "orange", "#2192FF", "magenta","red", "#2192FF"))
   + facet_wrap(~matrix, scales = "free")
   + theme_bw()
   + theme(axis.text.x = element_text(size = 12, angle = 45, hjust = 1),
                axis.title.x = element_text(size = 12, color = "black", face = "bold"),
                axis.text.y = element_text(size = 12),
                axis.title.y = element_text(size = 12, color = "black", face = "bold"),
                plot.title = element_text(size = 12, face = "bold", color = "black", hjust = 0.5),
                legend.position = "bottom",#c(0.85, 0.10),
                legend.title = element_text(size = 0),
                legend.text = element_text(size = 10),
                legend.background = element_rect(color = NA),
                legend.margin = margin(0, 0, 0, 0),
		legend.box = "horizontal",  # Arrange legend horizontally
      		legend.key.size = unit(0.5, "lines"),
                plot.background = element_blank()) +
        theme(plot.title = element_text(hjust = 0.5)) 
)
print(gg)
