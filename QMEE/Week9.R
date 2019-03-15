### Week 9 - Mixed Models

### foxchap - login/password for Bolker chapter

### Conceptualize random effects as random sample from a larger population
### With random effects, you estimate the mean and distribution of "spruce tree" effects

### Fixed effect gives more power by narrowing the scope of your scientific inference (can't
### extend the effects of clean/dirty to other populations beyond the spruce trees you looked at)

### Using random effects - make a stronger inference about the larger population

### >5 preferably >10 levels to allow a random effect
### Otherwise, use fixed, and note the inferential limitations (can't extend to broader pop.)

### Maybe don't just throw in the random intercept - maybe should consider the slope

### Group-side, residual-side

########## Example

### g has to be a factor
### Left of bar - "what is it I think is varying among the groups" 1 = intercept, 
### Right of bar is how you define the groups

### Nesting goes largest to smallest usually (site > block, so block withing site = site/block)

### site:block - only treat blocks within sites as a random effect


########### Wednesday

### examples file (can find it on Github)

### in random effects - std dev in intercepts, stdev Days - how much the groups vary terms of how much they increase in reaction time per day
### Corr is between the intercept and slope

### For fixed effects - what should the df be? There is argument...
### refit with lmer after loading lmertest, then gives pvals dfs, when using summary
### change ddf = "Kenward-Roger" as an arg in summary to get more accurate (but slower) df

### diagnostics not quite as easy
### qqplot - use qqmath(lmermodel)

### in principle, if you could measure the variance across groups, you should

### Female rats example - fixed effects Sex, time, dose

### (1 + time | Pup) ## time the only thing that varies within pup

### Little guidance about what to do with singular fit. Usually - simplify the model.
### For singular fits can also do a Bayesian thing

