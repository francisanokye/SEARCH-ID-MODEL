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

calibrator <- rdsRead()

fitted_data <- mp_trajectory_sd(calibrator)
start_date <- as.Date("2021-12-15")
fitted_data$dates <- start_date + as.numeric(fitted_data$time) - 1
fitted_data <- fitted_data[(fitted_data$dates > "2021-12-14") & (fitted_data$dates <= "2022-03-19"),]

# subset beta values for boxplot
beta_values <- dplyr::filter(fitted_data, matrix %in% c("beta"))
start_date <- as.Date("2021-12-15")
beta_values$dates <- start_date + as.numeric(beta_values$time) - 1
beta_values <- beta_values[(beta_values$dates > "2021-12-14")& (beta_values$dates <= "2022-03-19"),]
beta_values <- subset(beta_values, select = c("value", "dates"))

# Assign  based on index positions
beta_values$alert_level <- rep(c('ALS-2', 'ALS-3', 'ALS-4', 'Mod-ALS-3', 'No-ALS'), times = c(10, 15, 30, 35, 5))
#beta_values$alert_level <- as.factor(beta_values$alert_level)
beta_values$alert_level <- factor(beta_values$alert_level, levels = c("No-ALS", "ALS-2", "ALS-3", "Mod-ALS-3", "ALS-4"))


# calculate means for annotation
means <- beta_values |>
  group_by(alert_level) |>
  summarise(mean_value = mean(value, na.rm = TRUE)
  )

  # colors for alert levels
alert_colors <- c('ALS-2' = "green", 'ALS-3' = "#CDA4DE", 'ALS-4' = "#FF9800",'Mod-ALS-3' = "#EADDF0", 'No-ALS' = "lightblue")        

betaplot <- (ggplot() +
  geom_line(data = beta_values, aes(x = dates, y = value), linewidth = 2, color = "black") + 
  geom_line(data = beta_values %>% dplyr::filter(alert_level == "No-ALS"), aes(x = dates, y = value, color = alert_level), linewidth = 2) +
  geom_line(data = beta_values %>% dplyr::filter(alert_level == "ALS-2"), aes(x = dates, y = value, color = alert_level), linewidth = 2) +
  geom_line(data = beta_values %>% dplyr::filter(alert_level == "ALS-3"), aes(x = dates, y = value, color = alert_level), linewidth = 2) +
  geom_line(data = beta_values %>% dplyr::filter(alert_level == "Mod-ALS-3"), aes(x = dates, y = value, color = alert_level), linewidth = 2) +
  geom_line(data = beta_values %>% dplyr::filter(alert_level == "ALS-4"), aes(x = dates, y = value, color = alert_level), linewidth = 2) +
  labs(title = "Transmission Rates Across Time", x = "Date (Dec 15, 2021 - June 02, 2022)", y = expression(""*beta*"")) +
  scale_color_manual(values = alert_colors, name = "Alert Level") +
  theme_clean() +  
  geom_vline(data = beta_values,aes(xintercept = as.Date("2021-12-23")), colour = "grey", linetype = 2, linewidth = 1) +
  geom_vline(data = beta_values,aes(xintercept = as.Date("2022-01-06")), colour = "grey", linetype = 2, linewidth = 1) +
  geom_vline(data = beta_values,aes(xintercept = as.Date("2022-02-06")), colour = "grey", linetype = 2, linewidth = 1) +
  geom_vline(data = beta_values,aes(xintercept = as.Date("2022-03-14")), colour = "grey", linetype = 2, linewidth = 1) +
  geom_vline(data = beta_values,aes(xintercept = as.Date("2022-03-18")), colour = "black", linetype = 2, linewidth = 1) +
  theme(
    axis.text.x = element_text(size = 12, hjust = 1, angle = 45),
    axis.title.x = element_text(size = 12, color = "black", face = "bold"),
    axis.text.y = element_text(size = 12),
    axis.title.y = element_text(size = 12, color = "black", face = "bold"),
    plot.title = element_text(size = 12, face = "bold"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 12),
    legend.position = "bottom",
    legend.justification = "center",
    legend.background = element_blank(),  
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 0),
    panel.border = element_blank(),       
    plot.background = element_blank()      
  ))

alert_boxplot <- (ggplot(beta_values, aes(x = alert_level, y = value, fill = alert_level)) +  
  geom_boxplot(color = "black", outlier.shape = NA) +
  stat_summary(fun = mean, geom = "point", shape = 20, color = "red", size = 3) +
  geom_text(data = means, aes(x = alert_level, y = mean_value, label = round(mean_value, 2)),vjust = -1.5, hjust = 0.40, color = "red", size = 5)+
  labs(title = "Mean Transmission Rate For Alert Levels", x = "Alert Levels", y = expression(""*beta*"")) +
  scale_fill_manual(values = alert_colors, guide = "none") + 
  theme_clean() + 
  theme(
    axis.text.x = element_text(size = 10, hjust = 1, angle = 45),
    axis.title.x = element_text(size = 12, color = "black", face = "bold"),
    axis.text.y = element_text(size = 12),
    axis.title.y = element_text(size = 12, color = "black", face = "bold"),
    plot.title = element_text(size = 12, face = "bold", color = "black", hjust = 0.5),
    legend.position = "none", 
    panel.border = element_blank(),        
    plot.background = element_blank()    
  )
 )

# combine the plots using patchwork with equal widths 
combined_plot <- (betaplot | alert_boxplot) + plot_layout(guides = "collect", widths = c(1, 1)) & theme(legend.position = "bottom")
# save plot 
#ggsave("../../figures/beta_boxplot.png", plot = combined_plot, width = 10, height = 6, dpi = 600)


print(combined_plot)


