library(macpan2)
library(shellpipes)
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

outputs = c("S", "E", "A", "R", "C", "H", "I", "D","cases", "beta", "serop", "report_prob")

population = 510550

calibrator <- mp_tmb_calibrator(
    spec = timevar_spec |> mp_hazard()
  , data = seroprevdata
  , traj = list(
      cases = mp_neg_bin(disp = mp_fit(1))
    , serop = mp_log_normal(sd = mp_nofit(0.5))
  )
  , outputs = c(outputs)
<<<<<<< HEAD
  , par = c("beta_deviation", "beta_baseline")
  , tv = mp_rbf("beta_deviation", 5, sparse_tol = 0)
=======
#  , par = c("beta_deviation", "beta_baseline")
#  , tv = mp_rbf("beta_deviation", 9, sparse_tol = 0)
  , par = "beta"
  , tv = mp_rbf("beta", 7, sparse_tol = 0)
>>>>>>> cef8044471ab48e2e8815de65b3724717c7834a0
  , time = mp_sim_bounds(-30, 200, "daily")#-50,100
)


mp_optimize(calibrator)

rdsSave(calibrator)

