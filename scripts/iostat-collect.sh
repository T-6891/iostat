#!/usr/bin/env bash

killall iostat
rm -rf /tmp/test-iops.txt
iostat -dx 1 > /tmp/test-iops.txt &
