#!/usr/bin/env bash

# This will kick off the next reconftw scan that is present in the queued_scans.rftw file
# Add a check for if the line is blank or else there will be an infinite loop scenario

read -r next_scan < /home/ubuntu/reconftw-main/queued_scans.rftw 	# Saves the first line of queued_scans.rftw to $next_scan

if [[ $next_scan == "" ]]; then		# Checks to see if the line is blank, aka no queued scans.
	echo "No more queued scans... finally."
else
	echo "We are starting th next scan"
	sleep 10
	nohup $next_scan& >/dev/null 2>&1 	# This will call the next scan
fi

#	TODO
# - Remove the top line from the file once the scan is complete
# this should maybe happen at the end of the actual reconftw.sh script
# so that lines are only removed once the scan actually finishes
# - Modify the reconftw.sh script to call this script when it finishes
