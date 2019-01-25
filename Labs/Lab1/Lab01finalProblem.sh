#these commands assume that you have the file PredPreyData.csv in your directory
#first I will keep only columns 2-4 then pipe this to the grep command where I search for "time" because this is in the header and I only want to keep the header. Finally, I created a new file with this info
cut -f 2-4 -d , PredPreyData.csv| grep time > PredPrey_edit.csv
#now I want to keep the last 10 lines of those 2-4 columns and add it to the csv with the header I just created
cut -f 2-4 -d , PredPreyData.csv | tail >> PredPrey_edit.csv

