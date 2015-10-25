## install packages and libraries 
install.packages("data.table")
install.packages("plyr")
library(data.table)
library("plyr")
library("dplyr")
##### PROCESS RAW DATA COMMON TO TEST AND TRAIN
subNameDF <- fread("/Users/cherrylkimmbrown/Documents/2015/Getting and Cleaning Data Coursera/Class Project/UCI HAR Dataset/features.txt")
actlabelDF <- fread("/Users/cherrylkimmbrown/Documents/2015/Getting and Cleaning Data Coursera/Class Project/UCI HAR Dataset/activity_labels.txt")

## Activity Labels common to train and test
actlblchgDF <- rename(actlabelDF, activitylabel = V2, activitycode = V1)

###### PROCESS RAW TEST DATA
## Read test subject DATA
#subject identifiers
testsubIDDF <- fread("/Users/cherrylkimmbrown/Documents/2015/Getting and Cleaning Data Coursera/Class Project/UCI HAR Dataset/test/subject_test.txt")
#subject variables
testsubvarDF <- fread("/Users/cherrylkimmbrown/Documents/2015/Getting and Cleaning Data Coursera/Class Project/UCI HAR Dataset/test/x_test.txt")
#activity codes
testactcodeDF <- fread("/Users/cherrylkimmbrown/Documents/2015/Getting and Cleaning Data Coursera/Class Project/UCI HAR Dataset/test/y_test.txt")

## Rename variables in dataframes before join
testsubnmchgDF <- rename(testsubIDDF, subjectid = V1)
testactnmchgDF <- rename(testactcodeDF, activitycode = V1)

# Bind All Test Category Variables
testcatDF <- cbind(testsubnmchgDF, testactnmchgDF)


##### PROCESS RAW TRAIN DATA
# Read train subject data
#subject identifers
trainsubIDDF <- fread("/Users/cherrylkimmbrown/Documents/2015/Getting and Cleaning Data Coursera/Class Project/UCI HAR Dataset/train/subject_train.txt")
#subject variables
trainsubvarDF <- fread("/Users/cherrylkimmbrown/Documents/2015/Getting and Cleaning Data Coursera/Class Project/UCI HAR Dataset/train/x_train.txt")
#activity codes
trainactcodeDF <- fread("/Users/cherrylkimmbrown/Documents/2015/Getting and Cleaning Data Coursera/Class Project/UCI HAR Dataset/train/y_train.txt")

## Rename variables in dataframes before join
trainsubnmchgDF <- rename(trainsubIDDF, subjectid = V1)
trainactnmchgDF <- rename(trainactcodeDF, activitycode = V1)

# Bind All Train Category Variables
traincatDF <- cbind(trainsubnmchgDF, trainactnmchgDF)


##COMBINE TRAIN AND TEST CATEGORY DATA
testtraincatDF <- rbind(testcatDF,traincatDF)

##JOIN ACTIVITY LABELS
allcatDF <- join(actlblchgDF, testtraincatDF, by = "activitycode", type = "right")


## COMBINE TRAIN AND TEST VARIABLES
allvarsDF <- rbind(testsubvarDF,trainsubvarDF )

## SELECT MEAN AND STD FROM FEATURE DATA
#search for mean and std strings
allsubNameCHV <- as.character(subNameDF$V2)
meancols <- grep("mean",allsubNameCHV)
capmeancols <- grep("Mean",allsubNameCHV)
stdcols <- grep("std", allsubNameCHV)


allmeanstdDT <- subset(subNameDF, subNameDF$V1 %in% meancols | subNameDF$V1 %in% stdcols)
allmeanstdDT$V2 <- gsub("BodyBody","Body",allmeanstdDT$V2)
allmeanstdDT$V2 <- gsub("tBodyAcc","timebodyaccelerometer",allmeanstdDT$V2) 
allmeanstdDT$V2 <- gsub("fBodyAcc","frequencybodyaccelerometer",allmeanstdDT$V2)
allmeanstdDT$V2 <- gsub("tBodyGyro","timebodygyroscope",allmeanstdDT$V2) 
allmeanstdDT$V2 <- gsub("fBodyGyro","frequencybodygyroscope",allmeanstdDT$V2)
allmeanstdDT$V2 <- gsub("tGravityAcc","timebodygravityacc",allmeanstdDT$V2)
allmeanstdDT$V2 <- gsub("fGravityAcc","frequencybodygravityaccelerometer",allmeanstdDT$V2)
allmeanstdDT$V2 <- gsub("-mean()-X","meanx",allmeanstdDT$V2, fixed=TRUE)
allmeanstdDT$V2 <- gsub("-std()-X","stdx",allmeanstdDT$V2, fixed=TRUE)
allmeanstdDT$V2 <- gsub("-mean()-Y","meany",allmeanstdDT$V2, fixed=TRUE)
allmeanstdDT$V2 <- gsub("-std()-Y","stdy",allmeanstdDT$V2, fixed=TRUE)
allmeanstdDT$V2 <- gsub("-mean()-Z","meanz",allmeanstdDT$V2, fixed=TRUE)
allmeanstdDT$V2 <- gsub("-std()-Z","stdz",allmeanstdDT$V2, fixed=TRUE)
allmeanstdDT$V2 <- gsub("-meanFreq()","meanfreq",allmeanstdDT$V2, fixed=TRUE)
allmeanstdDT$V2 <- gsub("-mean()","mean",allmeanstdDT$V2, fixed=TRUE)
allmeanstdDT$V2 <- gsub("-std()","std",allmeanstdDT$V2, fixed=TRUE)
allmeanstdDT$V2 <- gsub("Jerk","jerk",allmeanstdDT$V2, fixed=TRUE)
allmeanstdDT$V2 <- gsub("Mag","mag",allmeanstdDT$V2, fixed=TRUE)


# Create empty data frame and list for adding relevant means and std columns
alltidysetDT=data.frame(matrix(NA, nrow=10299, ncol=0))
allnextcol <- list()

i <- 1
while (i <= nrow(allmeanstdDT))  {
  allnextcol <- select(allvarsDF, allmeanstdDT$V1[i])
  alltidysetDT <- cbind(alltidysetDT,allnextcol)
  colnames(alltidysetDT)[i] <- allmeanstdDT$V2[i] 
  ## print(allmeanstdDT$V1[i])
  i <- i + 1
  rm(allnextcol)
}

### Add category data to alltidysetDT

outputDF <- cbind(allcatDF,alltidysetDT)
outputDF$activitycode <- NULL
finalsetDF <- ddply(outputDF,.(activitylabel, subjectid), numcolwise(mean))
write.table(finalsetDF, file = "/Users/cherrylkimmbrown/Documents/2015/Getting and Cleaning Data Coursera/Class Project/gacd_project.txt", row.name=FALSE, sep=",",na="NA")

