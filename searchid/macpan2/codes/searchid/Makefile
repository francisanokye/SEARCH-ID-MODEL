## This is [project.Makefile] …

current: target
-include target.mk
Ignore = target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

### Makestuff

Sources += Makefile
Sources += $(wildcard *.R)

params.Rout: params.R
	$(pipeR)

keydates.Rout: keydates.R
	$(pipeR)
#test_elig_changepoints.Rout: test_elig_changepoints.R
#	$(pipeR)

flows.Rout: flows.R params.rda
	$(pipeR)

#reporting_probs.Rout: reporting_probs.R ../../data/report_probabilities.csv
#        $(pipeRcall)


## constant.timevar_spec.Rout: timevar_spec.R
## test_eli.timevar_spec.Rout: timevar_spec.R
## lindec.timevar_spec.Rout: timevar_spec.R
## rbf.timevar_spec.Rout: timevar_spec.R
timevar_spec.Rout: timevar_spec.R flows.rda params.rda keydates.rda
	$(pipeR)


simulate.Rout: simulate.R timevar_spec.rds params.rda 
	$(pipeR)

seroprevdata.Rout: seroprevdata.R keydates.rda ../../data/seroprevalence_adjusted_cases.csv
	$(pipeR)

## constant.calibrate.Rout: calibrate.R
## lindec.calibrate.Rout: calibrate.R
## rbf.calibrate.Rout: calibrate.R
#calibrate.Rout: calibrate.R timevar_spec.rds seroprevdata.rds params.rda timevar_spec.R
#	$(pipeR)

## constant.calibrate.Rout: calibrate.R
## test_eli.calibrate.Rout: calibrate.R
## lindec.calibrate.Rout: calibrate.R
## rbf.calibrate.Rout: calibrate.R
calibrate.Rout: calibrate.R timevar_spec.rds seroprevdata.rds params.rda keydates.rda timevar_spec.R
	$(pipeR)

#calibrate_summary.Rout: calibrate_summary.R calibrate.rds
#	$(pipeR)

## constant.calibrate_plot.Rout: calibrate_plot.R seroprevdata.R
## lindec.calibrate_plot.Rout: calibrate_plot.R
## rbf.calibrate_plot.Rout: calibrate_plot.R
calibrate_plot.Rout: calibrate_plot.R calibrate.rds keydates.rda seroprevdata.rds params.R
	$(pipeR)

%.calibrate_summary.Rout: calibrate_summary.R %.calibrate.rds
	$(pipeR)

## constant.calibrate_plot.Rout: calibrate_plot.R seroprevdata.R
## lindec.calibrate_plot.Rout: calibrate_plot.R
## rbf.calibrate_plot.Rout: calibrate_plot.R
calibrate_plot.Rout: calibrate_plot.R calibrate.rds seroprevdata.rds keydates.rda params.R 
	$(pipeR)

%.calibrate_summary.Rout: calibrate_summary.R %.calibrate.rds
	$(pipeR)

## constant.calibrate_plot.Rout: calibrate_plot.R seroprevdata.R ../../data/rp_constant.csv
## test_eli.calibrate_plot.Rout: calibrate_plot.R seroprevdata.R ../../data/rp_test_eli.csv
## lindec.calibrate_plot.Rout: calibrate_plot.R
## rbf.calibrate_plot.Rout: calibrate_plot.R
%.calibrate_plot.Rout: calibrate_plot.R %.calibrate.rds seroprevdata.rds keydates.rda params.R
	$(pipeRcall)

feature_select_plot.Rout: feature_select_plot.R calibrate.rds seroprevdata.rds keydates.rda params.R 
	$(pipeR)

## constant.extract_beta.Rout: extract_beta.R
## lindec.extract_beta.Rout: extract_beta.R

#rbf.extract_beta.Rout: extract_beta.R

## constant.extract_beta.Rout: extract_beta.R
## lindec.extract_beta.Rout: extract_beta.R
## rbf.extract_beta.Rout: extract_beta.R
extract_beta.Rout: extract_beta.R calibrate.rds

## rbf.extract_beta.Rout: extract_beta.R
%.extract_beta.Rout: extract_beta.R %.calibrate.rds
	$(pipeR)

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/00.stamp
makestuff/%.stamp:
	- $(RM) makestuff/*.stamp
	(cd makestuff && $(MAKE) pull) || git clone --depth 1 $(msrepo)/makestuff
	touch $@

-include makestuff/os.mk

-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
