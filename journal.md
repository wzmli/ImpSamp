2018 Dec 18 (Tues)

We need to figure out a way to use a good window.

This that are important: 
- as N increase, logistic underestimates + narrow CI
- low r implies slow epidemic, lots of data
- slowly deviates true parameter when we extend the window
- slow down/not slow down before peak
- 
- 

2018 Dec 17 (Mon)
=================

If Npop (population size) is large, epigrowthfit will underestimate little r and narrow CIs.
Ans: This is probably ok and expected because we don't believe the logistic/exp can _truely_ match the SIR or any epidemic. The exponential model is a first order approximation?!? and logistic is a second order approximation?!?. As Npop increase, it looks more like an SIR than exp/logistic (from whatever the first point to peak). One possible test is to change the window, and as we know from simulation test, the exponential model looks _underestimates_ less fitted to a shorted window (before the peak).
I think we are done.


TODO:
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


