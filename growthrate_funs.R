## Fitting logistic with linear r 

nll <- function(r=0.3,x0=1,K=6){
  cumulative_cases1 = exp(K)/(1 + (exp(K)/exp(x0) - 1) * exp(-r * (1:length(cases))))
  cumulative_cases2 = exp(K)/(1 + (exp(K)/exp(x0) - 1) * exp(-r * (0:(length(cases)-1))))
  incidence = cumulative_cases1 - cumulative_cases2
  -sum(-lgamma(cases + 1) + cases * log(incidence) - incidence)
}

nll2 <- function(r=0.3,x0=1,K=6){
  cumulative_cases1 = exp(K)/(1 + (exp(K)/exp(x0) - 1) * exp(-r * (2:(length(cases)+1))))
  cumulative_cases2 = exp(K)/(1 + (exp(K)/exp(x0) - 1) * exp(-r * (1:length(cases))))
  incidence = cumulative_cases1 - cumulative_cases2
  -sum(-lgamma(cases + 1) + cases * log(incidence) - incidence)
}
