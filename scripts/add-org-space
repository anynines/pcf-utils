#!/bin/bash

if [ $# -lt 4 ]; then
  echo "Usage: ./add-org-spaces.sh <System Domain> <Apps Manager Admin Username> <Apps Manager Admin Password> <Environment>"
  exit 1
fi

export SYSTEM_DOMAIN=$1
export API_ENDPOINT=api.$SYSTEM_DOMAIN
export APPS_MGR_ADMIN_USER=$2
export APPS_MGR_ADMIN_PWD=$3
export ENVIRONMENT=$4

if [[ $ENVIRONMENT = "dev" ]]; then
  cf api --skip-ssl-validation $API_ENDPOINT
  cf login -u $APPS_MGR_ADMIN_USER -p $APPS_MGR_ADMIN_PWD

  cf co DEVELOPMENT
  cf create-space development -o DEVELOPMENT

  cf logout
elif [[ $ENVIRONMENT = "int" ]]; then
  cf api --skip-ssl-validation $API_ENDPOINT
  cf login -u $APPS_MGR_ADMIN_USER -p $APPS_MGR_ADMIN_PWD

  cf co INTEGRATION
  cf create-space integration -o INTEGRATION

  cf logout
elif [[ $ENVIRONMENT = "test" ]]; then
  cf api --skip-ssl-validation $API_ENDPOINT
  cf login -u $APPS_MGR_ADMIN_USER -p $APPS_MGR_ADMIN_PWD

  cf co TEST
  cf create-space test -o TEST

  cf logout
elif [[ $ENVIRONMENT = "prod" ]]; then
  cf api --skip-ssl-validation $API_ENDPOINT
  cf login -u $APPS_MGR_ADMIN_USER -p $APPS_MGR_ADMIN_PWD

  cf co PRODUCTION
  cf create-space production -o PRODUCTION

  cf logout
else
  echo "Unsupported platform"
  exit 1
fi
