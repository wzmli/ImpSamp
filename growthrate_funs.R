## Fitting logistic with linear r 

nll <- function(r=0.3,x0=1,K=6){
  cumulative_cases = exp(K)/(1 + (exp(K)/exp(x0) - 1) * exp(-r * (1:length(cases))))
  incidence = diff(cumulative_cases)
  -sum(-lgamma(cases[-length(cases)] + 1) + cases[-length(cases)] * log(incidence) - incidence)
}

nll2 <- function(r=0.3,x0=1,K=6){
  cumulative_cases = K/(1 + (K/x0 - 1) * exp(-r * (1:length(cases))))
  incidence = diff(cumulative_cases)
  -sum(-lgamma(cases[-length(cases)] + 1) + cases[-length(cases)] * log(incidence) - incidence)
}

nllepi <- function(r=0.3,x0=1,K=6){
  cumulative_cases = (exp(K)/(1 + (1/((atan(x0/exp(K)) * 2/pi + 1)/2) - 1) * exp(-exp(r) * 1:length(cases))))
  incidence = diff(cumulative_cases)
  -sum(-lgamma(cases[-length(cases)] + 1) + cases[-length(cases)] * log(incidence) - incidence)
}
