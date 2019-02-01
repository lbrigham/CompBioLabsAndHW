#Brigham
#1 Feb 19
#lab assignment 3


#lab step #3: make variables for my guest and chip values

chips <- 5
guests <- 8

#lab step #5: each of your guests will eat an average of 0.4 bags of chips. Store this quantity in a new variable

consume <- 0.4 

#lab step #7: Use these three variables to calculate the expected amount of leftover chips. 
#In addition to the 8 guests, assume that you will also consume 0.4 bags of chips yourself.

leftover <- (chips - ((guests + 1) * consume)) 


#lab step #8: Make 5 vectors, one for each person, containing his/her rankings in the order given here.
Self <- c(7,6,5,1,2,3,4)
Penny <- c(5,7,6,3,1,2,4)             
Jenny <- c(4,3,2,7,6,5,1)
Lenny <- c(1,7,3,4,6,5,2)
Stewie <- c(6,7,5,4,3,1,2)

#lab step #9: access Penny’s and Lenny's ranking for Episode IV, and store it in a new variable
PennyIV <- Penny[4]
LennyIV <- Lenny[4]

#lab step #10: Concatenate all 5 sets of rankings into a single data object.
all_ratings <- cbind(Self,Penny,Jenny,Lenny,Stewie)

#lab step #11: look at tge structure of the 3 following data sets
str(Penny)
str(PennyIV)
str(all_ratings)
#differences:
#PennyIV represents one value (Penny's ranking for Episode IV)
#while Penny is her rankings for all of the movies 
#all_ratings represents the ratings of myself and my guests for all movies


#lab step #12: make a dataframe (two ways) with all_ratings
all_ratings_df <- data.frame(all_ratings)
all_ratings_asdf <- as.data.frame(all_ratings)

#lab step #13: describe the similarities and differences between all_ratings
# and all_ratings_asdf

#look at the dimensions (rows, columns)
dim(all_ratings_asdf)
dim(all_ratings)
#same for each

#structure
str(all_ratings)
#it's a vector
str(all_ratings_asdf)
#it's a dataframe
#the names are now column headers instead of characters
#the ratings are still numbers

#same values in those rows/columns? 
all_ratings==all_ratings_asdf
#have all of the same values

#similarities: 
#same number of rows/columns and the same values withing those rows/columns
#the ratings are treated as numbers

#differences:
#all_ratings is a vector while all_ratings_asdf is a dataframe
#in all_ratings_asdf, the names are now column heads instead of characters
#the ratings are variables in the dataframe

#lab step #14: Make a vector of the Episode names as Roman numerals
episodes <- c("I","II","III","IV","V","VI","VII")

#lab step #15: add episode rownames to all_ratings and all_ratings_asdf
row.names(all_ratings) <- episodes
row.names(all_ratings_asdf) <- episodes

#lab step #16: Access the third row of the matrix all_ratings
all_ratings[3,]

#lab step #17: Access the fourth column from the data frame all_ratings_asdf
all_ratings_asdf[,4]

#lab step #18: Access my ranking for Episode V
all_ratings_asdf[5,1]

#lab step #19: Access Penny’s ranking for Episode II.
all_ratings_asdf[2,2]

#lab step 20: Access everyone’s rankings for episodes IV – VI
all_ratings_asdf[c(4:6),]

#lab step 21:Access everyone’s rankings for episodes II, V, and VII.
all_ratings_asdf[c(2,5,7),]

#lab step 22: Access rankings for just Penny, Jenny, and Stewie for just episodes IV and VI.
all_ratings_asdf[c(4,6),c(2,3,5)]

#lab step 23: switch Lenny’s rankings for Episodes II and V in all_ratings_asdf
ep2_Lenny <- all_ratings_asdf[2,4]
ep5_Lenny <- all_ratings_asdf[5,4]
all_ratings_asdf[5,4] <- ep2_Lenny
all_ratings_asdf[2,4] <- ep5_Lenny

#lab step 24: use col/row names instead of numbers (allRankings[“III”, “Penny”]) on all_ratings and all_ratings_asdf
all_ratings["III", "Penny"]
all_ratings_asdf["III", "Penny"]

#lab step 25:Use this method (names rather than indexes) to undo the switch made in step 23
new_ep2_Lenny <- all_ratings_asdf["II","Lenny"]
new_ep5_Lenny <- all_ratings_asdf["V","Lenny"]
all_ratings_asdf["V","Lenny"] <- new_ep2_Lenny
all_ratings_asdf["II","Lenny"] <- new_ep5_Lenny


#lab step 26: Use this the $ to re-do the switch from step 23
dollar_ep2_Lenny <- all_ratings_asdf$Lenny[2]
dollar_ep5_Lenny <- all_ratings_asdf$Lenny[5]
all_ratings_asdf$Lenny[5] <- dollar_ep2_Lenny
all_ratings_asdf$Lenny[2] <- dollar_ep5_Lenny


