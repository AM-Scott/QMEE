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

# Make summarized data for the plots (means, etc)
summarized.soc.data <- soc.data %>%
  group_by(Generation, Treatment, Sex) %>%
  summarise(mean_AI = mean(AI),
            sem_AI = (sd(AI)/sqrt(n())))

# Plot 1 - I first want to look at the divergence of the 3 selection treatments over generations (Control, Down, and Up)
# I care the most about comparing these treatments to each other, so I have plotted them on the same plot on a common scale, with colour used to differentiate the treatment levels
# I don't really care as much (at this point) about the comparison between sexes, so I have plotted these as separate panels using facet_grid()
# I have included error bars conveying +/- 1 SEM at each mean to convey some sense of the variation. In order to see them a bit more cleaerly, I have used position_dodge to create some jitter

soc.plot.1 <- ggplot(data = summarized.soc.data, 
                     aes(x = Generation,
                         y = mean_AI,
                         colour = Treatment)) + 
  geom_line(size = 0.75) +
  geom_point(position = position_dodge(width = 0.1)) +
  facet_grid(rows = vars(Sex), 
             labeller = labeller(Sex = c(F = "Females",M = "Males"))) + # don't really like the default label position, and couldn't find a way to change it
  annotate("segment", x = -Inf, xend = Inf, y = -Inf, yend = -Inf, size = 1) + # not sure if there is a better way to add an x-axis to the top facet panel?
  geom_errorbar(aes(
    ymax = mean_AI + sem_AI,
    ymin = mean_AI - sem_AI), 
    position = position_dodge(width = 0.1), 
    width = 0.1, 
    size = 0.25) + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  scale_x_continuous(breaks = unique(summarized.soc.data$Generation)) + 
  labs(x= "Generation", y= "Mean Aggregation Index")

print(soc.plot.1)

# plot 2 - With this plot, I want to include the individual replicate lineages within each selection treatment to see whether the effects on the overall treatment means are consistent or being driven by a few replicate lineages.
# Again, I care most about the comparison between treatments and replicates, so these are on the same plot and a common scale
# The plot was a bit too busy with error bars, so I have eliminated them and made the lines a bit thinner
# I don't really care about the identity of the replicate lineages at this point, so I have left off labels for them
# I really want to be able to distinguish replicates from different treatments, so I have modified the colours to have a bit better contrast

summarized.soc.data.2 <- soc.data %>%
  group_by(Generation, Treatment, Sex, Lineage) %>%
  summarise(mean_AI = mean(AI),
            sem_AI = (sd(AI)/sqrt(n())))

soc.plot.2 <- ggplot(data = summarized.soc.data.2, 
                     aes(x = Generation,
                         y = mean_AI,
                         colour = Treatment,
                         line = Lineage)) + 
  scale_colour_manual(values = c("gray50", "steelblue2", "red2")) + #change colours to distinguish the treatments a bit better
  geom_line(size = 0.5) +
  geom_point(size = 1, position = position_dodge(width = 0.1)) +
  facet_grid(rows = vars(Sex), 
             labeller = labeller(Sex = c(F = "Females",M = "Males"))) + 
  annotate("segment", x = -Inf, xend = Inf, y = -Inf, yend = -Inf, size = 1) + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  scale_x_continuous(breaks = unique(summarized.soc.data.2$Generation)) + 
  labs(x= "Generation", y= "Mean Aggregation Index")

print(soc.plot.2)


