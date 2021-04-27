#!/bin/bash

source scripts/shared/check_env.sh
source .env
source scripts/shared/sanitize_sql_filename.sh
source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh
source scripts/shared/check_container_online.sh

check_container_online "${THEME_NAME}__db__dev"

function title {
  title_template "Database Restore Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt db restore [options]

Commands:
  (none)        Run the restore operation with most recent sql backup

Options:
  -f, --filename [sql filename]    Restores the given sql file
  -h, --help                       Shows this help information

EOF
}

BACKUP_FILE=""

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      -f|--filename)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          BACKUP_FILE="$(sanitize_sql_filename $2)"

          # check whether the file exists, exit if it doesn't
          if ! test -f "$HOST_BACKUPS_DIR/$BACKUP_FILE"; then
            nonexistent_file_error $BACKUP_FILE $HOST_BACKUPS_DIR 
            exit 1
          fi

          shift 2
        else
          echo "Error: Argument for $1 is missing" >&2
          exit 1
        fi
        ;;

      *)
        parse_args_essential title commands_and_options $@
    esac
  done
  eval set -- "$PARAMS"
}

function do_backup_restore {
  if [ -z "$BACKUP_FILE" ]; then
    echo "Finding newest backup from: $HOST_BACKUPS_DIR" 

    if [ -z "$1" ]; then
        unset -v host_backup_path
        for file in "$HOST_BACKUPS_DIR"/*; do
        [[ $file -nt $LATEST_FILE ]] && host_backup_path=$file
        done
    else
        host_backup_path=$1
    fi
    BACKUP_FILE="${host_backup_path##*/}"
  fi

  repo_name="$(basename "$PWD")"
  container_name="${THEME_NAME}__db__dev"
  container_backup_path="${CONTAINER_BACKUPS_DIR}/${BACKUP_FILE}"

  cat << EOF
  Restoring Db backup...
  from: $HOST_BACKUPS_DIR/$BACKUP_FILE
  to: $container_name
EOF

  docker exec $container_name bash -c \
    "mysql \
      -u$DB_USER \
      -p$DB_PASS \
      $DB_NAME < /$container_backup_path \
      &> /dev/null"
}

parse_args $@
do_backup_restore