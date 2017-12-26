#!/bin/bash

killall iostat
rm -rf /tmp/iostat-collect.tmp
iostat -dx 1 > /tmp//tmp/iostat-collect.tmp &
