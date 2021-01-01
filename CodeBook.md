CodeBook.md

=========================================
CodeBook Description:

This CodeBook describes the variables, the data, and all transformations and work performed in run_analysis.R
to clean up the data.

The source data was downloaded and obtained from the zip file located at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

1. All steps performed on the source data for downloading, unzipping, and cleaning the data are clearly explained 
   in the code file: run_analysis.R 

2. The features, activities, subjects, test and training sets were merged to create one data set.

3. Measurements containing the mean and standard deviation (std) were extracted for each measurement, thereby 
   reducing the dataset.

4. Replaced Activities Code column of "integers" with column of descriptive Activities Code Factor names.

5. Adjusted column names and replaced with more descriptive and complete variable names.

6. Created new Table, Group, and Summarize All measurement columns by average Mean value for each measurement by 
   Subject and Activity.

7. A final data set called TidyData.txt was created with the mean average of each variable for each 
   Subject and each Activity.