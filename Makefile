
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

exp.Rout: parameters.Rout ImpSampFuns.Rout simMLE.Rout exp.R
	$(run-R)


######################################################################

## normal_CIplot.Rout:
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
## exp_checkplot.Rout: simMLE.R checkplot.R
## gamma_checkplot.Rout: checkplot.R

## epigrowthfit example

sir.Rout: parameters.Rout sir.R

fitsir.Rout: sir.Rout fitsir.R
	$(run-R)

fitsir_pvals.Rout: fitsir.Rout ImpSampFuns.Rout simMLE.Rout fitsir_pvals.R
	$(run-R)

fitsir_checkPlots.Rout: fitsir_pvals.Rout fitsir_checkPlots.R
	$(run-R)

fitsir_miliPlot.Rout: fitsir.Rout fitsir_miliPlot.R
	$(run-R)

fitsir_multi_miliPlot.Rout: fitsir_miliPlot.Rout fitsir_multi_miliPlot.R
	$(run-R)

fitsir_allPlot.Rout: fitsir_multi_miliPlot.Rout fitsir_allPlot.R
	$(run-R)


## fitsir_1000_miliPlot.Rout: fitsir_miliPlot.Rout fitsir_multi_miliPlot.R

reedfrost.Rout: parameters.Rout reedfrost.R
	$(run-R)

epigrowthfit.Rout: reedfrost.Rout epigrowthfit.R
	$(run-R)

epigrowthfit_CIplot.Rout: epigrowthfit.Rout ImpSampFuns.Rout epigrowthfit_CIplot.R
	$(run-R)

logCIplot.Rout: epigrowthfit_CIplot.Rout logCIplot.R
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
 
