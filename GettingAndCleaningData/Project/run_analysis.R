## This script creates a tidy data set from the UCI HAR Dataset available at
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

library("dplyr")

download.data = function() {
  zipfile="UCI_HAR_data.zip"
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  
  ## Download the data if they haven't been downloaded yet
  if (!file.exists(zipfile)) { 
    message(sprintf("Downloading data from %s", fileURL))
    download.file(fileURL, zipfile, method="curl")
  }
  else {
    message(sprintf("Data already downloaded to %s", zipfile))
  }
  
  if (!file.exists("UCI HAR Dataset")) {
    message(sprintf("Extracting data from %s", zipfile))
    unzip(zipfile)
  }
  else {
    message("Data already extracted to UCI HAR Dataset")
  }
}

read.and.merge.data = function() {
  message("Reading labels")
  activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]
  feature.labels <- read.table("UCI HAR Dataset/features.txt")[,2]
  
  message("Change feature names to be more human readable")
  cleaned.feature.labels <- gsub("\\(\\)", "", feature.labels)
  cleaned.feature.labels <- gsub("Acc", "-acceleration", cleaned.feature.labels)
  cleaned.feature.labels <- gsub("Mag", "-magnitude", cleaned.feature.labels)
  cleaned.feature.labels <- gsub("^t(.*)$", "\\1-time", cleaned.feature.labels)
  cleaned.feature.labels <- gsub("^f(.*)$", "\\1-frequency", cleaned.feature.labels)
  cleaned.feature.labels <- gsub("(Jerk|Gyro)", "-\\1", cleaned.feature.labels)
  cleaned.feature.labels <- gsub("BodyBody", "Body", cleaned.feature.labels)
  cleaned.feature.labels <- tolower(cleaned.feature.labels)
  
  message("Reading training data")
  training.features <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names=cleaned.feature.labels)
  training.activity <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names=c("activity.id"))
  training.subject <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names=c("subject.id"))
  
  message("Reading test data")
  test.features <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names=cleaned.feature.labels)
  test.activity <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE,col.names=c("activity.id"))
  test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE,col.names=c("subject.id"))
  
  message("Merge training and test datasets")
  merged.features <- rbind(training.features, test.features)
  merged.activity <- rbind(training.activity, test.activity)
  merged.subject <- rbind(training.subject, test.subject)
  
  message("Extract mean and standard deviation for each measurement")
  merged.features <- select(merged.features, contains("mean\\(\\)"), contains("std\\(\\)")) 
  #features.to.be.extracted <- grepl("mean()|std()", feature.labels)
  #merged.features = merged.features[,features.to.be.extracted]
  
  message("Add descriptive activity names")
  merged.activity[,2] <- activity.labels[merged.activity[,1]]
  names(merged.activity) <- c("activity.id", "activity.description")
 
  message("Merge separate datasets into a single dataset")
  data <- cbind(merged.subject, merged.activity, merged.features)
}

download.data()
data <- read.and.merge.data()

data %>%
  # Generate the new tidy dataset with the average of each variable
  # for each subject and each activity.
  group_by(activity.id, activity.description, subject.id) %>%
  # compute the average of the selected features
  summarise_each(funs(mean)) %>%
  # generate the output txt file
  write.table("tidy.txt",row.names=FALSE)
