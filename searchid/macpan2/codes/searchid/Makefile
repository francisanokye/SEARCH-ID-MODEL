e:Q This is [project.Makefile] …

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

flows.Rout: flows.R params.rda
	$(pipeR)

#reporting_probs.Rout: reporting_probs.R ../../data/report_probabilities.csv
#        $(pipeRcall)

timevar_spec.Rout: timevar_spec.R flows.rda  params.rda
	$(pipeRcall)

simulate.Rout: simulate.R timevar_spec.rds params.rda
	$(pipeRcall)

seroprevdata.Rout: seroprevdata.R ../../data/seroprevalence_adjusted_cases.csv
	$(pipeRcall)

calibrate.Rout: calibrate.R timevar_spec.rds seroprevdata.rds params.rda timevar_spec.R
	$(pipeRcall)

calibrate_summary.Rout: calibrate_summary.R calibrate.rds
	$(pipeR)

calibrate_plot.Rout: calibrate_plot.R calibrate.rds seroprevdata.rds params.R
	$(pipeR)

feature_select_plot.Rout: feature_select_plot.R calibrate.rds seroprevdata.rds params.R
	$(pipeR)

extract_beta.Rout: extract_beta.R calibrate.rds
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
