#!/bin/bash

source scripts/host/sanitize_sql_filename.sh
source scripts/host/vars.sh
source .env

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

function nonexistent_file_error {
cat >&2 << EOF

Operation failed. The file "$backup_file" cannot be found in $HOST_BACKUPS_DIR.
Please make sure that you have specified the correct file name and try again.

EOF
}

# Vars
backup_file=""

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      -f|--filename)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          backup_file="$(sanitize_sql_filename $2)"

          # check whether the file exists, exit if it doesn't
          if ! test -f "$HOST_BACKUPS_DIR/$backup_file"; then
            nonexistent_file_error
            exit 1
          fi

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

# Error checking for whether the environment vars are defined
if ! test -f ".env"; then 
  env_file_error
  exit 1;
fi

if [ -z "$backup_file" ]; then
  echo "Finding newest backup from: $HOST_BACKUPS_DIR" 

  if [ -z "$1" ]; then
      unset -v host_backup_path
      for file in "$HOST_BACKUPS_DIR"/*; do
      [[ $file -nt $LATEST_FILE ]] && host_backup_path=$file
      done
  else
      host_backup_path=$1
  fi
  backup_file="${host_backup_path##*/}"
fi

repo_name="$(basename "$PWD")"
container_name="${THEME_NAME}__db"
container_backup_path="${CONTAINER_BACKUPS_DIR}/${backup_file}"

cat << EOF
Restoring Db backup...
from: $HOST_BACKUPS_DIR/$backup_file
to: $container_name
EOF

docker exec $container_name bash -c \
  "mysql \
    -u$DB_USER \
    -p$DB_PASS \
    $DB_NAME < /$container_backup_path \
    &> /dev/null" 