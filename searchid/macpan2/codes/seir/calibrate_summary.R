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

calibrator <- rdsRead()

print(calibrator)
##########################################################################################

coeff <- mp_tmb_coef(calibrator, conf.int = TRUE)
print(coeff)
############ Visualize simulation with calibrated paramters against the observed data ###########






