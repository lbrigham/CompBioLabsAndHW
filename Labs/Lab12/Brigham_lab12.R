#This is my work for lab 12. 12 April 19

#Load libraries
library(cowplot)
library(tidyverse) 

#Read in the data
camData <- read.csv("/Users/laurelbrigham/Documents/CU_Boulder/2018-2019/Spring Sem/Comp_Bio/CompBioLabsAndHW/Labs/Lab9/Cusack_et_al/Cusack_et_al_random_versus_trail_camera_trap_data_Ruaha_2013_14.csv", stringsAsFactors = F)
str(camData)


#Problem 1
#Plot count on the y and Species on the x axis
#only need Species as the aesthetic, ggplot will calculate Count

ggplot(camData, aes(x = Species)) +
  geom_bar() +
  labs(y = "Count") #capitalize the y axis label
  

#Problem 2
#Make the same plot as above, but rotate the labesl 90 degrees, so they can be read
ggplot(camData, aes(x = Species)) +
  geom_bar() +
  labs(y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) #rotates the x axis labels 90 degrees

#source for labels at 90 degrees: https://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2

#Problem 3
#Make the same plot as above, but flip the axes so Species is now on the y,
  #order the counts in increasing order (going down the y axis),
  #and put the counts on a log scale

#First, I'll order the data
camData_ordered <- within(camData, 
                   Species <- factor(Species, 
                                      levels = names(sort(table(Species), 
                                                        decreasing = T))))

#source for ordering:https://stackoverflow.com/questions/5208679/order-bars-in-ggplot2-bar-graph

#Here, I am using the new df that will tell ggplot to order the data
ggplot(camData_ordered, aes(x = Species)) +
  geom_bar() +
  labs(y = "Count, Log-10 Scaling") + #note in the axis label that it's a log scale
  scale_y_continuous(trans = 'log10') +  #puts the Count data on a log scale 
  coord_flip() + #flips the axes
  theme_cowplot() #I like the way this looks

#source for transforming axis to log: https://stackoverflow.com/questions/4699493/transform-only-one-axis-to-log10-scale-with-ggplot2
#source for coord_flip: https://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2




