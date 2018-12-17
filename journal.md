2018 Dec 17 (Mon)
=================

If Npop (population size) is large, epigrowthfit will underestimate little r and narrow CIs.

Confints did not converge!


2018 Dec 13 (Thu)
=================

Why is expgrowthfit giving such small confints? TODO

Play with pointsizes in fitsir pic?

Simple stuff is complicated! e.g., simple Reed-Frost gives us biased distributions if we filter on epidemics breaking out: but what else is there to do?

----------------------------------------------------------------------

## Dec 3rd 2018

We are trying to figure out the issues we are having with importance sampling. 
Here I have three exampling using simulated data from normal, exponential and gamma distribution. 
A cool observation I got is looking at the pair plots, parameter vs imp_weights looks uniform-ish for parameters without constrain and "S" shape if it is strictly positive.


