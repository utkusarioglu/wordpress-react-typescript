#!/bin/bash

source .env

# Vars
repo_name="$(basename "$PWD")"
date=`date +%Y%m%d`
HOST_BACKUPS_DIR=backups/sql
CONTAINER_BACKUPS_DIR=backups/sql

# Error checking for whether script is run inside the devcontainer
if [ $repo_name == 'workspace' ]; then
  cat << EOF

Backup failed. You cannot run this script while inside the devcointainer.
Please start a separate terminal, and run this script from the host.

EOF
exit 1
fi

# Error checking for whether the environment vars are defined
if ! test -f ".env"; then 
  cat << EOF

Operation failed. This script requires the following properties from the .env file:

THEME_NAME: The name for the theme that you are developing
DB_NAME: Name for the schema that wp will use
DB_ROOT_PASS: Mysql root user password

Please make sure that an .env file exists and the listed properties are set, 
and then rerun this script.

EOF
exit 1;
fi

echo "Creating ${date}.sql inside ${HOST_BACKUPS_DIR}"

containter_backup_path="${CONTAINER_BACKUPS_DIR}/${date}.sql"
docker exec "${THEME_NAME}__db" \
  mysqldump \
    -uroot \
    -p${DB_ROOT_PASS} \
    $DB_NAME > $containter_backup_path