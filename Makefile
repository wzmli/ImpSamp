
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

lunchbox:
	git clone https://github.com/wzmli/hybridx.git

Sources += Makefile README.md LICENSE.md journal.md

######################################################################

Sources += $(wildcard *.R)

normal.Rout: parameters.Rout ImpSampFuns.Rout simMLE.Rout normal.R
	$(run-R)

%_CIplot.Rout: %.Rout CIplot.R
	$(run-R)

## normal_CIplot.Rout: CIplot.R

exp.Rout: parameters.Rout ImpSampFuns.Rout simMLE.R exp.R
	$(run-R)

## exp_CIplot.Rout: CIplot.R

gamma.Rout: parameters.Rout ImpSampFuns.Rout simMLE.Rout gamma.R
	$(run-R)

%_plot.Rout: %.Rout plot.R
	$(run-R)

%_checkplot.Rout: %.Rout checkplot.R
	$(run-R)

## normal_plot.Rout: plot.R
## exp_plot.Rout: plot.R 
## gamma_plot.Rout: 

## normal_checkplot.Rout: simMLE.R checkplot.R
## exp_checkplot.Rout: checkplot.R
## gamma_checkplot.Rout: checkplot.R

## epigrowthfit example

nbinom.Rout: parameters.R nbinom.R
	$(run-R)

nbinom.data.Rout: parameters.R nbinom.R
	$(run-R)

egf_exp.Rout: parameters.R egf_exp.R
	$(run-R)
epiPlot.Rout: egf_exp.Rout epiPlot.R
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

sir.Rout: sir.R
	$(run-R)

epigrowthfit.Rout: sir.Rout epigrowthfit.R
	$(run-R)

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
 
