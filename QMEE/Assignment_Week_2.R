## QMEE Assignment Week 2 - Data Management

library(tidyverse)

soc.data <- read_csv("data/Sociability_Raw_Data.csv")

# examine data structure
str(soc.data)
# head(soc.data)

# make block, lineage, generation and sex factors
soc.data <- soc.data %>% 
  mutate(Block = as.factor(Block)) %>%
  mutate(Lineage = as.factor(Lineage)) %>%
  mutate(Sex = as.factor(Sex)) %>%
  mutate(Generation = as.factor(Generation))

# Summarize counts for each observation (vars Q1-Q8) into a single aggregation index (AI) dependent variable
soc.data <- soc.data %>%
  rowwise() %>% # allow for row-by-row operations
  mutate(AI = var(c(Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8))/mean(c(Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8))) %>%
  ungroup() # remove rowwise

# Min and max AI should be within 0-16: do a check
print(c(min(soc.data$AI), max(soc.data$AI)))

# Make a new factor "treatment" with 3 levels corresponding to direction of selection (U, D, C)
soc.data <- soc.data %>%
  mutate(Treatment = as.factor(str_extract(Lineage, "^.{1}"))) # The treatment is located in the first letter of the Lineage string

# Should be 3 levels - check
levels(soc.data$Treatment)

# make a list to examine the data for mistakes
soc.check <- soc.data %>%
        filter(Treatment %in% c("U", "D")) %>% # Just looking at the down and up for now
        group_by(Generation, Sex, Lineage) %>%
        summarize(count = n())
    
print(soc.check, n = 128)

# Should be n=12 for every lineage/sex combination - do a check:
soc.check %>% filter(count != 12)

# make a few plots to check the data for errors/anomalies
hist(soc.data$AI, breaks = 24) # looks typical for AI data we have used in the past - positive skew

pairs(soc.data[,-c(2,3,6:13)]) # all the categorical variables match up the way I expect, and no major outliers when plotting AI against other variables


