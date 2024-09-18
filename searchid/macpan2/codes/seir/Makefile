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

params.Rout: params.R
	$(pipeR)

flows.Rout: flows.R params.rda
	$(pipeR)

timevar_spec.Rout: timevar_spec.R flows.rda params.rda
	$(pipeRcall)

simulate.Rout: simulate.R timevar_spec.rds params.rda
	$(pipeRcall)

seroprevdata.Rout: seroprevdata.R ../../data/seroprevalence_adjusted_cases.csv
	$(pipeRcall)

serodata.Rout: serodata.R ../../data/seroprevalence_adjusted_cases.csv
	$(pipeRcall)

calibrate.Rout: calibrate.R timevar_spec.rds seroprevdata.rds timevar_spec.R
	$(pipeRcall)

cal_sims.Rout: cal_sims.R calibrate.rds seroprevdata.rds 
	$(pipeR) 

R_vrs_serop.Rout: R_vrs_serop.R calibrate.rds serodata.rds
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
