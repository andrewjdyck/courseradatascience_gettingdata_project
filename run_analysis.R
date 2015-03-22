
# Set the working directory where the downloaded data is located
# This folder contains data from the UCI Machine learning repository
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
setwd('~/Downloads/UCI HAR Dataset/')

# The project directory is where R code is saved and the 
# tidy dataset will be output
project_dir <- '~/Documents/getting_data_project/'

# Load the feature and activity definitions
features <- read.table('./features.txt', col.names=c('id', 'feature'))
activities <- read.table('./activity_labels.txt', col.names=c('id', 'activity'))

# Load the test dataset
test <- read.table('./test/X_test.txt')
test_activities <- read.table('./test//y_test.txt', col.names='activity')
test_subjects <- read.table('./test/subject_test.txt', col.names='subject')
test$subject <- test_subjects$subject
test$activity <- test_activities$activity

# Load the training dataset
train <- read.table('./train/X_train.txt')
train_activities <- read.table('./train/y_train.txt', col.names='activity')
train_subjects <- read.table('./train/subject_train.txt', col.names='subject')
train$subject <- train_subjects$subject
train$activity <- train_activities$activity

# Merge the test and training sets together and remove 
# the test/train sets from memory
data <- rbind(test, train)
rm(test, train)

# Defines only the features that we will keep.
# selected features are mean and standard defiation measures
featuremean <- features[grep('mean()', features$feature),]
featurestd <- features[grep('std()', features$feature), ]
selected_feature <- rbind(featuremean, featurestd)

# Create a tidy dataset with only selected features
# Names for the features are taken from the codebook
# activities are labeled via a Factor variable
tidy_data <- data[, selected_feature$id]
names(tidy_data) <- selected_feature$feature
tidy_data <- cbind(data[, c('subject', 'activity')], tidy_data)
tidy_data$activity <- factor(tidy_data$activity, 
                             activities$id, 
                             labels=activities$activity)

# Output the tidy dataset to a text file
write.table(tidy_data, 
            file=paste(project_dir, 'tidy_data.txt', sep=''),
            row.name=FALSE,
            quote=FALSE)

# Output the selected Variable names
write.table(paste('-', names(tidy_data)), 
            file=paste(project_dir, 'codebook.txt', sep=''),
            row.name=FALSE,
            quote=FALSE)
