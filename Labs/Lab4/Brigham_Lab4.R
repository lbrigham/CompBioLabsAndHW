#This script contains my Lab 4 assignment. 8Feb19. 

#Part I.

#1. Write a for loop that prints the word “hi” to the console 10 times.
for (i in 1:10) {
  print("hi")
}

#2. Tim currently has $10 in his piggy bank. Each week his parents give him an allowance of $5.
#Each week he also buys 2 packs of gum. If the packs of gum cost $1.34 each (with tax included), 
#how much money will Tim have in total eight weeks from now?

#Write a for loop that prints (to the console) his total amount of money each week for the next 8 weeks.

#start by making variables
TimInitialMoney <- 10   #the money Tim has
TimAllowance <- 5   #his weekly allowance
TimGum <- 2 * 1.34  #what time spends weekly on gum

#going to look at his weekly sum of money for 8 weeks
numberOfWeeks <- 8

#construct a for loop 
for (i in 1:numberOfWeeks) {
  TimInitialMoney <- (TimInitialMoney + TimAllowance) - TimGum
print(TimInitialMoney)
}


# 3. A conservation biologist estimates that, under current conditions, a population she is studying will
#shrink by 5% each year. Suppose the current population size is 2000 individuals. 

#Write a for loop that calculates the expected
#population size each year for the next seven years and prints each year’s size to the console.

#make  variables 
CurrentPop <- 2000    #starting pop size
ShrinkRate <- 1 - 0.05  #the rate of population change
NumYears <- 7     #how many years we want to look at the population over

#construct a for loop
for (i in 1:NumYears) {
  CurrentPop <- (CurrentPop * ShrinkRate) 
print(CurrentPop)
}

#4. Here is the discrete-time logistic growth equation, used in many models of population abundance over time:
#n[t] = n[t-1] + ( r * n[t-1] * (K - n[t-1])/K )
#where n[t] is the abundance of the population at time t, n[t – 1] is the abundance of the population in the 
#previous time step, r is the intrinsic growth rate of the population, and K is the environmental carrying
#capacity for the population. Suppose that right now is time 1 (i.e., the current time step is t = 1). 
#If n[1] = 2500, K = 10000, and r = 0.8, then what do you predict for the value of n[12]? 

#Write a for loop that answers this question and that also prints out the abundance of the population each time step.

#make variables
abundance <- rep(0,12)  #make a vector (of placeholder zeros) that has 12 spaces for values of pop size
abundance[1] <- 2500  #make the initial value of abundance our starting population size
carrying <- 10000  #carrying capacity
growthRate <- 0.8    #growth rate
TimeStep <- 12  #the final time step that we're interested in

#construct a for loop
#need to start the for loop at 2 because t = 1 is our starting time,
#so n[t-1] must not be n[0], it must be n[1]. 
for (t in 2:TimeStep) {
  abundance[t] <- abundance[t - 1] + (growthRate * abundance[t - 1] * (carrying - abundance[t - 1])/carrying )
  print(abundance[t])
}

#the population size at the 12th time step
#abundance[12] = 9999.985


#Part II.
#5. 
#5a. Use the rep command to make a vector of 18 zeros

#using rep to make a vector with 18 zeros
eighteen <- rep(0,18)

#5b. Make the loop store 3 times the ith value of the iterator variable (i) in the 
#ith spot of the vector you created in part a

#construct a for loop and store the values in vector eighteen
for (i in seq(1,18)) {
  eighteen[i] <- 3 * i
}

#5c. Repeat 5a to make a new vector of zeros. Then, make the first entry of that vector have a value of 1.

#name the vector eighteen_b to distinguish it from the original vector made in 5a
eighteen_b <- rep(0,18)
#make the first value of the vector 1 
eighteen_b[1] <- 1

#5d. Write a for loop so that starting with the second entry of the vector created in part c, 
#the value stored in that position in the vector is equal to one plus twice the value of the previous entry 
#(i.e., 1 + (2 * previous entry) )

#construct a for loop that starts at position 2 because we've already set the value for postion 1
for (i in 2:18) {
  eighteen_b[i] <- 1 + (2 * eighteen_b[i - 1])
}

#6. Using the information in parantheses (every number after the first two is the sum of the two preceding ones)
#write a for loop that makes a vector of the first 20 Fibonacci numbers, where the first number is 0 (zero).

#make a vector with 20 spots
Fibonacci <- rep(0,20)
#make the second number of the vector 1
Fibonacci[2] <- 1

#construct the for loop
#need to start the loop at 3 because the first two numbers are already established 
for (i in 3:20) {
  Fibonacci[i] <- Fibonacci[i - 1] + Fibonacci[i - 2]
}

#7. Redo question 4 from part I above, but now store all the data.
#Make two vectors, one called "time" that stores the time steps (1 to 12),
#and one called "abundance" that stores the data on population abundances predicted 
#from the discrete-time logistic equation. Then, make a plot of the results (i.e., plot(time, abundance))

#make a vector to store the time steps we're interested in
time <- 1:12
#I already made a vector that stores the data on population abundances of question 4 that I called abundance

#make a plot of abundance over time
plot(time, abundance)


#Part III.
#8. 
#Copy "CO2_data_cut_paste.csv" and the meta-data file  "MetaData_CO2_emissions.txt" from my clone of Sam's git repo
#into my own Lab4 directory using cp *csv *txt /Users/laurelbrigham/Documents/CU_Boulder/2018-2019/Spring\ Sem/Comp_Bio/CompBioLabsAndHW/Labs/Lab4
#from the correct cloned repo folder (Lab04)

#8a. Read in the csv
CO2_data <- read.csv('/Users/laurelbrigham/Documents/CU_Boulder/2018-2019/Spring Sem/Comp_Bio/CompBioLabsAndHW/Labs/Lab4/CO2_data_cut_paste.csv')

#look at the data structure
str(CO2_data)
#note that all variables are read in as integers, but that this is only correct for the first column (Year)

#8b. Change all columns (except the first) into numeric by altering the options within read.csv() [1] and by
# writing a for loop [2]

#[1]
#figure out the option that can be used in read.csv() to force it to import everything but the year as type numeric
# first, find out the options associated with read.csv
?read.csv

#the option colClasses looks promising, so I'll look up some example code
#code source: https://stackoverflow.com/questions/2805357/specifying-colclasses-in-the-read-csv

#read in the csv and specify that the first column should be an integer while the others should be numeric
#read it in as a separate name (CO2_data_a) in case I mess anything up 
CO2_data_a <- read.csv('/Users/laurelbrigham/Documents/CU_Boulder/2018-2019/Spring Sem/Comp_Bio/CompBioLabsAndHW/Labs/Lab4/CO2_data_cut_paste.csv',
                       colClasses = c("integer", rep("numeric",7)))

#check that it worked
str(CO2_data_a)


#[2] 
#Use a for loop, iterating on the variables/columns of the data frame, to change each variable/column 
#(except the year) one by one

#make a new data frame so that if I mess anything up I don't have to reread in CO2_data
CO2_data_b <- CO2_data
#start at column 2 because we don't want to change Year
columns <- 2:8

#source for unlist code https://csgillespie.github.io/efficientR/dplyr.html
#unlist converts an object to a vector, which I can then use as.numeric on
for (i in columns) {
  CO2_data_b[i] <- as.numeric(unlist(CO2_data_b[i]))
}

#check that it worked
str(CO2_data_b) 


#can use unlist without a for loop as well
#make a new data frame so that if I mess anything up I don't have to reread in CO2_data
CO2_data_c <- CO2_data

#grab the columns you want to change, turn them into vectors, and then make them numeric
CO2_data_c[,2:ncol(CO2_data_c)] <- as.numeric(as.character(unlist(CO2_data_c[,2:ncol(CO2_data_c)])))

#check that it worked
str(CO2_data_c)


#I ran out of time to finish the rest of question 8, so I'll just leave things here
