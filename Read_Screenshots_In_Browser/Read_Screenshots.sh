#!/bin/bash

# The Script is basically you should be at the directory of the screenshots were taken and then the ls command would take the name of them and then create index.html file that contains those names of the picture with the picture under it, so it's a html nice file to open it on the browser and fast and ease your work during check the screenshots that tooks from specific target


for i in $(ls)
do
	echo "<h3>$i</h3>" >> index.html
	echo "<img src=$i><br>" >> index.html
done

