# This script will run on a MESH device's console and try to steer the given WiFi client from one mesh radio to another mesh radio. For debugging purposes, log level will be increased before the steering and decreased 30 seconds after the steering.

#!/bin/bash

echo "STARTING SCRIPT"

# Check if six parameters are passed
if [ $# -ne 6 ]; then
  echo "Usage: $0 <SOURCE_DEVICE> <SOURCE_BAND> <TARGET_DEVICE> <TARGET_BAND> <CLIENT_DEVICE_NAME> <CHANNEL>"
  exit 1
fi

# Assign parameters to variables
SOURCE_DEVICE=$1
SOURCE_BAND=$2
TARGET_DEVICE=$3
TARGET_BAND=$4
CLIENT_DEVICE_NAME=$5
CHANNEL=$6

# Define MAC addresses for SOURCE_DEVICE
if [ "$SOURCE_DEVICE" == "373F" ]; then
  ALMAC_SOURCE="AA:AA:BB:BB:37:3F"
  if [ "$SOURCE_BAND" == "2G" ]; then
    BSSID="AA:AA:BB:BB:37:3F"
  else
    BSSID="AA:AA:BB:BB:37:41"
  fi
elif [ "$SOURCE_DEVICE" == "ACD2" ]; then
  ALMAC_SOURCE="AA:AA:BB:BB:AC:D2"
  if [ "$SOURCE_BAND" == "2G" ]; then
    BSSID="AA:AA:BB:BB:AC:D2"
  else
    BSSID="AA:AA:BB:BB:AC:D4"
  fi
elif [ "$SOURCE_DEVICE" == "EC98" ]; then
  ALMAC_SOURCE="AA:AA:BB:BB:EC:98"
  if [ "$SOURCE_BAND" == "2G" ]; then
    BSSID="AA:AA:BB:BB:EC:98"
  else
    BSSID="AA:AA:BB:BB:EC:9A"
  fi
else
  echo "Invalid SOURCE_DEVICE."
  exit 1
fi

# Define MAC addresses for TARGET_DEVICE
if [ "$TARGET_DEVICE" == "373F" ]; then
  TARGETBSSID="AA:AA:BB:BB:37:3F"
elif [ "$TARGET_DEVICE" == "ACD2" ]; then
  TARGETBSSID="AA:AA:BB:BB:AC:D2"
elif [ "$TARGET_DEVICE" == "EC98" ]; then
  TARGETBSSID="AA:AA:BB:BB:EC:98"
else
  echo "Invalid TARGET_DEVICE."
  exit 1
fi

# Define CLIENT_DEVICE
if [ "$CLIENT_DEVICE_NAME" == "iphone" ]; then
  CLIENT_DEVICE="AA:AA:BB:BB:6A:84"
elif [ "$CLIENT_DEVICE_NAME" == "linux_pc" ]; then
  CLIENT_DEVICE="AA:AA:BB:BB:C8:AF"
elif [ "$CLIENT_DEVICE_NAME" == "windows_pc" ]; then
  CLIENT_DEVICE="AA:AA:BB:BB:35:82"
else
  echo "Invalid CLIENT_DEVICE_NAME. Use 'iphone', 'linux_pc', or 'windows_pc'."
  exit 1
fi

# Construct the steering command
STEER_COMMAND="commandToSteer -fromMeshRadio $ALMAC_SOURCE -fromMeshBSSID $BSSID -clientDevice $CLIENT_DEVICE -toMeshBSSID $TARGETBSSID,128,$CHANNEL"

# Print the command for debugging
# echo "Steering command: $STEER_COMMAND"

# Set debug level to 4
commandToSetDebugLevel -s 4
commandToSetDebugLevel -s 4

# Send client steering request with the correct MAC addresses
commandToSteer -fromMeshRadio $ALMAC_SOURCE -fromMeshBSSID $BSSID -clientDevice $CLIENT_DEVICE -toMeshBSSID $TARGETBSSID,128,$CHANNEL

# Wait for 30 seconds
sleep 30

# Set debug level to 2
commandToSetDebugLevel -s 2
commandToSetDebugLevel -s 2

# Loop to show client information three times with 3 seconds interval
for i in {1..3}; do
  commandToShowClientList
  sleep 3
done

# SCRIPT FINISHED
echo "SCRIPT FINISHED"
