#!/usr/bin/env bash

set -e
export AWS_PROFILE=backups

currentDate=$(date +%F)
echo "Syncing db backups..."
aws s3 sync /data/backup/db/automysqlbackup/daily/ "s3://droidwiki-backups/${currentDate}/db/" --no-progress --quiet
echo "Syncing droidwiki images..."
aws s3 sync /data/shareddata/mediawiki/images/ "s3://droidwiki-backups/${currentDate}/mw_images/" --exclude "temp/" --no-progress --quiet
echo "Syncing missionrhode uploads..."
aws s3 sync /data/shareddata/www/missionrhode.go2tech.de/public_html/wp-content/uploads/ "s3://droidwiki-backups/${currentDate}/mr_wp/" --no-progress --quiet
