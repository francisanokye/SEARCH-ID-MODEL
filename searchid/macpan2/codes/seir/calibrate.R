library(macpan2)
library(shellpipes)
rpcall("calibrate.Rout calibrate.R timevar_spec.rds seroprevdata.rds params.rda timevar_spec.R")
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

outputs = c("S", "E", "I", "R", "cases","beta","serop", "report_prob")

population = 510550
if (interactive()) debug(mp_tmb_calibrator)
head(seroprevdata)
calibrator <- mp_tmb_calibrator(
  spec = timevar_spec |> mp_hazard()
  , data = dplyr::filter(seroprevdata, time < 201)
  , traj = list(
      cases = mp_neg_bin(disp = mp_fit(1))
    , serop = mp_log_normal(sd = mp_nofit(0.5))
  )
  , outputs = c(outputs)
  , par = "beta"
  #, par = list(
       #beta_values = mp_log_normal(params$beta, 1)
#      , reporting_values = mp_log_normal(params$report_prob, 1)
     #, gamma = mp_log_normal(params$gamma, 0.1)
     #, sigma = mp_log_normal(params$sigma, 0.1)
#     , log_I0 = mp_normal(10, 1)
#    , log_E0 = mp_normal(10, 1)
     #, report_prob = mp_log_normal(params$report_prob, 1)
  #)
  #, tv = mp_rbf("report_prob", 10)
  , tv = mp_rbf("beta", 15, fit_prior_sd = FALSE, prior_sd = 1)
  , time = mp_sim_bounds(-30, 200, "daily")
)

mp_optimize(calibrator)




rdsSave(calibrator)
