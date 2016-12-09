#!/bin/bash

# Vagrant environment turn off script

# It will just go through all the Vagrant machines
# and turn off one by one if they're powered up

# Obtain the status info about the requested Vagrant envinronment
# This will be a formatted line, e.g. something like this:
# 2ac90e2  default virtualbox poweroff /home/ve/Vagrants/5.3
INFO=$(vagrant global-status | awk "/virtualbox/{print \$0;}")
if [ "" == "$INFO" ]; then
	echo "No status info found for the requested environment, aborting"
	exit 1
fi

IFS=$'\n' # We will be running a loop by newline chars here
for ENTRY in $INFO; do
	INAME=$(echo $ENTRY | awk '{print $1}')
	ISTATE=$(echo $ENTRY | awk '{print $4}')
	if [[ "" == "$INAME" || "" == "$ISTATE" ]]; then
		echo "Unable to parse name ($INAME) and/or state ($STATE) from entry string, carrying on"
		continue
	fi

	# Okay so now we power this shit down
	if [ "poweroff" == "$ISTATE" ]; then
		echo "The machine [[$INAME]] is already powered off, carrying on"
		continue
	else
		echo "Machine [[$INAME]] is currently running. Attempting to shoot it down"
		vagrant halt $INAME
	fi;
done

