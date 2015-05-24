library(plyr)
library(dplyr)
library(reshape2)

# Creates a second independent tidy data set with the average of each variable
# for each activity and each subject
average_each_activity_and_each_subject <- function(dataset) {
    #
    melt_data = melt(dataset, id = c("Activity","Subject"), measure.vars = c(3:68))
    
    #
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

    # Select columns with the std (standard deviation) function in it's name
    stdColumns <- grep(pattern = "-std()",  features$V2, fixed=TRUE, value=FALSE)
    
    # Merge all the selected columns together
    columns <- dim(dataset)[2]
    selectedColumns <- c(meanColumns, stdColumns, columns-1, columns)
    
    # Now actually select the desired columns in the dataset
    dataSubset <- dataset[, as.vector(selectedColumns)]
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
    
    test <- cbind(test.x, test.s, test.y)
    
    # Read the train data
    train.s <- read.table("UCI-HAR-Dataset/train/subject_train.txt")
    train.x <- read.table("UCI-HAR-Dataset/train/X_train.txt")
    train.y <- read.table("UCI-HAR-Dataset/train/y_train.txt")
    
    # Safety check - abort if row count does not match
    stopifnot(dim(train.s)[1] == dim(train.x)[1])  
    stopifnot(dim(train.x)[1] == dim(train.y)[1])
    
    train <- cbind(train.x, train.s, train.y)
    
    # Combine the test and train data into one dataset
    dataset <- rbind(test, train)
    
    # Set the column names for the last two columns
    columns <- dim(dataset)[2]
    colnames(dataset)[columns-1] = "Subject"
    colnames(dataset)[columns] = "Activity"
    
    dataset
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

# Although not all of the columns are used for this project, this function
# progrmatically assigns column names for possible future use of this dataset
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
    selectedColumnNames <- c(meanColumnNames, stdColumnNames, "Subject", "Activity")
    
    # Now actually set the column names to the dataset
    colnames(dataset) <- selectedColumnNames

    # Reorganize columns so Subject and Activity are 1st two columns
    columns <- dim(dataset)[2]
    dataset[, c(columns-1,columns,1:(columns-2))]
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
