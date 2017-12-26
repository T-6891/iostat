#!/usr/bin/env bash
#
# Script iostat collect 
#

killall iostat
rm -rf /tmp/iostat-collect.tmp
iostat -dx 1 > /tmp/iostat-collect.tmp &

