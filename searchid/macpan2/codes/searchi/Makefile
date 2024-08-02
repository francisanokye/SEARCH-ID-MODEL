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

current:searchi_params.Rout searchi_flows.Rout searchi_spec.Rout searchi_simulate.Rout

searchi_params.Rout: searchi_params.R
	$(pipeR)

searchi_flows.Rout: searchi_flows.R searchi_params.rda
	$(pipeR)

searchi_spec.Rout: searchi_spec.R searchi_flows.rda searchi_params.rda
	$(pipeR)

searchi_simulate.Rout: searchi_simulate.R searchi_spec.rds searchi_params.rda
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
