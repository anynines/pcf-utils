#!/bin/bash

if [ "$(uname -s)" != 'Darwin' ]; then
  echo "Are you sure? This script is for development only..."
  exit 1
fi

cd $(dirname $0)

backups="Backup_$(date +%Y_%m_%d)
Backup_$(date -v-1d +%Y_%m_%d)
Backup_$(date -v-2d +%Y_%m_%d)
Backup_$(date -v-3d +%Y_%m_%d)
Backup_$(date -v-4d +%Y_%m_%d)
Backup_$(date -v-5d +%Y_%m_%d)
Backup_$(date -v-6d +%Y_%m_%d)
Backup_$(date -v-1w +%Y_%m_%d)
Backup_$(date -v-6d +%Y_%m_%d)
Backup_$(date +%Y_11_%d)
Backup_$(date +%Y_12_%d)
Backup_$(date +%Y_01_%d)"

backups=$(sort -n <<<"$backups")

echo "
Preparing test cases
====================

"
# echo "$backups"
[ -d "BACKUPS" ] && rm -R BACKUPS
while read backupname; do
  backupname="BACKUPS/$backupname"
  echo "$backupname: CREATED"
  mkdir -p "$backupname"
  if [ $((1+ RANDOM % 10)) -ge 6 ]; then
    echo "$backupname: SUCCESSFUL" | tee "$backupname/backup"
  else
    echo "$backupname: FAILED"
  fi
done <<<"$backups"

echo "

Preparations DONE

"
