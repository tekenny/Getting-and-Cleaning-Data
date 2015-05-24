library(plyr)
library(dplyr)
library(reshape2)

# Creates a second independent tidy data set with the average of each variable
# for each activity and each subject
average_each_activity_and_each_subject <- function(dataset) {
    columns <- dim(dataset)[2]
    
    # Use melt to reshape the data to rows with 4 variables:
    # Activity, Subject, measurement type and measurement value.
    # This is to facilitate taking the mean for each measurement type
    # in the next function call.
    melt_data = melt(dataset, id = c("Activity","Subject"), measure.vars = c(3:columns))
    
    # Use dcast to reshape the data, grouping by Activity and Subject
    # as well as taking the mean of the value of each measurement type.
    # Result is tidy data where observations (rows) consist of:
    # Activity, Subject and the mean of each measurement type for the
    # Activity, Subject grouping.
    tidy_data <- dcast(melt_data, Activity + Subject ~ variable, mean)   
}

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

# Extract only the measurements on the mean and standard deviation for
# each measurement
extract_mean_and_standard_deviation <- function(dataset) {
    # Read features for use as column names of X data variables
    features <- read.table("UCI-HAR-Dataset/features.txt")
    
    # Select columns with the mean function it it's name
    meanColumns <- grep(pattern = "-mean()", features$V2, fixed=TRUE, value=FALSE)
    # add offset of 2 since Activity and Subject are actually the first two columns
    meanColumns <- sapply(meanColumns, function(x) x+2)

    # Select columns with the std (standard deviation) function in it's name
    stdColumns <- grep(pattern = "-std()",  features$V2, fixed=TRUE, value=FALSE)
    # add offset of 2 since Activity and Subject are actually the first two columns
    stdColumns <- sapply(stdColumns, function(x) x+2)
    
    # Merge all the selected columns together
    selectedColumns <- c(1, 2, meanColumns, stdColumns)
    
    # Now actually select the desired columns in the dataset
    dataSubset <- dataset[, as.vector(selectedColumns)]
}

# Mutate the Activity column in the dataset from activity code values
# to names indicating the activity
mutate_activity <- function(dataset) {
    # Read activity labels to subsitute codes for descriptive names
    activity_labels <- read.table("UCI-HAR-Dataset/activity_labels.txt")
    colnames(activity_labels) <- c("ActivityID", "ActivityName")
    
    # Mutate Activity to be a name rather than a code
    dataset <- mutate(dataset, Activity = activity_labels[Activity, 2])
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
    
    test <- cbind(test.y, test.s, test.x)
    
    # Read the train data
    train.s <- read.table("UCI-HAR-Dataset/train/subject_train.txt")
    train.x <- read.table("UCI-HAR-Dataset/train/X_train.txt")
    train.y <- read.table("UCI-HAR-Dataset/train/y_train.txt")
    
    # Safety check - abort if row count does not match
    stopifnot(dim(train.s)[1] == dim(train.x)[1])  
    stopifnot(dim(train.x)[1] == dim(train.y)[1])
    
    train <- cbind(train.y, train.s, train.x)
    
    # Combine the test and train data into one dataset
    dataset <- rbind(test, train)
    
    # Set the column names for the first two columns
    colnames(dataset)[1] = "Activity"
    colnames(dataset)[2] = "Subject"
    
    dataset
}

# Assign appropriate column names for all the columns in the dataset
# Note: intentionally kept special characters in the column names
#       to provide a more descriptive name. Such as () suffixing the name of
#       the function that was used to derive values
set_column_names <- function(dataset) {    
    # Read features for use as column names of X data variables
    features <- read.table("UCI-HAR-Dataset/features.txt")
    
    # Select column names with the mean function it it's name
    meanColumnNames <- grep(pattern = "-mean()", features$V2, fixed=TRUE, value=TRUE)
    
    # Select column names with the std (standard deviation) function in it's name
    stdColumnNames <- grep(pattern = "-std()",  features$V2, fixed=TRUE, value=TRUE)
    
    # Merge all the selected column names together
    selectedColumnNames <- c("Activity", "Subject", meanColumnNames, stdColumnNames)
    
    # Now actually set the column names to the dataset
    colnames(dataset) <- selectedColumnNames
    
    dataset
}


############      Main line code starts here      ############


# Download the raw data from the Internet
download_raw_data()

# 1 Read and then merge the test and the train raw data to create one data set
# 2 Extract only the mean and standard deviation measurements
# 3 Mutate activity variables from codes to descriptive activity names
# 4 Appropriately label the data set with descriptive variable names 
# 5 Create a tidy data set with the average of each variable for each activity
#   and each subject
dataset <- read_raw_data() %>%
            extract_mean_and_standard_deviation() %>%
            mutate_activity() %>%
            set_column_names() %>%
            average_each_activity_and_each_subject() %>%
            write.table("analysis.txt", row.name=FALSE)
