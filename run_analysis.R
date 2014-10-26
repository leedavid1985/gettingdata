setwd("C:/Users/David/Desktop/getting_proj/UCI HAR Dataset")
library(reshape2)

# Takes features and activity type labels
features <- read.table('./features.txt',header=FALSE)
activityType <- read.table('./activity_labels.txt',header=FALSE)
colnames(activityType) <- c("activityID","activityType")

# Takes data from training files
subjectTrain <- read.table('./train/subject_train.txt',header=FALSE)
xTrain <- read.table('./train/x_train.txt',header=FALSE)
yTrain <- read.table('./train/y_train.txt',header=FALSE)
colnames(subjectTrain) <- "subjectID"
colnames(xTrain) <- features[,2]
colnames(yTrain) <- "activityID"
training = cbind(yTrain,subjectTrain,xTrain)

# Takes data from testing files
subjectTest <- read.table('./test/subject_test.txt',header=FALSE)
xTest <- read.table('./test/x_test.txt',header=FALSE)
yTest <- read.table('./test/y_test.txt',header=FALSE)
colnames(subjectTest) <- "subjectID"
colnames(xTest) <- features[,2] 
colnames(yTest) <- "activityID"
testing <- cbind(yTest,subjectTest,xTest);
mergedData <- rbind(training,testing)

#Look through column names and only keep ones with ID, mean, std. 
#But DOES NOT include MeanFreq columns
labels <- colnames(mergedData); 
labelsNoMeanFreq <- gsub(pattern="-?meanFreq[()][)]-?",replacement="DELETE",x=labels)
keep <- (grepl(".*ID.*|.*std.*|.*mean().*|.*std.*",labelsNoMeanFreq) )
finalData <- mergedData[keep==TRUE]
finalData = merge(finalData,activityType,by='activityID',all.x=TRUE);

#Reshapes data (Step 5 of Project question)
finalData.long <- melt(finalData, id = c("subjectID", "activityType"))
finalData.wide <- dcast(finalData.long, subjectID + activityType ~ variable, mean)

#Exports tidy data
write.table(finalData.wide, './tidyData.txt',row.names=TRUE,sep='\t');
