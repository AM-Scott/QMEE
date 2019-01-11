## QMEE Assignment 1

# Working directory should be automatically set to project directory

library(tidyverse)

# Load in sociability selection data through 8 generations
soc.data <- read_csv("Sociability_selection_data_after_gen_8.csv")

# Check the structure and first few rows
str(soc.data)
head(soc.data)

# Calculate the mean Aggregation Index (AI) and standard error of the mean for the 2 treatments (U=Up selection, D=Down selection) across sexes and generations
summarized.soc.data <- soc.data %>%
  group_by(Generation, Treatment, Sex) %>%
  summarise(mean_AI = mean(AI),
            sem_AI = (sd(AI)/sqrt(48))) # always 48 replicates per sex/treatment/generation

print(summarized.soc.data)

# Just look at the first and last generations to better compare the divergence at gen 8 to the starting means
gens.1.and.8 <- filter(summarized.soc.data, Generation %in% c(1,8))

print(gens.1.and.8)
