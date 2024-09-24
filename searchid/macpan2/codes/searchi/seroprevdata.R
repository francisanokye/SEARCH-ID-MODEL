library(shellpipes)
rpcall("seroprevdata.Rout seroprevdata.R ../../data/omicron_estimated_serop.csv")
library(tidyverse)

est_infect_from_seroprevalence <- csvRead()
est_infect_from_seroprevalence$date <- as.Date(est_infect_from_seroprevalence$date, format = "%Y-%m-%d")
est_infect_from_seroprevalence <- est_infect_from_seroprevalence |>
  rename_at("date",~"dates")

#seroprevdata = est_infect_from_seroprevalence |>
#                   select(dates, est_inci_serop) |>
#                   mutate(matrix = "cases") |>
#                   rename_at("est_inci_serop" , ~ "value") |>
#                   mutate(time = seq_along(dates))


seroprevdata <- est_infect_from_seroprevalence %>%
  select(dates, est_inci_serop, daily_serop) %>%
  mutate(time = seq_along(dates)) %>%
  pivot_longer(cols = c(est_inci_serop, daily_serop),names_to = "matrix",values_to = "value") %>%
  mutate(matrix = recode(matrix,"est_inci_serop" = "cases","daily_serop" = "serop")) %>%
  arrange(matrix)
		   
print(seroprevdata)

rdsSave(seroprevdata)
#saveEnvironment()

