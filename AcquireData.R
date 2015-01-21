
## This script is submitted for Coursera Data Science Course 3, Getting and Cleaning Data
## The script performs the following activities:
## Extracts data from the .zip source file into a directory in the working directory
## Creates separate df's for each relevant table in order to more properly compartmenalize the code
## Separatesthe the process into training and test where applicable and then performs following steps:
## Step 1 - Normalizes the the two data sets as follows:
##     1.a  Assigns names to the columns
##     1.b  Combines activity IDs (the "y_" files) with each data df (the "X_" files)
##     1.c  Creates a variable with Activity Names based on the  AcivityID code via merge
##     1.d  Merges activity names into the data df's
##     1.e  Merges subject id from one data file with the measured variaables 
##     1.f  Removes columns that are not either mean or std values
##     1.g  Merges the training and test data sets
##     1.h  Aggregates the values by activity and subject
##     1.i  Generates a tidy data set by normalizing the variable names




library(plyr)
library(dplyr)
library(reshape)
library(tidyr)
library(gdata)

require(plyr)
require(dplyr)
require(reshape)
require(tidyr)
require(gdata)

#rm(list=ls())
#getwd()
## PROVIDE THE WORKING DIRECTORY PATH for the SOURCE ZIP FILE INSIDE THE DOUBLE QUOTES 
## and UNCOMMENT THE CODE BEFORE RUNNING THIS CODE
#  setwd("<<INPUT WD HERE>>")


## Unzip Files from local drive
unzip("getdata-projectfiles-UCI HAR Dataset.zip")


##  read data into R


headerNAMES <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=F)  # table with header names

activityNAMES <- read.table("UCI HAR Dataset/activity_labels.txt")  # table with activity names

dataFileTRAIN <- read.table("UCI HAR Dataset/train/X_train.txt")  # table with training data


dataFileTEST <- read.table("UCI HAR Dataset/test/X_test.txt")     # table with test data

dataFileTRAINactivities <- read.table("UCI HAR Dataset/train/y_train.txt")     # table with training activity id's

dataFileTESTactivities <- read.table("UCI HAR Dataset/test/y_test.txt")     # table with test activity id's

dataFileTRAINsubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")     # table with training subject codes
names(dataFileTRAINsubjects)[1] <- "Subject"  # renanme col v1 with user friendly name for subjects.

dataFileTESTsubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")     # table with test subject codes
names(dataFileTESTsubjects)[1] <- "Subject"  # renanme col v1 with user friendly name for subjects.


##  create vector, properly ordered for use as  col names
listNAME <- as.character(headerNAMES[[2]])
#str(listNAME)

##  name columnns in both df's
colnames(dataFileTRAIN) <- listNAME
colnames(dataFileTEST) <- listNAME



## combine subject ID's with data in both df's and rename ActivityID variable
dataFileTEST <- cbind(dataFileTESTactivities, dataFileTEST)  # combine activity ID with data
names(dataFileTEST)[1] <- "ActivityID"  # renanme activity ID with user friendly name


dataFileTRAIN <- cbind(dataFileTRAINactivities, dataFileTRAIN)  # combine activity ID with data
names(dataFileTRAIN)[1] <- "ActivityID"  # renanme activity ID with user friendly name



## merge activity names with data df's

dataFileTEST <- data.frame(dataFileTEST, "activityName"=activityNAMES[match(dataFileTEST$ActivityID, activityNAMES$V1), 2], check.names=FALSE)

dataFileTRAIN <- data.frame(dataFileTRAIN, "activityName"=activityNAMES[match(dataFileTRAIN$ActivityID, activityNAMES$V1), 2], check.names=FALSE)




#merge subject id with data df and subset only columns that contain stand dev or mean values

dataFileTEST.obs <- cbind(dataFileTESTsubjects, dataFileTEST)

dataFileTEST.obs <- dataFileTEST.obs[, c("Subject", "ActivityID", 'activityName', 
                             grep("mean", names(dataFileTEST.obs), value=T, ignore.case=T),
                             grep("std", names(dataFileTEST.obs), value=T, ignore.case=T))]




dataFileTRAIN.obs <- cbind(dataFileTRAINsubjects, dataFileTRAIN)

dataFileTRAIN.obs <- dataFileTRAIN.obs[, c("Subject", "ActivityID", 'activityName', 
                              grep("mean", names(dataFileTRAIN.obs), value=T, ignore.case=T),
                              grep("std", names(dataFileTRAIN.obs), value=T, ignore.case=T))]



# Merge Training and Test final data sets

dataFileCOMBINED <- rbind(dataFileTEST.obs, dataFileTRAIN.obs)


# Remove Activity ID...not needed in final result
dataFileCOMBINED$ActivityID <- NULL


# Convert subjects to factors...required to perform aggregation
dataFileCOMBINED$Subject <- as.factor(dataFileCOMBINED$Subject)



## Calculate the MEAN values for all measured variables in aggregate by activity and subject

len.datafile <- length(dataFileCOMBINED)
dataFileCOMBINED.MEAN.prelim <- aggregate(dataFileCOMBINED[ , 3:len.datafile], 
                     by = dataFileCOMBINED[c("Subject", "activityName")], FUN=mean)



## Perform data tidy operation, renaming variables
## Elimnate "()", replace "(" and ")" with spaces,
##  replace "-" and "," with spaces,

dataFileCOMBINED.MEAN <- dataFileCOMBINED.MEAN.prelim


## Perform data tidy operation, renaming variables as per proven practices
## NOTE:  Some code sections has to be performed twice for the code to cleanse the data....don't know why


names(dataFileCOMBINED.MEAN) <- sub("\\-"," ",names(dataFileCOMBINED.MEAN),)  # hypen replace with space
names(dataFileCOMBINED.MEAN) <- sub("\\-"," ",names(dataFileCOMBINED.MEAN),)  # hypen replace with space
names(dataFileCOMBINED.MEAN) <- sub("\\,"," ",names(dataFileCOMBINED.MEAN),)  # comma replace with space
names(dataFileCOMBINED.MEAN) <- sub("\\()","",names(dataFileCOMBINED.MEAN),)  # double paren replace with blank
names(dataFileCOMBINED.MEAN) <- sub("\\("," ",names(dataFileCOMBINED.MEAN),)  # open paren replace with blank
names(dataFileCOMBINED.MEAN) <- sub("\\)"," ",names(dataFileCOMBINED.MEAN),)  # close paren replace with blank
names(dataFileCOMBINED.MEAN) <- sub("\\)"," ",names(dataFileCOMBINED.MEAN),)  # close paren replace with blank
names(dataFileCOMBINED.MEAN) <- sub("^f","f.",names(dataFileCOMBINED.MEAN),)  # f leading replace with f.
names(dataFileCOMBINED.MEAN) <- sub("^t","t.",names(dataFileCOMBINED.MEAN),)  # t leading replace with t.

# Trim trailing and leading spaces
names(dataFileCOMBINED.MEAN) <- trim(names(dataFileCOMBINED.MEAN))

#Final Output
dataFileCOMBINED.MEAN


