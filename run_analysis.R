library(dplyr)

## Load the subject IDs
sID_train <- read.table ("subject_train.txt")
sID_test <- read.table ("subject_test.txt")
subjID <- rbind(sID_train, sID_test)
subjID <- rename (subjID, subjID = V1)

## load the data sets
data_train <- read.table("X_train.txt")
data_test <- read.table("X_test.txt")

## load the activity labels for the data sets
actlabel_train <- read.table("y_train.txt")
actlabel_test <- read.table("y_test.txt")
activityID <- rbind(actlabel_train, actlabel_test)
activityID <- rename (activityID, activityID = V1)

## Merge the data values
rawdata <- rbind(data_train, data_test)

## Create a column vector for indicating which observations belong to training data set and which to test dataset
dataset <- rep(c("Training","Test"), c(dim(data_train)[1], dim(data_test)[1]))

## Merge with activity ID
rawdata <- cbind(activityID, rawdata)

## Merge with Subject ID 
rawdata <- cbind(subjID, rawdata)

## Merge with Data Set Type 
rawdata <- cbind(dataset, rawdata)

## Load feature information
feature <- read.table("features.txt")

## Extracting the mean and standard deviation for all measurements
data <- select(rawdata, dataset, subjID, activityID, V1, V2, V3, V4, V5, V6, V41
               , V42, V43, V44, V45, V46, V81, V82, V83, V84, V85, V86, V121, 
               V122, V123, V124, V125, V126, V161, V162, V163, V164, V165, V166,
               V201, V202, V214, V215, V227, V228, V240, V241, V253, V254, V266,
               V267, V268, V269, V270, V271, V345, V346, V347, V348, V349, V350, 
               V424, V425, V426, V427, V428, V429, V503, V504, V516, V517, V529, 
               V530, V542, V543 )

## Rename activity labels
data$activityID <- as.numeric(as.character(data$activityID))
data$subjID <- as.numeric(as.character(data$subjID))
data$dataset <- as.character(data$dataset)

data$activityID[data$activityID == 1] <- "Walking"
data$activityID[data$activityID == 2] <- "WalkingUpStairs"
data$activityID[data$activityID == 3] <- "WalkingDownStairs"
data$activityID[data$activityID == 4] <- "Sitting"
data$activityID[data$activityID == 5] <- "Standing"
data$activityID[data$activityID == 6] <- "Laying"

## Rename Variable names 
data <- rename (data, tBodyAccX_mean = V1, tBodyAccY_mean = V2, tBodyAccZ_mean = V3,
             tBodyAccX_sd = V4, tBodyAccY_sd = V5, tBodyAccZ_sd = V6, 
             tGravityAccX_mean = V41, tGravityAccY_mean = V42, 
             tGravityAccZ_mean = V43, tGravityAccX_sd = V44, 
             tGravityAccY_sd = V45, tGravityAccZ_sd = V46, 
             tBodyAccJerkX_mean = V81, tBodyAccJerkY_mean = V82, 
             tBodyAccJerkZ_mean = V83, tBodyAccJerkX_sd = V84, 
             tBodyAccJerkY_sd = V85, tBodyAccJerkZ_sd = V86, 
             tBodyGyroX_mean = V121, tBodyGyroY_mean = V122, 
             tBodyGyroZ_mean = V123, tBodyGyroX_sd = V124, tBodyGyroY_sd = V125,
             tBodyGyroZ_sd = V126, tBodyGyroJerkX_mean = V161, 
             tBodyGyroJerkY_mean = V162, tBodyGyroJerkZ_mean = V163, 
             tBodyGyroJerkX_sd = V164, tBodyGyroJerkY_sd = V165,
             tBodyGyroJerkZ_sd = V166, tBodyAccMag_mean = V201, 
             tBodyAccMag_sd = V202, tGravityAccMag_mean = V214, 
             tGravityAccMag_sd = V215, tBodyAccJerkMag_mean = V227, 
             tBodyAccJerkMag_sd = V228, tBodyGyroMag_mean = V240, 
             tBodyGyroMag_sd = V241, tBodyGyroJerkMag_mean = V253, 
             tBodyGyroJerkMag_sd = V254, fBodyAccX_mean = V266, 
             fBodyAccY_mean = V267, fBodyAccZ_mean = V268,
             fBodyAccX_sd = V269, fBodyAccY_sd = V270, fBodyAccZ_sd = V271, 
             fBodyAccJerkX_mean = V345, fBodyAccJerkY_mean = V346, 
             fBodyAccJerkZ_mean = V347, fBodyAccJerkX_sd = V348, 
             fBodyAccJerkY_sd = V349, fBodyAccJerkZ_sd = V350, 
             fBodyGyroX_mean = V424, fBodyGyroY_mean = V425, 
             fBodyGyroZ_mean = V426, fBodyGyroX_sd = V427, fBodyGyroY_sd = V428,
             fBodyGyroZ_sd = V429, fBodyAccMag_mean = V503, 
             fBodyAccMag_sd = V504, fBodyAccJerkMag_mean = V516, 
             fBodyAccJerkMag_sd = V517, fBodyGyroMag_mean = V529, 
             fBodyGyroMag_sd = V530, fBodyGyroJerkMag_mean = V542, 
             fBodyGyroJerkMag_sd = V543 )

## Step 05 - Making new dataset of averages --
subjectID <- rep(1:30, each= 6)
activityID <- rep (1:6, 30)

newdata <- data.frame(matrix(ncol = 68, nrow=180))
newdata$X1 <- subjectID
newdata$X2 <- activityID

newdata$X2[newdata$X2 == 1] <- "Walking"
newdata$X2[newdata$X2 == 2] <- "WalkingUpStairs"
newdata$X2[newdata$X2 == 3] <- "WalkingDownStairs"
newdata$X2[newdata$X2 == 4] <- "Sitting"
newdata$X2[newdata$X2 == 5] <- "Standing"
newdata$X2[newdata$X2 == 6] <- "Laying"

newdata <- rename(newdata, subjID = X1)
newdata <- rename(newdata, activityID = X2)


## a. Calculating averages and populating the new dataset with its values
for (i in 1:30){
    SubjWalking <- filter(data, subjID == i & activityID == "Walking")
    SubjWalkingAVG <- colMeans(SubjWalking[4:69], na.rm=T)
    newdata[1 + 6*(i-1),3:68] <- SubjWalkingAVG
    
    SubjWalkingUpStairs <- filter(data, subjID == i & activityID == "WalkingUpStairs")
    SubjWalkingUpStairsAVG <- colMeans(SubjWalkingUpStairs[4:69], na.rm=T)
    newdata[2 + 6*(i-1),3:68] <- SubjWalkingUpStairsAVG
    
    SubjWalkingDownStairs <- filter(data, subjID == i & activityID == "WalkingDownStairs")
    SubjWalkingDownStairsAVG <- colMeans(SubjWalkingDownStairs[4:69], na.rm=T)
    newdata[3 + 6*(i-1),3:68] <- SubjWalkingDownStairsAVG
    
    SubjSitting <- filter(data, subjID == i & activityID == "Sitting")
    SubjSittingAVG <- colMeans(SubjSitting[4:69], na.rm=T)
    newdata[4 + 6*(i-1),3:68] <- SubjSittingAVG
    
    SubjStanding <- filter(data, subjID == i & activityID == "Standing")
    SubjStandingAVG <- colMeans(SubjStanding[4:69], na.rm=T)
    newdata[5 + 6*(i-1),3:68] <- SubjStandingAVG
    
    SubjLaying <- filter(data, subjID == i & activityID == "Laying")
    SubjLayingAVG <- colMeans(SubjLaying[4:69], na.rm=T)
    newdata[6 + 6*(i-1),3:68] <- SubjLayingAVG
}


newdata <- rename(newdata, AVGtBodyAccX_mean = X3)
newdata <- rename(newdata, AVGtBodyAccY_mean = X4)
newdata <- rename(newdata, AVGtBodyAccZ_mean = X5)
newdata <- rename(newdata, AVGtBodyAccX_sd = X6)
newdata <- rename(newdata, AVGtBodyAccY_sd = X7)
newdata <- rename(newdata, AVGtBodyAccZ_sd = X8)
newdata <- rename(newdata, AVGtGravityAccX_mean = X9)
newdata <- rename(newdata, AVGtGravityAccY_mean = X10)
newdata <- rename(newdata, AVGtGravityAccZ_mean = X11)
newdata <- rename(newdata, AVGtGravityAccX_sd = X12)
newdata <- rename(newdata, AVGtGravityAccY_sd = X13)
newdata <- rename(newdata, AVGtGravityAccZ_sd = X14)
newdata <- rename(newdata, AVGtBodyAccJerkX_mean = X15)
newdata <- rename(newdata, AVGtBodyAccJerkY_mean = X16)
newdata <- rename(newdata, AVGtBodyAccJerkZ_mean = X17)
newdata <- rename(newdata, AVGtBodyAccJerkX_sd = X18)
newdata <- rename(newdata, AVGtBodyAccJerkY_sd = X19)
newdata <- rename(newdata, AVGtBodyAccJerkZ_sd =X20)
newdata <- rename(newdata, AVGtBodyGyroX_mean = X21)
newdata <- rename(newdata, AVGtBodyGyroY_mean = X22)
newdata <- rename(newdata, AVGtBodyGyroZ_mean = X23)
newdata <- rename(newdata, AVGtBodyGyroX_sd = X24)
newdata <- rename(newdata, AVGtBodyGyroY_sd = X25)
newdata <- rename(newdata, AVGtBodyGyroZ_sd = X26)
newdata <- rename(newdata, AVGtBodyGyroJerkX_mean = X27)
newdata <- rename(newdata, AVGtBodyGyroJerkY_mean  = X28)
newdata <- rename(newdata, AVGtBodyGyroJerkZ_mean = X29)
newdata <- rename(newdata, AVGtBodyGyroJerkX_sd = X30)
newdata <- rename(newdata, AVGtBodyGyroJerkY_sd = X31)
newdata <- rename(newdata, AVGtBodyGyroJerkZ_sd = X32)
newdata <- rename(newdata, AVGtBodyAccMag_mean  = X33)
newdata <- rename(newdata, AVGtBodyAccMag_sd = X34)
newdata <- rename(newdata, AVGtGravityAccMag_mean = X35)
newdata <- rename(newdata, AVGtGravityAccMag_sd = X36)
newdata <- rename(newdata, AVGtBodyAccJerkMag_mean = X37)
newdata <- rename(newdata, AVGtBodyAccJerkMag_sd = X38)
newdata <- rename(newdata, AVGtBodyGyroMag_mean = X39)
newdata <- rename(newdata, AVGtBodyGyroMag_sd = X40)
newdata <- rename(newdata, AVGtBodyGyroJerkMag_mean = X41)
newdata <- rename(newdata, AVGtBodyGyroJerkMag_sd = X42)
newdata <- rename(newdata, AVGfBodyAccX_mean= X43)
newdata <- rename(newdata, AVGfBodyAccY_mean= X44)
newdata <- rename(newdata, AVGfBodyAccZ_mean = X45)
newdata <- rename(newdata, AVGfBodyAccX_sd = X46)
newdata <- rename(newdata, AVGfBodyAccY_sd= X47)
newdata <- rename(newdata, AVGfBodyAccZ_sd = X48)
newdata <- rename(newdata, AVGfBodyAccJerkX_mean = X49)
newdata <- rename(newdata, AVGfBodyAccJerkY_mean = X50)
newdata <- rename(newdata, AVGfBodyAccJerkZ_mean = X51)
newdata <- rename(newdata, AVGfBodyAccJerkX_sd = X52)
newdata <- rename(newdata, AVGfBodyAccJerkY_sd = X53)
newdata <- rename(newdata, AVGfBodyAccJerkZ_sd = X54)
newdata <- rename(newdata, AVGfBodyGyroX_mean = X55)
newdata <- rename(newdata, AVGfBodyGyroY_mean = X56)
newdata <- rename(newdata, AVGfBodyGyroZ_mean = X57)
newdata <- rename(newdata, AVGfBodyGyroX_sd = X58)
newdata <- rename(newdata, AVGfBodyGyroY_sd = X59)
newdata <- rename(newdata, AVGfBodyGyroZ_sd = X60)
newdata <- rename(newdata, AVGfBodyAccMag_mean = X61)
newdata <- rename(newdata, AVGfBodyAccMag_sd  = X62)
newdata <- rename(newdata, AVGfBodyAccJerkMag_mean= X63)
newdata <- rename(newdata, AVGfBodyAccJerkMag_sd= X64)
newdata <- rename(newdata, AVGfBodyGyroMag_mean = X65)
newdata <- rename(newdata, AVGfBodyGyroMag_sd = X66)
newdata <- rename(newdata, AVGfBodyGyroJerkMag_mean =X67)
newdata <- rename(newdata, AVGfBodyGyroJerkMag_sd = X68)

write.table(newdata, "newdata.txt", row.name= FALSE)
