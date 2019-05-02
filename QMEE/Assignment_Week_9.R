### Assignment Week 9 - Mixed Models

library(tidyverse)
library(lme4)

### Cleaning up/preparing data

## JD: watch filename case for reproducibility
soc.data <- read_csv("Data/Sociability_Raw_Data.csv")

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

#### Mixed models - Maximal model:

lme.1 <- lmer(log(AI) ~ 1 + Sex*Generation*Treatment + 
                Block + ## block is random nuissance variable but has too few levels (4) to be a random effect
                (1 + Sex + Generation | Treatment:Lineage) + 
                (1 + Sex + Generation + Treatment | Dish),
              data = soc.data)

### I have specified Lineage and Dish as 2 random effects since Lineages are replicate populations
### under selection (effectively population-level subject IDs), and the Dish used in testing is just kind of a 
### nuissance variable whose levels don't have any real biological significance to our design, but the 
### variance among them should probably be accounted for.

### The random effect of lineage should be nested within treatment since each lineage has only 
### 1 selection treatment. Interestingly, it appears to give exactly the same answers in summary 
### as a model that does not specify this nesting structure (i.e. if I put (1 + Sex + Generation | Lineage),
### so I'm wondering if specifying this nesting within a fixed factor is redundant?
### JD: It is necessary to specify nesting when R might otherwise get confused
### e.g., when Cage 1 mouse 1 has nothing in common with Cage 2 mouse 1

### For the maximal model, I can include a random intercept and random slopes of Sex and Generation for lineage
### (this will show how the lineages vary in social score differences between the sexes, and how much the lineages
### vary in terms of their change in social score per generation). I can also include a random intercept
### and random slopes of Sex, Generation and Treatment for Dish, which would provide information similar to that 
### described above but about how the Dish IDs vary. I can include a treatment random slope here as Treatments do vary within Dish,
### but not within lineage.

### This model gives a "singular fit" warning, meaning the random effects may be too complicated or overspecified.

### I resolved the singular fit by removing the Sex random slope from the lineage random effect, and having dish as a fixed effect

lme.2 <- lmer(log(AI) ~ 1 + Sex*Generation*Treatment + 
                Block + 
                (1 + Generation|Treatment:Lineage) +
                Dish,
              data = soc.data)

### Diagnostic plots

plot(lme.2)

### Fitted vs residual plot looks reasonably good - residuals evenly spread around the 0 line

plot(lme.2, sqrt(abs(resid(.))) ~ fitted(.),
     type=c("p","smooth"), col.line="red")

### Scale-location plot also looks good - no "fan" shape, so residuals likely reasonably homoscedastic

### Now look at the summary
summary(lme.2)

### My interpretation of the random effects summary: the baseline (i.e. at Gen 0 (intercept)) log social
### scores among lineages tend to vary by about 0.08. The change in social score per generation tends to 
### vary by about 0.007 log(social score) among lineages.
### There is a large negative correlation between the random slope and intercept (meaning
### lineages with larger intercept (baseline score) tend to have a smaller slope (
### low change in soc score over generations?))

## Grade 2.4/3 Very good
