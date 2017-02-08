#!/bin/bash

export DATE=`date +%Y_%m_%d`
export OPS_MANAGER_HOST="ops"
export SSH_USER=""
export OPS_MGR_SSH_PASSWORD=""
export OPS_MGR_ADMIN_USERNAME=""
export OPS_MGR_ADMIN_PASSWORD=""
export BACKUP_DIR_NAME=Backup_$DATE
export WORK_DIR=""/$BACKUP_DIR_NAME
export NFS_DIR=$WORK_DIR/nfs_share
export DEPLOYMENT_DIR=$WORK_DIR/deployments
export DATABASE_DIR=$WORK_DIR/database
export COMPLETE_BACKUP="N"
