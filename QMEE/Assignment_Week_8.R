### Assignment Week 8 - Generalized linear models

library(tidyverse)
library(dotwhisker)
library(effects)
library(car)

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

### Comparison of Linear model of log tranformed data vs GLM with gamma distribution

lm.1 <- lm(log(AI) ~ 1 + Treatment*Sex*Generation + Block + Dish, data = soc.data)

### Generalized linear model with gamma distribution and a log link function.
### I chose a gamma distribution as my response variable is continuous, positive,
### and has a positive tail. 

glm.1 <- glm(AI ~ 1 + Treatment*Sex*Generation + Block + Dish, data = soc.data, 
             family = Gamma(link = "log"))

summary(lm.1)
summary(glm.1)

### Comparing the model estimates of the lm vs glm - they are pretty similar; sex 
### and generation effects are clear in both, the effects are in the same direction, etc.
### (I believe the estimates are directly comparable as the lm is on the log scale, 
### and the effect scale of the glm is also on the log scale.)

par(mfrow = c(2,2))

plot(lm.1)

plot(glm.1)

### Diagnostic plots appear to be similar for both and overall fine -
### No indication of non-linearity, heteroscedasticity, etc.

### So, given all of this together, it probably is simpler/cleaner to just use a regular
### linear model and log-transformed data. The data probably make more sense on the 
### log scale anyway, as we should probably value differences in social score nonlinearly
### (Example - at the lower end of the social scale, subtle differences in group size
### may be more important than subtle differences at the upper end of the social scale
### (where a small change to super-social groupings is not as meaningful)).

