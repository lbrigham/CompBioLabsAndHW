##This is my work for lab 11

#read in the necessary packages
library(tidyverse)

#3. Read in data frame
wood <- read.csv("/Users/laurelbrigham/Documents/CU_Boulder/2018-2019/Spring Sem/Comp_Bio/CompBioLabsAndHW/Labs/Lab11/GlobalWoodDensityDatabase_data.csv",
                 stringsAsFactors = F)

#what's our data structure?
str(wood)

#change the column name for col 4 to shorten it
colnames(wood)[4] <- "Density"

#It turns out there is one entry (out of 16468) in the data for which there is no density entered. It will import as NA.
#4a. Which row is it?
which(is.na(wood), arr.ind = TRUE) # row 12150, col 4



#to get row and column instead of index position
  #source: https://stackoverflow.com/questions/19895596/r-locating-index-of-rows-in-a-data-frame-that-have-the-value-of-na

#4b. Remove that row from the data frame (there are several ways to do this)
wood_noNA <- wood[-which(is.na(wood), arr.ind = TRUE)[1],]
str(wood_noNA) # got rid of one entry


#5. Dealing with one kind of pseudo-replication

#Starting with your result from problem 4b, create a new data frame that:
#has each species listed only once,
#has the Family and Binomial information for each species, and
#has the mean of the Density measurements for each species

wood_mean <- wood_noNA  %>%
  group_by(Binomial, Family) %>%
  summarise(mean_Density = mean(Density))
head(wood_mean)
str(wood_mean)  #has the correct number of rows

#BONUS for problem 5: Solve this problem in two different ways and validate that your two solutions produce 
#exactly the same result
wood_mean_agg <- aggregate(Density ~ Binomial + Family, data = wood_noNA, mean)
str(wood_mean_agg)

#need to validate that it's the same result
#aggregate automatically alphabetizes. need to sort by family for the summarise df
sort_wood_mean <- arrange(wood_mean, Family)

#see if there are any rows that don't match
which(wood_mean_agg != sort_wood_mean) #they all match

#6. Contrasting most and least dense families
#6a. Make a new data frame that has the average density for each Family (and no longer has individual species). 

wood_mean_family <- wood_mean  %>%
  group_by(Family) %>%
  summarise(mean_Density = mean(mean_Density))

str(wood_mean_family) #correct number of families
head(wood_mean_family) #correct values

#6b. Sort the result of problem 6a by MeanDensity (and store the sorted result in a data frame)

#sorted from smallest to largest mean density by family
sort_wood_mean_family <- arrange(wood_mean_family, mean_Density)

# 6c. Using your results from problem 6b:
#   What are the 8 families with the highest average densities?
top8 <- tail(sort_wood_mean_family, n = 8)

#   What are the 8 families with the lowest average densities?
bott8 <- head(sort_wood_mean_family, n = 8)

#7. Plotting densities of most and least dense families with facets

#need to subset to grab species from the 8 families with the highest densities
wood_highDensity <- subset(wood_noNA, Family %in% top8$Family)
unique(wood_highDensity$Family) #correct families

#need to subset to grab species from the 8 families with the lowest densities
wood_lowDensity <- subset(wood_noNA, Family %in% bott8$Family)
unique(wood_lowDensity$Family) #correct families

#high density
ggplot(wood_highDensity, aes(y = Density)) +
  geom_boxplot() +
  facet_wrap(~Family, ncol = 4)

#low density
ggplot(wood_lowDensity, aes(y = Density)) +
  geom_boxplot() +
  facet_wrap(~Family, ncol = 4)


#8. Facilitating comparisons with graphics.

#high density
ggplot(wood_highDensity, aes(y = Density, x = Family)) +
  labs(y = "Density (g/cm^3)") +
  coord_flip() +
  geom_boxplot() +
  ylim(0, 1.3)

#low density
ggplot(wood_lowDensity, aes(y = Density, x = Family)) +
  labs(y = "Density (g/cm^3)") +
  coord_flip() +
  geom_boxplot() +
  ylim(0, 1.3)



