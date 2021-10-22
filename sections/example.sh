#!/bin/bash

# set file name
fileName="testFile.txt"

# create file
touch $fileName

# intro message
echo "I'm your new test script!" >> $fileName
echo >> $fileName
echo >> $fileName

# fill it with some things
for i in {1..10}
do
        echo $i >> $fileName
done

# finish it out
echo >> $fileName
echo >> $fileName
echo "All Finished!" >> $fileName
