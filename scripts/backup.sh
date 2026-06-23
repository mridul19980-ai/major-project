#!/bin/bash
BACKUP_DIR="/home/ubuntu/backups"
mkdir -p $BACKUP_DIR
TIMESTAMP=$(date +"%F_%T")
# Backup running DB inside K8s
sudo kubectl exec $(sudo kubectl get pods -l app=mysql -o jsonpath="{.items[0].metadata.name}") -- mysqldump -u root -p$(sudo kubectl get secret app-secrets -o jsonpath="{.data.MYSQL_ROOT_PASSWORD}" | base64 --decode) webapp_db > $BACKUP_DIR/db_backup_$TIMESTAMP.sql
echo "Backup saved successfully at $BACKUP_DIR/db_backup_$TIMESTAMP.sql"
