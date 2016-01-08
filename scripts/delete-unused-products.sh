#!/bin/bash --login

remove_unused_products() {
	echo "REMOVING USUSED PRODUCTS"
	CONNECTION_URL=https://$OPS_MANAGER_HOST/api/products

	curl "$CONNECTION_URL" -d '' -X DELETE --insecure -k -u $OPS_MGR_ADMIN_USERNAME:$OPS_MGR_ADMIN_PASSWORD
}

execute() {
	remove_unused_products
}

if [ $# -lt 3 ]; then
	echo "Usage: ./delete-unused-products.sh <OPS MGR HOST or IP> <OPS MGR ADMIN USER> <OPS MGR ADMIN PASSWORD>"
	printf "\t %s \t\t\t %s \n" "OPS MGR HOST or IP:" "OPS Manager Host or IP"
	printf "\t %s \t\t\t %s \n" "OPS MGR ADMIN USER:" "OPS Manager Admin Username"
	printf "\t %s \t\t %s \n" "OPS MGR ADMIN PASSWORD:" "OPS Manager Admin Password"
	exit 1
fi

export DATE=`date +%Y_%m_%d`
export OPS_MANAGER_HOST=$1
export OPS_MGR_ADMIN_USERNAME=$2
export OPS_MGR_ADMIN_PASSWORD=$3

execute

echo "$DATE - CLEANUP SUCCESSFUL"
