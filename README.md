# gettingAndCleaningDataCourseraAssignment
This is an assignment submitted for the Coursera's course on Getting and Cleaning Data by John Hopkins University

The R script named "assignmentGettingAndCleaningData.R" does the following tasks:

1. Downloads the zipped folder contaning the data from the provided URL
	a). Unzips the Data if the data doesnot already exists
2. Reads both the Subject and Activity data both the Train and Test datasets and merges them
3. Merges the Test and Train datasets 
3. Reads both Activity and Feature information and then subsets the merged dataset for the required Columns 
4. Converts the Activity and Feature columns to factors 
5. Caculates the average for each column for each activity and each subject. This final dataset is stored in the form of a text file (named "tidy.txt") and a csv file (named "tidy.csv")

