#!/usr/bin/env bash

# Description:  Script for disk monitoring and iostat data collection
# Author:       Vladimir Smelnitskiy master@T-Brain.ru

FROMFILE="/tmp/iostat-collect.tmp"
PIDFILE="/tmp/iostat-collect.pid"
DISK=$1
METRIC=$2

# Check the number of arguments and the existence of data file
[[ $# -lt 2 ]] && { echo "FATAL: some parameters not specified"; exit 1; }
[[ -f "$FROMFILE" ]] || { echo "FATAL: datafile not found"; exit 1; }

# Check if iostat is running and start it if not
if [[ -f "$PIDFILE" ]] && kill -0 $(cat "$PIDFILE"); then
    echo "iostat is already running."
else
    echo "Starting iostat..."
    iostat -dx 1 > "$FROMFILE" &
    echo $! > "$PIDFILE"
fi

case "$METRIC" in
"rrqm/s")   NUMBER=2 ;;
"wrqm/s")   NUMBER=3 ;;
"r/s")      NUMBER=4 ;;
"w/s")      NUMBER=5 ;;
"rkB/s")    NUMBER=6 ;;
"wkB/s")    NUMBER=7 ;;
"avgrq-sz") NUMBER=8 ;;
"avgqu-sz") NUMBER=9 ;;
"await")    NUMBER=10 ;;
"r_await")  NUMBER=11 ;;
"w_await")  NUMBER=12 ;;
"svctm")    NUMBER=13 ;;
"util")     NUMBER=14 ;;
*) echo ZBX_NOTSUPPORTED; exit 1 ;;
esac

LINES=$(tail -n 60 "$FROMFILE")

if [[ "$DISK" != "total" ]]; then
    CMD="grep -w $DISK"
    END_CMD=""
else
    CMD="cat"
    END_CMD='; cmd ="iostat -d | tail -n +4 | head -n -1 | wc -l"; cmd | getline disk; close(cmd); printf("%.2f\n", sum*disk/count);'
fi

echo "$LINES" | $CMD | tr -s ' ' |awk -v N=$NUMBER 'BEGIN {sum=0.0;count=0;} {sum=sum+$N;count=count+1;} END {printf("%.2f\n", sum/count);}'"$END_CMD"
