---
title: "CodeBook"
author: "Chiara"
date: "31 January 2016"
output: html_document
---

This codebook describes the variables, the data, and any transformations or work that have been performed to clean up the data.

#Variable list and descriptions
##Subject
ID of the subject who performed the activity for each window sample. 
Its range is from 1 to 30.

##Activity
Activity performed by the subject:

* SITTING  
* STANDING  
* WALKING  
* WALKING_DOWNSTAIRS  
* WALKING_UPSTAIRS

##FeatureDomain
Time domain signal or frequency domain signal:

* Time
* Frequency

##FeatureAcceleration
Acceleration signal:

* Body
* Gravity

##FeatureInstrument
Instrument used:

* Accelerometer
* Gyroscope

##FeatureJerk
Jerk Signal (Jerk or NA)

##FeatureMag
Magnitude signal (Mag or NA)

##FeatureVariable
Variable:

* Mean
* Standard Deviation (Sdt)

##FeatureAxis
3-axial signals in the X, Y and Z directions (X, Y, or Z)

##Count
Count of data points used to compute average.

##Average
Average of each variable for each activity and each subject.

#Data Set structure
Data are structured in a ``data.table`` of 11880 obs. of 11 variables:

* subject, count and average: ``int`` variables
* activity: ``factor`` variable with 6 levels
* featureAxis: ``factor`` variable with 4 levels
* all others: ``factor`` variables with 2 levels

#Data transformation
See ``run_analysis.md``  for details on data set creation.


