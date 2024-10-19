library(shellpipes)
rpcall("seroprevdata.Rout seroprevdata.R ../../data/seroprevalence_adjusted_cases.csv")
library(tidyverse)

est_infect_from_seroprevalence <- csvRead()
est_infect_from_seroprevalence$date <- as.Date(est_infect_from_seroprevalence$date, format = "%Y-%m-%d")
est_infect_from_seroprevalence <- est_infect_from_seroprevalence |>
  rename_at("date",~"dates")

seroprevdata <- (est_infect_from_seroprevalence 
	#%>% select(dates, adjusted_serop_cases, seroprevalence, cases)
        %>% select(dates, seroprevalence, cases)	
	%>% mutate(time = seq_along(dates))
        %>% pivot_longer(cols = c( seroprevalence,cases),names_to = "matrix",values_to = "value")
        %>% mutate(matrix = recode(matrix,"seroprevalence" = "serop"))
	#%>% pivot_longer(cols = c(adjusted_serop_cases, seroprevalence,cases),names_to = "matrix",values_to = "value") 
	#%>% mutate(matrix = recode(matrix,"adjusted_serop_cases" = "sero_cases","seroprevalence" = "serop")) 
	%>% arrange(matrix)
)
	   
print(seroprevdata)

rdsSave(seroprevdata)
#saveEnvironment()

