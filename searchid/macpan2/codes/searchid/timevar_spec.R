library(macpan2)
library(dplyr)
library(shellpipes)
loadEnvironments()

effprop <- 0.9



reporting_probs = csvRead()

report_prob_ts <- reporting_probs$prob
report_prob_cp = as.integer(reporting_probs$Date - as.Date(start_date))
print(report_prob_cp)

print(head(reporting_probs))

print(summary(reporting_probs))

nspec <- rdsRead()

timevar_spec <- mp_tmb_insert(nspec
	, expression = list(report_prob ~ time_var(report_prob_ts, report_prob_cp))
	, phase = "during", at = 1L
	, default = list(report_prob_ts = report_prob_ts)
	, integers = list(report_prob_cp = report_prob_cp)
)

timevar_spec = mp_tmb_insert_reports(timevar_spec
  , incidence_name = "exposure"
  , report_prob = 0.5
  , mean_delay = 11
  , cv_delay = 0.95
  , reports_name = "cases"
  , report_prob_name = "report_prob"
)
rdsSave(timevar_spec)
