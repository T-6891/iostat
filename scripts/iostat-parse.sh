#!/usr/bin/env bash
#
# Description:  Script for disk monitoring
# Author:       Epikhin Mikhail michael@nomanlab.org
# Revision 1:   Lesovsky A.V. lesovsky@gmail.com
# Revision 2:   Oleg Evdokimov spionsbbs@gmail.com
# Revision 3:   Vladimir Smelnitskiy master@T-Brain.ru

NUMBER=0
FROMFILE=$1
DISK=$2
METRIC=$3

[[ $# -lt 3 ]] && { echo "FATAL: some parameters not specified"; exit 1; }
[[ -f "$FROMFILE" ]] || { echo "FATAL: datafile not found"; exit 1; }

case "$3" in
"rrqm/s")
    NUMBER=2
;;
"wrqm/s")
    NUMBER=3
;;
"r/s")
    NUMBER=4
;;
"w/s")
    NUMBER=5
;;
"rkB/s")
    NUMBER=6
;;
"wkB/s")
    NUMBER=7
;;
"avgrq-sz")
    NUMBER=8
;;
"avgqu-sz")
    NUMBER=9
;;
"await")
    NUMBER=10
;;
"r_await")
    NUMBER=11
;;
"w_await")
    NUMBER=12
;;
"svctm")
    NUMBER=13
;;
"util")
    NUMBER=14
;;
*) echo ZBX_NOTSUPPORTED; exit 1 ;;
esac

if [[ "$DISK" != "total" ]]
then grep -w $DISK $FROMFILE | tail -n 60 | tr -s ' ' |awk -v N=$NUMBER 'BEGIN {sum=0.0;count=0;} {sum=sum+$N;count=count+1;} END {printf("%.2f\n", sum/count);}'
else cat $FROMFILE | tail -n 60 | tr -s ' ' |awk -v N=$NUMBER 'BEGIN {sum=0.0;count=0;} {sum=sum+$N;count=count+1;} END { cmd ="iostat -d | tail -n +4 | head -n -1 | wc -l"; cmd | getline disk; close(cmd); printf("%.2f\n", sum*disk/count);}'
fi

