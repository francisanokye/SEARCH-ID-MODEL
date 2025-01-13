library(macpan2)
library(shellpipes)
library(conflicted)
library(tidyverse)
library(dplyr)
library(ggthemes)
library(broom.mixed)
set.seed(2024)

loadEnvironments()


timevar_spec <- rdsRead("timevar_spec.rds")

print(timevar_spec$integers$report_prob_cp[1])

seroprevdata <- rdsRead("seroprevdata.rds")

outputs = c("S", "E", "A", "R", "C", "H", "I", "D","cases", "beta", "serop", "report_prob")

calibrator <- mp_tmb_calibrator(
    spec = timevar_spec |> mp_hazard()
  , data = seroprevdata
  , traj = list(
      cases = mp_neg_bin(disp = mp_nofit(5))
    , serop = mp_log_normal(sd = mp_nofit(1))
  )
  , outputs = c(outputs)
  #, par = c("beta_deviation", "beta_baseline")
  #, tv = mp_rbf("beta_deviation", 5, sparse_tol = 0)

#  , par = c("beta_deviation", "beta_baseline")
#  , tv = mp_rbf("beta_deviation", 9, sparse_tol = 0)
  , par = "beta"
  , tv = mp_rbf("beta", 5 , sparse_tol = 0)
  , time = mp_sim_bounds(-off, 200-off, "daily")#-50,100
)


mp_optimize(calibrator)

rdsSave(calibrator)

