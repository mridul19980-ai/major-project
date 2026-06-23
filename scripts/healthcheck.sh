#!/bin/bash
URL="http://localhost"
STATUS=$(curl -o /dev/null -s -w "%{http_code}\n" $URL)
if [ "$STATUS" -eq 200 ] || [ "$STATUS" -eq 502 ]; then
    echo "Cluster Entry Point Status: $STATUS (Responsive)"
else
    echo "CRITICAL: Cluster entry point unreachable. Status: $STATUS"
fi
