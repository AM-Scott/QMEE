## QMEE Assignment Week 2 - Data Management

library(tidyverse)

soc.data <- read_csv("data/Sociability_Raw_Data.csv")

# examine data structure
## str(soc.data)
## head(soc.data)
## BMB: comment these out in code

# make block, lineage, generation and sex factors
soc.data <- soc.data %>% 
  mutate(Block = as.factor(Block)) %>%
  mutate(Lineage = as.factor(Lineage)) %>%
  mutate(Sex = as.factor(Sex)) %>%
  mutate(Generation = as.factor(Generation))

## BMB: you don't need to use separate mutate statements:
##  can be comma-separated, or ...
soc.data <- soc.data %>%
    mutate_at(vars(Block,Lineage,Sex,Generation),factor)

## BMB: why make Generation a factor??

# Summarize counts for each observation (vars Q1-Q8) into a single aggregation index (AI) dependent variable
soc.data <- soc.data %>%
  rowwise() %>% # allow for row-by-row operations
  mutate(AI = var(c(Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8))/mean(c(Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8))) %>%
  ungroup() # remove rowwise

## BMB: or ... 
soc.data <- soc.data %>%
    gather(key=Q,value=score,Q1:Q8) %>%
    group_by(Generation,Block,Dish,Lineage,Sex) %>%
    summarise(AI=var(score)/mean(score)) %>%
    full_join(soc.data)

# Min and max AI should be within 0-16: do a check
print(c(min(soc.data$AI), max(soc.data$AI)))
stopifnot(min(soc.data$AI)>=0 && max(soc.data$AI)<=16)

# Make a new factor "treatment" with 3 levels corresponding to direction of selection (U, D, C)
soc.data <- soc.data %>%
    mutate(Treatment = as.factor(str_extract(Lineage, "^.{1}"))) # The treatment is located in the first letter of the Lineage string
## BMB: or more simply factor(str_sub(Lineage,1,1))

# Should be 3 levels - check
levels(soc.data$Treatment)
stopifnot(identical(levels(soc.data$Treatment),c("C","D","U")))

# make a list to examine the data for mistakes
soc.check <- soc.data %>%
        filter(Treatment %in% c("U", "D")) %>% # Just looking at the down and up for now
        group_by(Generation, Sex, Lineage) %>%
        summarize(count = n())
    
print(soc.check, n = 128)

## BMB: could  spread() or use table():

(tt <- with(filter(soc.data,Treatment != "C"),
     table(Sex, Lineage, Generation)))
# Should be n=12 for every lineage/sex combination - do a check:
soc.check %>% filter(count != 12)

## BMB: or
stopifnot(all(tt %in% c(0,12)))

# make a few plots to check the data for errors/anomalies
hist(soc.data$AI, breaks = 24) # looks typical for AI data we have used in the past - positive skew
## BMB: I like col="gray" too

pairs(soc.data[,-c(2,3,6:13)], gap=0) # all the categorical variables match up the way I expect, and no major outliers when plotting AI against other variables

library(GGally)
ggpairs(soc.data[,-c(2,3,6:13)])

## BMB: 2.5 (1=poor, 2=fine, 3=excellent)

## a fancier plot ...
library(ggplot2)
theme_set(theme_bw())
ggplot(soc.data,aes(Generation,AI,colour=Treatment))+
    geom_boxplot()+
    ## maybe I don't have the right grouping for lines?
    geom_line(aes(group=interaction(Block,Dish,Lineage)),alpha=0.1)+
    scale_colour_brewer(palette="Dark2")+
    geom_smooth(aes(group=Treatment),method="gam")+
    scale_y_log10()+
    facet_wrap(~Sex)
