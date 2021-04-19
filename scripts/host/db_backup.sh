#!/bin/bash

source scripts/host/check_env.sh
source .env
source scripts/host/sanitize_sql_filename.sh
source scripts/host/vars.sh

function invalid_flag_error {
cat >&2 << EOF

Operation failed. $1 is not a recognized flag. 
Available flags are listed below:

-f, --filename [sql filename]: Custom filename for the backup file that will be created

EOF
}

function running_inside_container_error {
cat >&2 << EOF

Backup failed. You cannot run this script while inside the devcointainer.
Please start a separate terminal, and run this script from the host.

EOF
}

# Error checking for whether script is run inside the devcontainer
repo_name="$(basename "$PWD")"
if [ $repo_name == 'workspace' ]; then
  running_inside_container_error
  exit 1
fi

# Vars
date=`date +%Y%m%d-%H%M%S`
backup_file_name="${date}.sql"

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      -f|--filename)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          backup_file_name="$(sanitize_sql_filename $2)"
          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          exit 1
        fi
        ;;

      -*|--*=) # unsupported flags
        invalid_flag_error $1
        exit 1
        ;;

      *) # preserve positional arguments
        PARAMS="$PARAMS $1"
        shift
        ;;
    esac
  done
  eval set -- "$PARAMS"
}
parse_args $@




echo "Creating ${backup_file_name} inside ${HOST_BACKUPS_DIR}"

containter_backup_path="${CONTAINER_BACKUPS_DIR}/${backup_file_name}"
docker exec "${THEME_NAME}__db__dev" bash -c \
  "mysqldump -uroot -p${DB_ROOT_PASS} $DB_NAME > $containter_backup_path" \
  &> /dev/null


