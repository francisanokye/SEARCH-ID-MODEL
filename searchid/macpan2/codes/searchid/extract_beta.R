library(shellpipes)
library(conflicted)
library(tidyverse)
library(dplyr)
library(ggthemes)
library(broom.mixed)
library(macpan2)
set.seed(2024)

loadEnvironments()

calibrator <- rdsRead("calibrate.rds")

fitted_data <- mp_trajectory_sd(calibrator)
start_date <- as.Date("2021-12-15")
fitted_data$dates <- start_date + as.numeric(fitted_data$time) - 1
fitted_data <- fitted_data[(fitted_data$dates > "2021-12-14")& (fitted_data$dates <= "2022-06-02"),]

# subset beta values for boxplot
beta_values <- dplyr::filter(fitted_data, matrix %in% c("beta"))
start_date <- as.Date("2021-12-15")
beta_values$dates <- start_date + as.numeric(beta_values$time) - 1
beta_values <- beta_values[(beta_values$dates > "2021-12-14")& (beta_values$dates <= "2022-06-02"),]
beta_values <- subset(beta_values, select = c("value", "dates"))

# times when alert level chnages occurred
beta_changepoints <- c(0, 10, 25, 55, 90)
# Assign  based on index positions
beta_values$alert_level <- rep(c('ALS 2', 'ALS 3', 'ALS 4', 'Mod-ALS 3', 'SMO Repealed'), times = c(10, 15, 30, 35, 80))

# Calculate means for annotation
means <- beta_values |>
  group_by(alert_level) |>
  summarise(mean_value = mean(value, na.rm = TRUE))

# Create boxplot with mean values annotated
betaplot <- (ggplot(beta_values, aes(x = alert_level, y = value))
  + geom_boxplot(fill = "lightblue", color = "black")
  + stat_summary(fun = mean, geom = "point", shape = 20, color = "red", size = 3)
  + geom_text(data = means, aes(x = alert_level, y = mean_value, label = round(mean_value, 2)),vjust = -1.2, hjust = 0.97, color = "red")
  + labs(title = "Mean Transmission Rate For Alert Levels", x = "Alert Levels", y = expression("Transmission Rate ("*beta*")"))
  + theme_bw()
  + theme(axis.text.x = element_text(size = 10, hjust = 0.5),
               axis.title.x = element_text(size = 12, color = "black", face = "bold"),
               axis.text.y = element_text(size = 10),
               axis.title.y = element_text(size = 12, color = "black", face = "bold"),
               plot.title = element_text(size = 12, face = "bold", color = "black", hjust = 0.5),
               legend.position = "right",
               legend.title = element_text(size = 0),
               legend.text = element_text(size = 12),
               legend.background = element_rect(color = NA),
               legend.margin = margin(0, 0, 0, 0),
               plot.background = element_blank())
       + theme(plot.title = element_text(hjust = 0.5)))


print(betaplot)


