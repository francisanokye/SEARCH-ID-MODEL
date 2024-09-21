library(macpan2)
library(shellpipes)
rpcall("calibrate.Rout calibrate.R timevar_spec.rds reporteddata.rds")
library(conflicted)
library(tidyverse)
library(dplyr)
library(ggthemes)
library(broom.mixed)
set.seed(2024)

#conflicted_prefer("rdsSave", "shellpipes")

loadEnvironments()

timevar_spec <- rdsRead("timevar_spec.rds")

reporteddata <- rdsRead("reporteddata.rds")

outputs = c("S", "E", "A", "R", "C", "H", "I")

calibrator <- mp_tmb_calibrator(
  spec = timevar_spec,
  data = reporteddata,
  traj = "cases",
  outputs = c("cases",outputs),
  par = c("beta_values", "gamma")#, "phi")#,"xi", "mu", "theta", "omega", "eta") 
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
  start_date <- as.Date("2021-12-15")
  fitted_data$dates <- start_date + fitted_data$time -1

  fitted_data <- fitted_data[(fitted_data$dates >= "2021-12-15") & (fitted_data$dates <= "2022-06-02"),]
  reporteddata <- reporteddata[(reporteddata$dates >= "2021-12-15") & (reporteddata$dates <= "2022-06-02"),]
  
  unique_values_matrix <- length(unique(fitted_data$matrix))

  p <- ggplot() +
    geom_point(data = reporteddata, aes(x = dates, y = value, color = "data"), size = 1.5) +
    geom_line(data = fitted_data, aes(x = dates, y = value, color = matrix), size = 1.5) +
    # geom_ribbon(aes(x = dates, ymin = conf.low, ymax = conf.high), data = fitted_data, alpha = 0.2, fill = "red") +
    labs(x = "Date (Dec 2021  - June 2022)", y = "Omicron True Infections", title = "SEARCHI Model Fit With macpan2", color = "") +
    #annotate("text", x = as.Date("2021-12-18"), y = 700, label = expression(beta[2] == 0.20),size = 6,angle = 90, hjust = 1, color = "black")+
  #annotate("text", x = as.Date("2021-12-28"), y = 700, label = expression(beta[3] == 5.21),size = 6,angle = 90, hjust = 1,color = "black")+
  #annotate("text", x = as.Date("2022-01-30"), y = 550, label = expression(beta[4] == 0.62),size = 6,angle = 0, hjust = 1, color = "black")+
  # annotate("text", x = as.Date("2022-02-05"), y = 3, label = "Alert Level 3",size = 5,angle = 10, hjust = 1, color = "black")+
  #annotate("text", x = as.Date("2022-03-03"), y = 550, label = expression(beta[3] == 0.70),size = 6,angle = 0, hjust = 1, color = "black")+
  #annotate("text", x = as.Date("2022-05-01"), y = 1500, label = expression(beta[0] == 0.82),size = 6, hjust = 1, color = "black")+
    facet_wrap(~matrix, scales = "free") +
    theme_clean() +
    geom_vline(xintercept = as.Date("2022-03-18"), colour = "purple", linetype = 6, size = 1)  +
    #geom_vline(xintercept = as.Date("2022-04-10"), colour = "purple", linetype = 6, size = 2)  +
    geom_vline(xintercept = as.Date("2021-12-23"), colour = "gold4", linetype = 2, size = 1)  +
    geom_vline(xintercept = as.Date("2022-01-03"), colour = "gold4", linetype = 2, size = 1)  +
    geom_vline(xintercept = as.Date("2022-02-06"), colour = "gold4", linetype = 2, size = 1)  +
    geom_vline(xintercept = as.Date("2022-03-14"), colour = "gold4", linetype = 1, size = 1)  +
    #annotate("text", x = as.Date("2022-03-05"), y = 1200, label = "Pre-Cancellation of Public \nHealth Emergency Declaration",size=4, hjust=1, color = "darkblue")+
    #annotate("text", x = as.Date("2022-05-20"), y = 1200, label = "Post Cancellation of Public \nHealth Emergency Declaration",size=4, hjust=1,color = "darkblue")+
    #facet_wrap(~matrix, scales = "free")+
    theme(axis.text.x = element_text(size = 12, angle = 45, hjust = 1),
          axis.title.x = element_text(size = 12, color = "black", face = "bold"),
          axis.text.y = element_text(size = 12),
          axis.title.y = element_text(size = 12, color = "black", face = "bold"),
          plot.title = element_text(size = 12, face = "bold", color = "black", hjust = 0.5),
          legend.position = c(0.80, 0.15),
          legend.title = element_text(size = 0),
          legend.text = element_text(size = 10),
          legend.background = element_rect(color = NA),
          legend.margin = margin(0, 0, 0, 0),
          plot.background = element_blank()) +
          theme(plot.title = element_text(hjust = 0.5))

  # Conditionally apply scale_color_manual based on the number of unique values in 'matrix'
  if (unique_values_matrix == 1) {
    p <- p + scale_color_manual(labels = c("fit", "data"), values = c("red", "black"))
    p <- p + theme(legend.position = c(0.85, 0.35))
  } else {
    p <- p + scale_color_manual(labels = c("A", "C", "fit", "data", "E", "H", "I", "R", "S"),
                                values = c("#008080", "blue", "red", "black", "brown", "orange", "green", "#2192FF", "magenta"))
  }
  
  print(p)

}

plot_fit(calibrator)


rdsSave(calibrator)




