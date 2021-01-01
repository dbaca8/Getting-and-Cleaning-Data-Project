## Getting and Cleaning Data Project
## Week 4 Project

## 1. All steps performed on the source data for downloading, unzipping, and 
## cleaning the data are clearly explained in this code file: run_analysis.R 
library(dplyr)

## Directory commands
getwd()
setwd("~/Desktop") 

## Checking and Create Directory "data" if one does not exist
if(!file.exists("data")){
        dir.create("data")
}

## Download Dataset.zip from Web
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
filepath <- "./data/Dataset.zip"
download.file(fileUrl, destfile = filepath) 

## unzip Dataset.zip 
unzip(zipfile="./data/Dataset.zip", exdir="~/Desktop")

list.files("~/Desktop")
# [1] "UCI HAR Dataset"

## Record date of downloaded file
dateDownloaded <- date()
dateDownloaded
# [1] "Sat Dec 26 16:30:39 2020"

## Reading all Data Frames
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("number","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ActivitiesCode", "Activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "ActivitiesCode")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "ActivitiesCode")

features
activities
subject_test
x_test
y_test
subject_train
x_train
y_train

dim(features)
# [1] 561   2
dim(activities)
# [1] 6 2
dim(subject_test)
# [1] 2947    1
dim(x_test)
# [1] 2947  561
dim(y_test)
# [1] 2947    1
dim(x_train)
# [1] 7352  561
dim(y_train)
# [1] 7352    1

## 2. The features, activities, subjects, test and training sets are merged 
## to create one data set.

# Merge Data Frames
x_data <- rbind(x_test, x_train)
y_data <- rbind(y_test, y_train)
subject_data <- rbind(subject_test, subject_train)
merged_data <- cbind(subject_data, y_data, x_data)

x_data
y_data
subject_data
merged_data
dim(x_data)
# [1] 10299   561
dim(y_data)
# [1] 10299     1
dim(subject_data)
# [1] 10299     1
dim(merged_data)
# [1] 10299   563
str(merged_data)

## 3. Measurements containing the mean and standard deviation (std) were 
## extracted for each measurement, thereby reducing the dataset.

## Select first 2 columns and then Extract all Columns containing "Mean" and "STD"
tidy_data <- merged_data %>% select(Subject, ActivitiesCode, contains("mean"), contains("std"))
dim(tidy_data)
#[1] 10299    88
str(tidy_data)

## 4. Replaced Activities Code column of "integers" with column of descriptive 
## Activities Code Factor names.

## Replace ActivitiesCode column of "integers" with column of ActivitiesCode Factors
tidy_data$ActivitiesCode <- activities[tidy_data$ActivitiesCode, 2]
str(tidy_data)
colnames(tidy_data)

## 5. Adjusted column names and replaced with more descriptive and complete 
## variable names.

## Rename and substitute to adjust Column Names
colnames(tidy_data)[2] <- "Activity"
colnames(tidy_data) <- gsub("Acc", "Accelerometer", colnames(tidy_data))
colnames(tidy_data)<-gsub("Gyro", "Gyroscope", colnames(tidy_data))
colnames(tidy_data)<-gsub("BodyBody", "Body", colnames(tidy_data))
colnames(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
colnames(tidy_data)<-gsub("^t", "Time", colnames(tidy_data))
colnames(tidy_data)<-gsub("freq", "Frequency", colnames(tidy_data))
colnames(tidy_data)<-gsub("^f", "Frequency", colnames(tidy_data))
colnames(tidy_data)<-gsub("tBody", "TimeBody", colnames(tidy_data))
colnames(tidy_data)<-gsub("mean()", "Mean", colnames(tidy_data))
colnames(tidy_data)<-gsub("std()", "Std", colnames(tidy_data))
colnames(tidy_data)<-gsub("angle", "Angle", colnames(tidy_data))
colnames(tidy_data)<-gsub("gravity", "Gravity", colnames(tidy_data))
colnames(tidy_data)<-gsub("\\.", "", colnames(tidy_data))

colnames(tidy_data)
dim(tidy_data)
# [1] 10299    88
str(tidy_data)
tidy_data[,1:5]

## 6. Created new Table, Group, and Summarize All measurement columns by 
## average Mean value for each measurement by Subject and Activity.

## Create new Table, Group, and Summarize All by Mean value
TidyData <- tidy_data %>%
        group_by(Subject, Activity) %>%
        summarise_all(list(mean))

colnames(TidyData)
dim(TidyData)
# [1] 180  88
str(TidyData)
TidyData[,1:5]
TidyData[170:180,1:5]

## 7. A final data set called TidyData.txt is created with the mean average of 
## each variable for each Subject and each Activity.

## Write text file of TidyData
write.table(TidyData, "UCI HAR Dataset/TidyData.txt", row.name=FALSE)