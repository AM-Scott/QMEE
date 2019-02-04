### Assignment Week 5 - Permutation tests

library(tidyverse)
library(lmPerm)
library(coin)
library(gtools)

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


set.seed(999)

### Hyp 1 - Would a difference between the Up/Down be expected by chance in gen 1? - just looking at males

summarized.soc.data <- (soc.data
               %>% group_by(Generation, Treatment, Sex)
               %>% summarise(mean_AI = mean(AI))
)

# Observed mean difference in males
g1.diff.M <- (summarized.soc.data
              %>% filter(Generation == 1, Sex == "M", Treatment != "C")
              %>% pull(mean_AI)
              %>% diff()
)
print(g1.diff.M)

# Permutation test
gen1.M.data <- filter(soc.data, Generation == 1, Sex == "M", Treatment != "C")

g1.M.result <- numeric(2000)
for (i in 1:1999) {
  bdat <- transform(gen1.M.data,
                    AI = gen1.M.data$AI[sample(nrow(gen1.M.data))])
  g1.M.result[i] <- (bdat
                     %>% group_by(Treatment)
                     %>% summarise(mean_AI = mean(AI))
                     %>% pull(mean_AI)
                     %>% diff
  )
}
# add our actual observation as the 2000th
g1.M.result[2000] <- g1.diff.M

hist(g1.M.result, col="gray",main = "", breaks = 24)
abline(v=g1.diff.M, col = "red")


### How does this difference look at gen 9? Also just in males

# Observed mean difference in males
g9.diff.M <- (summarized.soc.data
              %>% filter(Generation == 9, Sex == "M", Treatment != "C")
              %>% pull(mean_AI)
              %>% diff()
)
print(g9.diff.M)

# Permutation test
gen9.M.data <- filter(soc.data, Generation == 9, Sex == "M", Treatment != "C")

g9.M.result <- numeric(2000)
for (i in 1:1999) {
  bdat <- transform(gen9.M.data,
                    AI = gen9.M.data$AI[sample(nrow(gen9.M.data))])
  g9.M.result[i] <- (bdat
                     %>% group_by(Treatment)
                     %>% summarise(mean_AI = mean(AI))
                     %>% pull(mean_AI)
                     %>% diff
  )
}
# add our actual observation as the 2000th
g9.M.result[2000] <- g9.diff.M

hist(g9.M.result, col="gray", main = "", breaks = 24)
abline(v=g9.diff.M, col = "red")






## females g9


# Observed mean difference in females
g9.diff.F <- (summarized.soc.data
              %>% filter(Generation == 9, Sex == "F", Treatment != "C")
              %>% pull(mean_AI)
              %>% diff()
)
print(g9.diff.F)

# Permutation test
gen9.F.data <- filter(soc.data, Generation == 9, Sex == "F", Treatment != "C")

g9.F.result <- numeric(2000)
for (i in 1:1999) {
  bdat <- transform(gen9.F.data,
                    AI = gen9.F.data$AI[sample(nrow(gen9.F.data))])
  g9.F.result[i] <- (bdat
                     %>% group_by(Treatment)
                     %>% summarise(mean_AI = mean(AI))
                     %>% pull(mean_AI)
                     %>% diff
  )
}
# add our actual observation as the 2000th
g9.F.result[2000] <- g9.diff.F

hist(g9.F.result, col="gray", main = "", breaks = 24)
abline(v=g9.diff.F, col = "red")




#######################################################################
#######################################################################

# lm at gen 9- females

gen9.F.data <- filter(soc.data, Generation == 9, Sex == "F", Treatment != "C")

summary(lmp(AI ~ Treatment + Block + Dish, data = gen9.F.data))

oneway_test(AI ~ Treatment, data = gen9.F.data)



