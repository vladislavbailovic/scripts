#!/bin/bash

# Creates test image

HSIZE=200
VSIZE=100
SIZE="$HSIZE"'x'"$VSIZE"

# Define colors, say 100
for i in $(seq 1 100); do
	tmp='rgb('
	tmp="$tmp"$(shuf -i1-255 -n 1)","
	tmp="$tmp"$(shuf -i1-255 -n 1)","
	tmp="$tmp"$(shuf -i1-255 -n 1)")"
	COLORS[$i]="$tmp" 
done;

COL1IDX="$(shuf -i1-100 -n1)"
COL1="${COLORS[$COL1IDX]}"

COL2IDX="$(shuf -i1-100 -n1)"
COL2="${COLORS[$COL2IDX]}"

COLRANGE="$COL1"'-'"$COL2"

CMD="convert -size '$SIZE' 'plasma:$COLRANGE' 'jpeg:-'"
PIXELATED="$CMD | convert -scale '5%' -scale '$SIZE'! 'jpeg:-' 'jpeg:-'"

eval $PIXELATED
