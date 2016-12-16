#!/bin/bash

# Creates images from figlet|toilet output
if [ -p /dev/stdin ]; then
	RAW=$(cat)
else
	RAW="Test test test"
fi

CONTENT=""
oldIFS="$IFS"
IFS=
while read -r line; do
	CONTENT="$CONTENT\n$line"
done <<< $(echo "$RAW")
IFS="$oldIFS"

# Font list
FONTS=($(convert -list font | grep -i 'font: .*mono' | sed -e 's/^.*: //'))
IDX=$((RANDOM%${#FONTS[@]}))
FONT=${FONTS[$IDX]}

convert -size '300x100' -font $FONT -pointsize 10 -background white -fill black label:"$CONTENT" 'png:-'
#exec "$COMMAND"
