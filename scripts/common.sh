#!/bin/bash --login

login_opsman() {

	echo "LOGIN TO OPSMAN"

	uaac target https://$OPS_MANAGER_HOST/uaa --skip-ssl-validation

	uaac token owner get opsman $OPS_MGR_ADMIN_USERNAME -s "" -p $OPS_MGR_ADMIN_PASSWORD

}

scp_files() {

	echo "COPY DEPLOYMENT MANIFEST"
	ssh-keygen -R $OPS_MANAGER_HOST

	/usr/bin/expect -c "
		set timeout -1

		spawn scp $SSH_USER@$OPS_MANAGER_HOST:$1 $2

		expect {
			-re ".*Are.*.*yes.*no.*" {
				send yes\r ;
				exp_continue
			}

			"*?assword:*" {
				send $OPS_MGR_SSH_PASSWORD\r
			}
		}
		expect {
			"*?assword:*" {
				send $OPS_MGR_SSH_PASSWORD\r
				interact
			}
		}

		exit
	"
}

export_installation_settings() {
	CONNECTION_URL=https://$OPS_MANAGER_HOST/api/installation_settings

	echo "EXPORT INSTALLATION FILES FROM " $CONNECTION_URL

	export UAA_ACCESS_TOKEN=`cat ~/.uaac.yml | grep "access_token:" | cut -d':' -f2 | cut -d' ' -f2`

	curl "$CONNECTION_URL" -X GET -k -H "Authorization: Bearer $UAA_ACCESS_TOKEN" -o $WORK_DIR/installation.yml

}

fetch_bosh_connection_parameters() {
	echo "GATHER BOSH DIRECTOR CONNECTION PARAMETERS"

	output=`sh appassembler/bin/app $WORK_DIR/installation.yml p-bosh director director`

	export DIRECTOR_USERNAME=`echo $output | cut -d '|' -f 1`
	export DIRECTOR_PASSWORD=`echo $output | cut -d '|' -f 2`
	export BOSH_DIRECTOR_IP=`echo $output | cut -d '|' -f 3`

}

bosh_login() {
	echo "BOSH LOGIN"
	rm -rf ~/.bosh_config

	bosh --ca-cert $WORK_DIR/root_ca_certificate target $BOSH_DIRECTOR_IP << EOF
	$DIRECTOR_USERNAME
	$DIRECTOR_PASSWORD
EOF

	bosh login $DIRECTOR_USERNAME $DIRECTOR_PASSWORD
}
