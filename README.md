# TidyData
Submission to TidyData

##CODE DESCRIPTION

1. Imports and merges the following into AllDF
   a. labels
      activity_labels.txt
      features.txt
   b. data
      subject_test.txt
      x_test.txt
      y_test.txt
      subject_train.txt
      x_train.txt
      y_train.txt

2. Creates a logical vector where the subject ID, Activity Type, Activity ID, Mean variables, and SD variables and applies it to AllDF

3. Use and merge activity_labels to match the activity_type

4. Clean the column names using gsub and regular expressions in a loop over the vector of column names, then apply the edited names to AllDF

5. Create the tidy data set with the average of each variable for each activity and each subject, then export


      
