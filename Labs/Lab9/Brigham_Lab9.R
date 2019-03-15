#This is my work for lab 9. 15 Mar 19

#import data
camData <- read.csv("Cusack_et_al_random_versus_trail_camera_trap_data_Ruaha_2013_14.csv", stringsAsFactors = F)
str(camData)
#our time variable is read in as a character

# 1. 
# convert those dates and times into actual objects that represent time (as we humans think about it) 
# rather than just being character strings
# use the info from here: https://www.stat.berkeley.edu/~s133/dates.html

camData$DateTime <- strptime(camData$DateTime, format = '%d/%m/%Y %H:%M')


# 2.
# How could you figure out which were NOT coverted properly by your method from problem?

#make a vector to work with separately
DateTime <- camData$DateTime

#can look at what format the years are listed as
unique(DateTime$year)

#where 2013 is 113 and 2014 is 114, but because the other years are represented as
# 0013 is -1887 and 0014 is -1886

#this will give the indexes within my vector that have date values that are off
which(DateTime$year < 0)

#this will tell me how many indexes within my vector that have date values that are off
length(which(DateTime$year < 0))    #there are 5645 entries in the wrong date format


# 3. How could you use your methods from problems 1 and 2 to create an ACCURATE vector of dates and times?

# write a for loop that takes every value that is not 113 and makes in 114 by adding 2000 based on the conventions of 
# the function 

for (i in 1:length(DateTime$year)) {
  if ( DateTime$year[i] < 0 ) {
    DateTime$year[i] <- DateTime$year[i] + 2000
  }
}

# 4. How could you look at the average time between observations for a given 
# combination of Season, Station, and Species?
  
#  add the correct data to the original df
camData$DateTime <- DateTime
str(camData)

# make a function that subsets the df to look at a given Season, Station, and Species, takes the time diff between entries
# and then averages that time differences

avg_time <- function(sp, se, st) {
  # Season, Station, and Species must be given as characters
  # must be in the exact right format (e.g. capitalization)
  #subet based on chosen parameters sp, se, st
  subset <- subset(camData, camData$Season == se & camData$Station == st & camData$Species == sp)
  if (nrow(subset) > 1) {
    #make sure the dates are all in increasing order
    subset <- subset[ order(subset$DateTime , decreasing = F ),]
    #make a vector to store the time differences
    vec <- rep(0, (nrow(subset) - 1))
    #there will be n-1 time differences for a subset of nrow = n
    for (i in 1:(nrow(subset) - 1)) {
      vec[i] <- subset$DateTime[i + 1] - subset$DateTime[i]
    }
    mean <- mean(vec)
    # there must be more than two entries to compute the mean
  } else {
    return("Error: There are fewer than 2 entries")
  }
  return(mean)
}


# Demonstrate that it works: 
avg_time("Impala", "W", "28")
avg_time("Elephant", "W", "28")
avg_time("Greater kudu", "D", "28") # this should return an error since there's only one entry for this combo



# I was on to something regarding not needing to input as characters, but I ran out of time
# deparse(substitute) 
# source: https://stackoverflow.com/questions/4108577/cast-function-argument-as-a-character-string