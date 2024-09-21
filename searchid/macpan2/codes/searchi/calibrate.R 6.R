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
  par = c("beta_values","gamma")#,"mu")#,"phi")#, "phi","gamma", "xi", "theta", "omega", "eta") 
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
  fitted_data$dates <- start_date + fitted_data$time - 1
  
  reporteddata <- reporteddata[(reporteddata$dates >= "2021-12-15") & (seroprevdata$dates <= "2022-06-02"),]

  unique_values_matrix <- length(unique(fitted_data$matrix))
  beta_changepoints = c(0, 10, 21, 55, 90)

  pp <- (ggplot(data = fitted_data, aes(x = time, y= value))
        + geom_line(aes(color = matrix),linewidth = 1.5)
        + geom_point(data = reporteddata, aes(x = time, y = value, color = "data"))
        + geom_vline(aes(xintercept = x), linetype = "dashed",color = "gold4" , alpha = 0.5, data = data.frame(x = beta_changepoints))
        #+ geom_vline(xintercept = as.Date("2022-03-18"), colour = "purple", linetype = 4, size = 1)
        #+ geom_vline(xintercept = as.Date("2021-12-23"), colour = "gold4", linetype = 4, size = 1)
        #+ geom_vline(xintercept = as.Date("2022-01-03"), colour = "gold4", linetype = 4, size = 1)
        #+ geom_vline(xintercept = as.Date("2022-02-06"), colour = "gold4", linetype = 4, size = 1)
        #+ geom_vline(xintercept = as.Date("2022-03-14"), colour = "gold4", linetype = 1, size = 1)
        + labs(x = "Date (Dec 2021 - June 2022)", y = "Incidence", title = "SEARCHI Model Fit", color = "")
        + facet_wrap(~matrix, scales = "free")
        + theme_clean()
        + theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
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
       )

  if (unique_values_matrix == 1) {
    pp <- pp + scale_color_manual(labels = c("fit", "data"), values = c("red", "black"))
    pp <- pp + theme(legend.position = c(0.85, 0.35))
  } else {
    pp <- pp + scale_color_manual(labels = c("A", "C", "fit", "data", "E", "H", "I", "R", "S"),
                                values = c("#008080", "blue", "red", "black", "brown", "orange", "green", "#2192FF", "magenta"))
  }

  print(pp)
}

plot_fit(calibrator)


rdsSave(calibrator)




