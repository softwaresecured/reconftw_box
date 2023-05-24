current_scan="$0 $@"

read -r next_scan < /home/ubuntu/reconftw-main/queued_scans.rftw

#echo "$current_scan"

#echo "$next_scan"

#if the current scan is the same as the top queued scan, delete the scan from the queue on completion of scan
if [[ $current_scan == $next_scan ]]; then
	echo "They are the same"
	sed -i '1d' /home/ubuntu/reconftw-main/queued_scans.rftw
else
	echo "Next queued scan not deleted."
fi
