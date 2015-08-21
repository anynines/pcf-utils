#!/bin/bash

# 1. UAA url
# 2. Admin username
# 3. Admin secret
# 4. User to promote as admin

if [ $# -lt 4 ]; then
  echo "Usage: ./assign-admin-privileges.sh <uaa url> <admin username> <admin-secret> <user-to-promote>"
  exit 1
fi

echo "Log location is: /tmp/assign-admin-privileges.log"

uaac target $1 >> /tmp/assign-admin-privileges.log 2>&1
uaac token client get $2 -s $3 >> /tmp/assign-admin-privileges.log 2>&1
uaac contexts >> /tmp/assign-admin-privileges.log 2>&1

uaac member add cloud_controller.admin $4 >> /tmp/assign-admin-privileges.log 2>&1
uaac member add uaa.admin $4 >> /tmp/assign-admin-privileges.log 2>&1
uaac member add scim.read $4 >> /tmp/assign-admin-privileges.log 2>&1
uaac member add scim.write $4 >> /tmp/assign-admin-privileges.log 2>&1
uaac member add password.write $4 >> /tmp/assign-admin-privileges.log 2>&1
uaac member add openid $4 >> /tmp/assign-admin-privileges.log 2>&1

uaac token delete

echo "You've sucessfully handed over the power of admin to $4. Mission Accomplished!!"
