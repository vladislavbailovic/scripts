#!/bin/bash

# Creates images from figlet|toilet output

RAW="$(figlet 'doom')"
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

if [ -p /dev/stdin ]; then
	convert 'fd:0' -font $FONT -pointsize 10 -gravity center \
		-stroke white -strokewidth 2 -annotate 0 "$CONTENT" \
		-stroke none -fill black -annotate 0 "$CONTENT" \
	'png:-'
else
	convert -size '300x100' -font $FONT -pointsize 10 -gravity center \
		-background white -fill black \
		label:"$CONTENT" \
	'png:-'
fi
