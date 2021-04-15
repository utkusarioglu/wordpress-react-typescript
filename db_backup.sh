#!/bin/bash

function invalid_flag_error {
cat >&2 << EOF

Operation failed. $1 is not a recognized flag. 
Available flags are listed below:

-f, --filename : Custom filename for the backup file that will be created

EOF
}

function running_inside_container_error {
cat >&2 << EOF

Backup failed. You cannot run this script while inside the devcointainer.
Please start a separate terminal, and run this script from the host.

EOF
}

function env_file_error {
cat >&2 << EOF

Operation failed. This script requires the following properties from the .env file:

THEME_NAME: The name for the theme that you are developing
DB_NAME: Name for the schema that wp will use
DB_ROOT_PASS: Mysql root user password

Please make sure that an .env file exists and the listed properties are set, 
and then rerun this script.

EOF
}

source .env

# Vars
HOST_BACKUPS_DIR=backups/sql
CONTAINER_BACKUPS_DIR=backups/sql
repo_name="$(basename "$PWD")"
date=`date +%Y%m%d-%H%M%S`
backup_file_name="${date}.sql"

# Parses input params to the relevant variables listed above
function handle_input {
  while test $# -gt 0; do
    case "$1" in
      -f|--filename)
        shift
        # adds .sql extension to the file if it's absent
        if [ "${1:(-4)}" == '.sql' ]; then
          backup_file_name=$1
        else
          backup_file_name="$1.sql"
        fi
        shift
        ;;&

      *)
        # TODO find a way to avoid this empty string check
        if [ ! -z $1 ]; then
          invalid_flag_error $1
          exit 1;
        fi
      ;;
    esac
  done 
}
handle_input $@

# Error checking for whether script is run inside the devcontainer
if [ $repo_name == 'workspace' ]; then
  running_inside_container_error
  exit 1
fi

# Error checking for whether the environment vars are defined
if ! test -f ".env"; then 
  env_file_error
  exit 1;
fi

echo "Creating ${backup_file_name} inside ${HOST_BACKUPS_DIR}"

containter_backup_path="${CONTAINER_BACKUPS_DIR}/${backup_file_name}"
docker exec "${THEME_NAME}__db" bash -c \
  "mysqldump -uroot -p${DB_ROOT_PASS} $DB_NAME > $containter_backup_path" \
  &> /dev/null


