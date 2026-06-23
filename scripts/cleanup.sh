#!/bin/bash
# Clean up logs older than 7 days
find /var/log -type f -name "*.log" -mtime +7 -exec truncate -s 0 {} \;
# Clean up unused local Docker caches
docker system prune -f --volumes
echo "System clean up tasks executed successfully."
