library(shellpipes)
library(tidyverse)

reported_cases <- read.csv("~/Documents/MUN/SEARCH-ID-MODEL/searchid/macpan2/data/IM215194_NL_COVID_CASESHOSPDEATH.csv")
reported_cases$date <- as.Date(reported_cases$date, format = "%Y-%m-%d")
reported_cases <- reported_cases |>
  rename_at("date",~"dates")

reporteddata = reported_cases |> 
                   select(dates, cases) |> 
                   mutate(matrix = "cases") |>
                   rename_at("cases" , ~ "value") |>
                   mutate(time = seq_along(dates))

rdsSave(reporteddata)	   
