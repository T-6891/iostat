#!/usr/bin/env bash
#
# Script iostat collected

killall iostat
rm -rf /tmp/iostat-collect.tmp
iostat -dx 1 > /tmp//tmp/iostat-collect.tmp &
