pcf-utils
=========
Repository to hold utilities specific to Pivotal CF functionality, like

1. Backup
2. Import users
3. Create Admin user
4. Add Orgs and Spaces
5. Remove unused products from Ops Manager
6. Download and upload products to Ops Manager
7. Start/Stop all CF jobs

# Automated Backups
Copy the file `environment.sh` from examples to `config` directory.
Open it and fill in your environment details.
To create a backup, execute `backup_with_om`.

# Import users
Copy the file `environment` from examples to `config` directory.
Open it and fill in your environment details before executing `import-single-user`

# Firewall considerations
Destination: OpsManager
Destination Port: 22 (SSH)
Reason: download deployment manifests

Destination: OpsManager
Destination Port: 443 (https)
Reason: login to OpsManager UAA and access OpsManager API to download installation.zip and other settings.

Destination: Director
Destination Port: 25555 (https/director port)
Reason: target bosh director and download director database and other status

Destination: Director
Destination Port: 8443 (https/uaa port)
Reason: login to bosh director and download director database and other status

Destination: Director
Destination Port: 22 (ssh)
Reason: download director store

Destination: ERT networks
Destination Port: 22 (ssh)
Reason: execute backup tasks and download storage files on VMs holding data (nfs, redis data, mysql...)

Destination: MySQL proxy or server
Destination Port: 3306 (mysql)
Reason: create database dumps

Destination: RabbitMQ management API (https://pivotal-rabbitmq.PCF_SYSTEM_DOMAIN)
Destination Port: 443 (https)
Reason: download queue descriptions

## deprecated
Destination: CC DB, Console DB, UAA DB
Destination Port: 2544
Reason: create database dumps
