
# This code is intended to be run from a working directory that includes the source data.
# The source data is located at the following url:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#############
# Section 1 #
#############
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

#############
# Section 2 #
#############
# Defines only the features that we will keep.
# selected features are mean and standard defiation measures
featuremean <- features[grep('mean()', features$feature),]
featurestd <- features[grep('std()', features$feature), ]
selected_feature <- rbind(featuremean, featurestd)

#############
# Section 3 #

# Create a tidy dataset with only selected features
# Names for the features are taken from the codebook
# activities are labeled via a Factor variable
tidy_data <- data[, selected_feature$id]
names(tidy_data) <- selected_feature$feature
tidy_data <- cbind(data[, c('subject', 'activity')], tidy_data)
tidy_data$activity <- factor(tidy_data$activity, 
                             activities$id, 
                             labels=activities$activity)
tidy_data <- aggregate(tidy_data[, 3:ncol(tidy_data)], by=list(tidy_data$subject, tidy_data$activity), FUN=mean, na.rm=TRUE)
names(tidy_data)[1:2] <- c('Subject', 'Activity')

#############
# Section 4 #
#############
# Output the tidy dataset to a text file
write.table(tidy_data, 
            file='./tidy_data.txt',
            row.name=FALSE,
            quote=FALSE)

# Output the selected Variable names
write.table(paste('-', names(tidy_data)), 
            file='./codebook.txt',
            row.name=FALSE,
            quote=FALSE)
