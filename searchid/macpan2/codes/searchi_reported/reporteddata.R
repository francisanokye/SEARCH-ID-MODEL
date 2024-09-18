library(shellpipes)
rpcall("reporteddata.Rout reporteddata.R ../../data/seroprevalence_adjusted_cases.csv")
library(tidyverse)

reported_cases <- csvRead()
reported_cases$DATE <- as.Date(reported_cases$date, format = "%Y-%m-%d")
reported_cases <- reported_cases |>
  rename_at("date",~"dates")

reporteddata = reported_cases |>
                   select(dates, cases, seroprevalence) |>
                   mutate(time = seq_along(dates)) |>
		   pivot_longer(cols = c(cases, seroprevalence), names_to = "matrix", values_to = "value") |>
		   mutate(matrix = recode(matrix, "cases" = "cases", "seroprevalence" = "serop")) |>
		   arrange(matrix)

print(reporteddata)

rdsSave(reporteddata)
#saveEnvironment()

