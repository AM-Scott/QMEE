# Week 4 - statistical philosophy

# Do the 3 readings

# Frequentism vs Bayesian

# Never use high p vals for anything

# High p value means we can't see the effect clearly -> may be because the effect is small
# Never use high p value to advance your conclusion

# p values about clarity not significance

# type I errors not possible in biology - there is ALWAYS AN EFFECT

# Type II also never happen
# NEVER ACCEPT THE NULL HYP.

# Sign error/magnitude errors instead of t1 t2


############
# Wednesday - frequentist vs bayesian

# Basic philiosophy of frequentist stats:
# Permutation Tests! This is how you do frequentist statistics in the computer age!
# Scrambled measurements
# Get a much clearer idea if these observations are due to chance

# Bayesian paradigm
# Prior beliefs
# Works better for cape town raining on sundays type thing



############
# Simulations
set.seed(41)


# make data set
numChildren <- 60

hm <- 120
hsd <- 8
grow <- 0.05
extraGrow <- 0.01

children <- tibble(
  startHeight = rnorm(numChildren, hm, hsd),
  treatment = sample(c("A", "C"), numChildren, replace = TRUE)
) 

children <- (children 
             %>% mutate(expGrow = ifelse(treatment == "C", grow, grow + extraGrow),
                        realGrow = rlnorm(numChildren, log(expGrow), sdlog = 0.05),
                        endHeight = startHeight*(1 + realGrow))
             %>% select(-c(realGrow, expGrow))
)

# analysis

children <- (children
             %>% mutate(growth = endHeight - startHeight, 
                        propHeight = endHeight/startHeight)
)

model <- lm(propHeight ~ treatment, data = children)

confint(model) # true value within the 95%CI

# make these into functions...



