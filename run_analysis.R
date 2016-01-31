##Merges the training and the test sets to create one data set.
##Extracts only the measurements on the mean and standard deviation for each measurement.
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names.
##From the data set in step 4, creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.

run_analysis <- function(){
        
        #Load necessary packages
        library(data.table)
        library(reshape2)
        library(dplyr)
        
        #Load data into R
        ##Load Subject data (subject_test.txt and subject_train.text files)
        fSubjectTest <- file.path(getwd(), "data/UCI HAR Dataset/test/subject_test.txt")
        df_subject_test <- read.table(fSubjectTest) ##reads as data.frame
        dt_subject_test <- data.table(df_subject_test) ##converts into a data.table
        names(dt_subject_test) <- "subject" ##assign name to the loaded file
        
        fSubjectTrain <- file.path(getwd(), "data/UCI HAR Dataset/train/subject_train.txt")
        df_subject_train <- read.table(fSubjectTrain) 
        dt_subject_train <- data.table(df_subject_train) 
        names(dt_subject_train) <- "subject"
        
        ##Load activity data (y_test.txt and y_train.txt files)
        fActivityTest <- file.path(getwd(), "data/UCI HAR Dataset/test/y_test.txt")
        df_activity_test <- read.table(fActivityTest) 
        dt_activity_test <- data.table(df_activity_test) 
        names(dt_activity_test) <- "activityID"
        
        fActivityTrain <- file.path(getwd(), "data/UCI HAR Dataset/train/y_train.txt")
        df_activity_train <- read.table(fActivityTrain) 
        dt_activity_train <- data.table(df_activity_train) 
        names(dt_activity_train) <- "activityID"
        
        ##Load test and train data (X_test.txt and X_train.txt files)
        fTest <- file.path(getwd(), "data/UCI HAR Dataset/test/X_test.txt")
        df_test <- read.table(fTest) 
        dt_test <- data.table(df_test) 
        
        fTrain <- file.path(getwd(), "data/UCI HAR Dataset/train/X_train.txt")
        df_train <- read.table(fTrain) 
        dt_train <- data.table(df_train) 
        
        #Merge test and training data set to create one data set
        ##combine test data with subject and activity data set
        dt_test <- cbind(dt_subject_test, dt_activity_test, dt_test)
        dt_train <- cbind(dt_subject_train, dt_activity_train, dt_train)
        
        ##combine test and training data set
        dt <- rbind(dt_test, dt_train)
        
        #Extracts only the measurements on the mean and standard deviation for each measurement.
        ##Load list of all features (features.txt file)
        fFeatures <- file.path(getwd(), "data/UCI HAR Dataset/features.txt")
        df_features <- read.table(fFeatures) 
        dt_features <- data.table(df_features) 
        names(dt_features) <- c("featureID", "featureName")
        
        ##Subset only measurements for the mean and the standard deviation 
        dt_features <- dt_features[grepl("mean\\(\\)|std\\(\\)", featureName)]
        
        ##Convert the column numbers to a vector of variable names matching columns in dt.
        dt_features$featureCode <- dt_features[, paste0("V", featureID)] ##creates a column featureCode that matches the variable name in table dt, i.e. 'V1', 'V2', etc
        head(dt_features)
        dt_features$featureCode
        
        ##Set key for dt data set
        setkey(dt, subject, activityID)
        
        ##Subset only columns that matches values in featureCode vector, using subject and activity as Key
        dt <- dt[, c(key(dt), dt_features$featureCode), with=FALSE]
        
        #Uses descriptive activity names to name the activities in the data set
        ##Load activity names (activity_labels.txt file)
        fActivityName <- file.path(getwd(), "data/UCI HAR Dataset/activity_labels.txt")
        df_activity_name <- read.table(fActivityName) 
        dt_activity_name <- data.table(df_activity_name) 
        names(dt_activity_name) <- c("activityID", "activityName")
        
        ##Combine dt set with activity name
        dt <- merge(dt, dt_activity_name, by = "activityID", all.x = TRUE)
        
        ##Add activity name as a Key
        setkey(dt, subject, activityID, activityName)
        
        #Appropriately labels the data set with descriptive variable names.
        
        ##Melt dt data set to reshape it into a tall and skinny format:
        ##id variables 'subject', 'activityID', 'activityName' are set as key for the data set
        ##use featureCode as name for the measured variable names column
        dtMelt <- melt(dt, key(dt), variable.name = "featureCode")
        
        ##Combine dtMelt with featureName
        dtMelt <- merge(dtMelt, dt_features, by = "featureCode")
        
        ##Create two new variables equivalent to activityName and featureName, as factor class:
        ##they will be used to summarise data at the end.
        
        dtMelt$activity <- factor(dtMelt$activityName)
        dtMelt$feature <- factor(dtMelt$featureName)
        
        ##Separate features from featureName:
        ##time and frequency - featureDomain
        ##Acc and Gyro - featureInstrument
        ##body and gravity acceleration - featureAcceleration
        ##mean and sdt - featureVariable
        ##Jerk - featureJerk
        ##Mag - featureMagnitude
        #X, Y, Z - Axis
        
        ##Use the helper function grepthis
        grepthis <- function (regex) {
                grepl(regex, dtMelt$feature)
        }
        
        ##features with two categories
        n <- 2
        y <- matrix(seq(1, n), nrow=n)
        ##Domain: time and frequency
        x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol=nrow(y)) ##creates a logical matrix of 2 columns, where the first column matches all rows in dtMelt starting with t-, and second column matches all rows in dtMelt starting with f-
        dtMelt$featureDomain <- factor(x %*% y, labels=c("Time", "Frequency"))
        ##Instrument: acceleration and gyroscope
        x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), ncol=nrow(y))
        dtMelt$featureInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))
        ##Acceleration: body and gravity
        x <- matrix(c(grepthis("Body"), grepthis("Gravity")), ncol=nrow(y))
        dtMelt$featureAcceleration <- factor(x %*% y, labels=c("Body", "Gravity"))
        ##Variable: mean and sdt
        x <- matrix(c(grepthis("-mean"), grepthis("-sdt")), ncol=nrow(y))
        dtMelt$featureVariable <- factor(x %*% y, labels=c("Mean", "Sdt"))
        
        ##feaures with one category:
        ##Jerk
        dtMelt$featureJerk <- factor(grepthis("Jerk"), labels=c(NA, "Jerk"))
        ##Magnitued
        dtMelt$featureMag <- factor(grepthis("Mag"), labels=c(NA, "Mag"))
        
        ##features with three categories
        n <- 3
        y <- matrix(seq(1, n), nrow=n)
        x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), ncol=nrow(y))
        dtMelt$featureAxis <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))
        
        ##Check to make sure all possible combinations of feature are accounted for by all possible 
        ##combinations of the factor class variables.
        r1 <- nrow(dtMelt[, .N, by=c("feature")])
        r2 <- nrow(dtMelt[, .N, by=c("featureDomain", "featureAcceleration", "featureInstrument", "featureJerk", "featureMag", "featureVariable", "featureAxis")])
        r1 == r2
        ##Yes. All possible combination of feature are accounted. Column feature is now redundant.
        
        ##Create tidy data sets
        dt_tidy <- select(dtMelt, subject, activity, featureDomain, featureAcceleration, featureInstrument, featureJerk, featureMag, featureVariable, featureAxis, value)
        ##Create another tiry data set with the average of each variable for each activity and each subject.
        setkey(dt_tidy, subject, activity, featureDomain, featureAcceleration, featureInstrument, featureJerk, featureMag, featureVariable, featureAxis)
        dt_tidy_avg <- dt_tidy[, list(count = .N, average = mean(value)), by=key(dt_tidy)]
        
        ##Create output tables
        write.table(dt_tidy, "data/dt_tidy.txt", row.names = FALSE)
        write.table(dt_tidy_avg, "data/dt_tidy_avg.txt", row.names = FALSE)
        
        
}

