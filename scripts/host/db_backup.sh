#!/bin/bash

source scripts/shared/check_env.sh
source .env
source scripts/shared/sanitize_sql_filename.sh
source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh
source scripts/shared/exit_if_in_devcontainer.sh
source scripts/shared/check_ownership.sh

check_ownership "$HOST_BACKUPS_DIR"

function title {
  title_template "Database Backup Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt db replace-url [options]

Commands:
  (none)        Run the db backup operation

Options:
  -f, --filename [sql filename]     Custom filename for the backup file that 
                                    will be created

EOF
}

CURRENT_DATE_TIME=`date +%Y%m%d-%H%M%S`
BACKUP_FILE_NAME="${CURRENT_DATE_TIME}.sql"

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      -f|--filename)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          BACKUP_FILE_NAME="$(sanitize_sql_filename $2)"
          shift 2
        else
          missing_argument_error $1
          exit 1
        fi
        ;;

      *)
        parse_args_essential title commands_and_options $@
    esac
  done
  eval set -- "$PARAMS"
}

function do_db_backup {
  echo "Creating ${BACKUP_FILE_NAME} inside ${HOST_BACKUPS_DIR}"
  CONTAINER_BACKUP_PATH="${CONTAINER_BACKUPS_DIR}/${BACKUP_FILE_NAME}"
  docker exec "${THEME_NAME}__db__dev" bash -c \
    "mysqldump -uroot -p${DB_ROOT_PASS} $DB_NAME > $CONTAINER_BACKUP_PATH" \
    &> /dev/null
}

parse_args $@
do_db_backup