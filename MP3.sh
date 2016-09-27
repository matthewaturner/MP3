#!/bin/bash

PID="0"
re='^[0-9]+$' # Regex for number type checking

while true; do
  printf "Enter your PID\n['q' for quit]: "; read PID;
  if [ "$PID" == "q" ]; then
    break
  elif ! [[ $PID =~ $re ]] || ! [ -d "/proc/$PID/" ]; then
    printf "Not a valid PID, try again.\n\n"
  else
    printf "\nPID INFO FOR: $PID\n----\n"
	
	# Identifiers
	awk '/^Pid/ {print "PID:\t" $2}' /proc/$PID/status		#Pid
	awk '/^PPid/ {print "PPID:\t" $2}' /proc/$PID/status	#PPid
	awk '/^Uid/ {print "EUID:\t" $3}' /proc/$PID/status		#EUid - Effective
	awk '/^Gid/ {print "EGID:\t" $3}' /proc/$PID/status		#EGid - Effective
	awk '/^Uid/ {print "RUID:\t" $2}' /proc/$PID/status		#RUid - Real
	awk '/^Gid/ {print "RGID:\t" $2}' /proc/$PID/status		#RGid - Real
	awk '/^Uid/ {print "FSUID:\t" $5}' /proc/$PID/status	#FSUid - File System
	awk '/^Gid/ {print "FSGID:\t" $5}' /proc/$PID/status	#FSGid - File System
	
	# State
	awk '/State/ {$1 = ""; print "STATE:\t" $0}' /proc/$PID/status
	
	# Thread Information
	# 	Assuming this is talking about the Tgid?
	# 	Only other thread info I can see is the number of threads in process containing this thread.
	#	Going to print both for now.
	awk '/^Tgid/ {print "TGID:\t" $2}' /proc/$PID/status				#Tgid
	awk '/^Threads/ {print "THREAD COUNT:\t" $2}' /proc/$PID/status		#Threads
	
	# Priority - See 'man proc 5' for location info
	awk '{print "PRIORITY NUMBER: " $18}' /proc/$PID/stat	#priority
	awk '{print "NICENESS VALUE:\t" $19}' /proc/$PID/stat	#nice
	
	# Time Information - See 'man proc 5' for location info
	awk '{print "STIME:\t" $15}' /proc/$PID/stat	#stime
	awk '{print "UTIME:\t" $14}' /proc/$PID/stat	#utime
	awk '{print "CSTIME:\t" $17}' /proc/$PID/stat	#cstime
	awk '{print "CUTIME:\t" $16}' /proc/$PID/stat	#cutime
	
	# Address Space - See 'man proc 5' for location info
	awk '{print "STARTCODE:\t" $26}' /proc/$PID/stat		#Startcode
	awk '{print "ENDCODE:\t" $27}' /proc/$PID/stat			#Endcode
	awk '{print "ESP / KSTKESP:\t" $29}' /proc/$PID/stat	#ESP / Stack Pointer / kstkesp
	awk '{print "EIP / KSTKEIP:\t" $30}' /proc/$PID/stat	#EIP / Instruction Pointer / kstkeip
	
	# Resources
	printf "NUMBER OF FDS USED:\t\t"; cd /proc/$PID/fd; lsof | wc -l;										# Number of allocated file handles - Not sure if this is what they wanted on this one.
	awk '/^voluntary_ctxt_switches/ {print "VOLUNTARY CONTEXT SWITCHES:\t" $2}' /proc/$PID/status			#voluntary_ctxt_switches / Voluntary Context Switches
	awk '/^nonvoluntary_ctxt_switches/ {print "NONVOLUNTARY CONTEXT SWITCHES:\t" $2}' /proc/$PID/status		#nonvoluntary_ctxt_switches / Nonvoluntary Context Switches
	
	# Processors - See 'man proc 5' for location info
	awk '/^Cpus_allowed_list/ {$1 = ""; print "ALLOWED PROCESSORS:\t" $0 }' /proc/$PID/status	#Cpus_allowed_list - Allowed Processors
	awk '{print "LAST USED PROCESSOR:\t" $39}' /proc/$PID/stat									#processor - Last Used Processor
	
	# Memory Map - MUST OUTPUT FILE CONTAINING THIS INFORMATION - Have yet to output info
		# Address Range
		# permissions
		# offset
		# dev
		# inode
		# path name
	
	printf "\n"
  fi
done
echo "Exiting."