#This script contains my Lab 8 assignment. 8 Mar 19. 

# 3
# part a
# Paste the code from Lab 4 that implemented the discrete-time logistic growth model

############################
######Start Code from Lab 4 #######
############################
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


#7. Redo question 4 from part I above, but now store all the data.
#Make two vectors, one called "time" that stores the time steps (1 to 12),
#and one called "abundance" that stores the data on population abundances predicted 
#from the discrete-time logistic equation. Then, make a plot of the results (i.e., plot(time, abundance))

#make a vector to store the time steps we're interested in
time <- 1:12
#I already made a vector that stores the data on population abundances of question 4 that I called abundance

#make a plot of abundance over time
plot(time, abundance)

############################
######End Code from Lab 4 #######
############################


# part b
#Turn the logistic growth model code into a function that takes r (the intrinsic growth rate), 
#K (the carrying capacity), the total number of generations, and the initial population size as its arguments.

logit_grow <- function(r, K, g, n) {
  # the intrinsic growth rate, carrying capacity, number of generations, and initial population size
  # must be given
  # create a vector containing 1 through the number of generations so that this info can be returned later
  generations <- 1:g
  # create a vector to store abundances that is as long as the number of generations
  abundance <- rep(0, g)
  # set the first value of the vector to be that of the initial population size
  abundance[1] <- n
  # write a for loop that populates the abundance vector 
  for (t in 2:g) {
    abundance[t] <- abundance[t - 1] + (r * abundance[t - 1] * (K - abundance[t - 1])/K )
  }
  # bind the time and abundance vectors to return a single object
  time_pop <- cbind(generations, abundance)
return(time_pop)
}


#Demonstrate that the function works
logit_grow(r = 0.8, K = 10000, g = 12, n = 2500)


# part c
# Add code to the function so that it produces a plot of the data it generates 
# (i.e., it should plot abundance over time). Note that the axes should be labeled appropriately.

logit_grow_plot <- function(r, K, g, n) {
  # the intrinsic growth rate, carrying capacity, number of generations, and initial population size
  # must be given
  # create a vector containing 1 through the number of generations so that this info can be returned later
  generations <- 1:g
  # create a vector to store abundances that is as long as the number of generations
  abundance <- rep(0, g)
  # set the first value of the vector to be that of the initial population size
  abundance[1] <- n
  # write a for loop that populates the abundance vector 
  for (t in 2:g) {
    abundance[t] <- abundance[t - 1] + (r * abundance[t - 1] * (K - abundance[t - 1])/K )
  }
  # plot the abundance over time
  plot(x = generations,y = abundance, type = "p", pch = 21, xlab = "Number of Generations", ylab = "Population Size")
  # bind the time and abundance vectors to return a single object
  time_pop <- cbind(generations, abundance)
  return(time_pop)
}

# part d
# Demonstrate that the function works
logit_grow_plot(r = 0.8, K = 10000, g = 12, n = 2500)

# part e
# Write a line(s) of code that writes the data set to a file (also in your Lab08 directory). 
# The data file should have two columns: the first column should be "generations",
# and the second column should be "abundance".

#first, assign the output to an object easily input to the write.csv function
output_logit_grow <- logit_grow(r = 0.8, K = 10000, g = 12, n = 2500)
write.csv(x = output_logit_grow, file = "Abundance_Gen.csv", row.names = F)

