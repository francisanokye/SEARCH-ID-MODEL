library(macpan2)
library(shellpipes)
library(tidyverse)
library(ggthemes)

loadEnvironments()

n = 170

calobj = rdsRead("calibrate.rds")
# reporteddata = rdsRead("reporteddata.rds")
serodata <- rdsRead("serodata.rds")
serodata <- serodata[(serodata$dates >= "2021-12-15") &(serodata$dates <= "2022-03-18"),]

population = 510550

plot_seroprevalence = function(cal_object) {
  fitted_data = mp_trajectory_sd(cal_object)
  start_date <- as.Date("2021-12-15")
  fitted_data$dates <- start_date + fitted_data$time - 1
  
  #serrow_data <- fitted_data %>%
  #filter(matrix %in% c("A", "I", "R")) %>%
  #group_by(dates, time, row, col) %>%
  #summarize(value = sum(value), 
  #          sd = NA,  # Adjust as needed, handling 'sd' appropriately
  #          matrix = "serrow",  # Assign 'serrow' to the matrix column
  #          .groups = 'drop')  # Ungroup after summarization

  # Bind the original data with the new 'serrow' rows
  #combined_data <- bind_rows(fitted_data, serrow_data)

  # Optionally sort by dates, time, etc. to maintain orderz
  #combined_data <- combined_data %>%
  #  arrange(dates, time, row, col)

  fitted_data <- fitted_data[(fitted_data$matrix == "R"),]
  
  fitted_data <- fitted_data[(fitted_data$dates >= "2021-12-15")& (fitted_data$dates <= "2022-03-18"),]
  
  ggplot() +
        geom_line(data = serodata, aes(x = dates, y = daily_serop, color = "CITF Seroprevalence"), linewidth = 1.5) +
        geom_line(data = fitted_data, aes(x = dates, y = value/population, color = "Recovery Per Capita"), linewidth = 1.5) +
        scale_color_manual(labels = c("CITF Seroprevalence", "Recovery Per Capita"), values =c("maroon","darkgreen")) +
        labs(x = "Date", y = "Seroprevalence", title = "Recovery Per Capita and CITF Seroprevalence", color = "") +
        geom_vline(xintercept = as.Date("2022-03-18"), colour = "purple", linetype = 6, size = 1)  +
        geom_vline(xintercept = as.Date("2021-12-23"), colour = "gold4", linetype = 2, size = 1)  +
        geom_vline(xintercept = as.Date("2022-01-03"), colour = "gold4", linetype = 2, size = 1)  +
        geom_vline(xintercept = as.Date("2022-02-06"), colour = "gold4", linetype = 2, size = 1)  +
        geom_vline(xintercept = as.Date("2022-03-14"), colour = "gold4", linetype = 1, size = 1)  +
        #facet_wrap(~matrix, scale = "free")+
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


