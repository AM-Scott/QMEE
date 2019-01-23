## Assignment Week 3 - Data Visualization

library(tidyverse)

soc.data <- read_csv("data/Sociability_Raw_Data.csv")

# make block, lineage, generation and sex factors
soc.data <- soc.data %>%
  mutate_at(vars(Block,Lineage,Sex),factor)

# Summarize counts for each observation (vars Q1-Q8) into a single aggregation index (AI) dependent variable
soc.data <- soc.data %>%
  gather(key=Q,value=score,Q1:Q8) %>%
  group_by(Generation,Block,Dish,Lineage,Sex) %>%
  summarise(AI=var(score)/mean(score)) %>%
  full_join(soc.data)

# Make a new factor "treatment" with 3 levels corresponding to direction of selection (U, D, C)
soc.data <- soc.data %>%
  ungroup() %>% # have to add this for it to work?
  mutate(Treatment = as.factor(str_sub(Lineage, 1,1)))

# ggplots
