#!/bin/bash

echo "Choose an option from the following:"
echo
echo "1. Backup"
echo "2. Import users"
echo "3. Create Admin user"
echo "4. Add Orgs and Spaces"
echo "5. Remove unused products from Ops Manager"
echo "6. Download and upload products to Ops Manager"

read -p "Enter Your Option: " OPTION
if [[ $OPTION -eq 1 ]]; then
  echo "Backup it is..."

  read -p "Enter the OPS Manager Host or IP: " OPS_MANAGER_HOST
  read -p "Enter the OPS Manager SSH Username: " SSH_USER
  read -s -p "Enter the OPS Manager SSH Password: " OPS_MGR_SSH_PASSWORD
  echo
  read -p "Enter the OPS Manager Admin Username: " OPS_MGR_ADMIN_USERNAME
  read -s -p "Enter the OPS Manager Admin Password: " OPS_MGR_ADMIN_PASSWORD
  echo
  read -p "Enter the Backup Directory: " WORK_DIR
  read -p "Enter Y/N for complete backup: " COMPLETE_BACKUP
  ./backup_script.sh $OPS_MANAGER_HOST $SSH_USER $OPS_MGR_SSH_PASSWORD $OPS_MGR_ADMIN_USERNAME $OPS_MGR_ADMIN_PASSWORD $WORK_DIR $COMPLETE_BACKUP

elif [[ $OPTION -eq 2 ]]; then
  echo "Import users it is..."

  read -p "Enter the system domain: " SYSTEM_DOMAIN
  read -p "Enter the Apps Manager Admin Username: " APPS_MGR_ADMIN_USER
  read -s -p "Enter the Apps Manager Admin Password: " APPS_MGR_ADMIN_PWD
  echo
  read -p "Enter the UAA Admin Username: " UAA_ADMIN_USER
  read -s -p "UAA Admin Client Credentials: " UAA_ADMIN_PWD
  echo
  ./import-users.sh $SYSTEM_DOMAIN $APPS_MGR_ADMIN_USER $APPS_MGR_ADMIN_USER $UAA_ADMIN_USER $UAA_ADMIN_PWD

elif [[ $OPTION -eq 3 ]]; then
  echo "Create Admin User it is..."

  read -p "Enter the system domain: " SYSTEM_DOMAIN
  read -p "Enter the UAA Admin Username: " UAA_ADMIN_USER
  read -s -p "UAA Admin Client Credentials: " UAA_ADMIN_PWD
  echo
  read -p "Enter the Username to promote as Admin: " USER_TO_PROMOTE
  ./assign-admin-privileges.sh $SYSTEM_DOMAIN $UAA_ADMIN_USER $UAA_ADMIN_PWD $USER_TO_PROMOTE

elif [[ $OPTION -eq 4 ]]; then
  echo "Add Orgs and Spaces it is.."

  read -p "Enter the system domain: " SYSTEM_DOMAIN
  read -p "Enter the Apps Manager Admin Username: " UAA_ADMIN_USER
  read -s -p "Enter the Apps Manager Admin Password: " UAA_ADMIN_PWD
  echo
  read -p "Enter the Environment name dev/int/test/prod: " ENVIRONMENT
  ./add-org-space.sh $SYSTEM_DOMAIN $UAA_ADMIN_USER $UAA_ADMIN_PWD $ENVIRONMENT

elif [[ $OPTION -eq 5 ]]; then
  echo "Remove unused products from Ops Manager"

  read -p "Enter the OPS Manager Host or IP: " OPS_MANAGER_HOST
  read -p "Enter the OPS Manager Admin Username: " OPS_MGR_ADMIN_USERNAME
  read -s -p "Enter the OPS Manager Admin Password: " OPS_MGR_ADMIN_PASSWORD
  echo
  ./delete-unused-products.sh $OPS_MANAGER_HOST $OPS_MGR_ADMIN_USERNAME $OPS_MGR_ADMIN_PASSWORD

elif [[ $OPTION -eq 6 ]]; then
  echo "Download and upload products to Ops Manager"

  read -p "Enter the API Token from network.pivotal.io: " API_TOKEN
  read -p "Enter the FileName to Save (ex: p-redis-1.2.0.pivotal): " FILE_NAME
  read -p "Enter the Product ID: " PRODUCT_ID
  read -p "Enter the Release ID: " RELEASE_ID
  read -p "Enter the Product File ID: " PRODUCT_FILE_ID
  read -p "Enter the OPS Manager Host or IP: " OPS_MANAGER_HOST
  read -p "Enter the OPS Manager Admin Username: " OPS_MGR_ADMIN_USERNAME
  read -s -p "Enter the OPS Manager Admin Password: " OPS_MGR_ADMIN_PASSWORD
  echo
  ./download-upload.sh $API_TOKEN $FILE_NAME $PRODUCT_ID $RELEASE_ID $PRODUCT_FILE_ID $OPS_MANAGER_HOST $OPS_MGR_ADMIN_USERNAME $OPS_MGR_ADMIN_PASSWORD

else
  echo "You've selected an upsupported operation"
  exit 1
fi
