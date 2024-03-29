#!/bin/bash

set -eu

echo Restoring back-up ...

# Store ssh key
mkdir -p /root/.ssh
ssh-keyscan -p $SFTP_PORT $SFTP_HOST > ~/.ssh/known_hosts

# Restore back-up using duplicity
duplicity restore \
    --no-encryption \
    --force \
    sftp://$SFTP_USER:$SFTP_PASSWORD@$SFTP_HOST:$SFTP_PORT/$BACKUP_NAME \
    /backup

echo Back-up restored: $(date)
