
setwd('~/Downloads/UCI HAR Dataset/')
project_dir <- '~/Documents/getting_data_project/'

features <- read.table('./features.txt', col.names=c('id', 'feature'))
activities <- read.table('./activity_labels.txt', col.names=c('id', 'activity'))

test <- read.table('./test/X_test.txt')
test_activities <- read.table('./test//y_test.txt', col.names='activity')
test_subjects <- read.table('./test/subject_test.txt', col.names='subject')
test$subject <- test_subjects$subject
test$activity <- test_activities$activity

train <- read.table('./train/X_train.txt')
train_activities <- read.table('./train/y_train.txt', col.names='activity')
train_subjects <- read.table('./train/subject_train.txt', col.names='subject')
train$subject <- train_subjects$subject
train$activity <- train_activities$activity

data <- rbind(test, train)
#rm(test, train)

featuremean <- features[grep('mean()', features$feature),]
featurestd <- features[grep('std()', features$feature), ]
selected_feature <- rbind(featuremean, featurestd)

d1 <- data[, selected_feature$id]
names(d1) <- selected_feature$feature
d1[, c('subject', 'activity')] <- data[, c('subject', 'activity')]
d1$activity <- factor(d1$activity, activities$id, labels=activities$activity)

write.table(d1, 
            file=paste(project_dir, 'tidy_data.txt', sep=''),
            row.name=FALSE,
            quote=FALSE)
