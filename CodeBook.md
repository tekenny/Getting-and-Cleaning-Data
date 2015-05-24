# Code 

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

## Modular Code Structure

The main line of this code uses chaining for easily passing the transformed data set to the next step.

The script also includes a function named download_raw_data for convenience of obtaining the raw data.

1. Read and then merge the test and the train raw data to create one data set<br>
The 3 test data files test/y_test.txt, test/subject_test.txt and test/X_test.txt are read into tables.
As a safety check processing is stopped if the number of observations does not match for the 3 tables.
The columns (variables) of those 3 tables are then combined into a test data set in the order of y_test, subject_test and X_test.
The 3 train data files train/y_train.txt, train/subject_train.txt and train/X_train.txt are read into tables.
As a safety check processing is stopped if the number of observations does not match for the 3 tables.
The columns (variables) of those 3 tables are then combined into a train data set in the order of y_train, subject_train and X_train.
The rows (observations) of the test and train tables are then combined into a single data set.
Column names of Activity and Subject are assigned to the first two rows.
(Column names for the rest of the columns which are the feature measurements will be set later)

2. Extract only the mean and standard deviation measurements<br>


3. Mutate activity variables from codes to descriptive activity names<br>

4. Appropriately label the data set with descriptive variable names<br>

5. Create a tidy data set with the average of each variable for each activity and each subject<br>

# Processed tidy output data

# TBD
Was code book submitted to GitHub that modifies and updates the codebooks available to you with the data to indicate all the variables and summaries you calculated, along with units, and any other relevant information?
