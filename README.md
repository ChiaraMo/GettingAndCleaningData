---
title: "Project for Getting and Cleaning Data"
author: "Chiara"
date: "31 January 2016"
output: html_document
---

#Parameters for the Project
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Here are the data for the project:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

You should create one R script called run_analysis.R that does the following.

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive activity names.
* Creates a second, independent tidy data set with the average of each variable for each activity   and each subject.

Good luck!

#Steps to reproduce this project
1. Download the data from above link and save them on your pc
2. Open the R script ``run_analysis.r`` in ``R Studio``.
3. Using the ``setwd`` function set as your working directory/folder the folder where both the R script file and the data are saved.
4. Run the R script ``run_analysis.r``. Hint: make sure the ``run_analysis.r`` file is saved in the same folder where the data are saved.

##Output produced
1. Tidy dataset file dt_tidy_avg.txt (tab-delimited text) - contains count and average of each variable for each activity and each subject
2. Tidy data set file dt_tidy.txt (tab-delimited text) - contains indivual variable (average of each variable is not calculated)

#Acknowledgements
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

##Note
The run_analysis.R script is free to use, the original data and the output produced by the script are copyrighted and belongs to their respected owners mentioned in the Acknowledgements above.
