## Data Management

library(tidyverse)

droplevels() ## if subsetting data, it won't automatically remove unused factors - need this to get rid of them

# always wait until the last possible moment before converting strings to factors

hh <- read_csv("Data/CA_homicide.csv")

summary(hh)
head(hh) # normally comment these out when sending to profs

hh$Place <- as.factor(hh$Place)

hist(hh[["2007"]]) # can't use $ because column name is a number

# also draw scatterplots to look for utliers

pairs(hh[,-1]) #only works with numeric variables so drop first column

# convert this wide format set to long format

sdat <- gather(hh, key = year, value = homicides, -Place, convert = TRUE) # take a bunch of columns and collapse them into a single row

# want to add some other information to the data set

#create the extra info
head(rdat <- data_frame(Place=hh$Place,
                        Region=c("all",rep("Atlantic",4),
                                 rep("East",2),
                                 rep("West",4),
                                 rep("North",3))))

sdat2 <- sdat %>%
  full_join(rdat,by="Place") %>%  ## better than cbind (can be different shapes, etc)
  full_join(popdat,by="Place") 

### GO OVER THIS STUFF BEFORE WEDNESDAY...