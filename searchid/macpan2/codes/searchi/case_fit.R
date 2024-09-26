library(macpan2)
library(shellpipes)
library(tidyverse)
library(ggthemes)

loadEnvironments()

n = 170

calobj = rdsRead("calibrate.rds")
seroprevdata <- rdsRead("seroprevdata.rds")
seroprevdata <- seroprevdata[seroprevdata$matrix == "cases",]

plot_case_fit = function(cal_object) {
      fitted_data = mp_trajectory_sd(calobj)
      start_date <- as.Date("2021-12-15")
      fitted_data$dates <- start_date + fitted_data$time - 1

      fitted_data <- fitted_data[fitted_data$matrix == "cases",]
      fitted_data <- fitted_data[(fitted_data$dates > "2021-12-14")& (fitted_data$dates <= "2022-06-02"),]
      ggplot() +
        geom_point(data = seroprevdata, aes(x = dates, y = value, color = "Cases"), linewidth = 2) +
        geom_point(data = fitted_data, aes(x = dates, y = value, color = "Fit"), linewidth = 2) +
        scale_color_manual(labels = c("Cases", "Fit"), values =c("black","red")) +
        labs(x = "Date", y = "Number of Cases", title = "Serology-Derived Daily Incidence vrs Model Fit", color = "") +
        geom_vline(xintercept = as.Date("2022-03-18"), colour = "purple", linetype = 6, size = 1)  +
        geom_vline(xintercept = as.Date("2021-12-23"), colour = "gold4", linetype = 2, size = 1)  +
        geom_vline(xintercept = as.Date("2022-01-03"), colour = "gold4", linetype = 2, size = 1)  +
        geom_vline(xintercept = as.Date("2022-02-06"), colour = "gold4", linetype = 2, size = 1)  +
        geom_vline(xintercept = as.Date("2022-03-14"), colour = "gold4", linetype = 1, size = 1)  +
        annotate("text", x = as.Date("2021-12-18"), y = 900, label = expression(beta[2] == 0.405),size = 5,angle = 90, hjust = 1, color = "black")+
  	annotate("text", x = as.Date("2021-12-28"), y = 900, label = expression(beta[3] == 0.405),size = 5,angle = 90, hjust = 1,color = "black")+
  	annotate("text", x = as.Date("2022-02-01"), y = 900, label = expression(beta[4] == 0.395),size = 5,angle = 0, hjust = 1, color = "black")+
  # annotate("text", x = as.Date("2022-02-05"), y = 3, label = "Alert Level 3",size = 5,angle = 10, hjust = 1, color = "black")+
  	annotate("text", x = as.Date("2022-03-08"), y = 550, label = expression(beta[3] == 0.390),size = 5,angle = 0, hjust = 1, color = "black")+
  	annotate("text", x = as.Date("2022-05-01"), y = 550, label = expression(beta[0] == 0.393),size = 5, hjust = 1, color = "black")+
	theme_clean() +
        theme(axis.text.x = element_text(size = 20, angle = 45, hjust = 1),
                axis.title.x = element_text(size = 18, color = "black", face = "bold"),
                axis.text.y = element_text(size = 18),
                axis.title.y = element_text(size = 18, color = "black", face = "bold"),
                plot.title = element_text(size = 18, face = "bold", color = "black", hjust = 0.5),
                legend.position = c(0.85, 0.5),
                legend.title = element_text(size = 20),
                legend.text = element_text(size = 15),
                legend.background = element_rect(color = NA),
                legend.margin = margin(0, 0, 0, 0),
                plot.background = element_blank()) +
        theme(plot.title = element_text(hjust = 0.5))
        }

pdf("case_fit.Rout.pdf")
plot_case_fit(calobj)
dev.off()

