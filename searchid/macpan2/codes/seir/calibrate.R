library(macpan2)
library(shellpipes)
rpcall("calibrate.Rout calibrate.R timevar_spec.rds seroprevdata.rds timevar_spec.R")
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

outputs = c("S", "E", "I", "R", "cases", "serop")

population = 510550


#prior_distributions = list(
#      beta = beta
#    , logit_report_prob = qlogis(1.0)
#    , logit_serop_frac = qlogis(0.95)
#    #, "log_E0","log_I0","log_R0"
#)


calibrator <- mp_tmb_calibrator(
  spec = timevar_spec #|> mp_rk4()
  , data = seroprevdata
  , traj = c("cases", "serop")
  , outputs = c(outputs)
  , par = c("beta","report_prob","serop_frac","log_I0")#,"log_R0")
)

mp_optimize(calibrator)

rdsSave(calibrator)






