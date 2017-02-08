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
