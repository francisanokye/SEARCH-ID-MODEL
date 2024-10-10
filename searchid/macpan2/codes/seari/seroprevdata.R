library(shellpipes)
rpcall("seroprevdata.Rout seroprevdata.R ../../data/seroprevalence_adjusted_cases.csv")
library(tidyverse)

est_infect_from_seroprevalence <- csvRead()
est_infect_from_seroprevalence$date <- as.Date(est_infect_from_seroprevalence$date, format = "%Y-%m-%d")
est_infect_from_seroprevalence <- est_infect_from_seroprevalence |>
  rename_at("date",~"dates")


seroprevdata <- est_infect_from_seroprevalence %>%
  select(dates, adjusted_serop_cases, seroprevalence) %>%
  mutate(time = seq_along(dates)) %>%
  pivot_longer(cols = c(adjusted_serop_cases, seroprevalence),names_to = "matrix",values_to = "value") %>%
  mutate(matrix = recode(matrix,"adjusted_serop_cases" = "cases","seroprevalence" = "serop")) %>%
  arrange(matrix)
		   
print(seroprevdata)
seroprevdata0 <- seroprevdata
warmupdat <- data.frame(dates = seq.Date(as.Date("2021-09-15"),as.Date("2021-12-14"),by=1)
	, time = -90:0
	, matrix = "cases"
	, value = seq(0,400,length.out=91) 
#	, value = NA 
)

seroprevdata <- (bind_rows(warmupdat, seroprevdata)
	|> mutate(time = time + 90)
)

print(seroprevdata)

seroprevdata <- seroprevdata0
rdsSave(seroprevdata)
#saveEnvironment()

