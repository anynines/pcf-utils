

#!/bin/bash

if [ $# -lt 6 ]; then
  echo "Usage: ./import-users.sh <api url> <admin username> <admin password> <uaa url> <admin username> <admin-secret>"
  exit 1
fi

echo "Log location is: /tmp/import-users.log"

cf api --skip-ssl-validation $1 >> /tmp/import-users.log 2>&1
cf login -u $2 -p $3

uaac target --skip-ssl-validation $4 >> /tmp/import-users.log 2>&1
uaac token client get $5 -s $6 >> /tmp/import-users.log 2>&1

IFS="#"
while read f1 f2 f3 f4 f5 f6 f7
do
        echo "UID is                      : $f1"
        echo "Email is                    : $f2"
        echo "UserName is                 : $f3"
        echo "OrgName  is                 : $f4"
        echo "Org Permissions  is         : $f5"
        echo "SpaceName is                : $f6"
        echo "Space Permission is         : $f7"

        RESPONSE=`uaac curl -H "Content-Type: application/json" -k  /Users -X POST -d '{"userName":"'"$f3"'","emails":[{"value":"'"$f2"'"}],"origin":"ldap","externalId":"'"$f1"'"}'`
#	echo $RESPONSE
        ID=`echo $RESPONSE | grep "id" | head -3 | tail -1 | cut -d ":" -f2 | cut -d " " -f2 | cut -d "," -f1`
        echo $ID

        IMPORT_USER_TO_CC=`cf curl /v2/users -d '{"guid":"'"$ID"'"}' -X POST`
#	echo $IMPORT_USER_TO_CC >> /tmp/import-users.log 2>&1
	echo $IMPORT_USER_TO_CC
	
        IFS="|" read -a orgperms <<< "$f5"

        for orgperm in "${orgperms[@]}"
        do
          cf set-org-role $f3 $f4 $orgperm
        done

        IFS="|" read -a spaceperms <<< "$f7"

        for spaceperm in "${spaceperms[@]}"
        do
          cf set-space-role $f3 $f4 $f6 $spaceperm
        done

done < users.csv

uaac token delete
cf logout
