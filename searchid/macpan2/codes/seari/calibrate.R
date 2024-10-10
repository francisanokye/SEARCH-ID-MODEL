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

outputs = c("S", "E", "A", "I", "R", "cases", "serop")

population = 510550


calibrator <- mp_tmb_calibrator(
  spec = timevar_spec 
  , data = seroprevdata
  , traj = c("cases", "serop")
  , outputs = c(outputs)
  , par = c("beta","report_prob","serop_frac")#,"log_A0")#,"log_R0")
)

mp_optimize(calibrator)

rdsSave(calibrator)






