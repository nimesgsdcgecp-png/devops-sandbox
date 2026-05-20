#!/bin/bash

# 1. Define Variables
    BACKUP_DIR="/home/$USER/project-sandbox/backups"
    TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
    FILENAME="sandbox_db_$TIMESTAMP.sql"

# 2. Dump the database 
# We use 'sudo -u postgres' to bypass password prompts by acting as the system DB admin
    sudo -u postgres pg_dump sandbox_db > $BACKUP_DIR/$FILENAME

# 3. Compress the SQL file into a smaller .gz archive
    gzip $BACKUP_DIR/$FILENAME

# 4. Clean up old backups (Find files older than 7 days and delete them)
    find $BACKUP_DIR -type f -name "*.gz" -mtime +7 -exec rm {} \;

# 5. Log the success
    echo "Backup completed successfully at $TIMESTAMP" >> $BACKUP_DIR/backup_log.txt
