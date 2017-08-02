#!/bin/bash

export DATE=`date +%Y_%m_%d`
export OPS_MANAGER_HOST="ops"
export SSH_USER=""
export OPS_MGR_SSH_PASSWORD=""
export OPS_MGR_ADMIN_USERNAME=""
export OPS_MGR_ADMIN_PASSWORD=""

export BACKUP_DIR_NAME="Backup_$DATE"
export WORK_DIR="/backups/$BACKUP_DIR_NAME"
export NFS_DIR="$WORK_DIR/nfs_share"
export NFS_EXCLUDES="cc-resources/*
cc-droplets/buildpack_cache/*"
export DEPLOYMENT_DIR="$WORK_DIR/deployments"
export DATABASE_DIR="$WORK_DIR/database"

export COMPLETE_BACKUP="N"
export BOSH_OLD_CLI="false"

# choose which tiles to backup, ERT includes also OpsManager
export BACKUP_TILES="ERT
MySQL
RabbitMQ
Redis"

# override internal MySQL IPs (e.g. to use the proxies instead)
#export MYSQL_HOSTS="10.0.0.100 10.0.0.101 10.0.0.102"

export PMYSQL_DISTINCTIVE="true"
# override P-MySQL IPs (e.g. to use the proxies instead)
#export PMYSQL_HOSTS="10.0.1.100 10.0.2.101 10.0.3.102"

export BACKUP_RETENTION=4
export MIN_BACKUP_SIZE="10G"
