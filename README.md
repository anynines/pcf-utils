pcf-utils
=========
Repository to hold utilities specific to Pivotal CF functionality, like

* Backups
* Restore
* Deleting old artifacts
* Deleting unwanted products that are in-compatible with the foundation
* Import LDAP Users using the users.csv
* Promote a user as a superadmin
* etc


## AUTOMATE BACKUPS
Copy the file `environment.sh` from examples to scripts directory and chmod to `755`

Substitute the variable names there with your environment details, and execute `./backup_script.sh`
