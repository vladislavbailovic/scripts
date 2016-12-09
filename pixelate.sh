#!/bin/bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for file in `find . -name "*jpg"`
do
	size=`identify -format "%[fx:w]x%[fx:h]" "$file"`
	echo "Processing $file $size"
	convert "$file" -scale "5%" -scale "$size"! "$file"
done

IFS=$SAVEIFS
