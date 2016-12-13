#!/bin/bash

# Creates test image

HSIZE=200
VSIZE=100
SIZE="$HSIZE"'x'"$VSIZE"

# Define colors, say 100
for i in $(seq 1 100); do
	R=$(shuf -i1-255 -n 1)
	G=$(shuf -i1-255 -n 1)
	B=$(shuf -i1-255 -n 1)
	COLORS[$i]="rgb($R,$G,$B)" 
done;

COL1IDX="$(shuf -i1-100 -n1)"
COL1="${COLORS[$COL1IDX]}"

COL2IDX="$(shuf -i1-100 -n1)"
COL2="${COLORS[$COL2IDX]}"

COLRANGE="$COL1"'-'"$COL2"
FORMAT="png"

PIXELATE="no"

OPTIMIZATION="-quality 95 -depth 8"
COMMAND="convert -size '$SIZE' 'plasma:$COLRANGE' $OPTIMIZATION '$FORMAT:-'"
if [ "yes" == "$PIXELATED" ]; then
	COMMAND="$COMMAND | convert -scale '5%' -scale '$SIZE'! '$FORMAT:-' '$FORMAT:-'"
fi

eval $COMMAND
