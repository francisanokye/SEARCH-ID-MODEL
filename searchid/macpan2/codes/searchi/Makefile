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

current:params.Rout flows.Rout timevar_spec.Rout simulate.Rout calibrate.Rout

params.Rout: params.R
	$(pipeR)

flows.Rout: flows.R params.rda
	$(pipeR)

timevar_spec.Rout: timevar_spec.R flows.rda params.rda
	$(pipeR)

simulate.Rout: simulate.R timevar_spec.rds params.rda
	$(pipeR)

seroprevdata.Rout: seroprevdata.R  
	$(pipeR)

calibrate.Rout: calibrate.R timevar_spec.rds seroprevdata.rds
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
