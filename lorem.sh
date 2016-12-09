#!/bin/bash

# Lorem ipsum generator script
# Version: 0.2
#
# Generates one or more paragraphs of sample text.
#
# Can take piped input to disasemble and re-stitch
# into sample text. Otherwise, defaults to plain
# old, boring lorem ipsum.
#
# Example usage:
# 	links -dump "http://lorizzle.nl/?feed=1" | lorem.sh
# 	echo "something something something" | lorem.sh
# 	lorem.sh -p 4 -s 12
#
# TODO Introduce some more elaborate punctuation
# TODO Introduce some numbers, with way smaller frequency than words

if [ -p /dev/stdin ]; then
	# Take what's piped to us as input, if anything
	RAW=$(cat)
else
	# Default to plain old lorem ipsum
	RAW="lorem ipsum dolor sit amet consectetur adipiscing elit in congue augue a est sollicitudin porttitor morbi et convallis nisl et condimentum metus phasellus laoreet nisl nec velit placerat eu commodo tortor feugiat pellentesque pharetra dui sed velit viverra a tempus arcu molestie aliquam erat volutpat vestibulum nisl mauris pulvinar vel massa vel egestas congue tortor sed a mollis nunc donec sit amet maximus massa non accumsan eros morbi malesuada nibh ante eget fringilla nisi aliquam vitae curabitur arcu turpis porttitor in dui et dapibus placerat odio duis fermentum turpis sed nunc vehicula quis facilisis metus sodales proin in convallis urna phasellus sit amet viverra sem at sodales lacus sed a efficitur arcu ut pellentesque purus proin semper enim magna sollicitudin pretium nulla sodales ut aenean consequat feugiat urna a sagittis"
fi

# Clean up and normalize what we got - we only
# want to deal with space-separated, human-ish, 
# word-ish, lowercased entities
RAW=$(echo "$RAW" \
	| tr "\n" " " \
	| sed \
		-e 's/[^A-Za-z ]//g' \
		-e 's/  */ /g' \
		-e 's/^ //g' \
		-e 's/ $//g' \
	| tr "[:upper:]" "[:lower:]"
)

# At this point, we have to have *something* to work with
if [ "" == "$RAW" ]; then
	exit 1
fi

# Make sure we have a sample long enough
while [ $(echo "$RAW" | wc -w) -lt 100 ]; do
	RAW="$RAW $RAW"
done

# Defaults: paragraphs
PARAGRAPHS=1
# Defaults: sentences
SENTENCES=5
# Defaults: maximum sentence length (in words)
MAXLENGTH=10
# Defaults: clipboard command
CLIPCMD="xclip -i -sel c"
# Defaults: pipe command
PIPECMD="tee >($CLIPCMD)"

# Parse user input and override defaults
while getopts "p:s:dq" opt
do
	case $opt in
		p)
			PARAGRAPHS=$OPTARG
			;;
		s)
			SENTENCES=$OPTARG
			;;
		q)
			# Quiet mode - do not echo, just clip
			PIPECMD="$CLIPCMD"
			;;
		d)
			# Dry mode - don't touch the clipboard
			PIPECMD="tee"
			;;
	esac
done

# Separate the input into array of words
WORDS=($(echo "$RAW" | tr " " "\n"))

# Hold the output here until we're ready to spit it out
OUT=""

# Local sentences amount - this is the value
# that will be used in actual iteration.
# Use this instead of the default so we can
# distribute the number of sentences per paragraph
# if we're building more than one
LSENTENCES=$SENTENCES

for para in $(seq 1 $PARAGRAPHS); do
	
	# Let's vary sentences count per paragraph
	# if we'll be making more than one
	if [ $PARAGRAPHS -gt 1 ]; then
		LSENTENCES="$(shuf -i2-$SENTENCES -n1)"
	fi

	for snt in $(seq 1 $LSENTENCES); do
		# Determine the length of this sentence
		LENGTH=$(shuf -i3-"$MAXLENGTH" -n1)
		
		# We need to start somewhere, but let's
		# make sure we have enough words to work with
		MAXWORDS=$(expr "${#WORDS[@]}" - $LENGTH) # 
		START=$(shuf -i1-"$MAXWORDS" -n1)
		
		# Extract the words to be used for this sentence
		LOCALWORDS=("${WORDS[@]:$START:$LENGTH}")

		HAS_DOT="yes"
		for idx in "${!LOCALWORDS[@]}"; do
			WRD="${LOCALWORDS[$idx]}"

			# Capitalize the first word
			if [ "yes" == "$HAS_DOT" ]; then
				HAS_DOT="no"
				WRD=$(echo "${WRD^}")
			fi

			OUT="$OUT $WRD"
		done
		OUT="$OUT."
	done
	OUT="$OUT"$'\n\n'
done

echo "$OUT" \
	| sed -e 's/^ //' \
	| sed -e '$ d' \
	| sed -e '$ d' \
	| eval $PIPECMD
