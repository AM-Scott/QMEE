## Week 6

## More permutation stuff

# CONFIDENCE INTERVALS - can't have both permutation and confidence intervals 
## PERMUTATION TESTS just say there is "something about the data" as permutation tests make no assumptions about the data or anything else

# to get a confidence interval for the mean - have to assume the data are symmetric

# Advantages and disadvantages

# Nitrogen, phosporous and algae
# Could imagine scrambling N, P, or both
# Scramble the nitrogen - just  tells me that I can't trust what I see about nitrogen (null hypothesis of nitrogen doesn't matter)



## Ben's part of the lecture

# Actually coding the permutation

# ****** other test statistics you can use - linear regression and take the slope

# lmPerm computest the pvalues by permutation


###########
# Linear models (wednesday 13th)

# predictor/response better than independent/dependent variables

# assuming the RESIDUALS are independent of each other (e.g. 2 samples of the same sex expected to be more similar)

# dummy variables for categorical predictors (0, 1) - means the intercept is the baseline (which is the value for the first group)

# linear model is linear in the predictors not in "x"

# "default plots in R"
# - top left - should be flat (residuals vs fitted) - heteroscedasticity will appear here as a "fan"
# - bottom left - also shows heterosced.
# - bottom right - look for points over to the right - cooks distance of less than 0.5 is nothing to worry about
# - top right - least important (this means there more extreme values at the ends than expected by a gaussian)
# - DONT DO A SHAPIRO WILK...

# transformations
# sqrt transform is like a less intense log transform

# use dot whisker - dwplot()



