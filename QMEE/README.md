# QMEE
Bio 708 QMEE First Repository

Assignment Week 1

The dataset for this assignment is from a project aiming to create artificially selected lineages of fruit flies that are diverged in their level of sociability (which we define as the tendency of animals to engage in non-aggressive group activities). For each generation of selection, we quantify sociability using arenas with 8 compartments, each with a small food patch, that allow groups of 16 flies to assume their most preferred social arrangement after a period of acclimatization. The dependent variable is the “Aggregation Index” (AI), or variance/mean number of flies in each compartment, and varies from 0 (least social arrangement – all flies spread out evenly among the food patches) to 16 (most social arrangement – all flies in a single compartment). We then select flies from the largest group(s) to reproduce for the “Up” selected lineages, and from the smallest groups for the “Down” selected lineages. The main overall goal of this project is to identify genetic variants that may be underpinning some of the phenotypic variation seen in this social trait.

While I have only completed about 1/3rd of the expected required number of generations of selection, I would still like to know if there has been any meaningful divergence in sociability (as measured by the aggregation index) at this point. I would also like to know about the extent of environmental variation in producing variation among generations.


Assignment Week 2

The main investigation I wish to conduct with this data set is to determine whether there has been meaningful phenotypic divergence among the 2 artificial selection treatments (selection for increased sociability = “Up”, and selection for decreased sociability = “Down”) over the 8+ generations of selection. Further, I want to investigate whether this divergence is being driven by only a few (or 1) of the replicate lineages for each selection treatment, or if it is a consequence of divergence among all 4 replicates. Although the meatiest experiments/data collection will come once the artificial selection portion of this project is complete (and will involve, hopefully, well-diverged lineages), there are still a few other smaller questions I wish to look at with this selection data – for example, how sociability is affected by general lab adaptation, and whether there are interesting variable responses to our selection regime between the sexes. 

For part of the assignment 2 script, I have tried to make a replicable pipeline for the selection data that can easily process the raw data as I add to the raw data file with every additional generation. It is not hugely complicated, but allows for the “aggregation index” dependent variable to be calculated for each observation, creates new meaningful categorical variables to help sort the data, and checks for any errors and anomalies. The idea is that the output from this script could then be used to assess the progress of the experiment, and can be reproduced with the newest data included every generation.

