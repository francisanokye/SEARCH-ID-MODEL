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

flows.Rout: flows.R params.rda
	$(pipeR)

spec.Rout: spec.R params.rda flows.rda
	$(pipeR)


## francis.timevar_spec.Rout: timevar_spec.R ../../data/rp_francis.csv
## eligfrac.timevar_spec.Rout: timevar_spec.R ../../data/rp_eligfrac.csv
## eligfrac2.timevar_spec.Rout: timevar_spec.R ../../data/rp_eligfrac2.csv
## eligfrac3.timevar_spec.Rout: timevar_spec.R ../../data/rp_eligfrac2.csv
## lindec.timevar_spec.Rout: timevar_spec.R
## rbf.timevar_spec.Rout: timevar_spec.R
%.timevar_spec.Rout: timevar_spec.R spec.rds keydates.rda ../../data/rp_%.csv params.rda
	$(pipeR)


%.simulate.Rout: simulate.R %.timevar_spec.rds params.rda keydates.rda seroprevdata.rds
	$(pipeR)

simulate.Rout: simulate.R timevar_spec.rds params.rda keydates.rda
	$(pipeR)


#simulate.Rout: simulate.R timevar_spec.rds params.rda 
#	$(pipeR)

seroprevdata.Rout: seroprevdata.R keydates.rda ../../data/serop_avgcase_data.csv    #seroprevalence_adjusted_cases.csv
	$(pipeR)

## constant.calibrate.Rout: calibrate.R
## eligfrac3.calibrate.Rout: calibrate.R
## lindec.calibrate.Rout: calibrate.R
## rbf.calibrate.Rout: calibrate.R
%.calibrate.Rout: calibrate.R %.timevar_spec.rds seroprevdata.rds params.rda keydates.rda timevar_spec.R
	$(pipeR)

%.calibrate_summary.Rout: calibrate_summary.R %.calibrate.rds
	$(pipeR)

## constant.calibrate_plot.Rout: params.R calibrate_plot.R seroprevdata.R calibrate.R
## eligfrac.calibrate_plot.Rout: calibrate_plot.R seroprevdata.R ../../data/rp_test_eli.csv calibrate.R
## eligfrac2.calibrate_plot.Rout: calibrate_plot.R seroprevdata.R ../../data/rp_eligfrac2.csv calibrate.R
## eligfrac3.calibrate_plot.Rout: calibrate_plot.R seroprevdata.R ../../data/rp_eligfrac3.csv calibrate.R
## eligfrac.calibrate_plot.Rout: params.R seroprevdata.R ../../data/rp_test_eli.csv calibrate.R
## lindec.calibrate_plot.Rout: calibrate_plot.R
## rbf.calibrate_plot.Rout: calibrate_plot.R
%.calibrate_plot.Rout: calibrate_plot.R %.calibrate.rds seroprevdata.rds keydates.rda params.rda
	$(pipeR)

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
%.extract_beta.Rout: extract_beta.R  %.calibrate.rds seroprevdata.rds keydates.rda params.R 
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
