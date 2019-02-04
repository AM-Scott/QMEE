#BIO 708 Class 1 - Jan 7 2019

f <- function(x, y=2) {
  x + 2 + y
}

f(2) ## y argument defaults to 2

## square brackets - rows first, columns second

## tidyverse

#setwd

download.file(url="https://ndownloader.figshare.com/files/2292169",
              destfile = "data/portal_data_joined.csv")

library(tidyverse)

surveys <- read_csv("data/portal_data_joined.csv") ## this is a tidyverse function (the "parsed..." is not an error)
## this isnt a data frame - its a tibble


#################################
# Class 2 (Jan 9)

library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv") ## this is a tidyverse function (the "parsed..." is not an error)
str(surveys)

# selecting columns (variables)
surveys2 <- select(surveys, plot_id, species_id, weight)
surveys3 <- select(surveys, -plot_id) #everything but plot_id

names(surveys2)

# selecting rows (observations)
filter(surveys, month == 7, genus=="Neotoma") #only want surveys from month 7 with that genus
filter(surveys, month == 7 | genus=="Neotoma") #only want surveys from month 7 OR with that genus

unique(surveys$genus) #show what the options are

filter(surveys, genus %in% c("Neotoma", "Dipodomys", "Perognathus")) ## obs from any of those 3 genus

# PIPES - connect multiple verb steps together

surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight) ## do the filtering by rows, then we select the columns

# mutate - replace/make new variable

surveys %>% mutate(weight_kg = weight/1000) #create new variable for weight in kilos

surveys %>% mutate(weight_kg = weight/1000) %>%
  filter(!is.na(weight) & !is.na(sex)) ## also filter out the NAs in weight and sex

#group_by - doesnt modify anything, justs associate a grouping variable with this data sex

surveys %>% mutate(weight_kg = weight/1000) %>%
  filter(!is.na(weight) & !is.na(sex)) %>%
  group_by(species_id) %>% ## everything after this point, do the summary for each species (collapse by species)
  summarise(weight_mean = mean(weight_kg), ## get mean weight in kg for each species
            weight_median = median(weight_kg))



