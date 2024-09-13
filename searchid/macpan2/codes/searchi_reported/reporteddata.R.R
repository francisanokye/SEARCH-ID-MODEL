library(shellpipes)
rpcall("reporteddata.Rout reporteddata.R ../../data/IM215194_NL_COVID_CASESHOSPDEATH.csv")
library(tidyverse)

reported_cases <- csvRead()
reported_cases$DATE <- as.Date(reported_cases$DATE, format = "%Y-%m-%d")
reported_cases <- reported_cases[(reported_cases$DATE >= "2021-12-15") & (reported_cases$DATE < "2022-06-04"),]
rownames(reported_cases) <- NULL
reported_cases <- reported_cases |>
  rename(dates = DATE, cases = CASES)

reporteddata = reported_cases |>
                   select(dates, cases) |>
                   mutate(matrix = "cases") |>
                   rename_at("cases" , ~ "value") |>
                   mutate(time = seq_along(dates))

print(reporteddata)

rdsSave(reporteddata)
#saveEnvironment()

