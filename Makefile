
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

normal.Rout: parameters.R ImpSampFuns.R simMLE.R normal.R
	$(run-R)

exp.Rout: parameters.R ImpSampFuns.R simMLE.R exp.R
	$(run-R)

gamma.Rout: parameters.R ImpSampFuns.R simMLE.R gamma.R
	$(run-R)

%_plot.Rout: %.Rout plot.R
	$(run-R)

## normal_plot.Rout: plot.R
## exp_plot.Rout: plot.R 
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

mvt_egf_logistic.Rout: parameters.R egf_logistic.R
	$(run-R)	

## nbinom_plot.Rout: nbinom.Rout nbinom.R 
## nbinom.data_plot.Rout:
## egf_exp_plot.Rout:
## egf_logistic_plot.Rout:
## mvt_egf_logistic_plot.Rout: plot.R

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
 
