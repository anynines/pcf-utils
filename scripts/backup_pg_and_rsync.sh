#!/bin/bash --login
#export_installation_settings_vcap() {
#  CONNECTION_URL=https://$OPS_MANAGER_HOST/api/installation_settings

#  echo "EXPORT INSTALLATION FILES FROM " $CONNECTION_URL

#  curl "$CONNECTION_URL" -X GET -u $OPS_MGR_ADMIN_USERNAME:$OPS_MGR_ADMIN_PASSWORD --insecure -k -o $WORK_DIR/installation.yml
#}

get_vcap_credentials_for_p_bosh(){
  echo "GATHER BOSH DIRECTOR VCAP CONNECTION PARAMETERS"

  output=`sh appassembler/bin/app $WORK_DIR/installation.yml p-bosh director vcap`

  export DIRECTOR_VCAP_USERNAME=`echo $output | cut -d '|' -f 1`
  export DIRECTOR_VCAP_PASSWORD=`echo $output | cut -d '|' -f 2`
  export BOSH_DIRECTOR_VCAP_IP=`echo $output | cut -d '|' -f 3`
}

ssh_vcap_pg_dump(){
  echo "SSH INTO P-BOSH AS VCAP AND PG_DUMP"
  # UNSET PGPASSWORD DOES NOT WORK
  SCRIPT="\"PGPASSWORD=${DIRECTOR_VCAP_PASSWORD} /var/vcap/packages/postgres/bin/pg_dump -U postgres -c bosh > /var/vcap/store/postgres/pg_log/postgresql.sql; \""

 /usr/bin/expect -c "
     set timeout -1

     spawn ssh $DIRECTOR_VCAP_USERNAME@$BOSH_DIRECTOR_VCAP_IP $SCRIPT
    expect {
       -re ".*Are.*.*yes.*no.*" {
	  send yes\r;
          exp_continue
	}

        "*?assword:*" {
          send $DIRECTOR_VCAP_PASSWORD\r
        }
     }
     expect {
      "*?assword:*" {
        send $DIRECTOR_VCAP_PASSWORD\r
        interact
      }
   }
  exit"
}

rsync_vcap_store(){
  mkdir $WORK_DIR/opsmanager_director
  echo "RSYNC VCAP STORE"
 /usr/bin/expect -c "
     set timeout -1

     spawn rsync -v -a --exclude '/var/vcap/store/lost+found' $DIRECTOR_VCAP_USERNAME@$BOSH_DIRECTOR_VCAP_IP:/var/vcap/store $WORK_DIR/opsmanager_director
    expect {
       -re ".*Are.*.*yes.*no.*" {
	  send yes\r;
          exp_continue
	}

        "*?assword:*" {
          send $DIRECTOR_VCAP_PASSWORD\r
        }
     }
     expect {
      "*?assword:*" {
        send $DIRECTOR_VCAP_PASSWORD\r
        interact
      }
   }
  exit"
  rm -rf $WORK_DIR/installation.yml
}
