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

outputs = c("S", "E", "I", "R", "cases","sero_cases","serop", "report_prob")

population = 510550

head(seroprevdata)
calibrator <- mp_tmb_calibrator(
  spec = timevar_spec |> mp_hazard()
  , data = seroprevdata
  , traj = list(
      cases = mp_neg_bin(disp = mp_fit(1))
    , serop = mp_log_normal(sd = mp_nofit(0.5))
  )
  , outputs = c(outputs)
  , par = list(
       beta_values = mp_log_normal(params$beta, 1)
     #, gamma = mp_log_normal(params$gamma, 0.1)
     #, sigma = mp_log_normal(params$sigma, 0.1)
     , log_I0 = mp_normal(10, 1)
     , log_E0 = mp_normal(10, 1)
     #, report_prob = mp_log_normal(params$report_prob, 1)
  )
  , tv = mp_rbf("report_prob", 4)
  , time = mp_sim_bounds(0, 432, "daily")
)

mp_optimize(calibrator)

rdsSave(calibrator)
