
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
print(head(seroprevdata))

population = 510550

calibrator <- rdsRead("calibrate.rds")


fitted_data <- mp_trajectory_sd(calibrator)
start_date <- as.Date("2021-12-15")
fitted_data$dates <- start_date + as.numeric(fitted_data$time) - 1
fitted_data <- fitted_data[(fitted_data$dates > "2021-12-14")& (fitted_data$dates <= "2022-06-02"),]

# select the features to plot
fitted_data <- dplyr::filter(fitted_data, matrix %in% c( "cases","report_prob", "serop"))

# subset data for "report_prob"
fitted_data_report_prob <- dplyr::filter(fitted_data, matrix == "report_prob")
# subset data without "report_prob"
fitted_data_others <- dplyr::filter(fitted_data, matrix != "report_prob")

# plot setup
pp <- (ggplot(data = fitted_data, aes(x = dates, y = value))
       + geom_point(data = seroprevdata, aes(x = dates, y = value, color = "data"))
       + geom_line(aes(color = matrix), linewidth = 1.0)
       + labs(x = "Date (Dec 15, 2021 - June 02, 2022)", y = "Cases", title = "SEARCH-ID Model Fit")
       + scale_color_manual(labels = c( "case_fit", "data", "report_prob", "serop_fit"),values = c("red", "black", "blue", "#ea801c"))
       + facet_wrap(~matrix,nrow = 2, scales = "free")
       + theme_clean()
       + theme(
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
           plot.background = element_blank())
)

# Add geom_vline only for the "report_prob" facet by using filtered data
pp <- pp + geom_vline(data = fitted_data_report_prob,
                      aes(xintercept = as.Date("2021-12-15")), colour = "gray", linetype = 2, linewidth = 0.5) +
	   geom_vline(data = fitted_data_report_prob,
                      aes(xintercept = as.Date("2022-01-03")), colour = "gray", linetype = 2, linewidth = 0.5) +
           geom_vline(data = fitted_data_report_prob,
                      aes(xintercept = as.Date("2022-01-24")), colour = "gray", linetype = 2, linewidth = 0.5) +
           geom_vline(data = fitted_data_report_prob,
                      aes(xintercept = as.Date("2022-02-25")), colour = "gray", linetype = 2, linewidth = 0.5) +
           geom_vline(data = fitted_data_report_prob,
                      aes(xintercept = as.Date("2022-03-18")), colour = "gray", linetype = 1, linewidth = 0.5)

# Add geom_vline for the rest of the facets (excluding "report_prob")
pp <- pp + geom_vline(data = fitted_data_others,aes(xintercept = as.Date("2021-12-23")), colour = "gold4", linetype = 4, linewidth = 0.5) +
           geom_vline(data = fitted_data_others,aes(xintercept = as.Date("2022-01-03")), colour = "gold4", linetype = 4, linewidth = 0.5) +
           geom_vline(data = fitted_data_others,aes(xintercept = as.Date("2022-02-06")), colour = "gold4", linetype = 4, linewidth = 0.5) +
           geom_vline(data = fitted_data_others,aes(xintercept = as.Date("2022-03-14")), colour = "gold4", linetype = 1, linewidth = 0.5) +
           geom_vline(data = fitted_data_others,aes(xintercept = as.Date("2022-03-18")), colour = "purple", linetype = 6, linewidth = 0.5)
           #geom_ribbon(data = fitted_data_others,aes(dates, ymin = conf.low, ymax = conf.high))

#ggsave("../../figures/case_serop_reportprob_plot.png", plot = pp, width = 15, height = 6, dpi = 600)


print(pp)


