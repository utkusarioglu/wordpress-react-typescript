#!/bin/bash

function theme_name_not_defined_error {
cat >&2 << EOF

Operation failed. This script requires the following properties from the .env file:

THEME_NAME: The name for the theme that you are developing

Please make sure that an .env file exists and the listed properties are set, 
and then rerun this script.

EOF
}

source .env

# Vars
no_backup=FALSE
backup_file=""

# Parses input params to the relevant variables listed above
function handle_input {
  while test $# -gt 0; do
    case "$1" in
      -f|--filename)
        shift
        backup_file=$1
        shift
        ;;&

      -n|--no-backup) 
        no_backup=TRUE
        shift
        ;;&

      *)
        # TODO find a way to avoid this empty string check
        if [ ! -z $1 ]; then
          echo "-${1}-"
          invalid_flag_error
          exit 1;
        fi
      ;;
    esac
  done 
}
handle_input $@


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