
### ImpSamp
# https://github.com/wzmli/ImpSamp.git

### Hooks 
current: target
-include target.mk

## Journal

##################################################################


# make files and directories

Sources += Makefile .ignore README.md sub.mk LICENSE.md journal.md
Ignore += .gitignore

Sources += $(wildcard *.local)
jd.lmk: jd.local
%.lmk:
	$(CP) $*.local local.mk

include sub.mk

## Use epigrowthfit to estimate little r 
plague.repo: 
	git clone https://github.com/davidearn/plague.git

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
### Clean 



## epigrowthfit example

nbinom.Rout: parameters.R nbinom.R
	$(run-R)

## nbinom_plot.Rout: 


clean: 
	rm *.wrapR.r *.Rout *.wrapR.rout *.Rout.pdf

##################################################################
### Makestuff

-include $(ms)/cache.mk
sync: add_cache

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/pandoc.mk

-include $(ms)/wrapR.mk
-include $(ms)/masterR.mk
# include $(ms)/linkdirs.mk

-include $(ms)/texdeps.mk
 
