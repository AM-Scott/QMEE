### Assignment Week 6 - Linear models

library(tidyverse)
library(dotwhisker)
library(effects)

### Cleaning up/preparing data

soc.data <- read_csv("data/Sociability_Raw_Data.csv")

soc.data <- soc.data %>%
  mutate_at(vars(Block,Lineage,Sex),factor)

soc.data <- soc.data %>%
  gather(key=Q,value=score,Q1:Q8) %>%
  group_by(Generation,Block,Dish,Lineage,Sex) %>%
  summarise(AI=var(score)/mean(score)) %>%
  full_join(soc.data)

soc.data <- soc.data %>%
  ungroup() %>%
  mutate(Treatment = as.factor(str_sub(Lineage, 1,1))) %>%
  filter(Treatment != "C")


### Linear model - Log of the response variable (AI = social score) predicted by 
### Treatment (Up/Down/Control selection), Sex, and Generation of the selection 
### regime (Dish and Block are nuisance variables).

lm.1 <- lm(log(AI) ~ Treatment*Sex*Generation + Block + Dish, data = soc.data)


### Diagnostic plots:

## BMB: note that the 'mar' and 'mgp' settings are purely cosmetic
## (I wanted to squish the graphs a little closer together for displaying
## in class)
par(mfrow=c(2,2),mar=c(2,3,1.5,1),mgp=c(2,1,0))
plot(lm.1)

### Residuals vs. Fitted plot: the residuals are pretty much horizontal along the 0 line, and 
### don't appear to form a "fan", so we can probably assume that the residuals are homoscedastic
### across the predicted (fitted) values. There are not really any clear outliers - some extreme
### residual values appear throughout the distribution, in both positive and negative directions.
### Also, the residual values appear pretty evenly on both the positive and negative side, 
### indicating that the assumption of linearity is reasonably met. 

### QQ plot: the residuals do not appear to deviate much from the theoretical quantiles predicted 
### by a normal distribution. A few outliers at the most extreme ends, but I don't believe 
### this indicates anything unusual with respect to the normality assumption.
## BMB: FWIW this indicates the distribution is a bit left-skewed
## (heavy tail on the left, light tail on the right)

### Scale-location plot: Like the residuals vs fitted plot - the points are distributed evenly along
### the red line (no fan-shape), so we can be decently confident that the residuals are
### homoscedastic. 

### Residuals vs leverage plot: In this case, I can't even see the cook's distance lines in the 
### upper/lower right of the plot, so we can be pretty confident that there are no highly influential
### cases/data points to the results of the regression.

## BMB: good. (Note you don't really have to look for the "fan" in
## the residuals vs fitted plot - that should show up in the
## Scale-Location plot.)
## Also note that we can detect the discreteness of the response
## (visible lines in resid/fitted, scale/loc plots)

### Inferential plots:

dwplot(lm.1) +
  geom_vline(xintercept=0,lty=2)

### The dot-whisker plot shows us the estimates of the coefficients fitted in the linear model, along
### with their 95% confidence intervals. For most of the coefficients, the 95% CI overlaps with 0,
### (and so their effects cannot clearly be seen) except for Generation (where the estimate suggests 
### that log(AI) decreases by about 0.02 for each subsequent generation), and Sex (which suggests 
### Males have about 0.25 higher log sociability score compared to females).

## note that main effect of Generation by default (with "treatment contrasts" measures change over
## time in the baseline value (F, treatment=D).  Also - the most important/interesting effect (I think)
## is generation:treatment, more generally anything involving treatment.

## can refit with "sum-to-zero" contrasts ...
lm.2 <- update(lm.1, contrasts=list(Treatment=contr.sum))
dwplot(lm.2) + geom_vline(xintercept=0,lty=2)

all.effects <- allEffects(lm.1)
plot(all.effects$`Treatment:Sex:Generation`)
## note can be customized considerably:
plot(all.effects$`Treatment:Sex:Generation`,
     lines=list(multiline=TRUE),confint=list(style="bands"))

### I'm just looking at the effects plot for the "Treatment*Sex*Generation" part of the model.
### From these effect plots we can see a downward trend over time (generations) in log(AI) across
### all treatments and sexes (that probably indicates something about time-of-year effects). Other 
### trends are a bit more difficult to see - it looks like in both sexes that the Ups are finishing 
### a bit higher that the downs, though not by much. It's hard to compare males and females using
### this plot, the way it's displayed. Using the Anova function from the car package indicates that 
### the Sex, Treatment, and Generation variables are all significant:

library(car)
Anova(lm.1)

## BMB: but note that these are *not* actually interesting questions.  These are "type II" tests,
## which mean that Treatment is tested overall ... not necessarily biol. interesting.
## again, treatment X generation is what (I think) you care about
Anova(lm.2, type="III")

## score: 2.5
