library(macpan2)
library(shellpipes)
library(tidyverse)
library(ggthemes)

loadEnvironments()

n = 170

calobj = rdsRead("calibrate.rds")

seroprevdata <- rdsRead("seroprevdata.rds")

inc_sim <- mp_trajectory(calobj)

# Define the start date
start_date <- as.Date("2021-12-15")
# Generate a sequence of dates based on the 'time' column
inc_sim$dates <- start_date + inc_sim$time - 1

print(head(inc_sim))
print(head(seroprevdata))

outputs = c("cases","S", "E", "A", "R", "C", "H", "I")

#beta_changepoints = c(0, 10, 21, 55, 90)

unique_values_matrix <- length(unique(inc_sim$matrix))

pp <- (ggplot(data = inc_sim, aes(x = dates, y= value))
       + geom_line(aes(color = matrix), linewidth = 1.5)
       + geom_point(data = seroprevdata, aes(x = dates, y = value, color = "data"), size = 1.1)
       + labs(x = "Date (Dec 2021 - June 2022)", y = "Incidence", title = "SEARCHI Incidence Trajectory: Calibrated Params (macpan2)", color = "")
       + theme_clean()
       + facet_wrap(~matrix, scales = "free")
       + geom_vline(xintercept = as.Date("2022-03-18"), colour = "purple", linetype = 4, size = 1)  
       #geom_vline(xintercept = as.Date("2022-04-10"), colour = "purple", linetype = 6, size = 2)  
       + geom_vline(xintercept = as.Date("2021-12-23"), colour = "gold4", linetype = 4, size = 1)  
       + geom_vline(xintercept = as.Date("2022-01-03"), colour = "gold4", linetype = 4, size = 1)  
       + geom_vline(xintercept = as.Date("2022-02-06"), colour = "gold4", linetype = 4, size = 1)  
       + geom_vline(xintercept = as.Date("2022-03-14"), colour = "gold4", linetype = 1, size = 1) 
       + theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
               axis.title.x = element_text(size = 15, color = "black", face = "bold"),
               axis.text.y = element_text(size = 10),
               axis.title.y = element_text(size = 15, color = "black", face = "bold"),
               plot.title = element_text(size = 15, face = "bold", color = "black", hjust = 0.5),
               legend.position = c(0.85, 0.1),
               legend.title = element_text(size = 10),
               legend.text = element_text(size = 10),
               legend.background = element_rect(color = NA),
               legend.margin = margin(0, 0, 0, 0),
               plot.background = element_blank()) +
         theme(plot.title = element_text(hjust = 0.5))
)

# Conditionally apply scale_color_manual based on the number of unique values in 'matrix'
if (unique_values_matrix == 1) {
  pp <- pp + scale_color_manual(labels = c("fit", "data"), values = c("red", "black"))
  pp <- pp + theme(legend.position = c(0.85, 0.35))
  
} else {
  pp <- pp + scale_color_manual(labels = c("A", "C", "fit", "data", "E", "H", "I", "R", "S"),
                                values = c("#008080", "blue", "red", "black", "purple", "orange", "navy", "green", "brown"))
  
}
print(pp)



