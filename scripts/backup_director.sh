#!/bin/bash --login

get_vcap_credentials_for_p_bosh(){
  echo "GATHER BOSH DIRECTOR VCAP CONNECTION PARAMETERS"

  output=`sh lib/installationparser/app $WORK_DIR/installation.yml p-bosh director vcap`

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
  mkdir -p $WORK_DIR/opsmanager_director
  echo "RSYNC VCAP STORE"
 /usr/bin/expect -c "
     set timeout -1

     spawn rsync -v -a --exclude=lost+found $DIRECTOR_VCAP_USERNAME@$BOSH_DIRECTOR_VCAP_IP:/var/vcap/store $WORK_DIR/opsmanager_director
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

export_p_bosh() {
	if [[ "Y" = "$COMPLETE_BACKUP" || "y" = "$COMPLETE_BACKUP" ]]; then
    get_vcap_credentials_for_p_bosh
		ssh_vcap_pg_dump
		rsync_vcap_store
	fi
}
