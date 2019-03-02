#This is my work for lab 5. 15 Feb 19
#This work has been updated 2 March 19 based on comments from Sam


###Part 1.
#1. Create a variable named x and assign a numeric value of your choosing to it.
# On the next line of code, write an if-else statement that checks if the value is 
# larger than 5. Your code should print a message about whether the value is larger or smaller than 5.

#here I'm creating a variable x as directed
x <- 7
#create a variable to test in our if else
five <- 5

#I want to check if x is greater than 5 and print info about the result
#I will use if and else to do this

if ( x > five ) {
  print("Larger than 5")
} else {
  print("Smaller than 5")
}

#2. From Sam's github folder for Lab05, obtain and import the file "Vector1.csv"
Vector1 <- read.csv('/Users/laurelbrigham/Documents/CU_Boulder/2018-2019/Spring Sem/Comp_Bio/CompBioLabsAndHW/Labs/Lab5/Vector1.csv')

  #2a. Using a for() loop, write code that checks each value in the imported data and 
  #replaces every negative value with NA.

#I had initially used length(Vector1), but I want to use nrow because it's a dataframe and not a vector
#length(Vector1) gives a value of 1, but I want a value of 2024, which I get with nrow()

#construct a for loop iterating over nrows within the column x
for (i in 1:nrow(Vector1)) {
  if (Vector1$x[i] < 0) {
    Vector1$x[i] <- NA
  }
}

  #2b. Using vectorized code (no loop) that makes use of "logical" indexing, 
  #replace all those NA values with NaN. (Note that R has a special function for testing if something is an NA)

#Now I will make a logical that gives me a TRUE when the value in Vector1 is NA
logical <- is.na(Vector1$x)

#Now I want to take all of those TRUE values and make then NaN
Vector1$x[logical] <- NaN


  #2c. Using a which() statement and integer indexing (again, no loop), replace all those NaN 
  #values with a zero. (Note that R has a special function for testing if something is an NaN)

# I will make a vector that gives me the index where the value in Vector1 is NaN
vec_nan <- which(is.nan(Vector1$x))

#Now I want to take all of those indexes  and make then 0
Vector1$x[vec_nan] <- 0

  #2d. Use code to determine how many of the values from the imported data fall in the range between
  #50 and 100 (inclusive of those endpoints).

#set the boundaries of interest
Low <- 50
High <- 100

#conduct a logical test 
Range <-  Vector1$x >= Low & Vector1$x <= High

#sum the TRUE
sum(Range)


  #2e. Using any method of your choice, create a new vector of data that has all the values from the 
  #imported data that fall in the range between 50 and 100. Do NOT dynamically grow the array, however. 
  #This vector should be named "FiftyToOneHundred".

#make a vector using logical indexing
FiftyToOneHundred <- Vector1$x[Range]

  #2f. Use write.csv() to save your vector to a file named "FiftyToOneHundred.csv". Please use all 
  #default settings with write.csv(). In other words, assuming that your current working directory is 
  #your own directory for your work for Lab05, save it with the command
  #write.csv(x = FiftyToOneHundred, file = "FiftyToOneHundred.csv")

write.csv(x = FiftyToOneHundred, file = "FiftyToOneHundred.csv")
  

#3. Import the data on CO2 emissions from last week's lab ("CO2_data_cut_paste.csv" from Lab04).
#Read the accompanying metadata (in a plain text file in the same directory) to learn what the data represent. 
#Use code to answer the following questions. Hint: you do NOT need to use any loops here. Use some combination of 
#which(), logical operators, and/or indexing:

CO2_data <- read.csv('/Users/laurelbrigham/Documents/CU_Boulder/2018-2019/Spring Sem/Comp_Bio/CompBioLabsAndHW/Labs/Lab4/CO2_data_cut_paste.csv')


  #3a. What was the first year for which data on "Gas" emissions were non-zero?

#set a threshold at zero
Threshold_gas <- 0

#write a logical to get those gas measurements which are not 0
logical_Not0 <- CO2_data$Gas != Threshold_gas

#make a data frame that calls all rows of CO2_data that are associated with non-zero gas measurements
Not0_df <- CO2_data[logical_Not0,]

#grab the first row of the year column to find the first year of non-zero gas emissions 
Not0_df[1,"Year"]


  #3b. During which years were "Total" emissions between 200 and 300 million metric tons of carbon?

#set the boundaries defined by the problem
Low_total <- 200
High_total <- 300

#write a logical that is TRUE for total emissions between our set boundaries
logical_200and300 <- CO2_data$Total > Low_total & CO2_data$Total < High_total

#grab all years from the orginial data frame that are associated with total emissions between our set boundaries
CO2_data$Year[logical_200and300]



###Part 2.
#We'll be working with the Lotka-Volterra model for this part

#First, set parameter values using given info on https://github.com/flaxmans/CompBio_on_git/blob/master/Labs/Lab05/lab_05_LoopsAndConditionals.md

#parameters 
totalGenerations <- 1000
initPrey <- 100 	# initial prey abundance at time t = 1
initPred <- 10		# initial predator abundance at time t = 1
a <- 0.01 		# attack rate
r <- 0.2 		# growth rate of prey
m <- 0.05 		# mortality rate of predators
k <- 0.1 		# conversion constant of prey into predators

#Second, create a "time" vector, and make two additional vectors to store results, one for the values of n over time,
#and the other to store values of p

#make a time vector for future plotting
time <- 1:totalGenerations

#make empty vectors to store data
#the abundance of prey
n <- rep(0,totalGenerations)

#the abundance of predators
p <- rep(0,totalGenerations)

#set the initial values for the vectors using the parameters
n[1] <- 100
p[1] <- 10


#Third, write a loop that implements the calculations.
#start the loop at 2 because we don't want n(0)
for (t in 2:totalGenerations) {
  n[t] <- n[t - 1] + (r * n[t - 1]) - (a * n[t - 1] * p[t - 1])
  for(t in 2:totalGenerations) {
    p[t] <- p[t - 1] + (k * a * n[t - 1] * p[t - 1]) - (m * p[t - 1])
  }
} 

#Fourth, add some if statements to your code to check for negative numbers each generation. 
#If, for example, a given value of prey abundance is negative, then that value should be set to be zero.


#I'm going to leave the commented nested for loop in the code to serve as an example:
#One cannot use the same iterator in a nest for loop
#so while it works, it's not the correct way to go about the problem
#see the for loop directly below

#for (t in 2:totalGenerations) {
 # n[t] <- n[t - 1] + (r * n[t - 1]) - (a * n[t - 1] * p[t - 1])
  #if(n[t] < 0) {
  #  n[t] <- 0
 # }
  #for(t in 2:totalGenerations) {
   # p[t] <- p[t - 1] + (k * a * n[t - 1] * p[t - 1]) - (m * p[t - 1])
 # }
#} 

#this is the updated for loop, I removed the for statement at Sam's suggestion for the reasons stated above
for (t in 2:totalGenerations) {
  n[t] <- n[t - 1] + (r * n[t - 1]) - (a * n[t - 1] * p[t - 1])
  if (n[t] < 0) {
    n[t] <- 0
  }
    p[t] <- p[t - 1] + (k * a * n[t - 1] * p[t - 1]) - (m * p[t - 1])
} 

#Fifth, make a plot of the abundances of prey and predators over time (see cheat sheet above for using plot() 
#and lines()

plot(x = time,y = n, type = "p", pch = 21, col = "red", xlab = "Time", ylab = "Abundance")
lines(x = time,y = p, pch = 19, col = "blue", type = "p", lty = 2)
legend(600 ,600, legend = c("Prey", "Predator"), col = c("red", "blue"), cex = 0.8, title = c("Abundance"), pch = c(21,19), text.font = 4)

#source for adding color and a legend: http://www.sthda.com/english/wiki/add-legends-to-plots-in-r-software-the-easiest-way


#Sixth, create a matrix of your results named "myResults" in which the first column is named "TimeStep", 
#the second column is named "PreyAbundance", and the third column is named "PredatorAbundance".
#Write this matrix to a csv in your Lab05 working directory with the command 
#write.csv(x = myResults, file = "PredPreyResults.csv")

#bind the vectors that I've made into columns of a matrix
myResults <- cbind(time, n, p)

#renames the columns of my matrix
colnames(myResults) <- c("TimeStep", "PreyAbundance", "PredatorAbundance")

#write as a csv
write.csv(x = myResults, file = "PredPreyResults.csv")


