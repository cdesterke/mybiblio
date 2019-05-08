#!/bin/bash


#usage : ./start.sh "YOUR NAME"

variable=${1}
if [ -z "${variable}" ]
then 
	echo "TEXTTAB file not passed as parameter"
	exit 1
fi

nom=$(echo $1)

echo $nom

#cd lib
./lib/bibliobypubmed.r "$nom"


mkdir RESULTS



mv bibliobyjournal.pdf RESULTS
mv bibliobyjournal.txt RESULTS
mv bibliobyyear.pdf RESULTS
mv bibliobyyear.txt RESULTS

pwd 

exit 0
