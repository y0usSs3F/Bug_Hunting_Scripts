#!/bin/bash

# The Script is basically you should be at the directory of the screenshots were taken and then the ls command would take the name of them and then ...


for i in $(ls)
do
	echo "<h3>$i</h3>" >> index.html
	echo "<img src=$i><br>" >> index.html
done
