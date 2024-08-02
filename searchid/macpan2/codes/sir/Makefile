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

sir_params.Rout: sir_params.R
	$(pipeR)

sir_flows.Rout: sir_flows.R sir_params.rda
	$(pipeR)

sir_spec.Rout: sir_spec.R sir_flows.rda sir_params.rda
	$(pipeR)

sir_sim.Rout: sir_sim.R sir_spec.rds
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
spec = mp_tmb_model_spec(
  before = c(initialize_state)
  , during = c(flow_rates)
  , default = default
)



