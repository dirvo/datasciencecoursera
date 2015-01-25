Getting and Cleaning Data - Course Project
==========================================

This repository contains R code that downloads and tidies up the Human Activity Recognition data set available at the UCI machine learning repository (see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The code has been written as part of the course project of the *Getting and Cleaning Data* class on Coursera.

# Tidying 

The script ```run_analysis.R``` produces a tidy data set from the above dataset. 

The script does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Pre-requisites
The R script ```run_analyis.R``` requires the package ```dplyr```.

# Running the Script

To run the script, just type in R:
> source("run_analysis.R")  

# Script Output

The script outputs the following:

- A variabla ```data``` in the current environment containing the tidy data.
- A file ```tidy.txt``` in the current directory containing the tidy data.
