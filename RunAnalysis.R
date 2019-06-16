# Loading appropriate Libraries
library(reshape2)

# Downloading data from provided URL 

dirName <- "getdata_dataset.zip"

if(!file.exists(dirName)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, dirName)
}

# Unzipping the folder

if(!file.exists("UCI HAR Dataset")){
  unzip(dirName)
}

# Reading Test and Train datasets

xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subjectTrain, yTrain, xTrain)

xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/Y_test.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subjectTest, yTest, xTest)

# Merging Test and Train Datasets

mergedData <- rbind(train, test)

# Load Activity Labels

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])

# Load Features

features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only those features which contain mean or standart deviation

reqFeatures <- grep(".*mean.*|.*std*.", features[,2])
reqFeatures.names <- features[reqFeatures,2]

# Expand Variables and clean the variable names (Remove Special Characters)

reqFeatures.names = gsub('mean', 'Mean', reqFeatures.names)
reqFeatures.names = gsub('std', 'standardDeviation', reqFeatures.names)
reqFeatures.names = gsub('^f', 'frequencyDomain', reqFeatures.names)
reqFeatures.names = gsub('^t', 'timeDomain', reqFeatures.names)
reqFeatures.names = gsub('Acc', 'Accelerometer', reqFeatures.names)
reqFeatures.names = gsub('Gyro', 'Gyroscope', reqFeatures.names)
reqFeatures.names = gsub('Mag', 'Magnitude', reqFeatures.names)
reqFeatures.names = gsub('Freq', 'Frequency', reqFeatures.names)

reqFeatures.names <- gsub('[\\(\\)-]', '', reqFeatures.names)

# Remove Typo

reqFeatures.names = gsub('BodyBody', 'Body', reqFeatures.names)



# Subset the merged dataset for required features

mergedData1 <- mergedData[c(1, 2, reqFeatures+2)]
colnames(mergedData1) <- c("subject", "activity", reqFeatures.names)

# Convert Activities and Subject into Factors

mergedData1$activity <- factor(mergedData1$activity, levels = activityLabels[,1], labels = activityLabels[,2])
mergedData1$subject <- as.factor(mergedData1$subject)

# Final Tidy Data

mergedData1.melted <- melt(mergedData1, id = c("subject", "activity"))
mergedData1.mean <- dcast(mergedData1.melted, subject + activity ~ variable, mean)

write.table(mergedData1.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
write.csv(mergedData1.mean, file = "tidy.csv", row.names = FALSE)