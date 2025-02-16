library(macpan2)
library(shellpipes)
library(conflicted)
library(tidyverse)
library(dplyr)
library(ggthemes)
library(broom.mixed)
set.seed(2025)

loadEnvironments()

seroprevdata <- rdsRead("seroprevdata.rds")

population = 510550

calibrator <- rdsRead("calibrate.rds")

print(calibrator)

fitted_data <- mp_trajectory_sd(calibrator, conf.int = TRUE)

fitted_data <- (fitted_data
	|> mutate(dates = as.Date(start_date) + as.numeric(time) -1 )
	|> dplyr::filter(between(dates, as.Date(start_date), as.Date(last_date)))
)

fitted_data <- dplyr::filter(fitted_data, matrix %in% c("beta","cases", "report_prob","serop"))

# subset data for "report_prob"
fitted_data_report_prob <- dplyr::filter(fitted_data, matrix == "report_prob")

# subset data without "report_prob"
fitted_data_others <- dplyr::filter(fitted_data, matrix != "report_prob")

# plot setup 
pp <- (ggplot(data = fitted_data, aes(x = dates, y = value)) 
       + geom_point(data = seroprevdata, aes(x = dates, y = value, color = "data")) 
       
       # Apply geom_smooth only to non-report_prob data
       + geom_smooth(data = fitted_data_others, aes(color = matrix), span = 0.15, alpha = 0.7, linewidth = 1.5) 

       # Use geom_line instead for "report_prob" to ensure it remains in the plot
       + geom_line(data = fitted_data_report_prob, aes(color = matrix), linewidth = 1.0)

       + labs(x = "Date (Dec 15, 2021 - May 26, 2022)", y = "Incidence", title = "SEARCH-ID Model Fit", color = "") 
       + scale_color_manual(labels = c("beta", "case_fit", "data","report_prob", "serop_fit"), 
                            values = c("blue","red", "black", "#800074", "orange")) 
       + facet_wrap(~matrix, scales = "free") 
       + theme_clean() 
       + theme(axis.text.x = element_text(size = 8, angle = 45, hjust = 0.5), 
               axis.title.x = element_text(size = 8, color = "black", face = "bold"), 
               axis.text.y = element_text(size = 8), 
               axis.title.y = element_text(size = 8, color = "black", face = "bold"), 
               plot.title = element_text(size = 8, face = "bold", color = "black", hjust = 0.5), 
               legend.position = "bottom", 
               legend.title = element_text(size = 0), 
               legend.text = element_text(size = 8), 
               legend.background = element_rect(color = NA), 
               legend.margin = margin(0, 0, 0, 0), 
               plot.background = element_blank()) 
       + theme(plot.title = element_text(hjust = 0.5))) 
 
# Add geom_vline only for the "report_prob" facet by using filtered data 
pp <- pp + geom_vline(data = fitted_data_report_prob, aes(xintercept = as.Date("2021-12-15")), colour = "gray", linetype = 2, linewidth = 0.5) + 
           geom_vline(data = fitted_data_report_prob, aes(xintercept = as.Date("2022-01-03")), colour = "gray", linetype = 2, linewidth = 0.5) + 
           geom_vline(data = fitted_data_report_prob, aes(xintercept = as.Date("2022-01-24")), colour = "gray", linetype = 2, linewidth = 0.5) + 
           geom_vline(data = fitted_data_report_prob, aes(xintercept = as.Date("2022-02-25")), colour = "gray", linetype = 2, linewidth = 0.5) + 
           geom_vline(data = fitted_data_report_prob, aes(xintercept = as.Date("2022-03-18")), colour = "gray", linetype = 1, linewidth = 0.5) 
 
# Add geom_vline for the rest of the facets (excluding "report_prob") 
pp <- pp + geom_vline(data = fitted_data_others, aes(xintercept = as.Date("2021-12-23")), colour = "gold4", linetype = 4, linewidth = 0.5) + 
           geom_vline(data = fitted_data_others, aes(xintercept = as.Date("2022-01-03")), colour = "gold4", linetype = 4, linewidth = 0.5) + 
           geom_vline(data = fitted_data_others, aes(xintercept = as.Date("2022-02-06")), colour = "gold4", linetype = 4, linewidth = 0.5) + 
           geom_vline(data = fitted_data_others, aes(xintercept = as.Date("2022-03-14")), colour = "gold4", linetype = 1, linewidth = 0.5) + 
           geom_vline(data = fitted_data_others, aes(xintercept = as.Date("2022-03-18")), colour = "purple", linetype = 6, linewidth = 0.5) + 
           geom_ribbon(data = fitted_data_others, aes(dates, ymin = conf.low, ymax = conf.high), alpha = 0.05) 

print(pp)

