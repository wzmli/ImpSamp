
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

Ignore += lunchbox
lunchbox:
	git clone https://github.com/wzmli/hybridx.git

Ignore += bbmisc
bbmisc:
	git clone https://github.com/bbolker/bbmisc.git

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

fitsir_multi_miliPlot.Rout: parameters.Rout fitsir_multi_miliPlot.R
	$(run-R)

fitsir_allPlot.Rout: fitsir_multi_miliPlot.Rout fitsir_allPlot.R
	$(run-R)

fitsir_window.Rout: sir.Rout fitsir_window.R
	$(run-R)

fitsir_windowPlot.Rout: fitsir_window.Rout fitsir_windowPlot.R
	$(run-R)

fitsir_drop1.Rout: parameters.Rout sir.Rout fitsir_drop1.R
	$(run-R)

reedfrost.Rout: parameters.Rout reedfrost.R
	$(run-R)

epigrowthfit.Rout: reedfrost.Rout epigrowthfit.R
	$(run-R)

epigrowthfit_CIplot.Rout: epigrowthfit.Rout ImpSampFuns.Rout epigrowthfit_CIplot.R
	$(run-R)

logCIplot.Rout: epigrowthfit_CIplot.Rout logCIplot.R
	$(run-R)

gillesp.Rout: bbmisc/stochsim/gillesp.Rout parameters.Rout gillesp.R
	$(run-R)

compare.Rout: sir.Rout gillesp.Rout compare.R
	$(run-R)

fitgillesp.Rout: gillesp.Rout fitgillesp.R
	$(run-R)

fitgillesp_CIplot.Rout: fitgillesp.Rout fitgillesp_CIplot.R
	$(run-R)

fitgillesp_multi_miliPlot.Rout: parameters.Rout bbmisc/stochsim/gillesp.Rout fitgillesp_multi_miliPlot.R
	$(run-R)

fitgillesp_allPlot.Rout: fitgillesp_multi_miliPlot.Rout fitgillesp_allPlot.R
	$(run-R)

allPlot.Rout: fitsir_allPlot.Rout fitgillesp_allPlot.Rout allPlot.R
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
 
