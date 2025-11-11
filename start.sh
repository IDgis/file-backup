#!/bin/bash

set -eu

if [ ! -d /backup ]; then
	echo Error: directory /backup does not exist, backup volume missing?
	exit 1
fi

echo Generating config...

# store ssh key
mkdir -p /root/.ssh
ssh-keyscan -p $SFTP_PORT $SFTP_HOST > ~/.ssh/known_hosts

# store backup url
echo BACKUP_URL=sftp://$SFTP_USER:$SFTP_PASSWORD@$SFTP_HOST:$SFTP_PORT/$BACKUP_NAME > /etc/backup
if [[ -v PASSPHRASE ]]; then
	echo PASSPHRASE=$PASSPHRASE >> /etc/backup
else
	echo NO_ENCRYPTION=true >> /etc/backup
fi

mkfifo /opt/fifo
# tigger 'tail -f' to open fifo
echo Logging started... > /opt/fifo &

echo "00 5 * * * root /opt/backup.sh > /opt/fifo 2>&1" > /etc/crontab

echo Starting cron...

cron
tail -f /opt/fifo
