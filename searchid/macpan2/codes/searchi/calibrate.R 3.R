library(macpan2)
library(shellpipes)
rpcall("calibrate.Rout calibrate.R timevar_spec.rds seroprevdata.rds")
library(conflicted)
library(tidyverse)
library(dplyr)
library(ggthemes)
library(broom.mixed)
set.seed(2024)

#conflicted_prefer("rdsSave", "shellpipes")

loadEnvironments()

timevar_spec <- rdsRead("timevar_spec.rds")

seroprevdata <- rdsRead("seroprevdata.rds")

outputs =c("S", "E", "A", "R", "C", "H", "I")

population = 510550

calibrator <- mp_tmb_calibrator(
  spec = timevar_spec,
  data = seroprevdata,
  traj = "cases",
  outputs = c("cases",outputs),
  par = c("beta_values","mu")#,"gamma","mu")#, "phi","mu", "xi", "theta", "omega", "eta") 
)

mp_optimize(calibrator)


##########################################################################################
# see here, https://github.com/canmod/macpan2/issues/179
backtrans <- function(x) {
  vars1 <- intersect(c("default", "estimate", "conf.low", "conf.high"), names(x))
  prefix <- stringr::str_extract(x[["mat"]], "^log(it)?_")  |> tidyr::replace_na("none")
  sx <- split(x, prefix)
  for (ptype in setdiff(names(sx), "none")) {
    link <- make.link(stringr::str_remove(ptype, "_"))
    sx[[ptype]] <- (sx[[ptype]]
                    |> mutate(across(std.error, ~link$mu.eta(estimate)*.))
                    |> mutate(across(any_of(vars1), link$linkinv))
                    |> mutate(across(mat, ~stringr::str_remove(., paste0("^", ptype))))
    )
  }
  bind_rows(sx)
}
##########################################################################################

coeff <- mp_tmb_coef(calibrator, conf.int = TRUE) |> backtrans()
print(coeff)
############ Visualize simulation with calibrated paramters against the observed data ###########


plot_fit = function(cal_object) {
  fitted_data = mp_trajectory_sd(cal_object)
  # Define the start date
  start_date <- as.Date("2021-12-15")
  # Generate a sequence of dates based on the 'time' column
  fitted_data$dates <- start_date + fitted_data$time - 1
  print(head(fitted_data,20))
  # Check the number of unique values in the 'matrix' column
  unique_values_matrix <- length(unique(fitted_data$matrix))
  
  p <- ggplot(data = fitted_data, aes(x = dates, y = value)) +
    geom_line(aes(color = factor(matrix)), linewidth = 1.5) +  # Ensure 'matrix' is a valid factor
    geom_point(data = seroprevdata, aes(x = dates, y = value, color = "data"), size = 2) +
    #geom_vline(aes(xintercept = x), linetype = "dashed",color = "gold4", alpha = 0.95,size = 1.1, data = data.frame(x = beta_changepoints)) +
    labs(x = "Date (Dec 2021 – June 2022)", y = "Incidence", title = "SEARCHI Model Fit: Incidence Trajectory (macpan2)", color = "") +
    theme_clean()+
    facet_wrap(~matrix, scales = "free") +
    #annotate("text", x = as.Date("2021-12-18"), y = 200, label = expression(beta[2] == 0.20),size = 1,angle = 90, hjust = 1, color = "black")+
    #annotate("text", x = as.Date("2021-12-28"), y = 200, label = expression(beta[3] == 5.21),size = 1,angle = 90, hjust = 1,color = "black")+
    #annotate("text", x = as.Date("2022-01-30"), y = 250, label = expression(beta[4] == 0.62),size = 1,angle = 0, hjust = 1, color = "black")+
    #annotate("text", x = as.Date("2022-02-05"), y = 3, label = "Alert Level 3",size = 5,angle = 10, hjust = 1, color = "black")+
    #annotate("text", x = as.Date("2022-03-03"), y = 250, label = expression(beta[3] == 0.70),size = 1,angle = 0, hjust = 1, color = "black")+
    #annotate("text", x = as.Date("2022-05-01"), y = 200, label = expression(beta[0] == 0.82),size = 1, hjust = 1, color = "black")+
    geom_vline(xintercept = as.Date("2022-03-18"), colour = "purple", linetype = 4, size = 1)  +
    geom_vline(xintercept = as.Date("2021-12-23"), colour = "gold4", linetype = 4, size = 1)  +
    geom_vline(xintercept = as.Date("2022-01-03"), colour = "gold4", linetype = 4, size = 1)  +
    geom_vline(xintercept = as.Date("2022-02-06"), colour = "gold4", linetype = 4, size = 1)  +
    geom_vline(xintercept = as.Date("2022-03-14"), colour = "gold4", linetype = 1, size = 1)  +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          axis.title.x = element_text(size = 15, color = "black", face = "bold"),
          axis.text.y = element_text(size = 10),
          axis.title.y = element_text(size = 15, color = "black", face = "bold"),
          plot.title = element_text(size = 18, face = "bold", color = "black", hjust = 0.5),
          legend.position = c(0.85, 0.10),
          legend.title = element_text(size = 15),
          legend.text = element_text(size = 10),
          legend.background = element_rect(color = NA),
          legend.margin = margin(0, 0, 0, 0),
          plot.background = element_blank()) +
    theme(plot.title = element_text(hjust = 0.5))
  
  # Conditionally apply scale_color_manual based on the number of unique values in 'matrix'
  if (unique_values_matrix == 1) {
    p <- p + scale_color_manual(labels = c("cases", "data"), values = c("red", "black"))
    p <- p + theme(legend.position = c(0.85, 0.35))
  } else {
    p <- p + scale_color_manual(labels = c("A", "C", "cases", "data", "E", "H", "I", "R", "S"),
                                values = c("#008080", "blue", "red", "black", "purple", "orange", "navy", "green", "brown"))
  }
  
  print(p)
}


plot_fit(calibrator)


rdsSave(calibrator)




