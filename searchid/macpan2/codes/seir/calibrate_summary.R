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






