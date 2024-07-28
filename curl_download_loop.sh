# This script will download a file, write it to Linux null file, output the download speed in MB/s, wait for 5 seconds and repeat it again.

#!/bin/sh
count=0
while [ 1 ]; do
  let count=$(( $count + 1 ))
  echo "download #$count started"
  
  # Start the file download by limiting the download speed to 3Mbps and writing the output to Linux null file
  speed=$(curl https://testfile.org/file-1GB --limit-rate 3M -o /dev/null -w "%{speed_download}")

  # Print the raw speed value
  echo "Raw speed value: '$speed'"

  # Remove any non-numeric characters except the dot
  speed=$(echo "$speed" | sed 's/[^0-9.]//g')

  if [ -n "$speed" ] && [ "$speed" != "0" ]; then
    speed_MBps=$(echo "scale=3; $speed / 1048576000" | bc)  # Convert to MB/s
    echo "download #$count finished with an average speed $speed_MBps MB/s"
  else
    echo "download #$count finished with an average speed of 0 MB/s"
  fi

  sleep 5
done
