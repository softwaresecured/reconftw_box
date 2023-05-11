# reconftw_box
Offloading reconftw to a separate instance so we don't clog up network traffic and hog our local resources

## INSTALLATION

1) Unpack all of these files directly into your main reconftw directory (the dir that includes the main `reconftw.sh` script)
2) Modify the main `reconftw.sh` script to include the following 3 lines directly at the top of the script:
    ```bash
    start_next_scan="/home/ubuntu/reconftw-main/start_next_scan.sh"
    delete_queued_scan="/home/ubuntu/reconftw-main/delete_queued_scan.sh"
    current_scan="$0 $@"
   ```
   **NOTE:** You must define the full correct path to those files on your system in the first 2 lines
3) Modify the main `reconftw.sh` script by adding the following function above the original `end()` function:
    ```bash
   function delete_queued_scan(){

            #current_scan="$0 $@"

            read -r next_scan < /home/ubuntu/reconftw-main/queued_scans.rftw
            echo "This is the current scan name:"
            echo "$current_scan"

            echo "This is the next queued scan:"
            echo "$next_scan"

            #if the current scan is the same as the top queued scan, delete the scan from the queue on completion of scan
            if [[ $current_scan == $next_scan ]]; then
                echo "Scan complete - deleting this scan from the queue"
                sed -i '1d' /home/ubuntu/reconftw-main/queued_scans.rftw
            else
                echo "Next queued scan not deleted."
            fi
    } 
    ```

4) Modify the `end()` function in the main `reconftw.sh` script to call the newly added `delete_queued_scan()` function:
    ```bash
    ...snip...
      [ "$SOFT_NOTIFICATION" = true ] && echo "Finished Recon on: ${domain} under ${finaldir} in: ${runtime}" | notify -silent
            printf "${bgreen}#######################################################################${reset}\n"
            #Seperator for more clear messges in telegram_Bot
            echo "******  Stay safe 🦠 and secure 🔐  ******" | $NOTIFY
    
            delete_queued_scan
            . "$start_next_scan"
    
    }
    ```

6) Pray 🙏

## HOW TO USE

- Instead of calling the main `reconftw.sh` script with args as you usually would, instead, call the "check_active_scans.sh" script with your scan arguments. This checks for running instances of scans and will prompt you to add your scan to the queue if there is already scan running.
    - Eg.: `./check_active_scans.sh -d demo.testfire.net -s`
- If there are no scans actively running, your scan will kick off like normal
- If there is a scan actively running, you will be prompted to put your desired scan into the queue
- Your scan details will be pushed into `queued_scans.rftw` and will eventually be called when the current scan is complete 
