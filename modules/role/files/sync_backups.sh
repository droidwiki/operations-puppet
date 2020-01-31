#!/usr/bin/env bash

set -e
export AWS_PROFILE=backups

currentDate=$(data +%F)
aws s3 sync /data/backup/db/automysqlbackup/daily/ "s3://droidwiki-backups/${currentDate}/db/" --recursive --no-progress
aws s3 sync /data/shareddata/mediawiki/ "s3://droidwiki-backups/${currentDate}/mw_images/" --recursive --exclude "temp/" --no-progress
aws s3 sync /data/shareddata/www/missionrhode.go2tech.de/public_html/wp-content/uploads "s3://droidwiki-backups/${currentDate}/mr_wp/" --recursive --no-progress
