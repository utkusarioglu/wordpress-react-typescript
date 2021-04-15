#!/bin/bash

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

source .env

# Vars
HOST_BACKUPS_DIR=backups/sql
CONTAINER_BACKUPS_DIR=backups/sql
backup_file=""

# Parses input params to the relevant variables listed above
function handle_input {
  while test $# -gt 0; do
    case "$1" in
      -f|--filename)
        shift
        # adds .sql extension to the file if it's absent
        if [ "${1:(-4)}" == '.sql' ]; then
          backup_file=$1
        else
          backup_file="$1.sql"
        fi

        # check whether the file exists, exit if it doesn't
        if ! test -f "$HOST_BACKUPS_DIR/$backup_file"; then
          nonexistent_file_error
          exit 1
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
  "mysql -u$DB_USER -p$DB_PASS $DB_NAME < /$container_backup_path &> /dev/null" 