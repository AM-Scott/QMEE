## Week 5 - Permutations

# null hypothesis is about something that doesnt matter (that is why you shuffle)

# Permutation is just switching/shuffling around (sample w/o replacement) - bootstrap is sampling w replacement
## Permutation test is simulating the null hypothesis (easier)
## Bootstrapping is a way of resimulating your data (under the same thing that is going on in the data)
#### If the route to doing a permutation is clear - do that over bootstrapping
#### Bootstrapping - NEED A LARGE SAMPLE or else its not conservative

# Ant colonies - can't acurately see that the data are/aren't normal
# Good candidate for a permutation test

## can test any of mean, median, geometric mean with a permutation test

# calculate the statistic for the observed data, and for thousands of permutations of the data

# if data set is small - might have reasonable maximum # of permutations (e.g. 210)
# 5 larger than OR EQUAL TO the observed 3.75

5/210

# This above would be assuming you are doing a 1-tailed test

## BUT - Want to respect our nominal alpha value - using a 1-tailed test means you are SO sure
## that the forest can't have more ants than the field, you don't believe the data in that direction

# to do 2-tailed, halve the alpha, or double the p value

2*(5/210)

# TIES count against you (i.e. include them with the values that are more extreme than the observed)

# Increase power by transforming to normality

# Geometric mean is like a log transformation

## METHODOLOGY

# Impossible to do all possible permutations 
# Therefore do roughly thousands of permutations
# Do a valid frequentist test by putting your observed values in there!!*********


