#!/bin/bash

PID="0"
PIDLIST=""

while true; do
  echo -n "Enter your PID [0-100] ['q' for quit]: "; read PID;
  if (("$PID" < "0"))  || (("$PID" > "100")); then
    echo "Invalid PID, try again."
  elif [ "$PID" == "q" ]; then
    echo "All Entered PIDs: $PIDLIST"
    break
  else
	#PIDLIST += PID
    echo "PID INFO FOR: $PID"
  fi
done
echo "Exiting."