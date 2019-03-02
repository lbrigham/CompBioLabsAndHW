# This is my work for lab 7. 1 March 19.

#1. Write a function named triangleArea that calculates and returns the area of a 
# triangle when given two arguments (base and height).

triangleArea <- function(b, h) {
  #the base (b) and height (h) must be given
  # multiply the base (b) and height (h) by 0.5 per the formula 
  mult <- b * h * 0.5
  return(mult)
}

# Demonstrate that it works:
# Given a triangle of base = 1 and height = 1, we expect an area of 0.5
triangleArea(1,1)
triangleArea(10,10)
triangleArea(20,30)


# 2. Write a function named myAbs() that calculates and returns absolute values

myAbs <- function(x) {
  #the number (or vector of numbers) must be given
  #in the case that the input is a vector, create an empty vector that is input length
  abs_vec <- rep(0,length(x))
  #if the number is positive or zero, add the original value to the created vector
  #if the number is negative, take the negative of that value and add to the created vector
  for (i in 1:length(x)) {
    if (x[i] >= 0) {
      abs_vec[i] <- x[i]
    } else {
      abs_vec[i] <- -x[i]
    }
  }
return(abs_vec)
}


# Demonstrate that it works using:
#the number 5
myAbs(5)

#the number -2.3
myAbs(-2.3)

#the vector c(1.1, 2, 0, -4.3, 9, -12)
myAbs(c(1.1, 2, 0, -4.3, 9, -12))


#3. Write a function that returns a vector of the first n Fibonacci numbers,
#where n is any integer >= 3. Your function should take two arguments: the user's desired value of n and the user's 
#desired starting number (either 0 or 1 as explained in the quote above).

Fib <- function(n,y) {
  # the desired output length (n) and the starting value (y) must be given
  # the output length must be greater than or equal to 3
  if (n < 3) {
    return("Error: n must be >= 3")
    #if the correct output length is given, the function can continue
    # make a vector to store the Fibonacci sequences
    # start the vector at 1 because the first part of the fxn will consider if y is 1
    # make the vector the length of desired output
  } else {
    Fibonacci <- rep(1,n)
    #start the for loop at 3 because the first two values will be 1 per the Fibonacci when starting at 1
    for (i in 3:n) {
      Fibonacci[i] <- Fibonacci[i - 1] + Fibonacci[i - 2]
    }
    #if the user's desired start was 1 then return the vector of Fibonacci seq. 
    if (y == 1) {
      return(Fibonacci)
     #if the user's desired start was 0, then append a 0 to the front of the output vector and remove the last value
     # this way the output will be of the right length
    } else {
      if (y == 0) {
        Fibonacci_0 <- c(0, Fibonacci[1:n])
        return(Fibonacci_0[-(n + 1)])
      #if a starting value other than 0 or 1 was used, return an error message
      } else {
        return("Error: starting value must be 0 or 1")
      }
    }
  }
} 



# Demonstrate that it works
#this should return an error message regarding length
Fib(2,0)
#this should return an error message regarding start value
Fib(5,3)
Fib(5,0)
Fib(5,1)
Fib(10,0)
Fib(10,1)



# 4.
#Part a
#write a function that takes two numbers as its arguments and returns the square
# of the difference between them. 

sqr_LB <- function(x,r) {
  #needs two numbers as arguments
  #subtract the two numbers and take the square of the difference
  sub_sqr <- (x - r)^2
  return(sub_sqr)
}

# Demonstrate that it works
sqr_LB(3,5) 
sqr_LB(c(2, 4, 6),4)


#Part b
#Write a function that calculates the average of a vector of numbers. 

mean_LB <- function(x) {
  #requires a vector of numbers x
  #sum all numbers in the vector and divide by the number of values given to find the mean
  sum(x)/length(x)
}

# Demonstrate that it works
mean_LB(c(5, 15, 10))

#Read in data to test the mean function
# see for data: https://github.com/flaxmans/CompBio_on_git/blob/master/Labs/Lab07/DataForLab07.csv

Lab7_Data <- read.csv('/Users/laurelbrigham/Documents/CU_Boulder/2018-2019/Spring Sem/Comp_Bio/CompBioLabsAndHW/Labs/Lab7/DataForLab07.csv')
mean_LB(Lab7_Data$x)

#part c
#Write a function that calculates and returns the sum of squares as defined here. Use the previous two functions you defined. 
# see for sum of squares explanation and equation: https://en.wikipedia.org/wiki/Total_sum_of_squares

sum_sqr <- function(x) {
  #must be given a vector of numbers x
  #create a vector to store the sum of squares
  #make the vector the same length as the input vector
  sum_sqr_vec <- rep(0,length(x))
  #subtract each number in the vector from the mean and then square that difference
  for (i in 1:length(x)) {
    sum_sqr_vec[i] <- sqr_LB(x[i],mean_LB(x))
  }
  #sum all of the squared differences
  sum(sum_sqr_vec)
}

# Demonstrate that it works
sum_sqr(Lab7_Data$x)


