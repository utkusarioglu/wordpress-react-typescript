#!/bin/bash

source .env

HOST_BACKUPS_DIR=backups/sql
CONTAINER_BACKUPS_DIR=backups/sql

# Error checking for whether the environment vars are defined
if ! test -f ".env"; then 
  cat << EOF

Operation failed. This script requires the following properties from the .env file:

THEME_NAME: The name for the theme that you are developing
DB_USER: Username for wp's mysql access
DB_PASS: Password for wp's mysql access
DB_NAME: Name for the schema that wp will use

Please make sure that an .env file exists and the listed properties are set, 
and then rerun this script.

EOF
exit 1;
fi

echo "Finding newest backup from: $HOST_BACKUPS_DIR" 

if [ -z "$1" ]; then
    unset -v host_backup_path
    for file in "$HOST_BACKUPS_DIR"/*; do
    [[ $file -nt $LATEST_FILE ]] && host_backup_path=$file
    done
else
    host_backup_path=$1
fi

repo_name="$(basename "$PWD")"
container_name="${THEME_NAME}__db"
backup_file="${host_backup_path##*/}"
container_backup_path="${CONTAINER_BACKUPS_DIR}/${backup_file}"

cat << EOF
Restoring Db backup...
from: $host_backup_path
to: $container_name
EOF

docker exec $container_name bash -c \
  "mysql -u$DB_USER -p$DB_PASS $DB_NAME < /$container_backup_path"