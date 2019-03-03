### Week 7 - Bayes Approaches

# Bayes - assume almost everything
# Prior distribution -> run thru data -> posterior distribution

# credible interval - 95% chance that the value is in the CI

# Be thinking about scale dependence (unless using medians/quantiles)

# Prior dist
# Start with one that has little information (large variance)
# Scale used matters (linear/log)

# Set up model
# Flexible, and then simulate it:

# MCMC Methods

# Jonathan live-codes a Bayesian model : see files at end of lecture notes
# try rjags first before r2jags!!
# link data (in R) to jags file (.bugs): (think about all these choices being made)

# dnrom(pred[i], prec[i]) - saying this thing is normally distributed with mean of the prediction and "variance" is the precision (1/var)
# ith prediction and ith precision
# ith prediction is equal to beta height * height [i] + intercept (b_0)
# ith precision is equal to tau

# What to tell jags about the parameters (cant be uniform):
# b_height ~ dnorm(0, 0.0001) - mean of 0 and width of 10000 (1/10000 is precision)
# b_0 ~ dnorm(0, 0.00001) - 
# tau ~ dgamma(0.001, 0.001) - needs to be positive

# pass this model back to R
# Does a monte-carlo simulation
# inits is saying where to start - random
# start with about 4 chains and need them to go to the same place?
# the closer to 1 your Rhat is the better
# looks good - then go and change stuff ?



### Wednesday

# distribution of the predictor variables is determined by how you did your experiment, and what is set out there in the world
# chains simultaneously trying to arrive at same estimates

