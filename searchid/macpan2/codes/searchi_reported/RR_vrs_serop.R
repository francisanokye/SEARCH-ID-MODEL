library(macpan2)
library(shellpipes)
library(tidyverse)
library(ggthemes)

loadEnvironments()

n = 170

calobj = rdsRead("calibrate.rds")
# reporteddata = rdsRead("reporteddata.rds")
serodata <- rdsRead("serodata.rds")
serodata <- serodata[(serodata$dates > "2021-12-14") &(serodata$dates <= "2022-06-02"),]

population = 510550

plot_seroprevalence = function(cal_object) {
  fitted_data = mp_trajectory_sd(cal_object)
  start_date <- as.Date("2021-12-15")
  fitted_data$dates <- start_date + fitted_data$time - 1

  fitted_data <- fitted_data[fitted_data$matrix == "R",]
  fitted_data <- fitted_data[(fitted_data$dates > "2021-12-14")& (fitted_data$dates <= "2022-06-02"),]
  print(head(fitted_data$value,15))
  print(tail(fitted_data$value,15))
  ggplot() +
        geom_line(data = serodata, aes(x = dates, y = daily_serop, color = "CITF Seroprevalence"), linewidth = 1.5) +
        geom_line(data = fitted_data, aes(x = dates, y = value/510550, color = "Recovery Per Capita"), linewidth = 1.5) +
        scale_color_manual(labels = c("Recovery Per Capita","CITF Seroprevalence"), values =c("darkgreen","brown")) +
        labs(x = "Date", y = "Seroprevalence", title = "Recovery Per Capita and CITF Seroprevalence", color = "") +
        geom_vline(xintercept = as.Date("2022-03-18"), colour = "purple", linetype = 6, size = 1)  +
        geom_vline(xintercept = as.Date("2021-12-23"), colour = "gold4", linetype = 2, size = 1)  +
        geom_vline(xintercept = as.Date("2022-01-03"), colour = "gold4", linetype = 2, size = 1)  +
        geom_vline(xintercept = as.Date("2022-02-06"), colour = "gold4", linetype = 2, size = 1)  +
        geom_vline(xintercept = as.Date("2022-03-14"), colour = "gold4", linetype = 1, size = 1)  +
        theme_clean() +
        theme(axis.text.x = element_text(size = 20, angle = 45, hjust = 1),
                axis.title.x = element_text(size = 18, color = "black", face = "bold"),
                axis.text.y = element_text(size = 18),
                axis.title.y = element_text(size = 18, color = "black", face = "bold"),
                plot.title = element_text(size = 18, face = "bold", color = "black", hjust = 0.5),
                legend.position = c(0.25, 0.85),
                legend.title = element_text(size = 20),
                legend.text = element_text(size = 15),
                legend.background = element_rect(color = NA),
                legend.margin = margin(0, 0, 0, 0),
                plot.background = element_blank()) +
        theme(plot.title = element_text(hjust = 0.5))
        }

pdf("RR_vrs_serop.Rout.pdf")
plot_seroprevalence(calobj)
dev.off()


