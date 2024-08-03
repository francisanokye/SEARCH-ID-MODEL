library(shellpipes)
library(tidyverse)

est_infect_from_seroprevalence <- read.csv("~/Documents/MUN/SEARCH-ID-MODEL/searchid/macpan2/data/omicron_estimated_serop.csv")
est_infect_from_seroprevalence$date <- as.Date(est_infect_from_seroprevalence$date, format = "%Y-%m-%d")
est_infect_from_seroprevalence <- est_infect_from_seroprevalence |>
  rename_at("date",~"dates")

seroprevdata = est_infect_from_seroprevalence |>
                   select(dates, est_inci_serop) |>
                   mutate(matrix = "cases") |>
                   rename_at("est_inci_serop" , ~ "value") |>
                   mutate(time = seq_along(dates))

print(seroprevdata)

rdsSave(seroprevdata)
#saveEnvironment()

