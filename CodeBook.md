# Code Book

This code book descirbes the raw input data, processing transformations of the data and the resulting tidy output data.

# Raw input data

The raw data used was experimental observations from the "Human Activity Recognition Using Smartphones Data Set" by the Center for Machine Learning and Intelligent Systems. More details regarding this data set can be obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The actual raw data was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

## Files and Variables

The following files from the zip file were used. All of them can be viewed within this repo.<br>
- activity_labels.txt contains 6 mappings of activity codes and names
  - numeric activity code
  - descriptive activity name
- features.txt contains 561 mappings of feature codes and names
  - numeric feature code
  - name of feature (aka type of experimental measurement)
- test/subject_test.txt contains subject code for 2947 observations
  - numeric subject code
- test/X_test.txt contains 561 feature measurements for 2947 observations
  - 561 numeric measurements in expontential notation, see features.txt to sequentially map measurement to feature name
- test/y_test.txt contains activity code for 2947 observations
  - numeric activity code
- train/subject_train.txt contains subject code for 7352 observations
  - numeric subject code
- train/X_train.txt contains 561 feature measurements for 7352 observations
  - 561 numeric measurements in expontential notation, see features.txt to sequentially map measurement to feature name
- train/y_train.txt contains activity code for 7352 observations
  - numeric activity code

# Processing performed by run_analysis.R

The main line of this code uses chaining for easily passing the transformed data set to the next step.

The script also includes a function named download_raw_data for convenience of obtaining the raw data.

1. Read and then merge the test and the train raw data to create one data set.<br>
The 3 test data files test/y_test.txt, test/subject_test.txt and test/X_test.txt are read into tables.
As a safety check processing is stopped if the number of observations does not match for the 3 tables.
The columns (variables) of those 3 tables are then combined into a test data set in the order of y_test, subject_test and X_test.
The 3 train data files train/y_train.txt, train/subject_train.txt and train/X_train.txt are read into tables.
As a safety check processing is stopped if the number of observations does not match for the 3 tables.
The columns (variables) of those 3 tables are then combined into a train data set in the order of y_train, subject_train and X_train.
The rows (observations) of the test and train tables are then combined into a single data set.
Column names of Activity and Subject are assigned to the first two rows.
(Column names for the rest of the columns which are the feature measurements will be set later)

2. Extract only the mean and standard deviation measurements.<br>
The requirements of our project dictated that only features indicated by the use of the mean() and std() functions are of interest. Although some features have meanFreq() within their name they are excluded since our interest is for measurements with derived from the common mean() function. How values using meanFreq() are derived are unknown and thus might not use the common mean() function. Thus those features were deemed to be out of scope for our project requirements.
The existing data set from step 1 was then filter to only contain variables: Activity, Subject, 33 mean() related features and 33 std() related features.

3. Mutate activity variables from codes to descriptive activity names.<br>
To make the date set more readable the mappings of activity codes to activity descriptive names contained in activity_labels.txt was use to transform the dataset in step 2 to replace the values in the Activity column from codes to names.

4. Appropriately label the data set with descriptive variable names.<br>
The mappings in features.txt were used to assign appropriate column headings for the features in the data set in step 3.
Careful attention was made to ensure that the same algorithm used to determine appropriate selected features in step 2 was also used to determine the appropriate column names for the features.
Please note that I intentionally kept special characters in the column names to provide a more descriptive name. Such as () suffixing the name of the function that was used to derive values.

5. Create a tidy data set with the average of each variable for each activity and each subject.<br>
Use melt to reshape the data to rows with 4 variables: Activity, Subject, measurement type and measurement value.
This is to facilitate taking the mean for each measurement type in the next function call.
Use dcast to reshape the data, grouping by Activity and Subject as well as taking the mean of the value of each measurement type.
Result is tidy data where observations (rows) consist of: Activity, Subject and the mean of each measurement type for the Activity, Subject grouping.

# Processed tidy output data

## Files

The output conforms to tidy data rules and is contained in analysis.txt.
The first row is a listing the column headings followed by 180 data rows.
Each data row represents a grouping by unique combination of activity name, subject code along with the averages for 66 features of interest for the group.

## Variables

The following is the list of variables of the output data.<br>

- Activity
- Subject
- tBodyAcc-mean()-X
- tBodyAcc-mean()-Y
- tBodyAcc-mean()-Z
- tGravityAcc-mean()-X
- tGravityAcc-mean()-Y
- tGravityAcc-mean()-Z
- tBodyAccJerk-mean()-X
- tBodyAccJerk-mean()-Y
- tBodyAccJerk-mean()-Z
- tBodyGyro-mean()-X
- tBodyGyro-mean()-Y
- tBodyGyro-mean()-Z
- tBodyGyroJerk-mean()-X
- tBodyGyroJerk-mean()-Y
- tBodyGyroJerk-mean()-Z
- tBodyAccMag-mean()
- tGravityAccMag-mean()
- tBodyAccJerkMag-mean()
- tBodyGyroMag-mean()
- tBodyGyroJerkMag-mean()
- fBodyAcc-mean()-X
- fBodyAcc-mean()-Y
- fBodyAcc-mean()-Z
- fBodyAccJerk-mean()-X
- fBodyAccJerk-mean()-Y
- fBodyAccJerk-mean()-Z
- fBodyGyro-mean()-X
- fBodyGyro-mean()-Y
- fBodyGyro-mean()-Z
- fBodyAccMag-mean()
- fBodyBodyAccJerkMag-mean()
- fBodyBodyGyroMag-mean()
- fBodyBodyGyroJerkMag-mean()
- tBodyAcc-std()-X
- tBodyAcc-std()-Y
- tBodyAcc-std()-Z
- tGravityAcc-std()-X
- tGravityAcc-std()-Y
- tGravityAcc-std()-Z
- tBodyAccJerk-std()-X
- tBodyAccJerk-std()-Y
- tBodyAccJerk-std()-Z
- tBodyGyro-std()-X
- tBodyGyro-std()-Y
- tBodyGyro-std()-Z
- tBodyGyroJerk-std()-X
- tBodyGyroJerk-std()-Y
- tBodyGyroJerk-std()-Z
- tBodyAccMag-std()
- tGravityAccMag-std()
- tBodyAccJerkMag-std()
- tBodyGyroMag-std()
- tBodyGyroJerkMag-std()
- fBodyAcc-std()-X
- fBodyAcc-std()-Y
- fBodyAcc-std()-Z
- fBodyAccJerk-std()-X
- fBodyAccJerk-std()-Y
- fBodyAccJerk-std()-Z
- fBodyGyro-std()-X
- fBodyGyro-std()-Y
- fBodyGyro-std()-Z
- fBodyAccMag-std()
- fBodyBodyAccJerkMag-std()
- fBodyBodyGyroMag-std()
- fBodyBodyGyroJerkMag-std()
