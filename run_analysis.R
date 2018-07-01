setwd("C:\\Users\\Xela\\Desktop\\Coursera R\\UCI HAR Dataset")

# Import training data from files & Name the columns 

feat <- read.table('./features.txt',header=FALSE);
ActLabels <- read.table('./activity_labels.txt',header=FALSE); 
        colnames(ActLabels) <- c("ActID","ActType");

subTrain <- read.table('./train/subject_train.txt',header=FALSE); 
        colnames(subTrain) <- "SubID";
xTrain <- read.table('./train/x_train.txt',header=FALSE); colnames(xTrain) <- 
                feat[,2];
yTrain <- read.table('./train/y_train.txt',header=FALSE); colnames(yTrain) <- 
                "ActID";

# Merge Data into complete training set
trainingSet = cbind(yTrain,subTrain,xTrain);

# Import test data from files & Name columns
subTest <- read.table('./test/subject_test.txt',header=FALSE); 
        colnames(subTest) <- "SubID";
xTest <- read.table('./test/x_test.txt',header=FALSE); colnames(xTest) <- 
        feat[,2];
yTest <- read.table('./test/y_test.txt',header=FALSE); colnames(yTest) <- 
        "ActID";

# Merge Data into complete test set
testSet = cbind(yTest,subTest,xTest);

# Combine Training Data Set and Test Data Set into one Merged Data Set
AllDF = rbind(trainingSet,testSet);

# Create columns vector to prepare data for subsetting
columns <- colnames(AllDF);

###### 2. Extract only the measurements on the mean and standard deviation for each measurement

# Create a vector that indentifies the ID, mean & stddev columns as TRUE
MeanSTD <- (grepl("activity..",columns) | grepl("subject..",columns) | grepl("-mean..",columns) | grepl("ActID",columns) | grepl("ActType",columns) | grepl("SubID",columns) &
                  !grepl("-meanFreq..",columns) & !grepl("mean..-",columns) | 
                        grepl("-std..",columns) & !grepl("-std()..-",columns));

# Update AllDF based on previously identified columns
AllDF <- AllDF[MeanSTD==TRUE];

###### 3. Use descriptive activity names to name the activities in the data set

# Add in descriptive activity names & update columns vector
AllDF <- merge(AllDF, ActLabels,by="ActID", all.x=TRUE);
        AllDF$ActID <-ActLabels[,2][match(AllDF$ActID, ActLabels[,1])] 


columns <- colnames(AllDF);


## 4. Appropriately label the data set with descriptive activity names.

# Tidy column names
for (i in 1:length(columns)) 
        {
                columns[i] <- gsub("\\()","",columns[i])
                columns[i] <- gsub("-std$","StdDev",columns[i])
                columns[i] <- gsub("-mean","Mean",columns[i])
                columns[i] <- gsub("^(t)","time",columns[i])
                columns[i] <- gsub("^(f)","freq",columns[i])
                columns[i] <- gsub("([Gg]ravity)","Gravity",columns[i])
                columns[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",columns[i])
                columns[i] <- gsub("[Gg]yro","Gyro",columns[i])
                columns[i] <- gsub("AccMag","AccMagnitude",columns[i])
                columns[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",columns[i])
                columns[i] <- gsub("JerkMag","JerkMagnitude",columns[i])
                columns[i] <- gsub("GyroMag","GyroMagnitude",columns[i])
        };
        
# Update AllDF with new descriptive column names
colnames(AllDF) <- columns;

# Remove activityType column
AllDF <- AllDF[,names(AllDF) != "ActType"];

###### 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Averaging each activity and each subject as Tidy Data
tidyData <- aggregate(AllDF[,names(AllDF) != "ActID" & names(AllDF) != "SubID"],by=list
                        (ActID=AllDF$ActID,
                                SubID=AllDF$SubID),mean);

# Export tidyData set 
write.table(tidyData, './FinalTidyData.txt',row.names=FALSE,sep='\t')