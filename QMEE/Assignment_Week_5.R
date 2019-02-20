### Assignment Week 5 - Permutation tests

library(tidyverse)

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
  mutate(Treatment = as.factor(str_sub(Lineage, 1,1)))

### Hyp 1a - In generation 1, any difference in mean social score between the Up/Down selection treatments would be expected by chance, as there has been no treatment-related artificial selection at this point.
### Hyp 1b - In the latest generation (at this point, gen 9) selection should be causing the 2 treatments to become diverged, and differences at this point should not be expected by chance.
### I can look at these hypotheses with permutation tests that scramble the response variable (social score) with respect to treatment.
#
### I would like to be able to look at these hypotheses separately for males and females.
### Therefore, I'll make a generic function for the permutation test where the generation and sex being looked at can be easily modified.

set.seed(999)

soc.selection.perm <- function(Gen, sex, data = soc.data, nsim = 2000) {
  summarized.soc.data <- (data
                        %>% group_by(Generation, Treatment, Sex)
                        %>% summarise(mean_AI = mean(AI))
                        )
  # Observed mean difference
  obs.diff <- (summarized.soc.data
              %>% filter(Generation == Gen, Sex == sex, Treatment != "C")
              %>% pull(mean_AI)
              %>% diff()
              )
  print(obs.diff, message("Observed Difference"))
  # Permutation test
  perm.data <- filter(soc.data, Generation == Gen, Sex == sex, Treatment != "C")
  perm.result <- numeric(nsim)
  for (i in 1:nsim) {
    perm <- sample(nrow(perm.data))
    pdat <- transform(perm.data,
                      AI = AI[perm])
    perm.result[i] <- (pdat
                     %>% group_by(Treatment)
                     %>% summarise(mean_AI = mean(AI))
                     %>% pull(mean_AI)
                     %>% diff
    )
    }
  # add our actual observation to the result
  perm.result <- c(perm.result, obs.diff)
  
  hist(perm.result, col="gray",main = "", breaks = 24)
  abline(v=obs.diff, col = "red")
  p.val <- mean(abs(perm.result)>=abs(obs.diff))
  print(p.val, message("P-value"))
}

# Run the function separately for each generation and sex combination relating to the above hypotheses.

soc.selection.perm(Gen = 1, sex = "F")

soc.selection.perm(Gen = 9, sex = "F")

soc.selection.perm(Gen = 1, sex = "M")

soc.selection.perm(Gen = 9, sex = "M")

#######################################################################
### Preface: I'm not exactly sure if the following makes sense...
### Hyp 2 - I expect that the treatment-by-generation interaction estimated via a linear model should not be expected by chance. 
### (i.e. under the null hypothesis where the response variable (social score) is scrambled with respect to Treatment and Generation. 
### This is because divergence between treatments should be increasing with generation.

## For simplicity, I'll attempt this with just females

F.data <- filter(soc.data, Sex == "F", Treatment != "C")

# Calculate the observed interaction estimate
obs.inter <- coef(lm(AI ~ Treatment*Generation, data = F.data))[4]
names(obs.inter) <- NULL # just want the number

# Permutation
nsim <- 2000
perm.result.h2 <- numeric(nsim)
for (i in 1:nsim) {
  perm <- sample(nrow(F.data))
  pdat <- transform(F.data,
                    AI = AI[perm])
  perm.inter <- coef(lm(AI ~ Treatment*Generation, data = pdat))[4]
  names(perm.inter) <- NULL
  perm.result.h2[i] <- perm.inter
}

# add our actual observation to the result
perm.result.h2 <- c(perm.result.h2, obs.inter)

hist(perm.result.h2, col="gray",main = "", breaks = 24)
abline(v=obs.inter, col = "red")
p.val <- mean(abs(perm.result.h2)>=abs(obs.inter))
print(p.val)

# p val is basically the same as what is given from the summary of the model:
summary(lm(AI ~ Treatment*Generation, data = F.data))
