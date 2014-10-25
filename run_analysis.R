library(reshape2)
# setwd("C:/Coursera/Course3-DataCleaning")
## Load data from the source
datalocation <- "./UCIHARDataset"

## Load features/Columns
cols <- read.table(paste(datalocation,"/features.txt", sep=""), sep="", stringsAsFactors=FALSE)[,2]

#Load activityLabels
activityLabels <- read.table(paste(datalocation,"/activity_labels.txt", sep = ""), sep="", stringsAsFactors=FALSE)
names(activityLabels) <- c("Activity","ActivityDesc")

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

#Average of each variable for each activity and each subject
meltData <- melt(newData,id.vars=c("ActivityDesc","Subject"),
                 measure.vars=names(newData[,4:89]))
meanData <- dcast(meltData, ActivityDesc + Subject ~ variable,mean)

#Create description variable names
names(meanData) <- sub("()","",names(meanData))
names(meanData) <- sub(",","_",names(meanData),fixed=TRUE) 
names(meanData) <- sub("(","",names(meanData),fixed=TRUE) 
names(meanData) <- sub(")-","",names(meanData),fixed=TRUE)
names(meanData) <- sub(")","",names(meanData),fixed=TRUE) 


write.table(meanData,file="meanData.txt",row.names=FALSE)
