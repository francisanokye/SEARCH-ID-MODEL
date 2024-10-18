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

head(seroprevdata)
calibrator <- mp_tmb_calibrator(
  spec = timevar_spec |> mp_hazard()
  , data = seroprevdata
  , traj = list(
      cases = mp_neg_bin(disp = mp_fit(1))
    , serop = mp_log_normal(sd = mp_nofit(0.5))
  )
  , outputs = c(outputs)
  , par = "beta"
  , tv = mp_rbf("beta", 9, sparse_tol = 0)
  , time = mp_sim_bounds(-30, 200, "daily")
)

mp_optimize(calibrator)

# we generate the time series for the report probabilities and use them 
# report_prob_ts = mp_trajectory(calibrator) |> dplyr::filter(matrix == "report_prob")|> pull(value) |>dput()

rdsSave(calibrator)
