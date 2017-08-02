#!/bin/bash
cd $(dirname $0)
MYPATH=$(pwd)
set -o nounset
# set -o errexit
# set -o pipefail

# ==============================================================================
#
# Configuration
#
# ==============================================================================
BACKUP_RETENTION=4
MIN_BACKUP_SIZE="1"
CONFIG="$(dirname $MYPATH)/config/environment.sh"
[ ! -f "$CONFIG" ] && CONFIG="$MYPATH/scripts/config/environment.sh"
# load config
if [ ! -f "$CONFIG" ]; then
  echo "Config not found in: $CONFIG"
  exit 1
fi
source "$CONFIG"
BACKUP_DIR="$(dirname $WORK_DIR)"
SCRIPTNAME=$(basename $0)

# ==============================================================================
#
# Helper functions
#
# ==============================================================================
# unified output with date
function out() {
	echo "$(date) $SCRIPTNAME[$$]: ${1+$@}" 1>&2
}

# convert humanized numbers to bytes
dehumanise() {
  for v in "$@"; do
    echo $v | awk \
      'BEGIN{IGNORECASE = 1}
       function printpower(n,b,p) {printf "%u\n", n*b^p}
       /[0-9]$/{print $1;next};
       /K(iB)?$/{printpower($1,  2, 10)};
       /M(iB)?$/{printpower($1,  2, 20)};
       /G(iB)?$/{printpower($1,  2, 30)};
       /T(iB)?$/{printpower($1,  2, 40)};
       /KB$/{    printpower($1, 10,  3)};
       /MB$/{    printpower($1, 10,  6)};
       /GB$/{    printpower($1, 10,  9)};
       /TB$/{    printpower($1, 10, 12)}'
  done
}
MIN_BACKUP_SIZE=$(dehumanise $MIN_BACKUP_SIZE)
# out $MIN_BACKUP_SIZE

# check the size of a folder against MIN_BACKUP_SIZE
function checksize() {
  # out $1
  [ -z "$1" -o ! -d "$1" ] && return 2
  local dirname=$1
  local dirsize=$(du -s $dirname | awk '{print $1}')
  # out "$dirname has size: $dirsize"
  if [ $dirsize -ge $MIN_BACKUP_SIZE ]; then
    return 0
  else
    return 1
  fi
}

# returns/prints line count
function lc() {
  if [ -z "$1" ]; then
    echo 0
    return 0
  else
    echo $(wc -l <<<"$1")
    return $(wc -l <<<"$1")
  fi
}

# cleanup old/invalid backups
function cleanup() {
  local retain_count=${1:-$BACKUP_RETENTION}
  local backups="$(ls -d1 $BACKUP_DIR/*)"
  backups=$(sort -n <<<"$backups")

  # skip the rest if we already are at retention count
  if [ $(lc "$backups") -le $retain_count ]; then
    out "Nothing more to clean up"
    return 0
  fi

  # remove backups with invalid sizes
  out "Clean up broken backups (invalid sizes)"
  while read backupname; do
    checksize "$backupname"
    case $? in
      0)
        out "$backupname: Valid size"
        ;;
      1)
        if [ $(lc "$backups") -le $retain_count ]; then
          out "$backupname: would remove '$backupname' because of invalid size but would drop below retention count '$retain_count'"
        else
          rm -R ${backupname:-Non-existant}
          backups=$(grep -v ${backupname:-Non-existant} <<<"$backups")
          out "$backupname: removed (invalid size)"
        fi
        ;;
      2)
        out "$backupname: directory invalid or not present anymore"
        backups=$(grep -v ${backupname:-Non-existant} <<<"$backups")
        ;;
      *)
        out "Shouldn't reach here"
        exit 1
      ;;
    esac
  done <<<"$backups"

#   echo "
#
# Backups left after size check:
# $backups
#
#   "

  # skip the rest if we already are at retention count
  if [ $(lc "$backups") -le $retain_count ]; then
    out "Nothing more to clean up"
    return 0
  fi

  # remove backups from the future
  # this comes second in place because our date may be wrong, so it should first clean broken backups
  out "Clean up backups with backup date in the future"
  while read backupname; do
    [ -z "$backupname" ] && continue
    s=$(basename "$backupname" | sed -e 's:_: :g')
    read prefix byear bmonth bday <<<"$s"
    if [ "$(uname -s)" == "Darwin" ]; then
      bdate=$(date -v${byear}y -v${bmonth}m -v${bday}d +%s)
    else
      bdate=$(date -d "${byear}/${bmonth}/${bday}" +%s)
    fi
    if [ $bdate -gt $(date +%s) ]; then
      if [ $(lc "$backups") -le $retain_count ]; then
        out "$backupname: would remove because date is in the future but would drop below retention count '$retain_count'"
        break
      else
        rm -R "${backupname:-Non-existant}"
        backups=$(grep -v ${backupname:-Non-existant} <<<"$backups")
        out "$backupname: removed (date is in the future)"
      fi
    fi
  done <<<"$backups"

  # if there was already a backup today, remove it from the list
  todays_backup="Backup_$(date +%Y_%m_%d)"
  grep -q "$WORK_DIR" <<<"$backups"
  if [ $? -eq 0 ]; then
    out "$WORK_DIR: skipping"
    backups=$(grep -v ${WORK_DIR:-Non-existant} <<<"$backups")
  fi

  local retain_backups=$(tail -n $retain_count <<<"$backups")
  backups=$(grep -v -f <(echo "$retain_backups") <<<"$backups")
  # echo
  # echo "Delete Backups:"
  # echo "$backups"
  # echo
  while read backupname; do
    [ -z "$backupname" ] && continue
    rm -R "${backupname:-Non-existant}"
    out "$backupname: deleted"
  done <<<"$backups"

  out "Retained backups:" $retain_backups
}

function backup() {
  if [ "$(uname -s)" == "Linux" ]; then
    while read tile; do
      tilename=$(tr 'A-Z' 'a-z' <<<"$tile")
      out "Starting Backup for '$tile'"
      case $tilename in
        "ert")
          bash "scripts/backup_with_om"
          ;;
        *)
          if [ -f "scripts/service-tiles/backup_$tilename" ]; then
            bash "scripts/service-tiles/backup_$tilename"
          else
            out "Unsupported tile: $tile"
          fi
          ;;
      esac
    done <<<"${BACKUP_TILES:-ERT}"
  else
    echo "SHOULD BE RUN ON 'Linux' IN PRODUCTION, NOT '$(uname -s)'"
    return 0
  fi
}

# ==============================================================================
#
# Main execution
#
# ==============================================================================
# The first cleanup should make space for the new backup but may not do that
# properly if a backup has already been created for today (which is not counted).
# Therefore the "-1".
cleanup $((BACKUP_RETENTION-1)) && backup && cleanup
