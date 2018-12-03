
### ImpSamp
# https://github.com/wzmli/ImpSamp.git

### Hooks 
current: target
-include target.mk

## Journal

##################################################################


# make files and directories

Sources += Makefile .ignore README.md sub.mk LICENSE.md
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


### Clean 

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
 
