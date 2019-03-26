### Assignment Week 7 - Bayesian statistics

library(tidyverse)
library(R2jags)

### Cleaning up/preparing data

## JD: Be careful about capitaLization
soc.data <- read_csv("Data/Sociability_Raw_Data.csv")

soc.data <- soc.data %>%
  mutate_at(vars(Block,Lineage,Sex),factor)

soc.data <- soc.data %>%
  gather(key=Q,value=score,Q1:Q8) %>%
  group_by(Generation,Block,Dish,Lineage,Sex) %>%
  summarise(AI=var(score)/mean(score)) %>%
  full_join(soc.data) %>%
  mutate(logAI = log(AI))

soc.data <- soc.data %>%
  ungroup() %>%
  mutate(Treatment = as.factor(str_sub(Lineage, 1,1))) %>%
  filter(Treatment != "C")

### Analogous frequentist linear models (I'll explain later why I have 2...)

lm.1 <- lm(logAI ~ Treatment + Generation + Sex, data = soc.data)

lm.2 <- lm(logAI ~ Treatment*Generation*Sex, data = soc.data)


### Bayesian model 1
### For this first model, I have attempted to use JAGS and specify everything in the model by hand.
### I was unable to get anything with interactions to work reasonably, so I have left them out
### (thus, I am comparing it to the above lm.1). In the 2nd Bayes' model below I attempted to include 
### interaction terms.

### Priors: the expected value of the parameters is small (i.e. typically less than 1 log(Aggregation index) between groups)
### Therefore, I think it is reasonable to set the standard deviation to about 10 log(AI), or precision to 0.01
### There isn't any other information about the parameters, so I have set them to be normal and flat
### One question I have is whether it is useful to specify that the data are bounded in the priors (i.e. "logAI" is bounded at -inf, 2.77)? I'm not sure how to specify this in the priors.

## JD: Not sure what you mean by "flat" here, but this all looks fine.
## I don't really understand why you want to bound logAI;
## I don't think that the kind of bound you are thinking of would affect your answer

soc.data$Sex <- as.numeric(soc.data$Sex)
soc.data$Block <- as.numeric(soc.data$Block)

N <- nrow(soc.data)

soc.bayesmod <- with(soc.data, jags(model.file='jags_model.bug',
                                    parameters=c("b_Trt",
                                                 "b_Gen",
                                                 "b_Sex",
                                                 "b_0", 
                                                 "tau"),
                                    data = list('logAI' = logAI,
                                                'Treatment' = Treatment,
                                                'Generation' = Generation,
                                                'Sex' = Sex,
                                                'N'=N),
                                    n.chains = 4,
                                    inits=NULL
))

plot(soc.bayesmod)
print(soc.bayesmod)
summary(lm.1)

### The estimates generated from the Bayes and frequentist models are very similar for the 3
### predictor variables (Sex, Generation, Treatment). However, these are not very useful
### as they do not take key interactions into account.


### Bayesian model 2 - using model.matrix to include all the main effects and interactions that I want.

### JD: This is a really nice approach. Not sure there's so much variation
### JD: I added traceplots. They are fine.
X <- model.matrix(~Treatment*Generation*Sex, data = soc.data)
P <- ncol(X)

soc.bayesmod_2 <- with(soc.data, jags(model.file = 'jags_model2.bug', 
                                      parameters = c("beta",
                                                     "tau"),
                                      data = list("logAI" = logAI,
                                                  "X" = X,
                                                  "N" = N,
                                                  "P" = P),
                                      n.chains = 4,
                                      inits = NULL))

plot(soc.bayesmod_2)
traceplot(soc.bayesmod_2)
print(soc.bayesmod_2)
colnames(X) # so we know what each coefficient corresponds to
summary(lm.2)

### For this second model, I think something is going wrong, as the standard deviations around the 
### Bayes model estimates are massive. I'm not sure how to fix it at this point...

## JD: Mark 2/3 (good)
## JD: If you're interested, the next thing to try is to do the original model with model.matrix (to make sure that you did all the coding right).
