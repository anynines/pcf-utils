#!/bin/bash --login

copy_deployment_files() {

	echo "COPY DEPLOYMENT MANIFEST"
	/usr/bin/expect -c "
		set timeout -1

		spawn scp $SSH_USER@$OPS_MANAGER_HOST:/var/tempest/workspaces/default/deployments/*.yml $DEPLOYMENT_DIR

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

	curl "$CONNECTION_URL" -X GET -u $OPS_MGR_ADMIN_USERNAME:$OPS_MGR_ADMIN_PASSWORD --insecure -k -o $WORK_DIR/installation.yml
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

	bosh target $BOSH_DIRECTOR_IP << EOF
	$DIRECTOR_USERNAME
	$DIRECTOR_PASSWORD
EOF

	bosh login $DIRECTOR_USERNAME $DIRECTOR_PASSWORD
}
