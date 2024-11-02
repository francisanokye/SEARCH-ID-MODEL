library(shellpipes)
library(conflicted)
library(tidyverse)
library(dplyr)
library(ggthemes)
library(broom.mixed)
library(patchwork)
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
beta_values$alert_level <- rep(c('ALS-2', 'ALS-3', 'ALS-4', 'Mod-ALS-3', 'No-ALS'), times = c(10, 15, 30, 35, 80))
beta_values$alert_level <- as.factor(beta_values$alert_level)

# Calculate means for annotation
means <- beta_values |>
  group_by(alert_level) |>
  summarise(mean_value = mean(value, na.rm = TRUE))

# colors for alert levels
alert_colors <- c('No-ALS' = "#E69F00",  # Light orange
                  'ALS-2' = "#56B4E9",         # Light blue
                  'ALS-3' = "#F0E442",         # Light yellow
                  'Mod-ALS 3' = "#D3D3D3",     # Light gray
                  'ALS-4' = "#009E73")         # Light green

# Time Series Plot with Alert Levels
betaplot <- (ggplot(beta_values, aes(x = dates, y = value, color = alert_level)) + 
	geom_line(linewidth = 1) + 
	labs(title = "Transmission Rates Accross Time", x = "Date", y = expression("("*beta*")")) + 
	scale_color_manual(values = alert_colors) + 
	theme_clean() + 
	geom_vline(data = beta_values,aes(xintercept = as.Date("2021-12-15")), colour = "gray", linetype = 2, linewidth = 0.5) + 
	geom_vline(data = beta_values,aes(xintercept = as.Date("2022-01-03")), colour = "gray", linetype = 2, linewidth = 0.5) + 
	geom_vline(data = beta_values,aes(xintercept = as.Date("2022-01-24")), colour = "gray", linetype = 2, linewidth = 0.5) + 
	geom_vline(data = beta_values,aes(xintercept = as.Date("2022-02-25")), colour = "gray", linetype = 2, linewidth = 0.5) + 
	geom_vline(data = beta_values,aes(xintercept = as.Date("2022-03-18")), colour = "gray", linetype = 1, linewidth = 0.5) + 
	theme(
	      plot.title = element_text(size = 14, face = "bold"),
	      axis.title = element_text(size = 12),
	      axis.text = element_text(size = 10),
	      legend.position = "bottom",
	      legend.text = element_text(size = 10)
	)
) 
  
# Create the plot with flipped axes, custom ordering, and unique colors
alert_boxplot <- (ggplot(beta_values, aes(x = alert_level, y = value, fill = alert_level)) 
+ geom_boxplot(color = "black", outlier.shape = NA) 
+ stat_summary(fun = mean, geom = "point", shape = 20, color = "red", size = 3) 
+ geom_text(data = means, aes(x = alert_level, y = mean_value, label = round(mean_value, 2)),vjust = -1.2, hjust = 0.97, color = "red") 
+ labs(title = "Mean Transmission Rate For Alert Levels", x = "Alert Levels" ,y = expression("Transmission Rate ("*beta*")")) 
+ scale_fill_manual(values = alert_colors) 
+ theme_clean() 
+ theme(
    axis.text.x = element_text(size = 12, hjust = 1, angle = 45),
    axis.title.x = element_text(size = 14, color = "black", face = "bold"),
    axis.text.y = element_text(size = 12),
    axis.title.y = element_text(size = 14, color = "black", face = "bold"),
    plot.title = element_text(size = 12, face = "bold", color = "black", hjust = 0.5),
    legend.position = "none"
  )
)
# combine the plots using patchwork with equal widths 
combined_plot <- betaplot + alert_boxplot + plot_layout(ncol = 2, widths = c(1, 1))  & theme(legend.position = "bottom")

# save plot 
ggsave("../../figures/combined_plot.png", plot = combined_plot, width = 25, height = 8, dpi = 300)


print(combined_plot)


