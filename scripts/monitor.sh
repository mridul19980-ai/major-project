#!/bin/bash
THRESHOLD=80
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    echo "CRITICAL: Disk Usage is above ${THRESHOLD}%. Current usage: ${DISK_USAGE}%" | mail -s "Disk Space Alert" root@localhost
else
    echo "Disk Health OK: ${DISK_USAGE}% usage."
fi
