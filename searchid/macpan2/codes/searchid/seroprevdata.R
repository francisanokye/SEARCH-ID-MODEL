library(shellpipes)
rpcall("seroprevdata.Rout seroprevdata.R ../../data/seroprevalence_adjusted_cases.csv")
library(tidyverse)

start_date <- "2021-12-14"
last_date <- "2022-06-01"

sero <- (csvRead() 
	|> mutate(dates = as.Date(date,format = "%Y-%m-%d"))
	|> select(-date)
	|> filter(between(dates,as.Date(start_date),as.Date(last_date)))
)

serodat <- (sero
	#%>% select(dates, adjusted_serop_cases, seroprevalence, cases)
        %>% select(dates, seroprevalence, cases)	
	%>% mutate(time = seq_along(dates))
        %>% pivot_longer(cols = c( seroprevalence,cases),names_to = "matrix",values_to = "value")
        %>% mutate(matrix = recode(matrix,"seroprevalence" = "serop"))
	#%>% pivot_longer(cols = c(adjusted_serop_cases, seroprevalence,cases),names_to = "matrix",values_to = "value") 
	#%>% mutate(matrix = recode(matrix,"adjusted_serop_cases" = "sero_cases","seroprevalence" = "serop")) 
	%>% arrange(matrix)
)
	   
print(serodat)

rdsSave(serodat)
#saveEnvironment()

