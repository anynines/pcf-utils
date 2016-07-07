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

## AUTOMATE BACKUPS
Copy the file `environment.sh` from examples to scripts directory and chmod to `755`

Substitute the variable names there with your environment details, and execute `./backup_with_om`
