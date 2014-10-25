# Getting Cleaning Data Project #
# ============================= #
This project tries to achieve the following 5 goals using run_analysis.R script

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. In other words, create one dataset grouped by activity and subject with the mean for each variable calculated for each pair of activity and subject.

The data for the above is located at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## How To ##
1. Copy the script to the working directory (Refer `getwd()` and `setwd()`)
2. Also download the data set from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) to the working directory
3. At the R prompt (R Studio) execute command - source("./run_analysis.R") 
4. On executing one should see following messages on the screen. This is also indicative of the process flow of the script.

- [1] "Loading feature and activity labels"
- [1] "Loading Train data...."
- [1] "Loading Test data...."
- [1] "Merging Train and Test data...."
- [1] "Creating meanData and adding descriptive variables to column names"
- Writing dataset to meanData.txt file
