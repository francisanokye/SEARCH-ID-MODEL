library(shellpipes)
rpcall("serodata.Rout serodata.R ../../data/seroprevalence_adjusted_cases.csv")
library(tidyverse)

est_infect_from_seroprevalence <- csvRead()
est_infect_from_seroprevalence$date <- as.Date(est_infect_from_seroprevalence$date, format = "%Y-%m-%d")
est_infect_from_seroprevalence <- est_infect_from_seroprevalence |>
  rename_at("date",~"dates")

serodata = est_infect_from_seroprevalence |>
                   select(dates, seroprevalence) |>
                   mutate(matrix = "seroprevalence") |>
                   mutate(time = seq_along(dates))

print(serodata)

rdsSave(serodata)
#saveEnvironment()
