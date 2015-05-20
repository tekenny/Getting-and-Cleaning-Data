library(plyr)

# Download the zip file from the Internet which contains the raw data
# and then extract (unzip) the data from the zip file
download_raw_data <- function() {
    rawDataURL  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipFileName <- "UCI-HAR-DataSet.zip"
    
    if (file.exists(zipFileName)) {
        paste("Not downloading", zipFileName, "since it already exists")
    } else {
        download.file(rawDataURL, destfile = zipFileName, method="curl")
        
        unzip(zipFileName)
        
        # Replace spaces in direcotry name with dashes for readability
        # as well as avoid any issues with embedded spaces
        file.rename("UCI HAR DataSet", "UCI-HAR-DataSet")
    }
}

# Read the raw data from seperate files and merge it into one dataset
read_raw_data <- function() {
    # Read the test data
    test.s  <- read.table("UCI-HAR-Dataset/test/subject_test.txt")
    test.x  <- read.table("UCI-HAR-Dataset/test/X_test.txt")
    test.y  <- read.table("UCI-HAR-Dataset/test/y_test.txt")
    
    # Safety check - abort if row count does not match
    stopifnot(dim(test.s)[1] == dim(test.x)[1])
    stopifnot(dim(test.x)[1] == dim(test.y)[1])
    
    # Append a category column containing "test"
    # in case distinguishing between test and train data may be useful
    test.y$Category <- "test"
    test            <- cbind(test.s, test.y, test.x)

    # Read the train data
    train.s <- read.table("UCI-HAR-Dataset/train/subject_train.txt")
    train.x <- read.table("UCI-HAR-Dataset/train/X_train.txt")
    train.y <- read.table("UCI-HAR-Dataset/train/y_train.txt")
    
    # Safety check - abort if row count does not match
    stopifnot(dim(train.s)[1] == dim(train.x)[1])  
    stopifnot(dim(train.x)[1] == dim(train.y)[1])
    
    # Append a category column containing "train"
    # in case distinguishing between test and train data may be useful
    train.y$Category <- "train"
    train            <- cbind(train.s, train.y, train.x)
    
    # Combine the test and train data into one dataset
    dataset <- rbind(test, train)
}

mutate_activity <- function(dataset) {
    # Read activity labels to subsitute codes for descriptive names
    activity_labels <- read.table("UCI-HAR-Dataset/activity_labels.txt")
    colnames(activity_labels) <- c("ActivityID", "ActivityName")
    
    # Mutate Activity to be a name rather than a code
    dataset <- mutate(dataset, Activity = activity_labels[Activity, 2])
}

# Although not all of the columns are used for this project, this function
# progrmatically assigns column names for possible future use of this dataset
# Note: intentionally kept special characters in the column names
#       to provide a more descriptive name. Such as () suffixing the name of
#       the function that was used to derive values
set_column_names <- function(dataset) {
    # Set column names for non-X data
    colnames(dataset)[1:3] <- c("Subject", "Activity", "Category")
    
    # Read features for use as column names of X data variables
    features <- read.table("UCI-HAR-Dataset/features.txt")
    
    # Set column names for X data
    colnames(dataset)[4:564] <- as.character(features[,2])
    
    dataset
}

# Main line code starts here

# Download the raw data from the Internet
download_raw_data()

# Read and then merge the test and the train raw data to create one data set
dataset <- read_raw_data()

# Appropriately label the data set with descriptive variable names 
dataset <- set_column_names(dataset)

# Mutate activity variables from codes to descriptive activity names
dataset <- mutate_activity(dataset)

# 2 - Extracts only the measurements on the mean and standard deviation for
#     each measurement 

# 5 - From the data set in step 4, creates a second, independent tidy data set
#     with the average of each variable for each activity and each subject

#write.table("analysis.txt", row.name=FALSE)
