An R script was used to process the following raw data files.

activity_labels.txt - name and code that identify the activity the volunteer is performing.
features.txt - label for the standard deviation or mean value that is captured.
subject_test.txt - test volunteer id code for the standard deviation or mean value that is captured in s_test.txt.
subject_train.txt - train volunteer id code for the standard deviation or mean value captured in feature.txt
x_test.txt - feature measure for the test volunteers.
y_test.txt - activity code for the standard deviation or mean value that is captured in feature.txt for the test volunteers.
x_train.txt - feature measure for the train volunteer subjects.
y_train.txt - activity code for the standard deviation or mean value that is captured in feature.txt for the train volunteers.

Test files were read and processed first by giving unique column names to the key values in the subject_test frame and activity_Labels data frame.  Then those renamed columns were bound together.  The same was done with the corresponding train data frames.

Train and test variables were then row binded to form one dataframe.

Next a join was performed to add activity labels to the dataframe.

Next the feature.txt file was search to select the name of the feature measures that are required for our output.  Those names were searched and the abbreviations in them were translated into words.

An empty data frame and temporary list were created.  A while loop was used to select the aforementioned features and add them to the temporary list and then bind the columns to the dataframe.

The category variables columns were then bound to the feature measures.  The mean of each feature measure was computed and the completed file was output to a comma delimited text file without row names.





