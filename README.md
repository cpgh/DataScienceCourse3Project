# DataScienceCourse3Project


This directory contains the R script with the code required to perform
the data extraction from zip file and data manipulation as per
the instruction for the course project.

The scrip is documented as follows:

1) The script assumes the source zip file is located in the working directory, and it will then create a directory with all
unzipped files.
2) The script includes a commented setwd() function line to make this change easy
3) The script assumes the following R packages have been installed:
	plyr
	dplyr
	reshape
	tidyr
	gdata
4) The code performs the following process:

## Extracts data from the .zip source file into a directory in the working directory
## Creates separate df's for each relevant table in order to more properly compartmenalize the code
## Separatesthe the process into training and test where applicable and then performs following steps:
## Step 1 - Normalizes the the two data sets as follows:
##     1.a  Assigns names to the columns
##     1.b  Combines activity IDs (the "y_" files) with each data df (the "X_" files)
##     1.c  Creates a variable with Activity Names based on the  AcivityID code via merge
##     1.d  Merges activity names into the data df's
##     1.e  Merges subject id from one data file with the measured variaables 
##     1.f  Removes columns that are not either mean or std values
##     1.g  Merges the training and test data sets
##     1.h  Aggregates the values by activity and subject
##     1.i  Generates a tidy data set by normalizing the variable names

OTHER NOTES:
1) All values that contained the word mean or std were included in the data set in accordance with the instructions
2) The tidy operation was performed to improve readability of the variable names, and also to reduce the downstream
   impact on systematic use of the data that can be caused by characters or spaces that tend to be problematic.  For example,
   trailing and leading spaces were removed, parenthenses were removed, commas were removed, etc.  In most cases a space or a
   null were used to replace the characters, except for the time and frequency prefix which was separated by a period for
   readability and also to facilitate a subsequent data manipulaiton operation, like crosstabbing of this data.