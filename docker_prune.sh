#!/bin/bash

source .env

function theme_name_not_defined_error {
cat >&2 << EOF

Operation failed. This script requires the following properties from the .env file:

THEME_NAME: The name for the theme that you are developing

Please make sure that an .env file exists and the listed properties are set, 
and then rerun this script.

EOF
}

# Vars
no_backup=FALSE
backup_file=""

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      -n|--no-backup)
        no_backup=TRUE
        shift
        ;;

      -b|--my-flag-with-argument)
        if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
          backup_file=$2
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


if ! test -f ".env"; then 
  theme_name_not_defined_error
  exit 1;
fi

echo "Running pruning for ${THEME_NAME}..."

if [[ $no_backup == TRUE ]]; then
  echo "Skipping db backup creation upon user command"
else
  if [ -z $backup_file ]; then
    bash ./db_backup.sh
  else 
    bash ./db_backup.sh -f $backup_file
  fi
fi

echo "Cleaning containers, volumes, and networks"

for command in 'stop' 'rm';
do
  docker container $command "${THEME_NAME}__wp" "${THEME_NAME}__db" 1> /dev/null
done;  

repo_name="$(basename "$PWD")"
docker volume rm "${repo_name}_db" 1> /dev/null
docker network rm "${repo_name}_default" 1> /dev/null