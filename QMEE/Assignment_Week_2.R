## QMEE Assignment Week 2 - Data Management

library(tidyverse)

soc.data <- read_csv("data/Sociability_Raw_Data.csv")

str(soc.data)
# head(soc.data)

soc.data <- soc.data %>% 
  mutate(Block = as.factor(Block)) %>%
  mutate(Lineage = as.factor(Lineage)) %>%
  mutate(Sex = as.factor(Sex))

# Make a new factor "treatment" with 3 levels corresponding to direction of selection (U, D, C)

soc.data <- soc.data %>%
  mutate(Treatment = as.factor(str_extract(Lineage, "^.{1}"))) # The treatment is located in the first letter of the Lineage string
  
# Should be 3 levels - check
levels(soc.data$Treatment)
  
# Check for errors? - Make a table to see if the Ns match what you think they should?
# Calculate AI