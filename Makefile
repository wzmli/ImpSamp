
### ImpSamp
# https://github.com/wzmli/ImpSamp.git

### Hooks 
current: target
-include target.mk

## Journal

##################################################################

msrepo = https://github.com/dushoff
ms = makestuff
Sources += $(ms)

-include $(ms)/os.mk
# -include $(ms)/perl.def

# make files and directories

Sources += Makefile README.md LICENSE.md journal.md

######################################################################

Sources += $(wildcard *.R)

normal.Rout: parameters.R normal.R
	$(run-R)

normal2.Rout: parameters.R normal2.R
	$(run-R)

exp.Rout: parameters.R exp.R
	$(run-R)

gamma.Rout: parameters.R gamma.R
	$(run-R)

%_plot.Rout: %.Rout plot.R
	$(run-R)

## normal_plot.Rout:
## normal2_plot.Rout:
## exp_plot.Rout: 
## gamma_plot.Rout: 

## epigrowthfit example

nbinom.Rout: parameters.R nbinom.R
	$(run-R)

nbinom.data.Rout: parameters.R nbinom.R
	$(run-R)

egf_exp.Rout: parameters.R egf_exp.R
	$(run-R)

egf_logistic.Rout: parameters.R egf_logistic.R
	$(run-R)
## nbinom_plot.Rout: 
## nbinom.data_plot.Rout:
## egf_exp_plot.Rout:
## egf_logistic_plot.Rout:

clean: 
	rm *.wrapR.r *.Rout *.wrapR.rout *.Rout.pdf

##################################################################
### Makestuff

## -include $(ms)/cache.mk

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/pandoc.mk

-include $(ms)/wrapR.mk
-include $(ms)/masterR.mk
# include $(ms)/linkdirs.mk

-include $(ms)/texdeps.mk
 
