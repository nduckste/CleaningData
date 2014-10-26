library(reshape2)
# setwd("C:/Coursera/Course3-DataCleaning")
## Load data from the source
datalocation <- "./UCI HAR Dataset"

print("Loading feature and activity labels")

## Load features/Columns
cols <- read.table(paste(datalocation,"/features.txt", sep=""), sep="", stringsAsFactors=FALSE)[,2]

#Load activityLabels
activityLabels <- read.table(paste(datalocation,"/activity_labels.txt", sep = ""), sep="", stringsAsFactors=FALSE)
names(activityLabels) <- c("Activity","ActivityDesc")

print("Loading Train data....")
## Load Train data
xtrain <- read.table(paste(datalocation,"/train/X_train.txt", sep = ""), sep="", stringsAsFactors=FALSE)
xtrainsub <- read.table(paste(datalocation,"/train/subject_train.txt", sep = ""), sep="", stringsAsFactors=FALSE)
ytrain <- read.table(paste(datalocation,"/train/y_train.txt", sep = ""), sep="", stringsAsFactors=FALSE)

## Replace xtrain data's columns with columns loaded into cols varaiable
names(xtrain) <- cols

## Replace xtrainsub data's column name as Subject
names(xtrainsub) <- c("Subject")

## Replace ytrain data's column name as Activity
names(ytrain) <- c("Activity")

#remove all columns except those that have "mean" or "std" in them
xtrain <- xtrain[,c(grep("mean|std",tolower(cols)))]

#Merge Train data
newTrainData <- cbind(xtrainsub,ytrain,xtrain)

print("Loading Test data....")
## Load Test data
xtest <- read.table(paste(datalocation,"/test/X_test.txt", sep = ""), sep="", stringsAsFactors=FALSE)
xtestsub <- read.table(paste(datalocation,"/test/subject_test.txt", sep = ""), sep="", stringsAsFactors=FALSE)
ytest <- read.table(paste(datalocation,"/test/y_test.txt", sep = ""), sep="", stringsAsFactors=FALSE)

## Replace xtrain data's columns with columns loaded into cols varaiable
names(xtest) <- cols

#remove all columns except those that have "mean" or "std" in them
xtest <- xtest[,c(grep("mean|std",tolower(cols)))]

## Replace xtestsub data's column name as Subject
names(xtestsub) <- c("Subject")

## Replace ytest data's column name as Activity
names(ytest) <- c("Activity")

print("Merging Train and Test data....")
##Merge Test data
newTestData <- cbind(xtestsub,ytest,xtest)

##Merged Train and Test Data
# subTestData <- newTestData[,c(grep("mean|std",tolower(names(newTestData))))]
# subTrainData <- newTestData[,c(grep("mean|std",tolower(names(newTrainData))))]
# newData <- rbind(subTestData,subTrainData)
newData <- rbind(newTestData,newTrainData)

#Add ActivityDesc by merging newData with activityLabels.
newData <- merge(activityLabels,newData,by.x="Activity",by.y="Activity",all=TRUE)

#check that no fields have NA values:
if (all(colSums(is.na(newData))==0) == FALSE) {
  errmsg <- "Some columns have NA values.\n"
  stop(errmsg)
}

print("Creating meanData and adding descriptive variables to column names")

#Average of each variable for each activity and each subject
meltData <- melt(newData,id.vars=c("ActivityDesc","Subject"),
                 measure.vars=names(newData[,4:89]))
meanData <- dcast(meltData, ActivityDesc + Subject ~ variable,mean)

#Create description variable names
names(meanData) <- tolower(names(meanData))
names(meanData) <- gsub("freq","",names(meanData))
names(meanData) <- gsub("anglet","angletime",names(meanData))
names(meanData) <- gsub("bodybody","body",names(meanData))
names(meanData) <- gsub("mag","magnitude",names(meanData))
names(meanData) <- gsub("acc","acceleration",names(meanData))
names(meanData) <- gsub("()","",names(meanData))
names(meanData) <- gsub(",","-",names(meanData),fixed=TRUE) 
names(meanData) <- gsub("(","",names(meanData),fixed=TRUE) 
names(meanData) <- gsub(")-","",names(meanData),fixed=TRUE)
names(meanData) <- gsub(")","",names(meanData),fixed=TRUE) 

#split names(meanData) at "." -- there aren't any.
#just need a list
splitNames <- strsplit(names(meanData),"\\.")

#create a function to replace
#   the beginning "t" with "time" for variables that begin with "t"
#   the beginning "f" with "frequency" for variables that begin with "f"

replacePrefix <- function(x) {
  if (grepl("^t",x)==TRUE) {
    x <- sub("t","time",x,fixed=TRUE)
  }
  else if (grepl("^f",x)==TRUE) {
    x <- sub("f","frequency",x,fixed=TRUE)
  }
  else {
    x <- x
  }
}
names(meanData) <- sapply(splitNames,replacePrefix)

print("Writing dataset to meanData.txt file")
write.table(meanData,file="meanData.txt",row.names=FALSE)

#print out names of variables for code book.
# write.table(names(meanData),file="",row.names=FALSE)
